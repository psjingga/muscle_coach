import { z } from "zod";

/**
 * Skema assessment awal (brief §5 A–G). Harus sinkron dengan model Dart
 * `AssessmentData` (lib/features/assessment/domain/entities/assessment_data.dart).
 * Data kesehatan diminimalkan: kondisi medis hanya berupa flag, tanpa teks bebas.
 */

export const CONSENT_VERSION = "2026-11-v1";

const text = (max: number) => z.string().trim().max(max).nullable();
const uniqueArray = <T extends z.ZodType>(item: T, max: number) =>
  z
    .array(item)
    .max(max)
    .refine((a) => new Set(a).size === a.length, { message: "duplikat" });

export const SEXES = ["male", "female", "undisclosed"] as const;
export const PRIMARY_GOALS = ["muscle_gain", "strength", "recomposition"] as const;
export const LEVELS = ["beginner", "intermediate", "advanced"] as const;
export const ACTIVITY_LEVELS = ["sedentary", "light", "moderate", "high"] as const;
export const MEDICAL_FLAGS = [
  "pregnant",
  "chronic_condition",
  "eating_disorder_history",
  "injury_recovery",
  "medication",
] as const;
export const RED_FLAGS = ["chest_pain", "fainting", "unusual_breathlessness", "acute_injury"] as const;

const profile = z
  .object({
    nickname: text(40),
    birthDate: z.iso.date(),
    sex: z.enum(SEXES),
    heightCm: z.number().min(120).max(230),
    weightKg: z.number().min(35).max(250),
  })
  .strict();

const goal = z
  .object({
    primary: z.enum(PRIMARY_GOALS),
    targetWeightKg: z.number().min(35).max(250).nullable(),
    targetWeeks: z.int().min(4).max(104),
    priorityMuscles: uniqueArray(
      z.enum(["chest", "back", "shoulders", "arms", "legs", "glutes", "core"]),
      7,
    ),
    motivation: text(300),
  })
  .strict();

const experience = z
  .object({
    level: z.enum(LEVELS),
    trainingAge: z.enum(["none", "lt_6m", "6m_2y", "2y_5y", "gt_5y"]),
    currentSessionsPerWeek: z.int().min(0).max(14),
    knownExercises: text(300),
    workingWeights: text(300),
  })
  .strict();

const availability = z
  .object({
    trainingDays: uniqueArray(z.int().min(1).max(7), 7).refine((a) => a.length >= 1),
    sessionMinutes: z.literal([30, 45, 60, 75, 90]),
    location: z.enum(["home", "gym"]),
    equipment: z
      .object({
        dumbbell: z.boolean(),
        barbell: z.boolean(),
        bench: z.boolean(),
        rack: z.boolean(),
        pullUpBar: z.boolean(),
      })
      .strict()
      .refine((e) => e.dumbbell || e.barbell, { message: "butuh dumbbell atau barbell" }),
    dumbbellMaxKg: z.number().min(1).max(100).nullable(),
    barbellMaxKg: z.number().min(10).max(500).nullable(),
    preferences: text(300),
  })
  .strict();

const activity = z
  .object({
    level: z.enum(ACTIVITY_LEVELS),
    occupation: z.enum(["sitting", "standing", "active"]),
    sleepHours: z.number().min(3).max(14),
    stress: z.enum(["low", "medium", "high"]).nullable(),
    cardio: text(300),
  })
  .strict();

const nutrition = z
  .object({
    diet: z.enum(["omnivore", "vegetarian", "vegan", "other"]),
    allergies: text(300),
    dislikes: text(300),
    preferences: text(300),
    dailyBudgetIdr: z.int().min(0).max(10_000_000).nullable(),
    mealsPerDay: z.int().min(2).max(6),
    cooking: z.enum(["self", "catering", "mixed"]),
    country: z.string().regex(/^[A-Z]{2}$/),
    notes: text(300),
  })
  .strict();

const safety = z
  .object({
    injuries: text(300),
    avoidedMovements: text(300),
    medicalFlags: uniqueArray(z.enum(MEDICAL_FLAGS), MEDICAL_FLAGS.length),
    redFlags: uniqueArray(z.enum(RED_FLAGS), RED_FLAGS.length),
  })
  .strict();

export const assessmentSchema = z
  .object({ profile, goal, experience, availability, activity, nutrition, safety })
  .strict();

export type Assessment = z.infer<typeof assessmentSchema>;
export type Sex = (typeof SEXES)[number];
export type PrimaryGoal = (typeof PRIMARY_GOALS)[number];
export type Level = (typeof LEVELS)[number];
export type ActivityLevel = (typeof ACTIVITY_LEVELS)[number];
export type MedicalFlag = (typeof MEDICAL_FLAGS)[number];
export type RedFlag = (typeof RED_FLAGS)[number];

export const submitAssessmentSchema = z
  .object({
    assessment: assessmentSchema,
    consent: z
      .object({
        version: z.literal(CONSENT_VERSION),
        disclaimer: z.literal(true),
        healthData: z.literal(true),
      })
      .strict(),
  })
  .strict();

export const confirmGoalSchema = z
  .object({
    goalId: z.string().min(1).max(128).regex(/^[A-Za-z0-9_-]+$/),
    acknowledgedWarnings: z.boolean(),
  })
  .strict();

/** Usia penuh (tahun) pada tanggal `now` (UTC) dari `YYYY-MM-DD`. */
export function ageOn(birthDate: string, now: Date): number {
  const [y, m, d] = birthDate.split("-").map(Number) as [number, number, number];
  let age = now.getUTCFullYear() - y;
  const beforeBirthday =
    now.getUTCMonth() + 1 < m || (now.getUTCMonth() + 1 === m && now.getUTCDate() < d);
  if (beforeBirthday) age -= 1;
  return age;
}
