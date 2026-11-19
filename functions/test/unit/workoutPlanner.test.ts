import { describe, expect, it } from "vitest";

import { EQUIPMENT, EXERCISES, EXERCISES_BY_ID, MUSCLES, PATTERNS } from "../../src/catalog/exercises";
import { consecutive, estimateMinutes, type PlanContext, validatePlan } from "../../src/workout/plan";
import {
  buildTemplatePlan,
  equipmentOf,
  focusSequence,
  selectTrainingDays,
} from "../../src/workout/templatePlanner";
import { sampleAssessment } from "../fixtures/assessment";

describe("katalog latihan", () => {
  it("ID unik, enum valid, alternatif ada di katalog", () => {
    expect(EXERCISES.length).toBeGreaterThanOrEqual(40);
    expect(EXERCISES_BY_ID.size).toBe(EXERCISES.length);
    for (const ex of EXERCISES) {
      expect(ex.id).toMatch(/^[a-z0-9_]+$/);
      expect(PATTERNS).toContain(ex.pattern);
      for (const m of [...ex.primaryMuscles, ...ex.secondaryMuscles]) expect(MUSCLES).toContain(m);
      for (const e of ex.equipment) expect(EQUIPMENT).toContain(e);
      expect(ex.primaryMuscles.length).toBeGreaterThan(0);
      expect(ex.instructions.length).toBeGreaterThan(0);
      expect(ex.safety.length).toBeGreaterThan(0);
      for (const alt of ex.alternatives) {
        expect(EXERCISES_BY_ID.has(alt), `${ex.id} → ${alt}`).toBe(true);
        expect(alt).not.toBe(ex.id);
      }
    }
  });

  it("gerakan barbell berisiko di bench/rack ditandai butuh spotter", () => {
    expect(EXERCISES_BY_ID.get("barbell_bench_press")?.needsSpotter).toBe(true);
    expect(EXERCISES_BY_ID.get("barbell_back_squat")?.needsSpotter).toBe(true);
  });
});

describe("pemilihan hari & split", () => {
  it("membatasi jumlah hari per level, utamakan tidak berurutan", () => {
    expect(selectTrainingDays([1, 2, 3, 4, 5, 6, 7], "beginner")).toEqual([1, 3, 5, 6]);
    expect(selectTrainingDays([1, 2, 3, 4, 5, 6, 7], "intermediate")).toHaveLength(5);
    expect(selectTrainingDays([2, 4], "beginner")).toEqual([2, 4]);
  });

  it("full body untuk ≤ 3 hari tidak berurutan; upper/lower untuk ≥ 4 atau hari berurutan", () => {
    expect(focusSequence([1, 3, 5])).toEqual({
      split: "full_body",
      focuses: ["full_body_a", "full_body_b", "full_body_c"],
    });
    expect(focusSequence([1, 2]).split).toBe("upper_lower");
    expect(focusSequence([1, 2, 4, 5]).focuses).toEqual(["upper_a", "lower_a", "upper_b", "lower_b"]);
    expect(consecutive(7, 1)).toBe(true);
    expect(consecutive(1, 3)).toBe(false);
  });
});

describe("buildTemplatePlan", () => {
  it("pemula dengan dumbbell + bench: hanya gerakan yang alatnya ada & sesuai level", () => {
    const a = sampleAssessment({
      availability: { equipment: { dumbbell: true, barbell: false, bench: true, rack: false, pullUpBar: false } },
    });
    const plan = buildTemplatePlan(a);
    expect(plan.split).toBe("full_body");
    expect(plan.days.map((d) => d.weekday)).toEqual([1, 3, 5]);
    const ctx: PlanContext = { equipment: equipmentOf(a), level: "beginner" };
    expect(validatePlan(plan, ctx).errors).toEqual([]);
    for (const day of plan.days) {
      expect(day.exercises.length).toBeGreaterThanOrEqual(3);
      expect(day.estimatedMinutes).toBeLessThanOrEqual(60);
      for (const p of day.exercises) {
        const ex = EXERCISES_BY_ID.get(p.exerciseId)!;
        expect(ex.equipment.every((e) => ctx.equipment.has(e))).toBe(true);
        expect(ex.level).toBe("beginner");
        expect(p.rirMin).toBeGreaterThanOrEqual(2); // pemula tidak sampai gagal
      }
    }
    expect(plan.days[0]!.exercises[0]!.exerciseId).toBe("goblet_squat");
  });

  it("tidak menganggap ada rack/bench: back squat & bench press tidak dipilih tanpa rack", () => {
    const a = sampleAssessment({
      experience: { level: "intermediate" },
      availability: { equipment: { dumbbell: true, barbell: true, bench: false, rack: false, pullUpBar: false } },
    });
    const ids = buildTemplatePlan(a).days.flatMap((d) => d.exercises.map((e) => e.exerciseId));
    expect(ids).not.toContain("barbell_back_squat");
    expect(ids).not.toContain("barbell_bench_press");
    expect(ids).not.toContain("dumbbell_bench_press");
  });

  it("menengah dengan rack: memakai barbell & memberi peringatan spotter", () => {
    const a = sampleAssessment({
      experience: { level: "intermediate" },
      availability: {
        trainingDays: [1, 2, 4, 5],
        equipment: { dumbbell: true, barbell: true, bench: true, rack: true, pullUpBar: true },
      },
    });
    const plan = buildTemplatePlan(a);
    expect(plan.split).toBe("upper_lower");
    const ids = plan.days.flatMap((d) => d.exercises.map((e) => e.exerciseId));
    expect(ids).toContain("barbell_back_squat");
    expect(ids).toContain("pull_up");
    expect(plan.warnings).toContain("spotter_or_safeties");
    expect(plan.warnings).not.toContain("consecutive_muscle_overlap");
  });

  it("sesi 30 menit tetap ≤ 30 menit dengan minimal 3 latihan", () => {
    const plan = buildTemplatePlan(sampleAssessment({ availability: { sessionMinutes: 30 } }));
    for (const d of plan.days) {
      expect(d.exercises.length).toBeGreaterThanOrEqual(3);
      expect(d.estimatedMinutes).toBeLessThanOrEqual(30);
    }
  });

  it("sesi lebih panjang → lebih banyak latihan", () => {
    const short = buildTemplatePlan(sampleAssessment({ availability: { sessionMinutes: 45 } }));
    const long = buildTemplatePlan(sampleAssessment({ availability: { sessionMinutes: 90 } }));
    expect(long.days[0]!.exercises.length).toBeGreaterThan(short.days[0]!.exercises.length);
  });

  it("otot prioritas mendapat set tambahan", () => {
    const base = buildTemplatePlan(sampleAssessment({ goal: { priorityMuscles: [] } }));
    const chest = buildTemplatePlan(sampleAssessment({ goal: { priorityMuscles: ["chest"] } }));
    const press = (p: typeof base) => p.days[0]!.exercises.find((e) => e.exerciseId === "dumbbell_bench_press")!;
    expect(press(chest).sets).toBe(press(base).sets + 1);
    expect(press(chest).priority).toBe(true);
  });

  it("peringatan untuk cedera, pengurangan hari, dan alat terbatas", () => {
    const plan = buildTemplatePlan(
      sampleAssessment({
        safety: { injuries: "Lutut kiri kadang nyeri" },
        availability: {
          trainingDays: [1, 2, 3, 4, 5, 6],
          equipment: { dumbbell: false, barbell: true, bench: false, rack: false, pullUpBar: false },
        },
      }),
    );
    expect(plan.warnings).toEqual(expect.arrayContaining(["review_injuries", "days_reduced", "limited_equipment"]));
    expect(plan.daysPerWeek).toBe(4);
  });

  it("deterministik", () => {
    expect(buildTemplatePlan(sampleAssessment())).toEqual(buildTemplatePlan(sampleAssessment()));
  });
});

describe("validatePlan", () => {
  const ctx: PlanContext = { equipment: new Set(["dumbbell"]), level: "beginner" };
  const good = {
    exerciseId: "goblet_squat",
    name: "Goblet Squat",
    sets: 3,
    repMin: 8,
    repMax: 12,
    repUnit: "reps" as const,
    loadType: "total" as const,
    restSec: 120,
    rirMin: 2,
    rirMax: 3,
    priority: false,
  };
  const day = (exercises: (typeof good)[], weekday = 1) => ({
    id: `d${weekday}`,
    order: 0,
    weekday,
    focus: "full_body_a" as const,
    warmupMinutes: 8,
    estimatedMinutes: 30,
    exercises,
  });
  const codes = (r: ReturnType<typeof validatePlan>) => r.errors.map((e) => e.code);

  it("menerima rencana valid", () => {
    expect(validatePlan({ days: [day([good])] }, ctx).errors).toEqual([]);
  });

  it("menolak latihan di luar katalog, alat tidak ada, level terlalu tinggi, duplikat", () => {
    const r = validatePlan(
      {
        days: [
          day([
            { ...good, exerciseId: "kettlebell_swing" },
            { ...good, exerciseId: "barbell_back_squat" },
            { ...good, exerciseId: "dumbbell_arnold_press" },
            good,
            good,
          ]),
        ],
      },
      ctx,
    );
    expect(codes(r)).toEqual(
      expect.arrayContaining(["unknown_exercise", "equipment_missing", "level_too_high", "duplicate_exercise"]),
    );
  });

  it("menolak angka di luar batas", () => {
    const r = validatePlan(
      {
        days: [
          day([
            { ...good, sets: 9 },
            { ...good, exerciseId: "dumbbell_squat", repMin: 12, repMax: 8 },
            { ...good, exerciseId: "dumbbell_reverse_lunge", restSec: 10 },
            { ...good, exerciseId: "dumbbell_step_up", rirMin: 0, rirMax: 9 },
          ]),
        ],
      },
      { ...ctx, equipment: new Set(["dumbbell", "bench"]) },
    );
    expect(codes(r)).toEqual(
      expect.arrayContaining(["sets_out_of_range", "reps_out_of_range", "rest_out_of_range", "rir_out_of_range"]),
    );
  });

  it("menolak hari tidak valid/duplikat dan rencana kosong", () => {
    expect(codes(validatePlan({ days: [] }, ctx))).toEqual(["no_days"]);
    expect(codes(validatePlan({ days: [day([good], 8)] }, ctx))).toContain("invalid_weekday");
    expect(codes(validatePlan({ days: [day([good], 1), { ...day([good], 1), id: "x" }] }, ctx))).toContain(
      "duplicate_weekday",
    );
  });

  it("peringatan otot sama pada hari berurutan", () => {
    const r = validatePlan({ days: [day([good], 1), day([good], 2)] }, ctx);
    expect(r.warnings).toContain("consecutive_muscle_overlap");
  });

  it("estimateMinutes", () => {
    // 8 menit + 3×40 s + 2×120 s + 60 s = 8 + 7 = 15 menit
    expect(estimateMinutes(8, [good])).toBe(15);
  });
});
