import type { Assessment } from "../assessment/schema";
import { type Equipment, EXERCISES_BY_ID, type Exercise, type ExerciseLevel, type Muscle } from "../catalog/exercises";
import {
  consecutive,
  type DayFocus,
  estimateMinutes,
  hasEquipment,
  levelAllows,
  type PlanContext,
  type PlanDay,
  type PlannedExercise,
  type PlanWarning,
  validatePlan,
  type WorkoutPlanDraft,
} from "./plan";

/**
 * Program awal berbasis aturan (tanpa AI): dipakai sebelum integrasi Gemini
 * dan sebagai fallback aman bila output AI tidak valid.
 */
export const TEMPLATE_GENERATOR_VERSION = "template-2026-11-v1";

/** Kandidat per slot, urut preferensi. Yang pertama memenuhi alat & level dipakai. */
const SLOTS = {
  squat: ["barbell_back_squat", "goblet_squat", "dumbbell_squat"],
  squat_alt: ["barbell_front_squat", "goblet_squat", "dumbbell_squat"],
  lunge: ["dumbbell_bulgarian_split_squat", "dumbbell_reverse_lunge", "dumbbell_step_up", "dumbbell_walking_lunge"],
  hinge: ["barbell_romanian_deadlift", "dumbbell_romanian_deadlift", "dumbbell_single_leg_rdl"],
  hinge_heavy: ["barbell_deadlift", "barbell_romanian_deadlift", "dumbbell_romanian_deadlift"],
  hip: ["barbell_hip_thrust", "dumbbell_glute_bridge"],
  h_push: ["barbell_bench_press", "dumbbell_bench_press", "dumbbell_floor_press", "push_up"],
  h_push_incline: ["dumbbell_incline_press", "dumbbell_bench_press", "dumbbell_floor_press", "push_up"],
  v_push: ["barbell_overhead_press", "dumbbell_shoulder_press"],
  v_push_db: ["dumbbell_shoulder_press", "dumbbell_arnold_press"],
  h_pull: ["barbell_bent_over_row", "dumbbell_one_arm_row", "dumbbell_bent_over_row"],
  h_pull_db: ["dumbbell_chest_supported_row", "dumbbell_one_arm_row", "dumbbell_bent_over_row"],
  v_pull: ["pull_up", "chin_up", "dumbbell_pullover", "dumbbell_one_arm_row", "dumbbell_bent_over_row"],
  lateral: ["dumbbell_lateral_raise"],
  rear: ["dumbbell_rear_delt_fly"],
  curl: ["dumbbell_biceps_curl", "barbell_curl", "dumbbell_hammer_curl"],
  hammer: ["dumbbell_hammer_curl", "dumbbell_biceps_curl", "barbell_curl"],
  triceps: ["dumbbell_overhead_triceps_extension", "dumbbell_skull_crusher", "barbell_close_grip_bench_press"],
  calf: ["dumbbell_standing_calf_raise"],
  core: ["dead_bug", "plank"],
  core2: ["plank", "dead_bug"],
} as const satisfies Record<string, readonly string[]>;
type Slot = keyof typeof SLOTS;

const DAY_SLOTS: Record<DayFocus, Slot[]> = {
  full_body_a: ["squat", "h_push", "h_pull", "hinge", "lateral", "curl", "core"],
  full_body_b: ["hinge_heavy", "v_push", "v_pull", "lunge", "h_push_incline", "triceps", "calf"],
  full_body_c: ["lunge", "h_push_incline", "h_pull_db", "hip", "v_push_db", "hammer", "core2"],
  upper_a: ["h_push", "h_pull", "v_push", "v_pull", "lateral", "curl", "triceps"],
  upper_b: ["v_push", "h_pull_db", "h_push_incline", "v_pull", "rear", "triceps", "hammer"],
  lower_a: ["squat", "hinge", "lunge", "calf", "core", "hip"],
  lower_b: ["hinge_heavy", "lunge", "squat_alt", "hip", "calf", "core2"],
};

const MAX_DAYS: Record<ExerciseLevel, number> = { beginner: 4, intermediate: 5, advanced: 6 };

const PRIORITY_MUSCLES: Record<string, Muscle[]> = {
  chest: ["chest"],
  back: ["upper_back", "lats"],
  shoulders: ["front_delts", "side_delts", "rear_delts"],
  arms: ["biceps", "triceps"],
  legs: ["quads", "hamstrings", "calves"],
  glutes: ["glutes"],
  core: ["core"],
};

const EQUIPMENT_FROM_ASSESSMENT: Record<string, Equipment> = {
  dumbbell: "dumbbell",
  barbell: "barbell",
  bench: "bench",
  rack: "rack",
  pullUpBar: "pull_up_bar",
};

export function equipmentOf(a: Assessment): Set<Equipment> {
  const set = new Set<Equipment>();
  for (const [key, value] of Object.entries(a.availability.equipment)) {
    const eq = EQUIPMENT_FROM_ASSESSMENT[key];
    if (value && eq) set.add(eq);
  }
  return set;
}

/** Pilih hari latihan: maks. per level, utamakan hari yang tidak berurutan. */
export function selectTrainingDays(available: number[], level: ExerciseLevel): number[] {
  const days = [...new Set(available)].sort((a, b) => a - b);
  const max = MAX_DAYS[level];
  if (days.length <= max) return days;
  const chosen: number[] = [];
  for (const d of days) {
    if (chosen.length < max && !chosen.some((c) => consecutive(c, d))) chosen.push(d);
  }
  // Sisa slot: pilih hari dengan tetangga latihan paling sedikit.
  while (chosen.length < max) {
    const conflicts = (d: number) => chosen.filter((c) => consecutive(c, d)).length;
    const rest = days.filter((d) => !chosen.includes(d));
    const best = rest.reduce((a, b) => (conflicts(b) < conflicts(a) ? b : a));
    chosen.push(best);
  }
  return chosen.sort((a, b) => a - b);
}

function hasConsecutive(days: number[]): boolean {
  return days.some((a, i) => days.some((b, j) => i < j && consecutive(a, b)));
}

export function focusSequence(days: number[]): { split: WorkoutPlanDraft["split"]; focuses: DayFocus[] } {
  if (days.length >= 4 || (days.length >= 2 && hasConsecutive(days))) {
    const cycle: DayFocus[] = ["upper_a", "lower_a", "upper_b", "lower_b"];
    return { split: "upper_lower", focuses: days.map((_, i) => cycle[i % cycle.length]!) };
  }
  const cycle: DayFocus[] = ["full_body_a", "full_body_b", "full_body_c"];
  return { split: "full_body", focuses: days.map((_, i) => cycle[i % cycle.length]!) };
}

function prescribe(ex: Exercise, level: ExerciseLevel, priority: boolean): PlannedExercise {
  const lowerCompound = ex.compound && ["squat", "hinge", "hip_extension"].includes(ex.pattern);
  let repMin: number;
  let repMax: number;
  if (ex.repUnit === "seconds") {
    [repMin, repMax] = level === "beginner" ? [20, 40] : [30, 45];
  } else if (!ex.compound) {
    [repMin, repMax] = ex.pattern === "core" ? [8, 12] : [10, 15];
  } else if (ex.pattern === "lunge" || level === "beginner") {
    [repMin, repMax] = [8, 12];
  } else {
    [repMin, repMax] = [6, 10];
  }
  const baseSets = ex.compound ? (level === "advanced" ? 4 : 3) : level === "beginner" ? 2 : 3;
  const sets = Math.min(baseSets + (priority ? 1 : 0), 5);
  const restSec = ex.pattern === "core" || ex.pattern === "carry" ? 60 : ex.compound ? (lowerCompound ? 150 : 120) : 75;
  const [rirMin, rirMax] = level === "beginner" ? [2, 3] : level === "intermediate" ? [1, 3] : [1, 2];
  return {
    exerciseId: ex.id,
    name: ex.name,
    sets,
    repMin,
    repMax,
    repUnit: ex.repUnit,
    loadType: ex.loadType,
    restSec,
    rirMin,
    rirMax,
    priority,
  };
}

function pick(slot: Slot, ctx: PlanContext, used: Set<string>): Exercise | null {
  for (const id of SLOTS[slot]) {
    const ex = EXERCISES_BY_ID.get(id);
    if (ex && !used.has(id) && hasEquipment(ctx, ex) && levelAllows(ctx.level, ex.level)) return ex;
  }
  return null;
}

function buildDay(
  focus: DayFocus,
  weekday: number,
  order: number,
  sessionMinutes: number,
  ctx: PlanContext,
  priorityMuscles: Set<Muscle>,
): { day: PlanDay; skippedSlots: number } {
  const warmupMinutes = sessionMinutes <= 30 ? 5 : 8;
  const used = new Set<string>();
  const exercises: PlannedExercise[] = [];
  let skippedSlots = 0;
  for (const slot of DAY_SLOTS[focus]) {
    const ex = pick(slot, ctx, used);
    if (!ex) {
      skippedSlots++;
      continue;
    }
    const isPriority = ex.primaryMuscles.some((m) => priorityMuscles.has(m));
    const candidate = prescribe(ex, ctx.level, isPriority);
    const fits = estimateMinutes(warmupMinutes, [...exercises, candidate]) <= sessionMinutes;
    if (exercises.length >= 3 && !fits) break;
    exercises.push(candidate);
    used.add(ex.id);
  }
  // Sesi pendek: kurangi set (min. 2) sampai muat.
  while (estimateMinutes(warmupMinutes, exercises) > sessionMinutes) {
    const target = exercises.reduce<PlannedExercise | null>(
      (best, p) => (p.sets > 2 && (!best || p.sets > best.sets) ? p : best),
      null,
    );
    if (!target) break;
    target.sets -= 1;
  }
  return {
    day: {
      id: `d${order + 1}`,
      order,
      weekday,
      focus,
      warmupMinutes,
      estimatedMinutes: estimateMinutes(warmupMinutes, exercises),
      exercises,
    },
    skippedSlots,
  };
}

/** Susun program awal dari assessment final. Fungsi murni & deterministik. */
export function buildTemplatePlan(a: Assessment): WorkoutPlanDraft {
  const level = a.experience.level;
  const ctx: PlanContext = { equipment: equipmentOf(a), level };
  const days = selectTrainingDays(a.availability.trainingDays, level);
  const { split, focuses } = focusSequence(days);
  const priority = new Set<Muscle>(a.goal.priorityMuscles.flatMap((m) => PRIORITY_MUSCLES[m] ?? []));

  let skipped = 0;
  const planDays = days.map((weekday, i) => {
    const { day, skippedSlots } = buildDay(
      focuses[i]!,
      weekday,
      i,
      a.availability.sessionMinutes,
      ctx,
      priority,
    );
    skipped += skippedSlots;
    return day;
  });

  const warnings = new Set<PlanWarning>();
  const s = a.safety;
  if (s.injuries || s.avoidedMovements || s.medicalFlags.includes("injury_recovery")) {
    warnings.add("review_injuries");
  }
  if (days.length < new Set(a.availability.trainingDays).size) warnings.add("days_reduced");
  if (skipped > 0) warnings.add("limited_equipment");

  const draft: WorkoutPlanDraft = {
    split,
    level,
    daysPerWeek: days.length,
    sessionMinutes: a.availability.sessionMinutes,
    days: planDays,
    warnings: [],
  };
  const validation = validatePlan(draft, ctx);
  if (validation.errors.length > 0) {
    // Seharusnya tidak terjadi: planner hanya memilih dari katalog yang lolos filter.
    throw new Error(`Template plan invalid: ${validation.errors.map((e) => e.code).join(",")}`);
  }
  validation.warnings.forEach((w) => warnings.add(w));
  draft.warnings = [...warnings];
  return draft;
}
