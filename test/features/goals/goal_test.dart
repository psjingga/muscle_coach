import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';

import '../../fixtures/assessment_fixtures.dart';

void main() {
  test('Goal.fromJson membaca dokumen server', () {
    final g = Goal.fromJson(goalJson());
    expect(g.status, GoalStatus.proposed);
    expect(g.primaryGoal, PrimaryGoal.muscleGain);
    expect(g.startWeightKg, 70.0);
    expect(g.evaluation.verdict, GoalVerdict.realistic);
    expect(g.nutrition.targetKcal, 2495);
    expect(g.nutrition.bmrKcal.isSingle, isTrue);
    expect(g.nutrition.energySplitPct.carbs, 60);
  });

  test('NutritionPlan juga bisa dibaca dari dokumen nutritionTargets (field datar)', () {
    final json = {
      ...goalJson()['nutrition'] as Map<String, dynamic>,
      'status': 'active',
      'goalId': 'g1',
    };
    expect(NutritionPlan.fromJson(json).proteinG, 125);
  });

  test('canConfirm sama dengan aturan server', () {
    expect(testGoal().canConfirm, isTrue);
    expect(testGoal(verdict: 'needs_adjustment', reasons: ['rate_too_fast']).canConfirm, isFalse);
    expect(testGoal(stop: true, warnings: ['red_flag_symptoms']).canConfirm, isFalse);
    expect(testGoal(status: 'active').canConfirm, isFalse);
    expect(testGoal(warnings: ['medication']).requiresAcknowledgement, isTrue);
  });

  test('enum alasan & peringatan dari snake_case', () {
    final g = testGoal(
      verdict: 'needs_adjustment',
      reasons: ['target_below_current', 'recomposition_weight_change'],
      warnings: ['eating_disorder_history', 'low_bmi'],
    );
    expect(g.evaluation.reasons, [
      GoalReason.targetBelowCurrent,
      GoalReason.recompositionWeightChange,
    ]);
    expect(g.safety.warnings, [SafetyWarning.eatingDisorderHistory, SafetyWarning.lowBmi]);
  });
}
