import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/assessment/application/assessment_wizard_controller.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';
import 'package:musclecoach/features/exercise_library/domain/exercise.dart';
import 'package:musclecoach/features/exercise_library/presentation/providers/exercise_providers.dart';
import 'package:musclecoach/features/goals/presentation/providers/goal_providers.dart';
import 'package:musclecoach/features/workout/presentation/providers/workout_providers.dart';

import '../fixtures/sample_assessment.dart';

class _FileExerciseRepository implements ExerciseRepository {
  @override
  Future<List<Exercise>> fetchAll() async =>
      AssetExerciseRepository.parse(File(AssetExerciseRepository.path).readAsStringSync())
          .exercises;
}

/// Alur lewat provider asli (bukan mock) dengan database di memori —
/// menangkap kesalahan wiring/lifecycle provider.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('repository workout tidak auto-dispose (closure katalog dipakai setelah await)', () {
    // Regresi: versi autoDispose melempar UnmountedRefException saat membuat
    // program di perangkat (aset katalog dimuat melewati beberapa frame).
    expect(workoutRepositoryProvider.isAutoDispose, isFalse);
  });

  test('submit → konfirmasi → buat & aktifkan program lewat provider', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final c = ProviderContainer.test(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        exerciseRepositoryProvider.overrideWithValue(_FileExerciseRepository()),
      ],
    );
    addTearDown(db.close);

    final goalId = await c.read(assessmentRepositoryProvider).submit(sample);
    expect(
      await c
          .read(goalConfirmControllerProvider.notifier)
          .confirm(goalId, acknowledgedWarnings: false),
      isTrue,
    );

    // Tanpa listener (seperti tombol di UI): provider repository tidak boleh mati di tengah proses.
    final planId = await c.read(workoutActionsProvider.notifier).createStarterPlan();
    expect(c.read(workoutActionsProvider).error, isNull);
    expect(planId, isNotNull);
    expect(await c.read(workoutActionsProvider.notifier).activatePlan(planId!), isTrue);
  });
}
