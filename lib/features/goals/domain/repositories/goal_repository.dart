import '../entities/goal.dart';

abstract interface class GoalRepository {
  Stream<Goal?> watchGoal(String goalId);

  Stream<NutritionPlan?> watchNutritionTarget(String targetId);

  /// Aktifkan usulan goal (server memeriksa ulang semua syarat).
  Future<void> confirm(String goalId, {required bool acknowledgedWarnings});
}
