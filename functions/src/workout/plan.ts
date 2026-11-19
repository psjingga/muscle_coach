import { type Equipment, EXERCISES_BY_ID, type Exercise, type ExerciseLevel, type Muscle } from "../catalog/exercises";

/**
 * Model rencana latihan + validator domain. Validator dipakai untuk program
 * template (Fase 3) dan nanti untuk output Gemini (Fase 4) sebelum disimpan.
 */

export const PLAN_LIMITS = {
  sets: { min: 1, max: 6 },
  reps: { min: 1, max: 30 },
  seconds: { min: 5, max: 180 },
  restSec: { min: 30, max: 300 },
  rir: { min: 0, max: 5 },
  exercisesPerDay: { min: 1, max: 10 },
} as const;

export type DayFocus =
  | "full_body_a"
  | "full_body_b"
  | "full_body_c"
  | "upper_a"
  | "upper_b"
  | "lower_a"
  | "lower_b";

export interface PlannedExercise {
  exerciseId: string;
  /** Nama disalin agar riwayat tetap terbaca walau katalog berubah. */
  name: string;
  sets: number;
  repMin: number;
  repMax: number;
  repUnit: "reps" | "seconds";
  loadType: Exercise["loadType"];
  restSec: number;
  rirMin: number;
  rirMax: number;
  /** Otot prioritas pengguna → set tambahan. */
  priority: boolean;
}

export interface PlanDay {
  id: string;
  order: number;
  /** ISO 1 = Senin … 7 = Minggu. */
  weekday: number;
  focus: DayFocus;
  warmupMinutes: number;
  estimatedMinutes: number;
  exercises: PlannedExercise[];
}

export type PlanWarning =
  | "review_injuries"
  | "days_reduced"
  | "limited_equipment"
  | "spotter_or_safeties"
  | "consecutive_muscle_overlap";

export interface WorkoutPlanDraft {
  split: "full_body" | "upper_lower";
  level: ExerciseLevel;
  daysPerWeek: number;
  sessionMinutes: number;
  days: PlanDay[];
  warnings: PlanWarning[];
}

export interface PlanContext {
  equipment: ReadonlySet<Equipment>;
  level: ExerciseLevel;
}

export type PlanIssue =
  | { code: "no_days" }
  | { code: "invalid_weekday" | "duplicate_weekday"; day: string }
  | { code: "exercise_count"; day: string }
  | {
      code:
        | "unknown_exercise"
        | "equipment_missing"
        | "level_too_high"
        | "duplicate_exercise"
        | "sets_out_of_range"
        | "reps_out_of_range"
        | "rest_out_of_range"
        | "rir_out_of_range";
      day: string;
      exerciseId: string;
    };

const LEVEL_RANK: Record<ExerciseLevel, number> = { beginner: 0, intermediate: 1, advanced: 2 };

export function levelAllows(user: ExerciseLevel, exercise: ExerciseLevel): boolean {
  return LEVEL_RANK[exercise] <= LEVEL_RANK[user];
}

export function hasEquipment(ctx: Pick<PlanContext, "equipment">, ex: Exercise): boolean {
  return ex.equipment.every((e) => ctx.equipment.has(e));
}

const inRange = (v: number, r: { min: number; max: number }) =>
  Number.isFinite(v) && v >= r.min && v <= r.max;

/** Hari kalender berurutan (termasuk Minggu → Senin). */
export function consecutive(a: number, b: number): boolean {
  const d = Math.abs(a - b);
  return d === 1 || d === 6;
}

/** Otot utama dari latihan compound per hari (untuk cek hari berurutan). */
function heavyMuscles(day: PlanDay): Set<Muscle> {
  const result = new Set<Muscle>();
  for (const p of day.exercises) {
    const ex = EXERCISES_BY_ID.get(p.exerciseId);
    if (ex?.compound) ex.primaryMuscles.forEach((m) => result.add(m));
  }
  return result;
}

/**
 * Validasi rencana terhadap katalog, alat, level, dan batas angka.
 * `errors` → rencana ditolak; `warnings` → boleh disimpan dengan peringatan.
 */
export function validatePlan(
  plan: Pick<WorkoutPlanDraft, "days">,
  ctx: PlanContext,
): { errors: PlanIssue[]; warnings: PlanWarning[] } {
  const errors: PlanIssue[] = [];
  const warnings = new Set<PlanWarning>();
  if (plan.days.length === 0) errors.push({ code: "no_days" });

  const weekdays = new Set<number>();
  for (const day of plan.days) {
    if (!Number.isInteger(day.weekday) || day.weekday < 1 || day.weekday > 7) {
      errors.push({ code: "invalid_weekday", day: day.id });
    } else if (weekdays.has(day.weekday)) {
      errors.push({ code: "duplicate_weekday", day: day.id });
    }
    weekdays.add(day.weekday);

    if (!inRange(day.exercises.length, PLAN_LIMITS.exercisesPerDay)) {
      errors.push({ code: "exercise_count", day: day.id });
    }
    const seen = new Set<string>();
    for (const p of day.exercises) {
      const base = { day: day.id, exerciseId: p.exerciseId };
      const ex = EXERCISES_BY_ID.get(p.exerciseId);
      if (!ex) {
        errors.push({ code: "unknown_exercise", ...base });
        continue;
      }
      if (seen.has(p.exerciseId)) errors.push({ code: "duplicate_exercise", ...base });
      seen.add(p.exerciseId);
      if (!hasEquipment(ctx, ex)) errors.push({ code: "equipment_missing", ...base });
      if (!levelAllows(ctx.level, ex.level)) errors.push({ code: "level_too_high", ...base });
      if (ex.needsSpotter) warnings.add("spotter_or_safeties");
      if (!Number.isInteger(p.sets) || !inRange(p.sets, PLAN_LIMITS.sets)) {
        errors.push({ code: "sets_out_of_range", ...base });
      }
      const repRange = p.repUnit === "seconds" ? PLAN_LIMITS.seconds : PLAN_LIMITS.reps;
      if (
        p.repUnit !== ex.repUnit ||
        !inRange(p.repMin, repRange) ||
        !inRange(p.repMax, repRange) ||
        p.repMin > p.repMax
      ) {
        errors.push({ code: "reps_out_of_range", ...base });
      }
      if (!inRange(p.restSec, PLAN_LIMITS.restSec)) errors.push({ code: "rest_out_of_range", ...base });
      if (!inRange(p.rirMin, PLAN_LIMITS.rir) || !inRange(p.rirMax, PLAN_LIMITS.rir) || p.rirMin > p.rirMax) {
        errors.push({ code: "rir_out_of_range", ...base });
      }
    }
  }

  // Otot yang sama dilatih berat pada hari berurutan → peringatan.
  const sorted = [...plan.days].sort((a, b) => a.weekday - b.weekday);
  for (let i = 0; i < sorted.length; i++) {
    for (let j = i + 1; j < sorted.length; j++) {
      const a = sorted[i]!;
      const b = sorted[j]!;
      if (!consecutive(a.weekday, b.weekday)) continue;
      const ma = heavyMuscles(a);
      if ([...heavyMuscles(b)].some((m) => ma.has(m))) warnings.add("consecutive_muscle_overlap");
    }
  }
  return { errors, warnings: [...warnings] };
}

/** Perkiraan durasi sesi (menit): pemanasan + kerja + istirahat + transisi. */
export function estimateMinutes(warmupMinutes: number, exercises: PlannedExercise[]): number {
  let seconds = warmupMinutes * 60;
  for (const p of exercises) {
    const work = p.repUnit === "seconds" ? (p.repMin + p.repMax) / 2 : 40;
    seconds += p.sets * work + (p.sets - 1) * p.restSec + 60;
  }
  return Math.round(seconds / 60);
}
