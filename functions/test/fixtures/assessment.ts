import type { Assessment } from "../../src/assessment/schema";

/** Assessment valid & fiktif untuk test. */
export function sampleAssessment(overrides: Partial<{ [K in keyof Assessment]: Partial<Assessment[K]> }> = {}): Assessment {
  const base: Assessment = {
    profile: {
      nickname: null,
      birthDate: "1996-05-10",
      sex: "male",
      heightCm: 175,
      weightKg: 70,
    },
    goal: {
      primary: "muscle_gain",
      targetWeightKg: 74,
      targetWeeks: 24,
      priorityMuscles: ["chest", "back"],
      motivation: null,
    },
    experience: {
      level: "beginner",
      trainingAge: "lt_6m",
      currentSessionsPerWeek: 2,
      knownExercises: null,
      workingWeights: null,
    },
    availability: {
      trainingDays: [1, 3, 5],
      sessionMinutes: 60,
      location: "home",
      equipment: { dumbbell: true, barbell: true, bench: true, rack: false, pullUpBar: false },
      dumbbellMaxKg: 24,
      barbellMaxKg: 60,
      preferences: null,
    },
    activity: {
      level: "light",
      occupation: "sitting",
      sleepHours: 7,
      stress: null,
      cardio: null,
    },
    nutrition: {
      diet: "omnivore",
      allergies: null,
      dislikes: null,
      preferences: null,
      dailyBudgetIdr: null,
      mealsPerDay: 3,
      cooking: "mixed",
      country: "ID",
      notes: null,
    },
    safety: {
      injuries: null,
      avoidedMovements: null,
      medicalFlags: [],
      redFlags: [],
    },
  };
  const merged = { ...base } as Record<string, unknown>;
  for (const [key, value] of Object.entries(overrides)) {
    merged[key] = { ...(base as unknown as Record<string, object>)[key], ...value };
  }
  return merged as unknown as Assessment;
}

/** Tanggal acuan test (UTC). */
export const NOW = new Date("2026-11-19T03:00:00Z");
