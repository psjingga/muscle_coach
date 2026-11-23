import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/ai_coach/application/ai_plan_service.dart';
import 'package:musclecoach/features/ai_coach/data/ai_repository.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_client.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_config.dart';
import 'package:musclecoach/features/nutrition/application/food_scan_service.dart';
import 'package:musclecoach/features/nutrition/data/nutrition_repository.dart';
import 'package:musclecoach/features/nutrition/domain/food.dart';
import 'package:musclecoach/features/nutrition/domain/food_log.dart';
import 'package:musclecoach/features/nutrition/domain/food_scan.dart';
import 'package:musclecoach/features/nutrition/presentation/providers/food_scan_providers.dart';
import 'package:musclecoach/features/nutrition/presentation/providers/nutrition_providers.dart';
import 'package:musclecoach/features/nutrition/presentation/screens/food_scan_screen.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../ai_coach/ai_coach_test.dart' show FakeAiClient, MemoryKeyStore;
import 'nutrition_repository_test.dart' show foodSource;

final now = DateTime(2026, 11, 23, 12);

String scanJson({bool isFood = true, List<Map<String, Object?>>? items}) => jsonEncode({
  'isFood': isFood,
  'dishName': 'Nasi telur',
  'items':
      items ??
      [
        {
          'name': 'Nasi putih',
          'grams': 180,
          'tkpiCode': 'AP001',
          'kcal': 300,
          'protein': 5,
          'carbs': 65,
          'fat': 1,
        },
        {
          'name': 'Sambal goreng',
          'grams': 30,
          'tkpiCode': null,
          'kcal': 60,
          'protein': 1,
          'carbs': 4,
          'fat': 4.5,
        },
      ],
  'notes': 'Minyak tidak terlihat.',
});

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Map<String, Food> byCode;

  setUpAll(() async {
    byCode = {for (final f in (await foodSource.foods()).values) ?f.code: f};
  });

  group('FoodScanValidator', () {
    test('TKPI dipakai bila kode valid; tanpa padanan → estimasi AI per 100 g', () {
      final p = FoodScanValidator.parse(scanJson(), byCode);
      expect(p.isValid, isTrue);
      expect(p.dishName, 'Nasi telur');
      final nasi = p.items[0];
      expect(nasi.isTkpi, isTrue);
      expect(nasi.food!.code, 'AP001');
      // Gizi dari TKPI (180 kcal/100 g), bukan angka model (300).
      expect(nasi.nutrients.kcal, closeTo(180 * 1.8, 0.01));
      final sambal = p.items[1];
      expect(sambal.isTkpi, isFalse);
      expect(sambal.nutrients.kcal, closeTo(60, 0.01));
      expect(sambal.withGrams(60).nutrients.kcal, closeTo(120, 0.01));
    });

    test('kode karangan diabaikan → estimasi; kcal dihitung ulang bila tak konsisten', () {
      final p = FoodScanValidator.parse(
        scanJson(
          items: [
            {
              'name': 'Ayam bakar',
              'grams': 100,
              'tkpiCode': 'XX999',
              'kcal': 900,
              'protein': 30,
              'carbs': 0,
              'fat': 10,
            },
          ],
        ),
        byCode,
      );
      final item = p.items.single;
      expect(item.isTkpi, isFalse);
      expect(item.nutrients.kcal, closeTo(4 * 30 + 9 * 10, 0.01));
    });

    test('bukan makanan, JSON rusak, gram di luar batas, tanpa estimasi', () {
      expect(FoodScanValidator.parse(scanJson(isFood: false, items: []), byCode).notFood, isTrue);
      expect(FoodScanValidator.parse('bukan json', byCode).isValid, isFalse);
      expect(
        FoodScanValidator.parse(
          scanJson(
            items: [
              {
                'name': 'Nasi',
                'grams': 5000,
                'tkpiCode': 'AP001',
                'kcal': 1,
                'protein': 0,
                'carbs': 0,
                'fat': 0,
              },
            ],
          ),
          byCode,
        ).isValid,
        isFalse,
      );
      expect(
        FoodScanValidator.parse(
          scanJson(
            items: [
              {
                'name': 'Misteri',
                'grams': 100,
                'tkpiCode': null,
                'kcal': -5,
                'protein': 0,
                'carbs': 0,
                'fat': 0,
              },
            ],
          ),
          byCode,
        ).isValid,
        isFalse,
      );
    });
  });

  group('FoodScanService', () {
    late AppDatabase db;
    late AiRepository aiRepo;
    late NutritionRepository repo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      aiRepo = AiRepository(db);
      repo = LocalNutritionRepository(db, () => now, foodSource);
      await aiRepo.setConsent(accepted: true, now: now);
    });
    tearDown(() => db.close());

    FoodScanService service(FakeAiClient client, {String? key = 'kunci-uji'}) => FoodScanService(
      nutrition: repo,
      ai: aiRepo,
      client: client,
      keys: MemoryKeyStore(key),
      clock: () => now,
      model: () async => AiConfig.defaultModel,
    );

    const image = AiImage(bytes: [0xFF, 0xD8, 0xFF, 0xD9], mimeType: 'image/jpeg');

    test('foto terkirim bersama katalog; hasil tidak disimpan; log tanpa isi', () async {
      final client = FakeAiClient([scanJson()]);
      final r = await service(client).scan(image);
      expect(r.items, hasLength(2));
      expect(r.promptVersion, 'food_scan.v1');
      expect(client.imageCounts, [1]);
      expect(client.requests.single, contains('AP001|Nasi'));
      expect(await repo.watchDay('2026-11-23').first, isEmpty);
      final log = (await db.select(db.aiGenerationLogs).get()).single;
      expect((log.kind, log.status), ('food_scan', 'success'));
    });

    test('keluaran tidak valid → 1 retry dengan umpan balik, lalu berhasil', () async {
      final client = FakeAiClient(['{"isFood": true, "dishName": "x", "items": []}', scanJson()]);
      final r = await service(client).scan(image);
      expect(r.items, hasLength(2));
      expect(client.requests.last, contains('sebelumnya_tidak_valid'));
    });

    test('tanpa key / tanpa persetujuan → tidak memanggil AI', () async {
      final client = FakeAiClient([]);
      expect(
        service(client, key: null).scan(image),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'error', AiPlanError.noKey)),
      );
      await aiRepo.setConsent(accepted: false, now: now);
      expect(
        service(client).scan(image),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'error', AiPlanError.noConsent)),
      );
    });
  });

  test('simpan draft: TKPI via katalog, sisanya "Estimasi AI"; foto sementara dihapus', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        foodDataSourceProvider.overrideWithValue(foodSource),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final tmp = File('${Directory.systemTemp.createTempSync('scan_').path}/foto.jpg')
      ..writeAsBytesSync([1, 2, 3]);
    final parsed = FoodScanValidator.parse(scanJson(), byCode);
    final draft = c.read(foodScanDraftControllerProvider.notifier)
      ..set(
        FoodScanDraft(
          date: '2026-11-23',
          meal: MealSlot.breakfast,
          result: FoodScanResult(
            dishName: 'Nasi telur',
            items: parsed.items,
            promptVersion: 'food_scan.v1',
          ),
          items: parsed.items,
          imagePath: tmp.path,
        ),
      )
      ..setMeal(MealSlot.lunch)
      ..setGrams(0, 200);
    expect(await draft.save(), 2);
    expect(tmp.existsSync(), isFalse);
    expect(c.read(foodScanDraftControllerProvider), isNull);

    final logged = await c.read(nutritionRepositoryProvider).watchDay('2026-11-23').first;
    expect(logged.map((e) => (e.meal, e.quality)), [
      (MealSlot.lunch, NutritionQuality.source),
      (MealSlot.lunch, NutritionQuality.aiEstimate),
    ]);
    expect(logged.first.grams, 200);
    expect(logged.first.nutrients.kcal, closeTo(360, 0.5));
    expect(logged.last.name, 'Sambal goreng');
  });

  testWidgets('layar tinjauan: label sumber, ubah gram memperbarui total, hapus item', (
    tester,
  ) async {
    final parsed = FoodScanValidator.parse(scanJson(), byCode);
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c
        .read(foodScanDraftControllerProvider.notifier)
        .set(
          FoodScanDraft(
            date: '2026-11-23',
            meal: MealSlot.lunch,
            result: FoodScanResult(
              dishName: 'Nasi telur',
              items: parsed.items,
              promptVersion: 'food_scan.v1',
            ),
            items: parsed.items,
            imagePath: '/tidak/ada.jpg',
          ),
        );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('id'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const FoodScanScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Nasi telur'), findsOneWidget);
    expect(find.text('TKPI'), findsOneWidget);
    expect(find.text('Estimasi AI'), findsOneWidget);
    expect(find.text('Dicatat sebagai: Nasi'), findsOneWidget);
    String total() => tester.widget<Text>(find.byKey(const Key('scan-total-kcal'))).data!;
    expect(total(), '384'); // 180 g nasi (324) + sambal (60)
    await tester.enterText(find.byKey(const ValueKey('scan-grams-0')), '100');
    await tester.pump();
    expect(total(), '240');
    await tester.tap(find.byKey(const ValueKey('scan-remove-1')));
    await tester.pump();
    expect(total(), '180');
    expect(find.text('Catat 1 item'), findsOneWidget);
  });
}
