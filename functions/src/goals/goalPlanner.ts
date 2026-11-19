import { type Assessment, ageOn, type Level, type MedicalFlag, type PrimaryGoal } from "../assessment/schema";
import { bmi, calculateNutrition, type NutritionResult, type Range } from "../nutrition/calculator";
import { NUTRITION_CONFIG, type NutritionConfig } from "../nutrition/config";

/** Kode alasan evaluasi target — diterjemahkan di aplikasi. */
export type GoalReason =
  | "target_below_current" // muscle gain/strength tetapi target < berat sekarang
  | "rate_too_fast" // laju kenaikan melebihi batas
  | "recomposition_weight_change"; // recomposition dengan perubahan berat besar

export type SafetyWarning =
  | "red_flag_symptoms"
  | "minor_age"
  | "low_bmi"
  | "high_bmi"
  | MedicalFlag;

export interface GoalEvaluation {
  verdict: "realistic" | "needs_adjustment";
  reasons: GoalReason[];
  deltaKg: number | null;
  weeklyChangeKg: number | null;
  weeklyChangePct: number | null;
  maxWeeklyGainPct: number;
  /** Perkiraan kenaikan berat yang wajar per minggu (bukan janji). */
  expectedWeeklyGainKg: Range;
  suggestedWeeks: number | null;
  suggestedTargetWeightKg: number | null;
}

export interface SafetyAssessment {
  /** Gejala berbahaya → hentikan rekomendasi, arahkan ke tenaga medis. */
  stop: boolean;
  conservative: boolean;
  warnings: SafetyWarning[];
}

export interface GoalProposal {
  primaryGoal: PrimaryGoal;
  level: Level;
  age: number;
  bmi: number;
  startWeightKg: number;
  targetWeightKg: number | null;
  targetWeeks: number;
  /** YYYY-MM-DD (UTC) = hari ini + targetWeeks. */
  targetDate: string;
  evaluation: GoalEvaluation;
  safety: SafetyAssessment;
  nutrition: NutritionResult;
  configVersion: string;
}

const round1 = (v: number) => Math.round(v * 10) / 10;
const round2 = (v: number) => Math.round(v * 100) / 100;
const EPS = 1e-9;

export function assessSafety(
  input: { age: number; bmi: number; medicalFlags: MedicalFlag[]; redFlags: string[] },
  config: NutritionConfig = NUTRITION_CONFIG,
): SafetyAssessment {
  const warnings: SafetyWarning[] = [];
  if (input.redFlags.length > 0) warnings.push("red_flag_symptoms");
  if (input.age < config.age.adult) warnings.push("minor_age");
  if (input.bmi < config.bmi.low) warnings.push("low_bmi");
  if (input.bmi >= config.bmi.high) warnings.push("high_bmi");
  warnings.push(...input.medicalFlags);
  return {
    stop: input.redFlags.length > 0,
    conservative:
      input.age < config.age.adult || input.bmi < config.bmi.low || input.medicalFlags.length > 0,
    warnings,
  };
}

export function maxWeeklyGainPct(
  level: Level,
  conservative: boolean,
  config: NutritionConfig = NUTRITION_CONFIG,
): number {
  const base = config.maxWeeklyGainPct[level];
  return conservative ? Math.min(base, config.conservativeMaxWeeklyGainPct) : base;
}

export function evaluateGoal(
  input: {
    primary: PrimaryGoal;
    level: Level;
    startKg: number;
    targetKg: number | null;
    weeks: number;
    conservative: boolean;
  },
  config: NutritionConfig = NUTRITION_CONFIG,
): GoalEvaluation {
  const { primary, startKg, targetKg, weeks } = input;
  const maxPct = maxWeeklyGainPct(input.level, input.conservative, config);
  const maxKgPerWeek = (startKg * maxPct) / 100;
  const expectedWeeklyGainKg =
    primary === "recomposition"
      ? { min: 0, max: 0 }
      : { min: round2(maxKgPerWeek / 2), max: round2(maxKgPerWeek) };

  const base: GoalEvaluation = {
    verdict: "realistic",
    reasons: [],
    deltaKg: null,
    weeklyChangeKg: null,
    weeklyChangePct: null,
    maxWeeklyGainPct: maxPct,
    expectedWeeklyGainKg,
    suggestedWeeks: null,
    suggestedTargetWeightKg: null,
  };
  if (targetKg === null) return base;

  const deltaKg = round1(targetKg - startKg);
  const weeklyChangeKg = round2(deltaKg / weeks);
  const weeklyChangePct = round2((deltaKg / weeks / startKg) * 100);
  const result: GoalEvaluation = { ...base, deltaKg, weeklyChangeKg, weeklyChangePct };

  if (primary === "recomposition") {
    const maxTotal = (startKg * config.recompositionMaxTotalChangePct) / 100;
    if (Math.abs(deltaKg) > maxTotal + EPS) {
      result.verdict = "needs_adjustment";
      result.reasons.push("recomposition_weight_change");
      result.suggestedTargetWeightKg = round1(startKg);
    }
    return result;
  }

  if (deltaKg < -EPS) {
    result.verdict = "needs_adjustment";
    result.reasons.push("target_below_current");
    result.suggestedTargetWeightKg = round1(startKg + maxKgPerWeek * weeks);
    return result;
  }

  if (weeklyChangePct > maxPct + EPS) {
    result.verdict = "needs_adjustment";
    result.reasons.push("rate_too_fast");
    result.suggestedWeeks = Math.ceil(deltaKg / maxKgPerWeek - EPS);
    // Pembulatan ke bawah agar saran pasti di dalam batas.
    result.suggestedTargetWeightKg = Math.floor((startKg + maxKgPerWeek * weeks) * 10) / 10;
  }
  return result;
}

function addDaysIso(now: Date, days: number): string {
  const d = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + days));
  return d.toISOString().slice(0, 10);
}

/** Gabungkan keselamatan, evaluasi target, dan kalkulasi nutrisi. Fungsi murni. */
export function buildGoalProposal(
  assessment: Assessment,
  now: Date,
  config: NutritionConfig = NUTRITION_CONFIG,
): GoalProposal {
  const { profile, goal, experience, activity, safety } = assessment;
  const age = ageOn(profile.birthDate, now);
  const currentBmi = bmi(profile.weightKg, profile.heightCm);
  const safetyResult = assessSafety(
    { age, bmi: currentBmi, medicalFlags: safety.medicalFlags, redFlags: safety.redFlags },
    config,
  );
  return {
    primaryGoal: goal.primary,
    level: experience.level,
    age,
    bmi: round1(currentBmi),
    startWeightKg: profile.weightKg,
    targetWeightKg: goal.targetWeightKg,
    targetWeeks: goal.targetWeeks,
    targetDate: addDaysIso(now, goal.targetWeeks * 7),
    evaluation: evaluateGoal(
      {
        primary: goal.primary,
        level: experience.level,
        startKg: profile.weightKg,
        targetKg: goal.targetWeightKg,
        weeks: goal.targetWeeks,
        conservative: safetyResult.conservative,
      },
      config,
    ),
    safety: safetyResult,
    nutrition: calculateNutrition(
      {
        sex: profile.sex,
        weightKg: profile.weightKg,
        heightCm: profile.heightCm,
        age,
        activity: activity.level,
        goal: goal.primary,
        level: experience.level,
        conservative: safetyResult.conservative,
      },
      config,
    ),
    configVersion: config.version,
  };
}

/** Bisa dikonfirmasi pengguna? (Selain itu harus disesuaikan dulu.) */
export function canConfirm(proposal: Pick<GoalProposal, "evaluation" | "safety">): boolean {
  return !proposal.safety.stop && proposal.evaluation.verdict === "realistic";
}
