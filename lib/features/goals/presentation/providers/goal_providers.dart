import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/firebase/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/firestore_goal_repository.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';

part 'goal_providers.g.dart';

@riverpod
GoalRepository goalRepository(Ref ref) {
  final uid = ref.watch(authStateProvider.select((a) => a.value?.uid));
  if (uid == null) throw const AppFailure(FailureKind.unauthenticated);
  return FirestoreGoalRepository(
    ref.watch(firestoreProvider),
    ref.watch(functionsClientProvider),
    uid,
  );
}

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
}
