import 'dart:io' show Platform;

/// Lingkungan aplikasi, dipilih saat build:
/// `--dart-define=APP_ENV=emulator|dev|prod` (default: `emulator`).
enum AppEnvironment {
  /// Firebase Emulator Suite lokal (project `demo-*`, tanpa project nyata).
  emulator,

  /// Project Firebase pengembangan.
  dev,

  /// Project Firebase produksi.
  prod;

  static const _raw = String.fromEnvironment('APP_ENV', defaultValue: 'emulator');

  static AppEnvironment get current => parse(_raw);

  static AppEnvironment parse(String value) => switch (value.trim()) {
    'dev' => dev,
    'prod' => prod,
    _ => emulator,
  };

  bool get usesEmulator => this == emulator;
}

/// Alamat Firebase Emulator Suite. Port mengikuti `firebase.json`.
abstract final class EmulatorConfig {
  /// Untuk HP fisik: `--dart-define=EMULATOR_HOST=<IP Mac di LAN>`.
  /// Jangan pakai `127.0.0.1`/`localhost` + `adb reverse`: plugin FlutterFire
  /// Android selalu memetakannya ke `10.0.2.2` (hanya ada di emulator Android).
  static const _hostOverride = String.fromEnvironment('EMULATOR_HOST');

  static const authPort = 9099;
  static const firestorePort = 8080;
  static const functionsPort = 5001;

  /// Emulator Android menjangkau komputer host lewat `10.0.2.2`;
  /// simulator iOS lewat `localhost`.
  static String get host {
    if (_hostOverride.isNotEmpty) return _hostOverride;
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }
}
