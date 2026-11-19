import { describe, expect, it } from "vitest";

import { ageOn, submitAssessmentSchema, CONSENT_VERSION } from "../../src/assessment/schema";
import {
  assessSafety,
  buildGoalProposal,
  canConfirm,
  evaluateGoal,
  maxWeeklyGainPct,
} from "../../src/goals/goalPlanner";
import { NOW, sampleAssessment } from "../fixtures/assessment";

const gain = {
  primary: "muscle_gain" as const,
  level: "beginner" as const,
  startKg: 70,
  targetKg: 74 as number | null,
  weeks: 24,
  conservative: false,
};

describe("evaluateGoal", () => {
  it("target dalam batas laju → realistis", () => {
    // 4 kg / 24 mg = 0.167 kg/mg = 0.24 %/mg ≤ 0.5 %
    const e = evaluateGoal(gain);
    expect(e.verdict).toBe("realistic");
    expect(e.deltaKg).toBe(4);
    expect(e.weeklyChangePct).toBeCloseTo(0.24, 2);
    expect(e.expectedWeeklyGainKg).toEqual({ min: 0.18, max: 0.35 });
  });

  it("laju terlalu cepat → perlu disesuaikan + saran waktu & target", () => {
    // 10 kg / 8 mg → 1.79 %/mg
    const e = evaluateGoal({ ...gain, targetKg: 80, weeks: 8 });
    expect(e.verdict).toBe("needs_adjustment");
    expect(e.reasons).toEqual(["rate_too_fast"]);
    // batas 0.35 kg/mg → 10 / 0.35 = 28.6 → 29 minggu
    expect(e.suggestedWeeks).toBe(29);
    // 70 + 0.35 × 8 = 72.8
    expect(e.suggestedTargetWeightKg).toBe(72.8);
    const fixed = evaluateGoal({ ...gain, targetKg: 80, weeks: e.suggestedWeeks! });
    expect(fixed.verdict).toBe("realistic");
    const fixedTarget = evaluateGoal({ ...gain, targetKg: e.suggestedTargetWeightKg, weeks: 8 });
    expect(fixedTarget.verdict).toBe("realistic");
  });

  it("tepat di batas masih realistis", () => {
    // 0.5 % × 70 = 0.35 kg/mg × 20 = 7 kg
    expect(evaluateGoal({ ...gain, targetKg: 77, weeks: 20 }).verdict).toBe("realistic");
  });

  it("level lebih tinggi & mode konservatif → batas lebih rendah", () => {
    expect(maxWeeklyGainPct("beginner", false)).toBe(0.5);
    expect(maxWeeklyGainPct("advanced", false)).toBe(0.25);
    expect(maxWeeklyGainPct("beginner", true)).toBe(0.25);
    const e = evaluateGoal({ ...gain, targetKg: 77, weeks: 20, conservative: true });
    expect(e.verdict).toBe("needs_adjustment");
  });

  it("muscle gain dengan target di bawah berat sekarang → tidak disetujui otomatis", () => {
    const e = evaluateGoal({ ...gain, targetKg: 65 });
    expect(e.verdict).toBe("needs_adjustment");
    expect(e.reasons).toEqual(["target_below_current"]);
  });

  it("recomposition: berat relatif stabil OK, perubahan besar perlu disesuaikan", () => {
    const recomp = { ...gain, primary: "recomposition" as const };
    expect(evaluateGoal({ ...recomp, targetKg: 71 }).verdict).toBe("realistic");
    const e = evaluateGoal({ ...recomp, targetKg: 76 });
    expect(e.reasons).toEqual(["recomposition_weight_change"]);
    expect(e.suggestedTargetWeightKg).toBe(70);
    expect(e.expectedWeeklyGainKg).toEqual({ min: 0, max: 0 });
  });

  it("tanpa berat target → realistis, tanpa angka selisih", () => {
    const e = evaluateGoal({ ...gain, targetKg: null });
    expect(e.verdict).toBe("realistic");
    expect(e.deltaKg).toBeNull();
  });
});

describe("assessSafety", () => {
  const ok = { age: 30, bmi: 22, medicalFlags: [], redFlags: [] };

  it("tanpa flag → aman", () => {
    expect(assessSafety(ok)).toEqual({ stop: false, conservative: false, warnings: [] });
  });

  it("gejala berbahaya → stop", () => {
    const s = assessSafety({ ...ok, redFlags: ["chest_pain"] });
    expect(s.stop).toBe(true);
    expect(s.warnings).toContain("red_flag_symptoms");
  });

  it("kondisi medis, usia < 18, BMI rendah → konservatif + peringatan", () => {
    expect(assessSafety({ ...ok, medicalFlags: ["pregnant"] })).toMatchObject({
      conservative: true,
      warnings: ["pregnant"],
    });
    expect(assessSafety({ ...ok, age: 17 }).warnings).toEqual(["minor_age"]);
    expect(assessSafety({ ...ok, bmi: 17 }).conservative).toBe(true);
    const high = assessSafety({ ...ok, bmi: 36 });
    expect(high.warnings).toEqual(["high_bmi"]);
    expect(high.conservative).toBe(false);
  });
});

describe("buildGoalProposal", () => {
  it("menggabungkan usia, evaluasi, nutrisi, dan tanggal target", () => {
    const p = buildGoalProposal(sampleAssessment(), NOW);
    expect(p.age).toBe(30);
    expect(p.bmi).toBe(22.9);
    expect(p.targetDate).toBe("2027-05-06"); // + 24 minggu
    expect(p.evaluation.verdict).toBe("realistic");
    expect(p.nutrition.surplusPct).toBe(10);
    expect(p.configVersion).toMatch(/v\d+$/);
    expect(canConfirm(p)).toBe(true);
  });

  it("flag medis membuat surplus & batas laju konservatif", () => {
    const p = buildGoalProposal(sampleAssessment({ safety: { medicalFlags: ["medication"] } }), NOW);
    expect(p.safety.conservative).toBe(true);
    expect(p.nutrition.surplusPct).toBe(5);
    expect(p.evaluation.maxWeeklyGainPct).toBe(0.25);
  });

  it("gejala berbahaya → tidak bisa dikonfirmasi", () => {
    const p = buildGoalProposal(sampleAssessment({ safety: { redFlags: ["fainting"] } }), NOW);
    expect(canConfirm(p)).toBe(false);
  });
});

describe("ageOn", () => {
  it("menghitung ulang tahun dengan benar", () => {
    expect(ageOn("2000-11-19", NOW)).toBe(26);
    expect(ageOn("2000-11-20", NOW)).toBe(25);
    expect(ageOn("2000-12-01", NOW)).toBe(25);
  });
});

describe("submitAssessmentSchema", () => {
  const consent = { version: CONSENT_VERSION, disclaimer: true, healthData: true };

  it("menerima assessment lengkap", () => {
    expect(submitAssessmentSchema.safeParse({ assessment: sampleAssessment(), consent }).success).toBe(true);
  });

  it("menolak tanpa consent, field asing, atau tanpa dumbbell/barbell", () => {
    const a = sampleAssessment();
    expect(
      submitAssessmentSchema.safeParse({ assessment: a, consent: { ...consent, healthData: false } }).success,
    ).toBe(false);
    expect(
      submitAssessmentSchema.safeParse({
        assessment: { ...a, profile: { ...a.profile, email: "x@y.z" } },
        consent,
      }).success,
    ).toBe(false);
    const noGear = sampleAssessment({
      availability: { equipment: { dumbbell: false, barbell: false, bench: true, rack: true, pullUpBar: false } },
    });
    expect(submitAssessmentSchema.safeParse({ assessment: noGear, consent }).success).toBe(false);
  });

  it("menolak nilai di luar batas & duplikat", () => {
    const tooTall = sampleAssessment({ profile: { heightCm: 300 } });
    expect(submitAssessmentSchema.safeParse({ assessment: tooTall, consent }).success).toBe(false);
    const dupDays = sampleAssessment({ availability: { trainingDays: [1, 1] } });
    expect(submitAssessmentSchema.safeParse({ assessment: dupDays, consent }).success).toBe(false);
    const badMinutes = sampleAssessment({ availability: { sessionMinutes: 50 as 45 } });
    expect(submitAssessmentSchema.safeParse({ assessment: badMinutes, consent }).success).toBe(false);
  });
});
