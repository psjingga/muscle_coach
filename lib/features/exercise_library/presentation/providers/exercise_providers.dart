import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/exercise_repository.dart';
import '../../domain/exercise.dart';

part 'exercise_providers.g.dart';

@Riverpod(keepAlive: true)
ExerciseRepository exerciseRepository(Ref ref) => AssetExerciseRepository(rootBundle);

/// Katalog latihan, dimuat sekali lalu di-cache selama aplikasi berjalan.
@Riverpod(keepAlive: true)
Future<Map<String, Exercise>> exerciseCatalog(Ref ref) async {
  final list = await ref.watch(exerciseRepositoryProvider).fetchAll();
  return {for (final e in list) e.id: e};
}
