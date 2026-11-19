import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'database_providers.g.dart';

/// Basis data lokal, dibuka sekali selama aplikasi berjalan.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

/// Jam aplikasi (dapat dioverride di test).
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;
