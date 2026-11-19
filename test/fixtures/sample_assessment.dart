import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';

/// Padanan `sampleAssessment()` dari test server lama (data fiktif):
/// pria 30 th, 175 cm, 70 kg, pemula, muscle gain 74 kg / 24 minggu,
/// Sen/Rab/Jum 60 menit, dumbbell + barbell + bench (tanpa rack/pull-up bar).
const sample = AssessmentData(
  profile: ProfileSection(birthDate: '1996-05-10', sex: Sex.male, heightCm: 175, weightKg: 70),
  goal: GoalSection(
    primary: PrimaryGoal.muscleGain,
    targetWeightKg: 74,
    targetWeeks: 24,
    priorityMuscles: [MuscleGroup.chest, MuscleGroup.back],
  ),
  experience: ExperienceSection(
    level: ExperienceLevel.beginner,
    trainingAge: TrainingAge.under6Months,
    currentSessionsPerWeek: 2,
  ),
  availability: AvailabilitySection(
    trainingDays: [1, 3, 5],
    sessionMinutes: 60,
    location: TrainingLocation.home,
    equipment: EquipmentSelection(dumbbell: true, barbell: true, bench: true),
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

/// Tanggal acuan test.
final now = DateTime(2026, 11, 19, 10);

AssessmentData withEquipment(EquipmentSelection e, {ExperienceLevel? level, List<int>? days}) =>
    sample.copyWith(
      availability: sample.availability.copyWith(
        equipment: e,
        trainingDays: days ?? sample.availability.trainingDays,
      ),
      experience: sample.experience.copyWith(level: level ?? sample.experience.level),
    );
