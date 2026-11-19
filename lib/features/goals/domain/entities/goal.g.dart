// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NumRange _$NumRangeFromJson(Map<String, dynamic> json) =>
    _NumRange(min: (json['min'] as num).toDouble(), max: (json['max'] as num).toDouble());

Map<String, dynamic> _$NumRangeToJson(_NumRange instance) => <String, dynamic>{
  'min': instance.min,
  'max': instance.max,
};

_EnergySplit _$EnergySplitFromJson(Map<String, dynamic> json) => _EnergySplit(
  protein: (json['protein'] as num).toInt(),
  fat: (json['fat'] as num).toInt(),
  carbs: (json['carbs'] as num).toInt(),
);

Map<String, dynamic> _$EnergySplitToJson(_EnergySplit instance) => <String, dynamic>{
  'protein': instance.protein,
  'fat': instance.fat,
  'carbs': instance.carbs,
};

_NutritionPlan _$NutritionPlanFromJson(Map<String, dynamic> json) => _NutritionPlan(
  sexBasis: $enumDecode(_$SexBasisEnumMap, json['sexBasis']),
  bmrKcal: NumRange.fromJson(json['bmrKcal'] as Map<String, dynamic>),
  activityFactor: (json['activityFactor'] as num).toDouble(),
  tdeeKcal: NumRange.fromJson(json['tdeeKcal'] as Map<String, dynamic>),
  surplusPct: (json['surplusPct'] as num).toDouble(),
  targetKcalRange: NumRange.fromJson(json['targetKcalRange'] as Map<String, dynamic>),
  targetKcal: (json['targetKcal'] as num).toInt(),
  proteinG: (json['proteinG'] as num).toInt(),
  fatG: (json['fatG'] as num).toInt(),
  carbsG: (json['carbsG'] as num).toInt(),
  proteinGPerKg: (json['proteinGPerKg'] as num).toDouble(),
  fatGPerKg: (json['fatGPerKg'] as num).toDouble(),
  proteinBasisKg: (json['proteinBasisKg'] as num).toDouble(),
  energySplitPct: EnergySplit.fromJson(json['energySplitPct'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NutritionPlanToJson(_NutritionPlan instance) => <String, dynamic>{
  'sexBasis': _$SexBasisEnumMap[instance.sexBasis]!,
  'bmrKcal': instance.bmrKcal.toJson(),
  'activityFactor': instance.activityFactor,
  'tdeeKcal': instance.tdeeKcal.toJson(),
  'surplusPct': instance.surplusPct,
  'targetKcalRange': instance.targetKcalRange.toJson(),
  'targetKcal': instance.targetKcal,
  'proteinG': instance.proteinG,
  'fatG': instance.fatG,
  'carbsG': instance.carbsG,
  'proteinGPerKg': instance.proteinGPerKg,
  'fatGPerKg': instance.fatGPerKg,
  'proteinBasisKg': instance.proteinBasisKg,
  'energySplitPct': instance.energySplitPct.toJson(),
};

const _$SexBasisEnumMap = {
  SexBasis.male: 'male',
  SexBasis.female: 'female',
  SexBasis.range: 'range',
};

_GoalEvaluation _$GoalEvaluationFromJson(Map<String, dynamic> json) => _GoalEvaluation(
  verdict: $enumDecode(_$GoalVerdictEnumMap, json['verdict']),
  reasons: (json['reasons'] as List<dynamic>)
      .map((e) => $enumDecode(_$GoalReasonEnumMap, e))
      .toList(),
  deltaKg: (json['deltaKg'] as num?)?.toDouble(),
  weeklyChangeKg: (json['weeklyChangeKg'] as num?)?.toDouble(),
  weeklyChangePct: (json['weeklyChangePct'] as num?)?.toDouble(),
  maxWeeklyGainPct: (json['maxWeeklyGainPct'] as num).toDouble(),
  expectedWeeklyGainKg: NumRange.fromJson(json['expectedWeeklyGainKg'] as Map<String, dynamic>),
  suggestedWeeks: (json['suggestedWeeks'] as num?)?.toInt(),
  suggestedTargetWeightKg: (json['suggestedTargetWeightKg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GoalEvaluationToJson(_GoalEvaluation instance) => <String, dynamic>{
  'verdict': _$GoalVerdictEnumMap[instance.verdict]!,
  'reasons': instance.reasons.map((e) => _$GoalReasonEnumMap[e]!).toList(),
  'deltaKg': instance.deltaKg,
  'weeklyChangeKg': instance.weeklyChangeKg,
  'weeklyChangePct': instance.weeklyChangePct,
  'maxWeeklyGainPct': instance.maxWeeklyGainPct,
  'expectedWeeklyGainKg': instance.expectedWeeklyGainKg.toJson(),
  'suggestedWeeks': instance.suggestedWeeks,
  'suggestedTargetWeightKg': instance.suggestedTargetWeightKg,
};

const _$GoalVerdictEnumMap = {
  GoalVerdict.realistic: 'realistic',
  GoalVerdict.needsAdjustment: 'needs_adjustment',
};

const _$GoalReasonEnumMap = {
  GoalReason.targetBelowCurrent: 'target_below_current',
  GoalReason.rateTooFast: 'rate_too_fast',
  GoalReason.recompositionWeightChange: 'recomposition_weight_change',
};

_SafetyAssessment _$SafetyAssessmentFromJson(Map<String, dynamic> json) => _SafetyAssessment(
  stop: json['stop'] as bool,
  conservative: json['conservative'] as bool,
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => $enumDecode(_$SafetyWarningEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$SafetyAssessmentToJson(_SafetyAssessment instance) => <String, dynamic>{
  'stop': instance.stop,
  'conservative': instance.conservative,
  'warnings': instance.warnings.map((e) => _$SafetyWarningEnumMap[e]!).toList(),
};

const _$SafetyWarningEnumMap = {
  SafetyWarning.redFlagSymptoms: 'red_flag_symptoms',
  SafetyWarning.minorAge: 'minor_age',
  SafetyWarning.lowBmi: 'low_bmi',
  SafetyWarning.highBmi: 'high_bmi',
  SafetyWarning.pregnant: 'pregnant',
  SafetyWarning.chronicCondition: 'chronic_condition',
  SafetyWarning.eatingDisorderHistory: 'eating_disorder_history',
  SafetyWarning.injuryRecovery: 'injury_recovery',
  SafetyWarning.medication: 'medication',
};

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
  status: $enumDecode(_$GoalStatusEnumMap, json['status']),
  primaryGoal: $enumDecode(_$PrimaryGoalEnumMap, json['primaryGoal']),
  level: $enumDecode(_$ExperienceLevelEnumMap, json['level']),
  age: (json['age'] as num).toInt(),
  bmi: (json['bmi'] as num).toDouble(),
  startWeightKg: (json['startWeightKg'] as num).toDouble(),
  targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble(),
  targetWeeks: (json['targetWeeks'] as num).toInt(),
  targetDate: json['targetDate'] as String,
  evaluation: GoalEvaluation.fromJson(json['evaluation'] as Map<String, dynamic>),
  safety: SafetyAssessment.fromJson(json['safety'] as Map<String, dynamic>),
  nutrition: NutritionPlan.fromJson(json['nutrition'] as Map<String, dynamic>),
  configVersion: json['configVersion'] as String,
);

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
  'status': _$GoalStatusEnumMap[instance.status]!,
  'primaryGoal': _$PrimaryGoalEnumMap[instance.primaryGoal]!,
  'level': _$ExperienceLevelEnumMap[instance.level]!,
  'age': instance.age,
  'bmi': instance.bmi,
  'startWeightKg': instance.startWeightKg,
  'targetWeightKg': instance.targetWeightKg,
  'targetWeeks': instance.targetWeeks,
  'targetDate': instance.targetDate,
  'evaluation': instance.evaluation.toJson(),
  'safety': instance.safety.toJson(),
  'nutrition': instance.nutrition.toJson(),
  'configVersion': instance.configVersion,
};

const _$GoalStatusEnumMap = {
  GoalStatus.proposed: 'proposed',
  GoalStatus.active: 'active',
  GoalStatus.archived: 'archived',
};

const _$PrimaryGoalEnumMap = {
  PrimaryGoal.muscleGain: 'muscle_gain',
  PrimaryGoal.strength: 'strength',
  PrimaryGoal.recomposition: 'recomposition',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
};
