import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/entities/assessment_data.dart';
import '../../domain/validators/assessment_validator.dart';

/// Label & pesan error assessment (terjemahan enum domain).
extension AssessmentLabels on AppLocalizations {
  String sex(Sex v) => switch (v) {
    Sex.male => sexMale,
    Sex.female => sexFemale,
    Sex.undisclosed => sexUndisclosed,
  };

  String primaryGoal(PrimaryGoal v) => switch (v) {
    PrimaryGoal.muscleGain => goalMuscleGain,
    PrimaryGoal.strength => goalStrength,
    PrimaryGoal.recomposition => goalRecomposition,
  };

  String muscle(MuscleGroup v) => switch (v) {
    MuscleGroup.chest => muscleChest,
    MuscleGroup.back => muscleBack,
    MuscleGroup.shoulders => muscleShoulders,
    MuscleGroup.arms => muscleArms,
    MuscleGroup.legs => muscleLegs,
    MuscleGroup.glutes => muscleGlutes,
    MuscleGroup.core => muscleCore,
  };

  String level(ExperienceLevel v) => switch (v) {
    ExperienceLevel.beginner => levelBeginner,
    ExperienceLevel.intermediate => levelIntermediate,
    ExperienceLevel.advanced => levelAdvanced,
  };

  String trainingAge(TrainingAge v) => switch (v) {
    TrainingAge.none => trainingAgeNone,
    TrainingAge.under6Months => trainingAgeUnder6Months,
    TrainingAge.sixMonthsTo2Years => trainingAge6mTo2y,
    TrainingAge.twoTo5Years => trainingAge2To5y,
    TrainingAge.over5Years => trainingAgeOver5y,
  };

  String weekday(int isoDay) => switch (isoDay) {
    1 => weekday1,
    2 => weekday2,
    3 => weekday3,
    4 => weekday4,
    5 => weekday5,
    6 => weekday6,
    _ => weekday7,
  };

  String location(TrainingLocation v) => switch (v) {
    TrainingLocation.home => locationHome,
    TrainingLocation.gym => locationGym,
  };

  String activityLevel(ActivityLevel v) => switch (v) {
    ActivityLevel.sedentary => activitySedentary,
    ActivityLevel.light => activityLight,
    ActivityLevel.moderate => activityModerate,
    ActivityLevel.high => activityHigh,
  };

  String occupation(Occupation v) => switch (v) {
    Occupation.sitting => occupationSitting,
    Occupation.standing => occupationStanding,
    Occupation.active => occupationActive,
  };

  String stress(StressLevel v) => switch (v) {
    StressLevel.low => stressLow,
    StressLevel.medium => stressMedium,
    StressLevel.high => stressHigh,
  };

  String diet(Diet v) => switch (v) {
    Diet.omnivore => dietOmnivore,
    Diet.vegetarian => dietVegetarian,
    Diet.vegan => dietVegan,
    Diet.other => dietOther,
  };

  String cooking(Cooking v) => switch (v) {
    Cooking.self => cookingSelf,
    Cooking.catering => cookingCatering,
    Cooking.mixed => cookingMixed,
  };

  String medicalFlag(MedicalFlag v) => switch (v) {
    MedicalFlag.pregnant => medicalPregnant,
    MedicalFlag.chronicCondition => medicalChronic,
    MedicalFlag.eatingDisorderHistory => medicalEatingDisorder,
    MedicalFlag.injuryRecovery => medicalInjuryRecovery,
    MedicalFlag.medication => medicalMedication,
  };

  String redFlag(RedFlag v) => switch (v) {
    RedFlag.chestPain => redChestPain,
    RedFlag.fainting => redFainting,
    RedFlag.unusualBreathlessness => redBreathless,
    RedFlag.acuteInjury => redAcuteInjury,
  };

  String stepTitle(int step) => switch (step) {
    0 => stepProfile,
    1 => stepGoal,
    2 => stepExperience,
    3 => stepAvailability,
    4 => stepActivity,
    5 => stepNutrition,
    _ => stepSafety,
  };

  String issue(AssessmentIssue i) {
    String range(({num min, num max}) r) => issueRange(Fmt.one(r.min), Fmt.one(r.max));
    return switch (i) {
      AssessmentIssue.birthDateRequired ||
      AssessmentIssue.heightRequired ||
      AssessmentIssue.weightRequired ||
      AssessmentIssue.targetWeeksRequired ||
      AssessmentIssue.sessionsRequired ||
      AssessmentIssue.sleepRequired => issueRequired,
      AssessmentIssue.sexRequired ||
      AssessmentIssue.goalRequired ||
      AssessmentIssue.levelRequired ||
      AssessmentIssue.trainingAgeRequired ||
      AssessmentIssue.sessionMinutesRequired ||
      AssessmentIssue.locationRequired ||
      AssessmentIssue.activityRequired ||
      AssessmentIssue.occupationRequired ||
      AssessmentIssue.dietRequired ||
      AssessmentIssue.mealsRequired ||
      AssessmentIssue.cookingRequired => issueChoose,
      AssessmentIssue.ageOutOfRange => issueAge(
        AssessmentValidator.minAge,
        AssessmentValidator.maxAge,
      ),
      AssessmentIssue.heightOutOfRange => range(AssessmentValidator.heightRange),
      AssessmentIssue.weightOutOfRange ||
      AssessmentIssue.targetWeightOutOfRange => range(AssessmentValidator.weightRange),
      AssessmentIssue.targetWeeksOutOfRange => range(AssessmentValidator.targetWeeksRange),
      AssessmentIssue.sessionsOutOfRange => range(AssessmentValidator.sessionsRange),
      AssessmentIssue.dumbbellMaxOutOfRange => range(AssessmentValidator.dumbbellRange),
      AssessmentIssue.barbellMaxOutOfRange => range(AssessmentValidator.barbellRange),
      AssessmentIssue.sleepOutOfRange => range(AssessmentValidator.sleepRange),
      AssessmentIssue.budgetOutOfRange => range((min: 0, max: AssessmentValidator.maxBudgetIdr)),
      AssessmentIssue.trainingDaysRequired => issueTrainingDays,
      AssessmentIssue.equipmentRequired => issueEquipment,
      AssessmentIssue.consentRequired => issueConsent,
    };
  }

  /// Pesan untuk isu pertama dari [candidates] yang ada di [issues].
  String? issueFor(Set<AssessmentIssue> issues, List<AssessmentIssue> candidates) {
    for (final c in candidates) {
      if (issues.contains(c)) return issue(c);
    }
    return null;
  }
}
