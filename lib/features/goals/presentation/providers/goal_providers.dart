import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/database/database_providers.dart';
import '../../../assessment/application/assessment_wizard_controller.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/local_goal_repository.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';

part 'goal_providers.g.dart';

@riverpod
GoalRepository goalRepository(Ref ref) =>
    LocalGoalRepository(ref.watch(appDatabaseProvider), ref.watch(clockProvider));

@riverpod
Stream<Goal?> goal(Ref ref, String goalId) => ref.watch(goalRepositoryProvider).watchGoal(goalId);

/// Goal aktif berdasarkan `profile.activeGoalId`.
@riverpod
Stream<Goal?> activeGoal(Ref ref) {
  final id = ref.watch(userProfileProvider.select((p) => p.value?.activeGoalId));
  if (id == null) return Stream.value(null);
  return ref.watch(goalRepositoryProvider).watchGoal(id);
}

/// Target nutrisi aktif berdasarkan `profile.activeNutritionTargetId`.
@riverpod
Stream<NutritionPlan?> activeNutritionTarget(Ref ref) {
  final id = ref.watch(userProfileProvider.select((p) => p.value?.activeNutritionTargetId));
  if (id == null) return Stream.value(null);
  return ref.watch(goalRepositoryProvider).watchNutritionTarget(id);
}

/// Aksi konfirmasi goal; `state` = status aksi terakhir.
@riverpod
class GoalConfirmController extends _$GoalConfirmController {
  @override
  FutureOr<void> build() {}

  Future<bool> confirm(String goalId, {required bool acknowledgedWarnings}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      try {
        await ref
            .read(goalRepositoryProvider)
            .confirm(goalId, acknowledgedWarnings: acknowledgedWarnings);
      } catch (e) {
        throw FailureMapper.from(e);
      }
    });
    if (ref.mounted) state = result;
    return !result.hasError;
  }

  /// Kirim ulang assessment terakhir dengan berat target [targetKg] (saran
  /// evaluasi; `null` = tanpa berat target). Mengembalikan ID goal usulan baru.
  Future<String?> resubmitWithTarget(double? targetKg) async {
    state = const AsyncLoading();
    String? goalId;
    final result = await AsyncValue.guard(() async {
      try {
        final id = (await ref.read(userProfileProvider.future))?.latestAssessmentId;
        final repo = ref.read(assessmentRepositoryProvider);
        final data = id == null ? null : await repo.loadAssessment(id);
        if (data == null) throw StateError('assessment_not_found');
        goalId = await repo.submit(
          data.copyWith(goal: data.goal.copyWith(targetWeightKg: targetKg)),
        );
      } catch (e) {
        throw FailureMapper.from(e);
      }
    });
    if (ref.mounted) state = result;
    return result.hasError ? null : goalId;
  }
}
