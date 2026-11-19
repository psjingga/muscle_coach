import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_logger.dart';
import 'app.dart';

/// Pasang penanganan error global lalu jalankan aplikasi. Basis data lokal
/// dibuka saat pertama kali dibutuhkan (`appDatabaseProvider`).
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    appLogger.e('Flutter error', error: details.exception, stackTrace: details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    appLogger.e('Uncaught error', error: error, stackTrace: stack);
    return true;
  };

  runApp(const ProviderScope(child: MuscleCoachApp()));
}
