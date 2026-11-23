import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/storage/photo_store.dart';
import 'package:musclecoach/features/backup/data/backup_service.dart';
import 'package:musclecoach/features/backup/domain/backup_crypto.dart';
import 'package:musclecoach/features/progress/data/body_repository.dart';
import 'package:musclecoach/features/progress/data/progress_repository.dart';
import 'package:musclecoach/features/progress/domain/progress_models.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final now = DateTime(2026, 11, 23, 20, 15);
  const password = 'rahasia-kuat';

  late Directory tmp;
  late AppDatabase db;
  late LocalPhotoStore photos;
  late BackupService service;
  late File target;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('mc_backup_');
    db = AppDatabase(NativeDatabase.memory());
    photos = LocalPhotoStore(baseDirectory: () async => Directory('${tmp.path}/support'));
    target = File('${tmp.path}/docs/musclecoach.sqlite');
    await target.parent.create(recursive: true);
    service = BackupService(
      db: db,
      photos: photos,
      workDir: () async => Directory('${tmp.path}/cache'),
      databaseFile: () async => target,
      clock: () => now,
      iterations: 1000, // cepat di test; aplikasi memakai default
    );
  });

  tearDown(() async {
    await db.close();
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  Future<void> seed() async {
    await LocalProgressRepository(db, () => now).saveWeight('2026-11-23', 70.4);
    final src = File('${tmp.path}/foto.jpg')..writeAsBytesSync([0xFF, 0xD8, 1, 2, 3, 0xFF, 0xD9]);
    await LocalBodyRepository(
      db,
      photos,
      () => now,
    ).addPhoto(date: '2026-11-23', pose: PhotoPose.front, sourcePath: src.path);
  }

  test('ekspor → pulihkan: data & foto kembali utuh; berkas terenkripsi', () async {
    await seed();
    final file = await service.export(password);
    expect(file.path, endsWith('muscle-coach-20261123-2015.mcbackup'));
    final bytes = await file.readAsBytes();
    expect(BackupCrypto.looksLikeBackup(bytes), isTrue);
    // Tidak ada teks SQLite/manifest yang terbaca tanpa kata sandi.
    expect(latin1.decode(bytes, allowInvalid: true), isNot(contains('SQLite format 3')));
    expect(await service.watchLastBackup().first, now);

    final plan = await service.prepareRestore(bytes, password);
    expect(plan.manifest.photoCount, 1);
    expect(plan.manifest.schemaVersion, db.schemaVersion);
    await photos.deleteAll(); // simulasikan HP baru
    await service.applyRestore(plan);

    final restored = AppDatabase(NativeDatabase(target));
    addTearDown(restored.close);
    final weights = await LocalProgressRepository(restored, () => now).watchWeights().first;
    expect(weights.single.kg, 70.4);
    final photoRows = await restored.select(restored.progressPhotos).get();
    expect(photoRows, hasLength(1));
    final restoredPhoto = File('${(await photos.directory()).path}/${photoRows.single.fileName}');
    expect(restoredPhoto.readAsBytesSync(), [0xFF, 0xD8, 1, 2, 3, 0xFF, 0xD9]);
  });

  test('kata sandi salah, berkas diubah, bukan cadangan → ditolak', () async {
    final bytes = await (await service.export(password)).readAsBytes();
    expect(service.prepareRestore(bytes, 'salah-sandi'), throwsA(isA<BackupPasswordException>()));
    final tampered = Uint8List.fromList(bytes)..[bytes.length - 20] ^= 0x01;
    expect(service.prepareRestore(tampered, password), throwsA(isA<BackupPasswordException>()));
    expect(
      service.prepareRestore(
        Uint8List.fromList(utf8.encode('bukan cadangan sama sekali')),
        password,
      ),
      throwsA(isA<BackupFormatException>()),
    );
    expect(service.export('pendek'), throwsArgumentError);
  });

  test('cadangan dari versi aplikasi lebih baru ditolak', () async {
    final archive = Archive()
      ..addFile(
        ArchiveFile.string(
          'manifest.json',
          jsonEncode({'app': 'musclecoach', 'format': 1, 'schemaVersion': 999, 'photoCount': 0}),
        ),
      );
    final sealed = await BackupCrypto.encrypt(
      ZipEncoder().encodeBytes(archive),
      password,
      iterations: 1000,
    );
    expect(
      service.prepareRestore(sealed, password),
      throwsA(isA<BackupFormatException>().having((e) => e.reason, 'reason', 'newer')),
    );
  });
}
