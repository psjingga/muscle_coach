import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';

import '../generated_migrations/schema.dart';
import '../generated_migrations/schema_v3.dart' as v3;
import '../generated_migrations/schema_v4.dart' as v4;
import '../generated_migrations/schema_v5.dart' as v5;

/// Skema dibuat dengan `drift_dev schema dump` dari commit yang dirilis
/// (v1 7d900e2, v3 4054a30, v4 677040c, v5 7bcc285, v6 sekarang); v2 tidak pernah dirilis.
/// Tambah snapshot baru setiap kali `schemaVersion` naik (lihat README).
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  for (final from in GeneratedHelper.versions.where((v) => v < 6)) {
    test('migrasi v$from → v6 menghasilkan skema yang sama dengan instalasi baru', () async {
      final schema = await verifier.schemaAt(from);
      final db = AppDatabase(schema.newConnection());
      await verifier.migrateAndValidate(db, 6);
      await db.close();
    });
  }

  test('data v3 tetap utuh setelah migrasi (profil, set, pengaturan)', () async {
    final schema = await verifier.schemaAt(3);
    final old = v3.DatabaseAtV3(schema.newConnection());
    // Skema snapshot memakai tipe SQL mentah: bool = 0/1, DateTime = detik Unix.
    final t = DateTime(2026, 11, 1).millisecondsSinceEpoch ~/ 1000;
    await old
        .into(old.profileState)
        .insert(
          v3.ProfileStateCompanion.insert(
            onboardingCompleted: const Value(1),
            activeWorkoutPlanId: const Value('plan1'),
            updatedAt: t,
          ),
        );
    await old
        .into(old.appSettings)
        .insert(v3.AppSettingsCompanion.insert(key: 'notifications', value: '{}', updatedAt: t));
    await old.close();

    final db = AppDatabase(schema.newConnection());
    final profile = await db.select(db.profileState).getSingle();
    expect(profile.onboardingCompleted, isTrue);
    expect(profile.activeWorkoutPlanId, 'plan1');
    expect((await db.select(db.appSettings).getSingle()).key, 'notifications');
    // Tabel baru siap dipakai.
    expect(await db.select(db.foodLogs).get(), isEmpty);
    expect(await db.select(db.bodyMetrics).get(), isEmpty);
    await db.close();
  });

  test('data v4 (catatan makanan) tetap utuh setelah migrasi ke v6', () async {
    final schema = await verifier.schemaAt(4);
    final old = v4.DatabaseAtV4(schema.newConnection());
    final t = DateTime(2026, 11, 19).millisecondsSinceEpoch ~/ 1000;
    await old
        .into(old.foodLogs)
        .insert(
          v4.FoodLogsCompanion.insert(
            id: 'f1',
            date: '2026-11-19',
            meal: 'lunch',
            foodId: const Value('tkpi:AP001'),
            name: 'Nasi',
            grams: const Value(150),
            kcal: 270,
            protein: 4.5,
            carbs: 59.7,
            fat: 0.45,
            quality: 'source',
            createdAt: t,
            updatedAt: t,
          ),
        );
    await old.close();

    final db = AppDatabase(schema.newConnection());
    final row = await db.select(db.foodLogs).getSingle();
    expect((row.name, row.kcal, row.grams), ('Nasi', 270.0, 150.0));
    await db.saveWeightForTest();
    await db.close();
  });

  test('data v5 (berat & check-in) tetap utuh; tabel lingkar & foto tersedia', () async {
    final schema = await verifier.schemaAt(5);
    final old = v5.DatabaseAtV5(schema.newConnection());
    final t = DateTime(2026, 11, 19).millisecondsSinceEpoch ~/ 1000;
    await old
        .into(old.bodyMetrics)
        .insert(
          v5.BodyMetricsCompanion.insert(
            date: '2026-11-19',
            weightKg: 70.5,
            createdAt: t,
            updatedAt: t,
          ),
        );
    await old.close();

    final db = AppDatabase(schema.newConnection());
    expect((await db.select(db.bodyMetrics).getSingle()).weightKg, 70.5);
    expect(await db.select(db.bodyMeasurements).get(), isEmpty);
    expect(await db.select(db.progressPhotos).get(), isEmpty);
    await db.close();
  });

  test('hapus semua data: tabel kosong lalu VACUUM berhasil', () async {
    final schema = await verifier.schemaAt(5);
    final db = AppDatabase(schema.newConnection());
    await db.saveWeightForTest();
    await db.wipeAll();
    expect(await db.select(db.bodyMetrics).get(), isEmpty);
    await db.close();
  });
}

extension on AppDatabase {
  Future<void> saveWeightForTest() => into(bodyMetrics).insert(
    BodyMetricsCompanion.insert(
      date: '2026-11-19',
      weightKg: 70,
      createdAt: DateTime(2026, 11, 19),
      updatedAt: DateTime(2026, 11, 19),
    ),
  );
}
