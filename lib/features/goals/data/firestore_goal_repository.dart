import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/network/functions_client.dart';
import '../domain/entities/goal.dart';
import '../domain/repositories/goal_repository.dart';

class FirestoreGoalRepository implements GoalRepository {
  FirestoreGoalRepository(this._db, this._functions, this._uid);

  final FirebaseFirestore _db;
  final FunctionsClient _functions;
  final String _uid;

  @override
  Stream<Goal?> watchGoal(String goalId) =>
      _db.doc('users/$_uid/goals/$goalId').snapshots().map((s) {
        final json = s.data();
        return json == null ? null : Goal.fromJson(json).copyWith(id: s.id);
      });

  @override
  Stream<NutritionPlan?> watchNutritionTarget(String targetId) => _db
      .doc('users/$_uid/nutritionTargets/$targetId')
      .snapshots()
      .map((s) => s.data() == null ? null : NutritionPlan.fromJson(s.data()!));

  @override
  Future<void> confirm(String goalId, {required bool acknowledgedWarnings}) async {
    await _functions.call(
      'confirmGoal',
      data: {'goalId': goalId, 'acknowledgedWarnings': acknowledgedWarnings},
    );
  }
}
