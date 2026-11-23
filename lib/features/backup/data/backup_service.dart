import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/storage/photo_store.dart';
import '../domain/backup_crypto.dart';

/// Ringkasan isi cadangan (dari `manifest.json`).
class BackupManifest {
  const BackupManifest({
    required this.schemaVersion,
    required this.createdAt,
    required this.photoCount,
  });

  final int schemaVersion;
  final DateTime createdAt;
  final int photoCount;

  static const app = 'musclecoach';
  static const format = 1;

  Map<String, Object?> toJson() => {
    'app': app,
    'format': format,
    'schemaVersion': schemaVersion,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'photoCount': photoCount,
  };
}

/// Cadangan yang sudah didekripsi & diperiksa, siap dipasang.
class RestorePlan {
  const RestorePlan({required this.manifest, required this.dbFile, required this.photosDir});

  final BackupManifest manifest;

  /// Salinan basis data hasil ekstrak (sementara).
  final File dbFile;

  /// Folder foto hasil ekstrak (sementara).
  final Directory photosDir;
}

/// Ekspor & impor cadangan terenkripsi: basis data (snapshot `VACUUM INTO`,
/// konsisten walau aplikasi berjalan) + foto progres + manifest, di-zip lalu
/// dienkripsi dengan kata sandi ([BackupCrypto]). API key Gemini tidak ikut
/// (ada di Keystore/Keychain, bukan di basis data).
class BackupService {
  BackupService({
    required this.db,
    required this.photos,
    required this.workDir,
    required this.databaseFile,
    required this.clock,
    this.iterations = BackupCrypto.defaultIterations,
  });

  final AppDatabase db;
  final PhotoStore photos;

  /// Folder kerja sementara (cache aplikasi).
  final Future<Directory> Function() workDir;

  /// Berkas basis data aktif (`Documents/musclecoach.sqlite`).
  final Future<File> Function() databaseFile;
  final DateTime Function() clock;
  final int iterations;

  static const lastBackupKey = 'last_backup_at';
  static const extension = 'mcbackup';
  static const _dbEntry = 'musclecoach.sqlite';
  static const _photoPrefix = 'photos/';

  static final _safePhoto = RegExp(r'^[A-Za-z0-9_-]+\.(jpg|jpeg|png)$');
  static final _sqliteMagic = ascii.encode('SQLite format 3');

  Future<Directory> _fresh(String name) async {
    final dir = Directory('${(await workDir()).path}/$name');
    if (await dir.exists()) await dir.delete(recursive: true);
    return dir.create(recursive: true);
  }

  String _stamp(DateTime t) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${t.year}${two(t.month)}${two(t.day)}-${two(t.hour)}${two(t.minute)}';
  }

  /// Buat berkas cadangan terenkripsi; kembalikan berkasnya (di cache).
  Future<File> export(String password) async {
    if (password.length < BackupCrypto.minPasswordLength) {
      throw ArgumentError('password-too-short');
    }
    final dir = await _fresh('backup_out');
    final snapshot = File('${dir.path}/$_dbEntry');
    await db.customStatement('VACUUM INTO ?', [snapshot.path]);

    final archive = Archive()..addFile(ArchiveFile.bytes(_dbEntry, await snapshot.readAsBytes()));
    final photoDir = await photos.directory();
    var photoCount = 0;
    for (final row in await db.select(db.progressPhotos).get()) {
      final f = File('${photoDir.path}/${row.fileName}');
      if (_safePhoto.hasMatch(row.fileName) && await f.exists()) {
        archive.addFile(ArchiveFile.bytes('$_photoPrefix${row.fileName}', await f.readAsBytes()));
        photoCount++;
      }
    }
    final now = clock();
    final manifest = BackupManifest(
      schemaVersion: db.schemaVersion,
      createdAt: now,
      photoCount: photoCount,
    );
    archive.addFile(ArchiveFile.string('manifest.json', jsonEncode(manifest.toJson())));
    await snapshot.delete();

    final zipped = ZipEncoder().encodeBytes(archive);
    final sealed = await BackupCrypto.encrypt(zipped, password, iterations: iterations);
    final out = File('${dir.path}/muscle-coach-${_stamp(now)}.$extension');
    await out.writeAsBytes(sealed, flush: true);
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: lastBackupKey,
            value: now.toUtc().toIso8601String(),
            updatedAt: now,
          ),
        );
    return out;
  }

  /// Waktu cadangan terakhir dari perangkat ini.
  Stream<DateTime?> watchLastBackup() =>
      (db.select(db.appSettings)..where((t) => t.key.equals(lastBackupKey)))
          .watchSingleOrNull()
          .map((r) => r == null ? null : DateTime.tryParse(r.value)?.toLocal());

  /// Dekripsi & periksa cadangan, ekstrak ke folder sementara. Belum
  /// mengubah data. Melempar [BackupPasswordException] /
  /// [BackupFormatException].
  Future<RestorePlan> prepareRestore(Uint8List bytes, String password) async {
    final zipped = await BackupCrypto.decrypt(bytes, password);
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipped);
    } catch (_) {
      throw const BackupFormatException('zip');
    }
    ArchiveFile? entry(String name) => archive.files.where((f) => f.name == name).firstOrNull;

    final Map<String, dynamic> m;
    try {
      m = jsonDecode(utf8.decode(entry('manifest.json')!.content)) as Map<String, dynamic>;
    } catch (_) {
      throw const BackupFormatException('manifest');
    }
    if (m['app'] != BackupManifest.app || m['format'] != BackupManifest.format) {
      throw const BackupFormatException('app');
    }
    final schema = m['schemaVersion'];
    if (schema is! int || schema < 1) throw const BackupFormatException('schema');
    if (schema > db.schemaVersion) throw const BackupFormatException('newer');
    final manifest = BackupManifest(
      schemaVersion: schema,
      createdAt: DateTime.tryParse(m['createdAt'] as String? ?? '')?.toLocal() ?? clock(),
      photoCount: (m['photoCount'] as num?)?.toInt() ?? 0,
    );

    final dbBytes = entry(_dbEntry)?.content;
    if (dbBytes == null ||
        dbBytes.length < 100 ||
        !List.generate(_sqliteMagic.length, (i) => dbBytes[i] == _sqliteMagic[i]).every((b) => b)) {
      throw const BackupFormatException('database');
    }

    final dir = await _fresh('backup_in');
    final dbFile = File('${dir.path}/$_dbEntry');
    await dbFile.writeAsBytes(dbBytes, flush: true);
    final photosDir = await Directory('${dir.path}/photos').create();
    for (final f in archive.files) {
      if (!f.isFile || !f.name.startsWith(_photoPrefix)) continue;
      final name = f.name.substring(_photoPrefix.length);
      // Hanya nama berkas sederhana (cegah path traversal).
      if (!_safePhoto.hasMatch(name)) continue;
      await File('${photosDir.path}/$name').writeAsBytes(f.content, flush: true);
    }
    return RestorePlan(manifest: manifest, dbFile: dbFile, photosDir: photosDir);
  }

  /// Pasang cadangan: ganti berkas basis data & folder foto. WAJIB dipanggil
  /// setelah koneksi basis data ditutup; aplikasi lalu dimuat ulang.
  Future<void> applyRestore(RestorePlan plan) async {
    final target = await databaseFile();
    for (final suffix in ['-wal', '-shm', '-journal']) {
      final f = File('${target.path}$suffix');
      if (await f.exists()) await f.delete();
    }
    await plan.dbFile.copy(target.path);
    await photos.deleteAll();
    final photoDir = await photos.directory();
    await for (final e in plan.photosDir.list()) {
      if (e is File) await e.copy('${photoDir.path}/${e.uri.pathSegments.last}');
    }
    final work = plan.dbFile.parent;
    if (await work.exists()) await work.delete(recursive: true);
  }
}
