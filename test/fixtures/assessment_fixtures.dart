import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';

/// Tanggal acuan test.
final testNow = DateTime(2026, 11, 19);

/// Assessment lengkap & valid (data fiktif).
const completeAssessment = AssessmentData(
  profile: ProfileSection(
    nickname: '  Budi ',
    birthDate: '1996-05-10',
    sex: Sex.male,
    heightCm: 175,
    weightKg: 70,
  ),
  goal: GoalSection(primary: PrimaryGoal.muscleGain, targetWeightKg: 74, targetWeeks: 24),
  experience: ExperienceSection(
    level: ExperienceLevel.beginner,
    trainingAge: TrainingAge.under6Months,
    currentSessionsPerWeek: 2,
    knownExercises: '',
  ),
  availability: AvailabilitySection(
    trainingDays: [5, 1, 3],
    sessionMinutes: 60,
    location: TrainingLocation.home,
    equipment: EquipmentSelection(dumbbell: true, bench: true),
    dumbbellMaxKg: 24,
    barbellMaxKg: 60,
  ),
  activity: ActivitySection(
    level: ActivityLevel.light,
    occupation: Occupation.sitting,
    sleepHours: 7,
  ),
  nutrition: NutritionSection(diet: Diet.omnivore, mealsPerDay: 3, cooking: Cooking.mixed),
);

/// JSON goal seperti yang ditulis `submitAssessment` (tanpa timestamp).
Map<String, dynamic> goalJson({
  String status = 'proposed',
  String verdict = 'realistic',
  List<String> reasons = const [],
  bool stop = false,
  List<String> warnings = const [],
  String sexBasis = 'male',
}) => {
  'status': status,
  'primaryGoal': 'muscle_gain',
  'level': 'beginner',
  'age': 30,
  'bmi': 22.9,
  'startWeightKg': 70,
  'targetWeightKg': 74,
  'targetWeeks': 24,
  'targetDate': '2027-05-06',
  'evaluation': {
    'verdict': verdict,
    'reasons': reasons,
    'deltaKg': 4,
    'weeklyChangeKg': 0.17,
    'weeklyChangePct': 0.24,
    'maxWeeklyGainPct': 0.5,
    'expectedWeeklyGainKg': {'min': 0.18, 'max': 0.35},
    'suggestedWeeks': verdict == 'realistic' ? null : 29,
    'suggestedTargetWeightKg': verdict == 'realistic' ? null : 72.8,
  },
  'safety': {'stop': stop, 'conservative': warnings.isNotEmpty, 'warnings': warnings},
  'nutrition': {
    'sexBasis': sexBasis,
    'bmrKcal': {'min': 1649, 'max': 1649},
    'activityFactor': 1.375,
    'tdeeKcal': {'min': 2267, 'max': 2267},
    'surplusPct': 10,
    'targetKcalRange': {'min': 2490, 'max': 2490},
    'targetKcal': 2495,
    'proteinG': 125,
    'fatG': 55,
    'carbsG': 375,
    'proteinGPerKg': 1.8,
    'fatGPerKg': 0.8,
    'proteinBasisKg': 70,
    'energySplitPct': {'protein': 20, 'fat': 20, 'carbs': 60},
  },
  'configVersion': '2026-11-v1',
  'source': 'calculated',
  'assessmentId': 'a1',
  'schemaVersion': 1,
};

Goal testGoal({
  String status = 'proposed',
  String verdict = 'realistic',
  List<String> reasons = const [],
  bool stop = false,
  List<String> warnings = const [],
}) => Goal.fromJson(
  goalJson(status: status, verdict: verdict, reasons: reasons, stop: stop, warnings: warnings),
).copyWith(id: 'g1');
