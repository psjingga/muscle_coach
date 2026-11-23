import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart' show newId;

/// Penyimpanan berkas foto progres di folder privat aplikasi
/// (`Application Support/progress_photos`). Android: tidak ikut cadangan
/// cloud (`data_extraction_rules.xml`). iOS: lihat PRIVACY.md.
abstract interface class PhotoStore {
  /// Folder foto (dibuat bila belum ada).
  Future<Directory> directory();

  /// Salin berkas dari [sourcePath] (mis. hasil kamera/galeri) ke folder
  /// foto. Mengembalikan nama berkas baru.
  Future<String> import(String sourcePath);

  Future<void> delete(String fileName);

  /// Hapus seluruh folder foto (hapus semua data).
  Future<void> deleteAll();
}

class LocalPhotoStore implements PhotoStore {
  LocalPhotoStore({Future<Directory> Function()? baseDirectory})
    : _base = baseDirectory ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _base;

  static const folder = 'progress_photos';

  Future<Directory> _dir() async => Directory('${(await _base()).path}/$folder');

  @override
  Future<Directory> directory() async => (await _dir()).create(recursive: true);

  /// Hanya nama berkas sederhana (tanpa path) yang diterima.
  static bool isSafeName(String name) => RegExp(r'^[A-Za-z0-9_-]+\.(jpg|jpeg|png)$').hasMatch(name);

  @override
  Future<String> import(String sourcePath) async {
    final dir = await directory();
    final ext = sourcePath.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
    final name = '${newId()}.$ext';
    await File(sourcePath).copy('${dir.path}/$name');
    return name;
  }

  @override
  Future<void> delete(String fileName) async {
    if (!isSafeName(fileName)) return;
    final file = File('${(await _dir()).path}/$fileName');
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> deleteAll() async {
    final dir = await _dir();
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
