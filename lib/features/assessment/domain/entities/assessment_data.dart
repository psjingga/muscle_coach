import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment_data.freezed.dart';
part 'assessment_data.g.dart';

// Model assessment awal (brief §5 A–G). Nilai JSON harus sinkron dengan
// `functions/src/assessment/schema.ts`. Semua field nullable karena model ini
// juga dipakai untuk draft; kelengkapan diperiksa `AssessmentValidator`.

@JsonEnum(fieldRename: FieldRename.snake)
enum Sex { male, female, undisclosed }

@JsonEnum(fieldRename: FieldRename.snake)
enum PrimaryGoal { muscleGain, strength, recomposition }

@JsonEnum(fieldRename: FieldRename.snake)
enum MuscleGroup { chest, back, shoulders, arms, legs, glutes, core }

@JsonEnum(fieldRename: FieldRename.snake)
enum ExperienceLevel { beginner, intermediate, advanced }

enum TrainingAge {
  @JsonValue('none')
  none,
  @JsonValue('lt_6m')
  under6Months,
  @JsonValue('6m_2y')
  sixMonthsTo2Years,
  @JsonValue('2y_5y')
  twoTo5Years,
  @JsonValue('gt_5y')
  over5Years,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum TrainingLocation { home, gym }

@JsonEnum(fieldRename: FieldRename.snake)
enum ActivityLevel { sedentary, light, moderate, high }

@JsonEnum(fieldRename: FieldRename.snake)
enum Occupation { sitting, standing, active }

@JsonEnum(fieldRename: FieldRename.snake)
enum StressLevel { low, medium, high }

@JsonEnum(fieldRename: FieldRename.snake)
enum Diet { omnivore, vegetarian, vegan, other }

@JsonEnum(fieldRename: FieldRename.snake)
enum Cooking { self, catering, mixed }

@JsonEnum(fieldRename: FieldRename.snake)
enum MedicalFlag { pregnant, chronicCondition, eatingDisorderHistory, injuryRecovery, medication }

@JsonEnum(fieldRename: FieldRename.snake)
enum RedFlag { chestPain, fainting, unusualBreathlessness, acuteInjury }

/// Durasi sesi yang didukung (menit).
const sessionMinuteOptions = [30, 45, 60, 75, 90];

@freezed
abstract class ProfileSection with _$ProfileSection {
  const factory ProfileSection({
    String? nickname,

    /// `YYYY-MM-DD`.
    String? birthDate,
    Sex? sex,
    double? heightCm,
    double? weightKg,
  }) = _ProfileSection;

  factory ProfileSection.fromJson(Map<String, dynamic> json) => _$ProfileSectionFromJson(json);
}

@freezed
abstract class GoalSection with _$GoalSection {
  const factory GoalSection({
    PrimaryGoal? primary,
    double? targetWeightKg,
    int? targetWeeks,
    @Default(<MuscleGroup>[]) List<MuscleGroup> priorityMuscles,
    String? motivation,
  }) = _GoalSection;

  factory GoalSection.fromJson(Map<String, dynamic> json) => _$GoalSectionFromJson(json);
}

@freezed
abstract class ExperienceSection with _$ExperienceSection {
  const factory ExperienceSection({
    ExperienceLevel? level,
    TrainingAge? trainingAge,
    int? currentSessionsPerWeek,
    String? knownExercises,
    String? workingWeights,
  }) = _ExperienceSection;

  factory ExperienceSection.fromJson(Map<String, dynamic> json) =>
      _$ExperienceSectionFromJson(json);
}

@freezed
abstract class EquipmentSelection with _$EquipmentSelection {
  const factory EquipmentSelection({
    @Default(false) bool dumbbell,
    @Default(false) bool barbell,
    @Default(false) bool bench,
    @Default(false) bool rack,
    @Default(false) bool pullUpBar,
  }) = _EquipmentSelection;

  factory EquipmentSelection.fromJson(Map<String, dynamic> json) =>
      _$EquipmentSelectionFromJson(json);
}

@freezed
abstract class AvailabilitySection with _$AvailabilitySection {
  const factory AvailabilitySection({
    /// ISO: 1 = Senin … 7 = Minggu.
    @Default(<int>[]) List<int> trainingDays,
    int? sessionMinutes,
    TrainingLocation? location,
    @Default(EquipmentSelection()) EquipmentSelection equipment,
    double? dumbbellMaxKg,
    double? barbellMaxKg,
    String? preferences,
  }) = _AvailabilitySection;

  factory AvailabilitySection.fromJson(Map<String, dynamic> json) =>
      _$AvailabilitySectionFromJson(json);
}

@freezed
abstract class ActivitySection with _$ActivitySection {
  const factory ActivitySection({
    ActivityLevel? level,
    Occupation? occupation,
    double? sleepHours,
    StressLevel? stress,
    String? cardio,
  }) = _ActivitySection;

  factory ActivitySection.fromJson(Map<String, dynamic> json) => _$ActivitySectionFromJson(json);
}

@freezed
abstract class NutritionSection with _$NutritionSection {
  const factory NutritionSection({
    Diet? diet,
    String? allergies,
    String? dislikes,
    String? preferences,
    int? dailyBudgetIdr,
    @Default(3) int? mealsPerDay,
    Cooking? cooking,
    @Default('ID') String country,
    String? notes,
  }) = _NutritionSection;

  factory NutritionSection.fromJson(Map<String, dynamic> json) => _$NutritionSectionFromJson(json);
}

@freezed
abstract class SafetySection with _$SafetySection {
  const factory SafetySection({
    String? injuries,
    String? avoidedMovements,
    @Default(<MedicalFlag>[]) List<MedicalFlag> medicalFlags,
    @Default(<RedFlag>[]) List<RedFlag> redFlags,
  }) = _SafetySection;

  factory SafetySection.fromJson(Map<String, dynamic> json) => _$SafetySectionFromJson(json);
}

@freezed
abstract class AssessmentData with _$AssessmentData {
  const factory AssessmentData({
    @Default(ProfileSection()) ProfileSection profile,
    @Default(GoalSection()) GoalSection goal,
    @Default(ExperienceSection()) ExperienceSection experience,
    @Default(AvailabilitySection()) AvailabilitySection availability,
    @Default(ActivitySection()) ActivitySection activity,
    @Default(NutritionSection()) NutritionSection nutrition,
    @Default(SafetySection()) SafetySection safety,
  }) = _AssessmentData;

  factory AssessmentData.fromJson(Map<String, dynamic> json) => _$AssessmentDataFromJson(json);
}

/// Payload untuk `submitAssessment`: teks di-trim, string kosong → `null`,
/// daftar diurutkan. Hanya dipanggil setelah validasi lolos.
Map<String, Object?> assessmentPayload(AssessmentData data) {
  String? t(String? v) {
    final s = v?.trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  final d = data.copyWith(
    profile: data.profile.copyWith(nickname: t(data.profile.nickname)),
    goal: data.goal.copyWith(motivation: t(data.goal.motivation)),
    experience: data.experience.copyWith(
      knownExercises: t(data.experience.knownExercises),
      workingWeights: t(data.experience.workingWeights),
    ),
    availability: data.availability.copyWith(
      trainingDays: [...data.availability.trainingDays]..sort(),
      preferences: t(data.availability.preferences),
    ),
    activity: data.activity.copyWith(cardio: t(data.activity.cardio)),
    nutrition: data.nutrition.copyWith(
      allergies: t(data.nutrition.allergies),
      dislikes: t(data.nutrition.dislikes),
      preferences: t(data.nutrition.preferences),
      notes: t(data.nutrition.notes),
    ),
    safety: data.safety.copyWith(
      injuries: t(data.safety.injuries),
      avoidedMovements: t(data.safety.avoidedMovements),
    ),
  );
  return d.toJson();
}
