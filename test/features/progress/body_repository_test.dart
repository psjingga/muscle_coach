import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/core/storage/photo_store.dart';
import 'package:musclecoach/features/progress/data/body_repository.dart';
import 'package:musclecoach/features/progress/domain/progress_models.dart';

import '../../data/local_repositories_test.dart' show failure;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late Directory tmp;
  late LocalPhotoStore store;
  late LocalBodyRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('mc_photos_');
    store = LocalPhotoStore(baseDirectory: () async => tmp);
    repo = LocalBodyRepository(db, store, () => DateTime(2026, 11, 23, 8));
  });

  tearDown(() async {
    await db.close();
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  group('Lingkar badan', () {
    test('upsert per tanggal, ukuran kosong tidak disimpan, urut tanggal', () async {
      await repo.saveMeasurement(
        const BodyMeasurement(date: '2026-11-23', cm: {BodySite.waist: 80, BodySite.arm: 30}),
      );
      await repo.saveMeasurement(
        const BodyMeasurement(date: '2026-11-23', cm: {BodySite.waist: 79.5}),
      );
      await repo.saveMeasurement(
        const BodyMeasurement(date: '2026-11-01', cm: {BodySite.chest: 95}),
      );
      final all = await repo.watchMeasurements().first;
      expect(all.map((m) => m.date), ['2026-11-01', '2026-11-23']);
      expect(all.last.cm, {BodySite.waist: 79.5});
    });

    test('tanpa ukuran = hapus tanggal itu; validasi rentang & tanggal', () async {
      await repo.saveMeasurement(const BodyMeasurement(date: '2026-11-23', cm: {BodySite.hip: 90}));
      await repo.saveMeasurement(const BodyMeasurement(date: '2026-11-23', cm: {}));
      expect(await repo.watchMeasurements().first, isEmpty);
      for (final cm in [5.0, 300.0]) {
        expect(
          repo.saveMeasurement(BodyMeasurement(date: '2026-11-23', cm: {BodySite.waist: cm})),
          throwsA(failure(FailureKind.invalidInput)),
        );
      }
      expect(
        repo.saveMeasurement(const BodyMeasurement(date: '23-11-2026', cm: {BodySite.waist: 80})),
        throwsA(failure(FailureKind.invalidInput, 'date')),
      );
    });
  });

  group('Foto progres', () {
    Future<String> source(String name) async {
      final f = File('${tmp.path}/$name');
      await f.writeAsBytes([0xFF, 0xD8, 0xFF, 0xD9]);
      return f.path;
    }

    test('foto disalin ke folder privat; hapus menghapus baris & berkas', () async {
      await repo.addPhoto(
        date: '2026-11-23',
        pose: PhotoPose.front,
        sourcePath: await source('a.jpg'),
      );
      await repo.addPhoto(
        date: '2026-11-01',
        pose: PhotoPose.side,
        sourcePath: await source('b.jpg'),
      );
      final photos = await repo.watchPhotos().first;
      expect(photos.map((p) => (p.date, p.pose)), [
        ('2026-11-01', PhotoPose.side),
        ('2026-11-23', PhotoPose.front),
      ]);
      final dir = await store.directory();
      final file = File('${dir.path}/${photos.last.fileName}');
      expect(await file.exists(), isTrue);
      expect(LocalPhotoStore.isSafeName(photos.last.fileName), isTrue);

      await repo.deletePhoto(photos.last.id);
      expect(await repo.watchPhotos().first, hasLength(1));
      expect(await file.exists(), isFalse);
    });

    test('hapus semua: folder foto hilang', () async {
      await repo.addPhoto(
        date: '2026-11-23',
        pose: PhotoPose.back,
        sourcePath: await source('c.jpg'),
      );
      final dir = await store.directory();
      expect(dir.listSync(), isNotEmpty);
      await store.deleteAll();
      expect(await dir.exists(), isFalse);
    });

    test('nama berkas dengan path ditolak saat menghapus', () async {
      final outside = File('${tmp.path}/jangan.jpg')..writeAsBytesSync([1]);
      await store.delete('../jangan.jpg');
      expect(outside.existsSync(), isTrue);
    });
  });
}
