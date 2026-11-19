import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../assessment/domain/entities/assessment_data.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

// Usulan/goal aktif yang dihitung server (`functions/src/goals/goalPlanner.ts`).
// Client hanya membaca; semua angka berasal dari backend.

@JsonEnum(fieldRename: FieldRename.snake)
enum GoalStatus { proposed, active, archived }

@JsonEnum(fieldRename: FieldRename.snake)
enum GoalVerdict { realistic, needsAdjustment }

@JsonEnum(fieldRename: FieldRename.snake)
enum GoalReason { targetBelowCurrent, rateTooFast, recompositionWeightChange }

@JsonEnum(fieldRename: FieldRename.snake)
enum SafetyWarning {
  redFlagSymptoms,
  minorAge,
  lowBmi,
  highBmi,
  pregnant,
  chronicCondition,
  eatingDisorderHistory,
  injuryRecovery,
  medication,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum SexBasis { male, female, range }

@freezed
abstract class NumRange with _$NumRange {
  const factory NumRange({required double min, required double max}) = _NumRange;

  const NumRange._();

  bool get isSingle => min == max;

  factory NumRange.fromJson(Map<String, dynamic> json) => _$NumRangeFromJson(json);
}

@freezed
abstract class EnergySplit with _$EnergySplit {
  const factory EnergySplit({required int protein, required int fat, required int carbs}) =
      _EnergySplit;

  factory EnergySplit.fromJson(Map<String, dynamic> json) => _$EnergySplitFromJson(json);
}

/// Baseline energi & makro harian (juga isi dokumen `nutritionTargets`).
@freezed
abstract class NutritionPlan with _$NutritionPlan {
  const factory NutritionPlan({
    required SexBasis sexBasis,
    required NumRange bmrKcal,
    required double activityFactor,
    required NumRange tdeeKcal,
    required double surplusPct,
    required NumRange targetKcalRange,
    required int targetKcal,
    required int proteinG,
    required int fatG,
    required int carbsG,
    required double proteinGPerKg,
    required double fatGPerKg,
    required double proteinBasisKg,
    required EnergySplit energySplitPct,
  }) = _NutritionPlan;

  factory NutritionPlan.fromJson(Map<String, dynamic> json) => _$NutritionPlanFromJson(json);
}

@freezed
abstract class GoalEvaluation with _$GoalEvaluation {
  const factory GoalEvaluation({
    required GoalVerdict verdict,
    required List<GoalReason> reasons,
    double? deltaKg,
    double? weeklyChangeKg,
    double? weeklyChangePct,
    required double maxWeeklyGainPct,
    required NumRange expectedWeeklyGainKg,
    int? suggestedWeeks,
    double? suggestedTargetWeightKg,
  }) = _GoalEvaluation;

  factory GoalEvaluation.fromJson(Map<String, dynamic> json) => _$GoalEvaluationFromJson(json);
}

@freezed
abstract class SafetyAssessment with _$SafetyAssessment {
  const factory SafetyAssessment({
    required bool stop,
    required bool conservative,
    required List<SafetyWarning> warnings,
  }) = _SafetyAssessment;

  factory SafetyAssessment.fromJson(Map<String, dynamic> json) => _$SafetyAssessmentFromJson(json);
}

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    @JsonKey(includeFromJson: false, includeToJson: false) @Default('') String id,
    required GoalStatus status,
    required PrimaryGoal primaryGoal,
    required ExperienceLevel level,
    required int age,
    required double bmi,
    required double startWeightKg,
    double? targetWeightKg,
    required int targetWeeks,

    /// `YYYY-MM-DD`.
    required String targetDate,
    required GoalEvaluation evaluation,
    required SafetyAssessment safety,
    required NutritionPlan nutrition,
    required String configVersion,
  }) = _Goal;

  const Goal._();

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  /// Sama dengan `canConfirm` di server.
  bool get canConfirm =>
      status == GoalStatus.proposed && !safety.stop && evaluation.verdict == GoalVerdict.realistic;

  bool get requiresAcknowledgement => safety.warnings.isNotEmpty;
}
