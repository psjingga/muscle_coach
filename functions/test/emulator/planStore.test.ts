import { deleteApp, initializeApp, type App } from "firebase-admin/app";
import { getFirestore, type Firestore } from "firebase-admin/firestore";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";

import { CATALOG_VERSION, EXERCISES } from "../../src/catalog/exercises";
import { seedExerciseCatalog } from "../../src/catalog/seed";
import { confirmGoal, submitAssessment } from "../../src/goals/goalStore";
import { activateWorkoutPlan, createStarterPlan } from "../../src/workout/planStore";
import { NOW, sampleAssessment } from "../fixtures/assessment";

const PROJECT_ID = "demo-musclecoach";
const UID = "alice";
let app: App;
let db: Firestore;

beforeAll(() => {
  if (!process.env.FIRESTORE_EMULATOR_HOST) throw new Error("Jalankan lewat `npm run test:emulator`.");
  app = initializeApp({ projectId: PROJECT_ID }, "plan-store-test");
  db = getFirestore(app);
});

afterAll(async () => {
  await deleteApp(app);
});

beforeEach(async () => {
  await fetch(
    `http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/${PROJECT_ID}/databases/(default)/documents`,
    { method: "DELETE" },
  );
});

const user = () => db.doc(`users/${UID}`);

async function onboard(assessment = sampleAssessment()) {
  const { goalId } = await submitAssessment(db, UID, assessment, NOW);
  await confirmGoal(db, UID, goalId, true);
}

describe("createStarterPlan", () => {
  it("menolak sebelum onboarding selesai", async () => {
    await submitAssessment(db, UID, sampleAssessment(), NOW);
    await expect(createStarterPlan(db, UID)).rejects.toMatchObject({
      code: "failed-precondition",
      details: { reason: "onboarding-required" },
    });
  });

  it("membuat draft program + hari dari assessment terakhir; draft lama diganti", async () => {
    await onboard();
    const first = await createStarterPlan(db, UID);
    const { planId } = await createStarterPlan(db, UID);
    const plan = (await user().collection("workoutPlans").doc(planId).get()).data()!;
    expect(plan).toMatchObject({ status: "draft", source: "template", split: "full_body", daysPerWeek: 3 });
    const days = await user().collection("workoutPlans").doc(planId).collection("days").orderBy("order").get();
    expect(days.docs.map((d) => d.get("weekday"))).toEqual([1, 3, 5]);
    expect(days.docs[0]!.get("exercises").length).toBeGreaterThanOrEqual(3);
    expect((await user().collection("workoutPlans").doc(first.planId).get()).exists).toBe(false);
    expect((await user().collection("workoutPlans").doc(first.planId).collection("days").get()).size).toBe(0);
  });
});

describe("activateWorkoutPlan", () => {
  it("mengaktifkan draft, mengarsipkan program lama, mencatat di profil", async () => {
    await onboard();
    const a = await createStarterPlan(db, UID);
    await activateWorkoutPlan(db, UID, a.planId);
    const b = await createStarterPlan(db, UID);
    await activateWorkoutPlan(db, UID, b.planId);

    expect((await user().collection("workoutPlans").doc(a.planId).get()).get("status")).toBe("archived");
    expect((await user().collection("workoutPlans").doc(b.planId).get()).get("status")).toBe("active");
    expect((await user().collection("profile").doc("current").get()).get("activeWorkoutPlanId")).toBe(b.planId);
    await expect(activateWorkoutPlan(db, UID, b.planId)).rejects.toMatchObject({ code: "failed-precondition" });
    await expect(activateWorkoutPlan(db, UID, "tidak-ada")).rejects.toMatchObject({ code: "not-found" });
  });
});

describe("seedExerciseCatalog", () => {
  it("menulis katalog sekali per versi; latihan yang dihapus ditandai retired", async () => {
    await db.doc("exerciseCatalog/lama").set({ status: "published" });
    expect(await seedExerciseCatalog(db)).toEqual({ seeded: true, count: EXERCISES.length });
    expect(await seedExerciseCatalog(db)).toEqual({ seeded: false, count: 0 });
    const squat = (await db.doc("exerciseCatalog/goblet_squat").get()).data()!;
    expect(squat).toMatchObject({ status: "published", catalogVersion: CATALOG_VERSION, name: "Goblet Squat" });
    expect((await db.doc("exerciseCatalog/lama").get()).get("status")).toBe("retired");
  });
});
