import 'package:flutter/material.dart';

/// Branding sementara. Ganti nama & warna di sini; logo ada di
/// `app_logo.dart` (ikon aplikasi dibuat ulang dengan `tool/app_icon/generate.sh`).
abstract final class Brand {
  static const appName = 'Muscle Coach';

  /// Warna dasar; seluruh skema warna light/dark diturunkan darinya.
  static const seedColor = Color(0xFF1F7A5C);
}
