import '../../assessment/domain/entities/assessment_data.dart';

/// Angka default kalkulasi baseline. Semua PERLU DITINJAU terhadap rujukan
/// kredibel sebelum rilis. Ubah [version] setiap kali angka berubah — versi
/// tersimpan di goal & target nutrisi.
abstract final class NutritionConfig {
  static const version = '2026-11-v1';

  /// TDEE = BMR × faktor aktivitas.
  static const activityFactors = {
    ActivityLevel.sedentary: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.high: 1.725,
  };

  /// Surplus energi (% TDEE) per tujuan & pengalaman — konservatif.
  static const surplusPct = {
    PrimaryGoal.muscleGain: {
      ExperienceLevel.beginner: 10.0,
      ExperienceLevel.intermediate: 7.5,
      ExperienceLevel.advanced: 5.0,
    },
    PrimaryGoal.strength: {
      ExperienceLevel.beginner: 5.0,
      ExperienceLevel.intermediate: 5.0,
      ExperienceLevel.advanced: 5.0,
    },
    PrimaryGoal.recomposition: {
      ExperienceLevel.beginner: 0.0,
      ExperienceLevel.intermediate: 0.0,
      ExperienceLevel.advanced: 0.0,
    },
  };

  /// Surplus maksimum bila ada flag keselamatan.
  static const conservativeSurplusPct = 5.0;

  static const proteinDefaultGPerKg = 1.8;
  static const proteinRecompositionGPerKg = 2.0;

  static const fatGPerKg = 0.8;
  static const fatMinGPerKg = 0.6;
  static const fatMinEnergyPct = 20.0;
  static const fatMaxEnergyPct = 35.0;

  /// Bila BMI > [proteinReferenceBmiAbove], protein memakai berat pada BMI [proteinReferenceBmi].
  static const proteinReferenceBmiAbove = 30.0;
  static const proteinReferenceBmi = 25.0;

  /// Batas laju kenaikan berat (% BB per minggu).
  static const maxWeeklyGainPct = {
    ExperienceLevel.beginner: 0.5,
    ExperienceLevel.intermediate: 0.35,
    ExperienceLevel.advanced: 0.25,
  };
  static const conservativeMaxWeeklyGainPct = 0.25;

  /// Recomposition ≈ maintenance: perubahan total berat maks. (% BB).
  static const recompositionMaxTotalChangePct = 3.0;

  static const gramsStep = 5;
  static const kcalStep = 10;

  static const kcalPerGramProtein = 4;
  static const kcalPerGramCarbs = 4;
  static const kcalPerGramFat = 9;

  static const bmiLow = 18.5;
  static const bmiHigh = 35.0;

  static const adultAge = 18;
}
