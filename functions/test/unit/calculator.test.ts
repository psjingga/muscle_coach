import { describe, expect, it } from "vitest";

import { bmi, calculateNutrition, mifflinStJeor, surplusFor } from "../../src/nutrition/calculator";
import { NUTRITION_CONFIG } from "../../src/nutrition/config";

const base = {
  sex: "male" as const,
  weightKg: 70,
  heightCm: 175,
  age: 30,
  activity: "light" as const,
  goal: "muscle_gain" as const,
  level: "beginner" as const,
  conservative: false,
};

describe("mifflinStJeor", () => {
  it("menghitung BMR pria & wanita sesuai rumus", () => {
    // 10·70 + 6.25·175 − 5·30 + 5 = 1648.75
    expect(mifflinStJeor("male", 70, 175, 30)).toBeCloseTo(1648.75);
    // … − 161 = 1482.75
    expect(mifflinStJeor("female", 70, 175, 30)).toBeCloseTo(1482.75);
  });
});

describe("bmi", () => {
  it("kg / m²", () => expect(bmi(70, 175)).toBeCloseTo(22.857, 3));
});

describe("calculateNutrition", () => {
  it("BMR, TDEE, surplus dan makro untuk pria pemula", () => {
    const r = calculateNutrition(base);
    expect(r.sexBasis).toBe("male");
    expect(r.bmrKcal).toEqual({ min: 1649, max: 1649 });
    expect(r.activityFactor).toBe(1.375);
    expect(r.tdeeKcal).toEqual({ min: 2267, max: 2267 });
    expect(r.surplusPct).toBe(10);
    // 1.8 g/kg × 70 = 126 → 125 g (kelipatan 5)
    expect(r.proteinG).toBe(125);
    // 0.8 g/kg × 70 = 56 → 55 g
    expect(r.fatG).toBe(55);
    expect(r.carbsG % 5).toBe(0);
  });

  it("total kcal selalu konsisten dengan makro 4/4/9", () => {
    for (const weightKg of [45, 60, 82.5, 110, 150]) {
      for (const sex of ["male", "female", "undisclosed"] as const) {
        const r = calculateNutrition({ ...base, weightKg, sex });
        expect(r.targetKcal).toBe(r.proteinG * 4 + r.carbsG * 4 + r.fatG * 9);
        expect(r.proteinG % 5).toBe(0);
        expect(r.fatG % 5).toBe(0);
        expect(r.carbsG).toBeGreaterThanOrEqual(0);
      }
    }
  });

  it("energi target dekat TDEE × (1 + surplus)", () => {
    const r = calculateNutrition(base);
    const expected = r.tdeeKcal.min * 1.1;
    expect(Math.abs(r.targetKcal - expected)).toBeLessThan(40);
    expect(r.targetKcalRange.min).toBe(r.targetKcalRange.max);
  });

  it("jenis kelamin tidak diisi → rentang, bukan memilih salah satu", () => {
    const r = calculateNutrition({ ...base, sex: "undisclosed" });
    expect(r.sexBasis).toBe("range");
    expect(r.bmrKcal).toEqual({ min: 1483, max: 1649 });
    expect(r.targetKcalRange.min).toBeLessThan(r.targetKcalRange.max);
    expect(r.targetKcal).toBeGreaterThan(r.targetKcalRange.min - 30);
    expect(r.targetKcal).toBeLessThan(r.targetKcalRange.max + 30);
  });

  it("lemak dibatasi 20–35 % energi dan ≥ 0.6 g/kg", () => {
    for (const weightKg of [40, 70, 140]) {
      const r = calculateNutrition({ ...base, weightKg, heightCm: 180 });
      const fatPct = (r.fatG * 9) / r.targetKcal;
      expect(fatPct).toBeGreaterThanOrEqual(0.18); // toleransi pembulatan
      expect(fatPct).toBeLessThanOrEqual(0.37);
      expect(r.fatG).toBeGreaterThanOrEqual(Math.floor(0.6 * weightKg / 5) * 5);
    }
  });

  it("BMI tinggi → protein memakai berat acuan BMI 25", () => {
    const r = calculateNutrition({ ...base, weightKg: 120, heightCm: 175 }); // BMI ≈ 39
    expect(r.proteinBasisKg).toBeCloseTo(76.6, 1);
    expect(r.proteinG).toBe(140); // 1.8 × 76.56 = 137.8 → 140
  });

  it("recomposition: tanpa surplus, protein 2.0 g/kg", () => {
    const r = calculateNutrition({ ...base, goal: "recomposition" });
    expect(r.surplusPct).toBe(0);
    expect(r.proteinG).toBe(140);
  });

  it("mode konservatif membatasi surplus", () => {
    expect(surplusFor("muscle_gain", "beginner", true)).toBe(NUTRITION_CONFIG.conservativeSurplusPct);
    expect(surplusFor("muscle_gain", "advanced", false)).toBe(5);
    expect(calculateNutrition({ ...base, conservative: true }).surplusPct).toBe(5);
  });

  it("persentase energi berjumlah ±100", () => {
    const { energySplitPct: s } = calculateNutrition(base);
    expect(s.protein + s.fat + s.carbs).toBeGreaterThanOrEqual(99);
    expect(s.protein + s.fat + s.carbs).toBeLessThanOrEqual(101);
  });
});
