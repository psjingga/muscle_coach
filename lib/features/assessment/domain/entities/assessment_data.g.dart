// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileSection _$ProfileSectionFromJson(Map<String, dynamic> json) => _ProfileSection(
  nickname: json['nickname'] as String?,
  birthDate: json['birthDate'] as String?,
  sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
  heightCm: (json['heightCm'] as num?)?.toDouble(),
  weightKg: (json['weightKg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ProfileSectionToJson(_ProfileSection instance) => <String, dynamic>{
  'nickname': instance.nickname,
  'birthDate': instance.birthDate,
  'sex': _$SexEnumMap[instance.sex],
  'heightCm': instance.heightCm,
  'weightKg': instance.weightKg,
};

const _$SexEnumMap = {Sex.male: 'male', Sex.female: 'female', Sex.undisclosed: 'undisclosed'};

_GoalSection _$GoalSectionFromJson(Map<String, dynamic> json) => _GoalSection(
  primary: $enumDecodeNullable(_$PrimaryGoalEnumMap, json['primary']),
  targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble(),
  targetWeeks: (json['targetWeeks'] as num?)?.toInt(),
  priorityMuscles:
      (json['priorityMuscles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MuscleGroupEnumMap, e))
          .toList() ??
      const <MuscleGroup>[],
  motivation: json['motivation'] as String?,
);

Map<String, dynamic> _$GoalSectionToJson(_GoalSection instance) => <String, dynamic>{
  'primary': _$PrimaryGoalEnumMap[instance.primary],
  'targetWeightKg': instance.targetWeightKg,
  'targetWeeks': instance.targetWeeks,
  'priorityMuscles': instance.priorityMuscles.map((e) => _$MuscleGroupEnumMap[e]!).toList(),
  'motivation': instance.motivation,
};

const _$PrimaryGoalEnumMap = {
  PrimaryGoal.muscleGain: 'muscle_gain',
  PrimaryGoal.strength: 'strength',
  PrimaryGoal.recomposition: 'recomposition',
};

const _$MuscleGroupEnumMap = {
  MuscleGroup.chest: 'chest',
  MuscleGroup.back: 'back',
  MuscleGroup.shoulders: 'shoulders',
  MuscleGroup.arms: 'arms',
  MuscleGroup.legs: 'legs',
  MuscleGroup.glutes: 'glutes',
  MuscleGroup.core: 'core',
};

_ExperienceSection _$ExperienceSectionFromJson(Map<String, dynamic> json) => _ExperienceSection(
  level: $enumDecodeNullable(_$ExperienceLevelEnumMap, json['level']),
  trainingAge: $enumDecodeNullable(_$TrainingAgeEnumMap, json['trainingAge']),
  currentSessionsPerWeek: (json['currentSessionsPerWeek'] as num?)?.toInt(),
  knownExercises: json['knownExercises'] as String?,
  workingWeights: json['workingWeights'] as String?,
);

Map<String, dynamic> _$ExperienceSectionToJson(_ExperienceSection instance) => <String, dynamic>{
  'level': _$ExperienceLevelEnumMap[instance.level],
  'trainingAge': _$TrainingAgeEnumMap[instance.trainingAge],
  'currentSessionsPerWeek': instance.currentSessionsPerWeek,
  'knownExercises': instance.knownExercises,
  'workingWeights': instance.workingWeights,
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
};

const _$TrainingAgeEnumMap = {
  TrainingAge.none: 'none',
  TrainingAge.under6Months: 'lt_6m',
  TrainingAge.sixMonthsTo2Years: '6m_2y',
  TrainingAge.twoTo5Years: '2y_5y',
  TrainingAge.over5Years: 'gt_5y',
};

_EquipmentSelection _$EquipmentSelectionFromJson(Map<String, dynamic> json) => _EquipmentSelection(
  dumbbell: json['dumbbell'] as bool? ?? false,
  barbell: json['barbell'] as bool? ?? false,
  bench: json['bench'] as bool? ?? false,
  rack: json['rack'] as bool? ?? false,
  pullUpBar: json['pullUpBar'] as bool? ?? false,
);

Map<String, dynamic> _$EquipmentSelectionToJson(_EquipmentSelection instance) => <String, dynamic>{
  'dumbbell': instance.dumbbell,
  'barbell': instance.barbell,
  'bench': instance.bench,
  'rack': instance.rack,
  'pullUpBar': instance.pullUpBar,
};

_AvailabilitySection _$AvailabilitySectionFromJson(Map<String, dynamic> json) =>
    _AvailabilitySection(
      trainingDays:
          (json['trainingDays'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ??
          const <int>[],
      sessionMinutes: (json['sessionMinutes'] as num?)?.toInt(),
      location: $enumDecodeNullable(_$TrainingLocationEnumMap, json['location']),
      equipment: json['equipment'] == null
          ? const EquipmentSelection()
          : EquipmentSelection.fromJson(json['equipment'] as Map<String, dynamic>),
      dumbbellMaxKg: (json['dumbbellMaxKg'] as num?)?.toDouble(),
      barbellMaxKg: (json['barbellMaxKg'] as num?)?.toDouble(),
      preferences: json['preferences'] as String?,
    );

Map<String, dynamic> _$AvailabilitySectionToJson(_AvailabilitySection instance) =>
    <String, dynamic>{
      'trainingDays': instance.trainingDays,
      'sessionMinutes': instance.sessionMinutes,
      'location': _$TrainingLocationEnumMap[instance.location],
      'equipment': instance.equipment.toJson(),
      'dumbbellMaxKg': instance.dumbbellMaxKg,
      'barbellMaxKg': instance.barbellMaxKg,
      'preferences': instance.preferences,
    };

const _$TrainingLocationEnumMap = {TrainingLocation.home: 'home', TrainingLocation.gym: 'gym'};

_ActivitySection _$ActivitySectionFromJson(Map<String, dynamic> json) => _ActivitySection(
  level: $enumDecodeNullable(_$ActivityLevelEnumMap, json['level']),
  occupation: $enumDecodeNullable(_$OccupationEnumMap, json['occupation']),
  sleepHours: (json['sleepHours'] as num?)?.toDouble(),
  stress: $enumDecodeNullable(_$StressLevelEnumMap, json['stress']),
  cardio: json['cardio'] as String?,
);

Map<String, dynamic> _$ActivitySectionToJson(_ActivitySection instance) => <String, dynamic>{
  'level': _$ActivityLevelEnumMap[instance.level],
  'occupation': _$OccupationEnumMap[instance.occupation],
  'sleepHours': instance.sleepHours,
  'stress': _$StressLevelEnumMap[instance.stress],
  'cardio': instance.cardio,
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.light: 'light',
  ActivityLevel.moderate: 'moderate',
  ActivityLevel.high: 'high',
};

const _$OccupationEnumMap = {
  Occupation.sitting: 'sitting',
  Occupation.standing: 'standing',
  Occupation.active: 'active',
};

const _$StressLevelEnumMap = {
  StressLevel.low: 'low',
  StressLevel.medium: 'medium',
  StressLevel.high: 'high',
};

_NutritionSection _$NutritionSectionFromJson(Map<String, dynamic> json) => _NutritionSection(
  diet: $enumDecodeNullable(_$DietEnumMap, json['diet']),
  allergies: json['allergies'] as String?,
  dislikes: json['dislikes'] as String?,
  preferences: json['preferences'] as String?,
  dailyBudgetIdr: (json['dailyBudgetIdr'] as num?)?.toInt(),
  mealsPerDay: (json['mealsPerDay'] as num?)?.toInt() ?? 3,
  cooking: $enumDecodeNullable(_$CookingEnumMap, json['cooking']),
  country: json['country'] as String? ?? 'ID',
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$NutritionSectionToJson(_NutritionSection instance) => <String, dynamic>{
  'diet': _$DietEnumMap[instance.diet],
  'allergies': instance.allergies,
  'dislikes': instance.dislikes,
  'preferences': instance.preferences,
  'dailyBudgetIdr': instance.dailyBudgetIdr,
  'mealsPerDay': instance.mealsPerDay,
  'cooking': _$CookingEnumMap[instance.cooking],
  'country': instance.country,
  'notes': instance.notes,
};

const _$DietEnumMap = {
  Diet.omnivore: 'omnivore',
  Diet.vegetarian: 'vegetarian',
  Diet.vegan: 'vegan',
  Diet.other: 'other',
};

const _$CookingEnumMap = {
  Cooking.self: 'self',
  Cooking.catering: 'catering',
  Cooking.mixed: 'mixed',
};

_SafetySection _$SafetySectionFromJson(Map<String, dynamic> json) => _SafetySection(
  injuries: json['injuries'] as String?,
  avoidedMovements: json['avoidedMovements'] as String?,
  medicalFlags:
      (json['medicalFlags'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MedicalFlagEnumMap, e))
          .toList() ??
      const <MedicalFlag>[],
  redFlags:
      (json['redFlags'] as List<dynamic>?)?.map((e) => $enumDecode(_$RedFlagEnumMap, e)).toList() ??
      const <RedFlag>[],
);

Map<String, dynamic> _$SafetySectionToJson(_SafetySection instance) => <String, dynamic>{
  'injuries': instance.injuries,
  'avoidedMovements': instance.avoidedMovements,
  'medicalFlags': instance.medicalFlags.map((e) => _$MedicalFlagEnumMap[e]!).toList(),
  'redFlags': instance.redFlags.map((e) => _$RedFlagEnumMap[e]!).toList(),
};

const _$MedicalFlagEnumMap = {
  MedicalFlag.pregnant: 'pregnant',
  MedicalFlag.chronicCondition: 'chronic_condition',
  MedicalFlag.eatingDisorderHistory: 'eating_disorder_history',
  MedicalFlag.injuryRecovery: 'injury_recovery',
  MedicalFlag.medication: 'medication',
};

const _$RedFlagEnumMap = {
  RedFlag.chestPain: 'chest_pain',
  RedFlag.fainting: 'fainting',
  RedFlag.unusualBreathlessness: 'unusual_breathlessness',
  RedFlag.acuteInjury: 'acute_injury',
};

_AssessmentData _$AssessmentDataFromJson(Map<String, dynamic> json) => _AssessmentData(
  profile: json['profile'] == null
      ? const ProfileSection()
      : ProfileSection.fromJson(json['profile'] as Map<String, dynamic>),
  goal: json['goal'] == null
      ? const GoalSection()
      : GoalSection.fromJson(json['goal'] as Map<String, dynamic>),
  experience: json['experience'] == null
      ? const ExperienceSection()
      : ExperienceSection.fromJson(json['experience'] as Map<String, dynamic>),
  availability: json['availability'] == null
      ? const AvailabilitySection()
      : AvailabilitySection.fromJson(json['availability'] as Map<String, dynamic>),
  activity: json['activity'] == null
      ? const ActivitySection()
      : ActivitySection.fromJson(json['activity'] as Map<String, dynamic>),
  nutrition: json['nutrition'] == null
      ? const NutritionSection()
      : NutritionSection.fromJson(json['nutrition'] as Map<String, dynamic>),
  safety: json['safety'] == null
      ? const SafetySection()
      : SafetySection.fromJson(json['safety'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AssessmentDataToJson(_AssessmentData instance) => <String, dynamic>{
  'profile': instance.profile.toJson(),
  'goal': instance.goal.toJson(),
  'experience': instance.experience.toJson(),
  'availability': instance.availability.toJson(),
  'activity': instance.activity.toJson(),
  'nutrition': instance.nutrition.toJson(),
  'safety': instance.safety.toJson(),
};
