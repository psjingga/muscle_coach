import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_logger.dart';
import 'app.dart';
import 'config/app_environment.dart';
import 'config/firebase_config.dart';

/// Inisialisasi Firebase sesuai [AppEnvironment] lalu jalankan aplikasi.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    appLogger.e('Flutter error', error: details.exception, stackTrace: details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    appLogger.e('Uncaught error', error: error, stackTrace: stack);
    return true;
  };

  final env = AppEnvironment.current;
  await Firebase.initializeApp(options: FirebaseConfig.optionsFor(env));
  if (env.usesEmulator) await _connectEmulators();
  appLogger.i('Muscle Coach berjalan di lingkungan ${env.name}');

  runApp(const ProviderScope(child: MuscleCoachApp()));
}

Future<void> _connectEmulators() async {
  final host = EmulatorConfig.host;
  await FirebaseAuth.instance.useAuthEmulator(host, EmulatorConfig.authPort);
  FirebaseFirestore.instance.useFirestoreEmulator(host, EmulatorConfig.firestorePort);
  FirebaseFunctions.instanceFor(region: FirebaseConfig.functionsRegion)
      .useFunctionsEmulator(host, EmulatorConfig.functionsPort);
  appLogger.i('Terhubung ke Firebase Emulator di $host');
}
