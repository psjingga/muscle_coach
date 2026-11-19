import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logger aplikasi. Jangan mencatat data kesehatan, makanan, profil,
/// email, atau token — cukup kode error dan konteks teknis.
final Logger appLogger = Logger(
  level: kReleaseMode ? Level.warning : Level.debug,
  printer: kReleaseMode
      ? SimplePrinter(colors: false)
      : PrettyPrinter(methodCount: 0, errorMethodCount: 6, lineLength: 100),
);
