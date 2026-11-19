import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../profile/data/local_profile_repository.dart';
import '../domain/entities/goal.dart';
import '../domain/repositories/goal_repository.dart';

class LocalGoalRepository implements GoalRepository {
  LocalGoalRepository(this._db, this._clock);

  final AppDatabase _db;
  final DateTime Function() _clock;

  static Goal _goal(GoalRow row) =>
      Goal.fromJson(jsonDecode(row.data) as Map<String, dynamic>)
          .copyWith(id: row.id, status: GoalStatus.values.byName(row.status));

  @override
  Stream<Goal?> watchGoal(String goalId) => (_db.select(
    _db.goals,
  )..where((t) => t.id.equals(goalId))).watchSingleOrNull().map((r) => r == null ? null : _goal(r));

  @override
  Stream<NutritionPlan?> watchNutritionTarget(String targetId) =>
      (_db.select(
        _db.nutritionTargets,
      )..where((t) => t.id.equals(targetId))).watchSingleOrNull().map(
        (r) =>
            r == null ? null : NutritionPlan.fromJson(jsonDecode(r.data) as Map<String, dynamic>),
      );

  /// Aturan sama dengan versi server: hanya usulan realistis tanpa gejala
  /// bahaya; peringatan wajib dikonfirmasi; goal & target lama diarsipkan.
  @override
  Future<void> confirm(String goalId, {required bool acknowledgedWarnings}) async {
    final now = _clock();
    await _db.transaction(() async {
      final row = await (_db.select(
        _db.goals,
      )..where((t) => t.id.equals(goalId))).getSingleOrNull();
      if (row == null) throw const AppFailure(FailureKind.notFound);
      final goal = _goal(row);
      if (goal.status != GoalStatus.proposed) {
        throw const AppFailure(FailureKind.invalidInput, debugMessage: 'goal-not-proposed');
      }
      if (goal.safety.stop) {
        throw const AppFailure(FailureKind.invalidInput, debugMessage: 'safety-stop');
      }
      if (!goal.canConfirm) {
        throw const AppFailure(FailureKind.invalidInput, debugMessage: 'goal-needs-adjustment');
      }
      if (goal.requiresAcknowledgement && !acknowledgedWarnings) {
        throw const AppFailure(FailureKind.invalidInput, debugMessage: 'acknowledgement-required');
      }

      await (_db.update(_db.goals)..where((t) => t.status.equals('active'))).write(
        GoalsCompanion(status: const Value('archived'), archivedAt: Value(now)),
      );
      await (_db.update(_db.nutritionTargets)..where((t) => t.status.equals('active'))).write(
        NutritionTargetsCompanion(status: const Value('archived'), archivedAt: Value(now)),
      );
      final targetId = newId();
      await _db
          .into(_db.nutritionTargets)
          .insert(
            NutritionTargetsCompanion.insert(
              id: targetId,
              goalId: goalId,
              status: 'active',
              data: jsonEncode(goal.nutrition.toJson()),
              configVersion: goal.configVersion,
              createdAt: now,
            ),
          );
      await (_db.update(_db.goals)..where((t) => t.id.equals(goalId))).write(
        GoalsCompanion(
          status: const Value('active'),
          activatedAt: Value(now),
          warningsAcknowledged: Value(goal.requiresAcknowledgement),
        ),
      );
      await updateProfile(
        _db,
        ProfileStateCompanion(
          onboardingCompleted: const Value(true),
          activeGoalId: Value(goalId),
          activeNutritionTargetId: Value(targetId),
        ),
        now,
      );
    });
  }
}
