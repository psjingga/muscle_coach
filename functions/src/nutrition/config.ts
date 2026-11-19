import type { ActivityLevel, Level, PrimaryGoal } from "../assessment/schema";

/**
 * Konfigurasi kalkulasi baseline. Semua angka adalah default yang
 * PERLU DITINJAU terhadap rujukan kredibel sebelum rilis (IMPLEMENTATION_PLAN §5).
 * Ubah `version` setiap kali angka berubah — tersimpan di goal & target nutrisi.
 */
export const NUTRITION_CONFIG = {
  version: "2026-11-v1",

  /** Faktor aktivitas TDEE = BMR × faktor. */
  activityFactors: {
    sedentary: 1.2,
    light: 1.375,
    moderate: 1.55,
    high: 1.725,
  } satisfies Record<ActivityLevel, number>,

  /** Surplus energi (% TDEE) per tujuan & pengalaman — konservatif. */
  surplusPct: {
    muscle_gain: { beginner: 10, intermediate: 7.5, advanced: 5 },
    strength: { beginner: 5, intermediate: 5, advanced: 5 },
    recomposition: { beginner: 0, intermediate: 0, advanced: 0 },
  } satisfies Record<PrimaryGoal, Record<Level, number>>,

  /** Surplus maksimum bila ada flag keselamatan (usia < 18, kondisi medis, BMI rendah). */
  conservativeSurplusPct: 5,

  /** Protein g/kg berat acuan. */
  protein: { defaultGPerKg: 1.8, recompositionGPerKg: 2.0, minGPerKg: 1.6, maxGPerKg: 2.2 },

  /** Lemak: g/kg awal, lalu dibatasi rentang % energi dan minimum g/kg. */
  fat: { gPerKg: 0.8, minGPerKg: 0.6, minEnergyPct: 20, maxEnergyPct: 35 },

  /** Bila BMI di atas ambang, protein memakai berat acuan pada BMI ini. */
  proteinReferenceBmi: { above: 30, use: 25 },

  /** Batas laju kenaikan berat (% BB per minggu). */
  maxWeeklyGainPct: { beginner: 0.5, intermediate: 0.35, advanced: 0.25 } satisfies Record<
    Level,
    number
  >,
  conservativeMaxWeeklyGainPct: 0.25,

  /** Recomposition ≈ maintenance: perubahan total berat maks. (% BB). */
  recompositionMaxTotalChangePct: 3,

  /** Pembulatan makro (gram) dan rentang energi (kcal). */
  gramsStep: 5,
  kcalStep: 10,

  /** Kalori per gram. */
  kcalPerGram: { protein: 4, carbs: 4, fat: 9 },

  /** Ambang BMI untuk peringatan (bukan diagnosis). */
  bmi: { low: 18.5, high: 35 },

  age: { min: 16, adult: 18, max: 90 },
} as const;

export type NutritionConfig = typeof NUTRITION_CONFIG;
