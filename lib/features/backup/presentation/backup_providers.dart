import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database_providers.dart';
import '../../progress/presentation/providers/progress_providers.dart';
import '../data/backup_service.dart';

part 'backup_providers.g.dart';

@riverpod
BackupService backupService(Ref ref) => BackupService(
  db: ref.watch(appDatabaseProvider),
  photos: ref.watch(photoStoreProvider),
  workDir: getTemporaryDirectory,
  // Lokasi bawaan drift_flutter: Documents/<nama>.sqlite.
  databaseFile: () async =>
      File('${(await getApplicationDocumentsDirectory()).path}/musclecoach.sqlite'),
  clock: ref.watch(clockProvider),
);

@riverpod
Stream<DateTime?> lastBackup(Ref ref) => ref.watch(backupServiceProvider).watchLastBackup();
