import type { ActivityLevel, Level, PrimaryGoal, Sex } from "../assessment/schema";
import { NUTRITION_CONFIG, type NutritionConfig } from "./config";

/**
 * Kalkulasi baseline energi & makro — deterministik, tanpa AI.
 *
 * - BMR: Mifflin–St Jeor (1990). Keterbatasan: estimasi populasi, kurang
 *   akurat untuk orang sangat berotot/obesitas; tidak berlaku saat hamil.
 * - TDEE = BMR × faktor aktivitas.
 * - Energi target = TDEE × (1 + surplus%).
 * - Protein & lemak dari berat badan; karbohidrat = sisa energi.
 * - Total kcal dihitung ulang dari makro yang sudah dibulatkan (4/4/9).
 * - Jenis kelamin tidak diisi → BMR/TDEE/energi berupa rentang; makro
 *   memakai titik tengah rentang (ditandai `sexBasis: "range"`).
 */

export interface Range {
  min: number;
  max: number;
}

export interface NutritionInput {
  sex: Sex;
  weightKg: number;
  heightCm: number;
  age: number;
  activity: ActivityLevel;
  goal: PrimaryGoal;
  level: Level;
  /** Pakai batas konservatif (flag keselamatan). */
  conservative: boolean;
}

export interface NutritionResult {
  sexBasis: "male" | "female" | "range";
  bmrKcal: Range;
  activityFactor: number;
  tdeeKcal: Range;
  surplusPct: number;
  /** Rentang energi target (dibulatkan `kcalStep`). Sama bila jenis kelamin diketahui. */
  targetKcalRange: Range;
  /** Energi dari makro yang dibulatkan: 4P + 4C + 9F. */
  targetKcal: number;
  proteinG: number;
  fatG: number;
  carbsG: number;
  proteinGPerKg: number;
  fatGPerKg: number;
  /** Berat acuan untuk protein (berat badan, atau berat pada BMI acuan bila BMI tinggi). */
  proteinBasisKg: number;
  energySplitPct: { protein: number; fat: number; carbs: number };
}

export function mifflinStJeor(sex: "male" | "female", weightKg: number, heightCm: number, age: number) {
  return 10 * weightKg + 6.25 * heightCm - 5 * age + (sex === "male" ? 5 : -161);
}

export function bmi(weightKg: number, heightCm: number): number {
  const m = heightCm / 100;
  return weightKg / (m * m);
}

const roundTo = (value: number, step: number) => Math.round(value / step) * step;
const round1 = (value: number) => Math.round(value * 10) / 10;

export function surplusFor(
  goal: PrimaryGoal,
  level: Level,
  conservative: boolean,
  config: NutritionConfig = NUTRITION_CONFIG,
): number {
  const base = config.surplusPct[goal][level];
  return conservative ? Math.min(base, config.conservativeSurplusPct) : base;
}

export function calculateNutrition(
  input: NutritionInput,
  config: NutritionConfig = NUTRITION_CONFIG,
): NutritionResult {
  const { weightKg, heightCm, age } = input;
  const sexes: ("male" | "female")[] = input.sex === "undisclosed" ? ["female", "male"] : [input.sex];
  const bmrs = sexes.map((s) => mifflinStJeor(s, weightKg, heightCm, age));
  const bmrKcal = { min: Math.min(...bmrs), max: Math.max(...bmrs) };

  const activityFactor = config.activityFactors[input.activity];
  const tdeeKcal = { min: bmrKcal.min * activityFactor, max: bmrKcal.max * activityFactor };
  const surplusPct = surplusFor(input.goal, input.level, input.conservative, config);
  const factor = 1 + surplusPct / 100;
  const energyMid = ((tdeeKcal.min + tdeeKcal.max) / 2) * factor;

  // Protein
  const currentBmi = bmi(weightKg, heightCm);
  const proteinBasisKg =
    currentBmi > config.proteinReferenceBmi.above
      ? config.proteinReferenceBmi.use * (heightCm / 100) ** 2
      : weightKg;
  const proteinPerKg =
    input.goal === "recomposition" ? config.protein.recompositionGPerKg : config.protein.defaultGPerKg;
  const proteinG = roundTo(proteinPerKg * proteinBasisKg, config.gramsStep);

  // Lemak: mulai dari g/kg, batasi ke rentang % energi, minimum g/kg.
  const { kcalPerGram: k } = config;
  const fatMinByEnergy = (energyMid * config.fat.minEnergyPct) / 100 / k.fat;
  const fatMaxByEnergy = (energyMid * config.fat.maxEnergyPct) / 100 / k.fat;
  let fatRaw = Math.min(Math.max(config.fat.gPerKg * weightKg, fatMinByEnergy), fatMaxByEnergy);
  fatRaw = Math.max(fatRaw, config.fat.minGPerKg * weightKg);
  const fatG = roundTo(fatRaw, config.gramsStep);

  // Karbohidrat = sisa energi (tidak negatif).
  const carbsG = Math.max(
    0,
    roundTo((energyMid - proteinG * k.protein - fatG * k.fat) / k.carbs, config.gramsStep),
  );

  const targetKcal = proteinG * k.protein + carbsG * k.carbs + fatG * k.fat;
  const pct = (kcal: number) => (targetKcal === 0 ? 0 : Math.round((kcal / targetKcal) * 100));

  return {
    sexBasis: input.sex === "undisclosed" ? "range" : input.sex,
    bmrKcal: { min: Math.round(bmrKcal.min), max: Math.round(bmrKcal.max) },
    activityFactor,
    tdeeKcal: { min: Math.round(tdeeKcal.min), max: Math.round(tdeeKcal.max) },
    surplusPct,
    targetKcalRange: {
      min: roundTo(tdeeKcal.min * factor, config.kcalStep),
      max: roundTo(tdeeKcal.max * factor, config.kcalStep),
    },
    targetKcal,
    proteinG,
    fatG,
    carbsG,
    proteinGPerKg: round1(proteinG / weightKg),
    fatGPerKg: round1(fatG / weightKg),
    proteinBasisKg: round1(proteinBasisKg),
    energySplitPct: {
      protein: pct(proteinG * k.protein),
      fat: pct(fatG * k.fat),
      carbs: pct(carbsG * k.carbs),
    },
  };
}
