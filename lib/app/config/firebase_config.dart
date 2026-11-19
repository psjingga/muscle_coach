import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';

import 'app_environment.dart';

/// Konfigurasi Firebase per lingkungan.
abstract final class FirebaseConfig {
  /// Project ID berawalan `demo-` hanya berjalan di Emulator dan tidak
  /// pernah menyentuh resource Firebase sungguhan.
  static const emulatorProjectId = 'demo-musclecoach';

  /// Region Cloud Functions (Jakarta). Harus sama dengan
  /// `functions/src/common/config.ts`.
  static const functionsRegion = 'asia-southeast2';

  static FirebaseOptions optionsFor(AppEnvironment env) => switch (env) {
    AppEnvironment.emulator => FirebaseOptions(
      // Bukan key sungguhan: hanya berformat valid karena SDK Functions
      // Android menolak key yang tidak berpola `AIza` + 35 karakter.
      apiKey: 'AIzaSyDemoMuscleCoachEmulatorOnly-00000',
      appId: Platform.isIOS
          ? '1:000000000000:ios:0000000000000000'
          : '1:000000000000:android:0000000000000000',
      messagingSenderId: '000000000000',
      projectId: emulatorProjectId,
      iosBundleId: 'com.panjijingga.musclecoach',
    ),
    // Diisi setelah project Firebase dibuat:
    // `flutterfire configure` → lib/app/config/firebase_options_<env>.dart.
    AppEnvironment.dev || AppEnvironment.prod => throw UnsupportedError(
      'Project Firebase "${env.name}" belum dikonfigurasi. '
      'Jalankan dengan APP_ENV=emulator, atau lihat README bagian '
      '"Menghubungkan project Firebase".',
    ),
  };
}
