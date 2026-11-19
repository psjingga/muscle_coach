import { deleteApp, initializeApp, type App } from "firebase-admin/app";
import { getFirestore, type Firestore } from "firebase-admin/firestore";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";

import { confirmGoal, DRAFT_ID, submitAssessment } from "../../src/goals/goalStore";
import { NOW, sampleAssessment } from "../fixtures/assessment";

const PROJECT_ID = "demo-musclecoach";
const UID = "alice";
let app: App;
let db: Firestore;

beforeAll(() => {
  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    throw new Error("Jalankan lewat `npm run test:emulator`.");
  }
  app = initializeApp({ projectId: PROJECT_ID }, "goal-store-test");
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

async function expectHttpsError(promise: Promise<unknown>, code: string, reason?: string) {
  await expect(promise).rejects.toMatchObject({
    code,
    ...(reason ? { details: expect.objectContaining({ reason }) } : {}),
  });
}

describe("submitAssessment", () => {
  it("menyimpan assessment final, consent, peralatan, dan usulan goal; menghapus draft", async () => {
    await user().collection("assessments").doc(DRAFT_ID).set({ status: "draft" });
    const { assessmentId, goalId } = await submitAssessment(db, UID, sampleAssessment(), NOW);

    const assessment = (await user().collection("assessments").doc(assessmentId).get()).data()!;
    expect(assessment.status).toBe("final");
    expect(assessment.profile.weightKg).toBe(70);
    expect((await user().collection("assessments").doc(DRAFT_ID).get()).exists).toBe(false);

    const goal = (await user().collection("goals").doc(goalId).get()).data()!;
    expect(goal).toMatchObject({ status: "proposed", assessmentId, source: "calculated" });
    expect(goal.nutrition.targetKcal).toBeGreaterThan(0);

    expect((await user().collection("consents").doc("assessment_health_data").get()).data()).toMatchObject({
      accepted: true,
    });
    expect((await user().collection("equipment").doc("current").get()).data()).toMatchObject({
      dumbbell: true,
      rack: false,
    });
    const profile = (await user().collection("profile").doc("current").get()).data()!;
    expect(profile.latestAssessmentId).toBe(assessmentId);
    expect(profile.onboardingCompleted).toBeUndefined();
  });

  it("usulan lama yang belum dikonfirmasi diganti", async () => {
    const first = await submitAssessment(db, UID, sampleAssessment(), NOW);
    const second = await submitAssessment(db, UID, sampleAssessment(), NOW);
    const proposed = await user().collection("goals").where("status", "==", "proposed").get();
    expect(proposed.docs.map((d) => d.id)).toEqual([second.goalId]);
    expect(first.goalId).not.toBe(second.goalId);
  });

  it("menolak usia di luar rentang", async () => {
    const child = sampleAssessment({ profile: { birthDate: "2015-01-01" } });
    await expectHttpsError(submitAssessment(db, UID, child, NOW), "invalid-argument", "age-out-of-range");
  });
});

describe("confirmGoal", () => {
  it("mengaktifkan goal, membuat target nutrisi, menandai onboarding selesai", async () => {
    const { goalId } = await submitAssessment(db, UID, sampleAssessment(), NOW);
    const { nutritionTargetId } = await confirmGoal(db, UID, goalId, false);

    const goal = (await user().collection("goals").doc(goalId).get()).data()!;
    expect(goal.status).toBe("active");
    const target = (await user().collection("nutritionTargets").doc(nutritionTargetId).get()).data()!;
    expect(target).toMatchObject({ status: "active", goalId, proteinG: goal.nutrition.proteinG });
    const profile = (await user().collection("profile").doc("current").get()).data()!;
    expect(profile).toMatchObject({
      onboardingCompleted: true,
      activeGoalId: goalId,
      activeNutritionTargetId: nutritionTargetId,
    });
  });

  it("goal baru mengarsipkan goal & target aktif sebelumnya", async () => {
    const first = await submitAssessment(db, UID, sampleAssessment(), NOW);
    const firstActive = await confirmGoal(db, UID, first.goalId, false);
    const second = await submitAssessment(db, UID, sampleAssessment(), NOW);
    await confirmGoal(db, UID, second.goalId, false);

    expect((await user().collection("goals").doc(first.goalId).get()).get("status")).toBe("archived");
    const oldTarget = await user().collection("nutritionTargets").doc(firstActive.nutritionTargetId).get();
    expect(oldTarget.get("status")).toBe("archived");
    const active = await user().collection("nutritionTargets").where("status", "==", "active").get();
    expect(active.size).toBe(1);
  });

  it("menolak target yang perlu disesuaikan, gejala berbahaya, dan konfirmasi ganda", async () => {
    const tooFast = sampleAssessment({ goal: { targetWeightKg: 85, targetWeeks: 8 } });
    const a = await submitAssessment(db, UID, tooFast, NOW);
    await expectHttpsError(confirmGoal(db, UID, a.goalId, true), "failed-precondition", "goal-needs-adjustment");

    const danger = sampleAssessment({ safety: { redFlags: ["chest_pain"] } });
    const b = await submitAssessment(db, UID, danger, NOW);
    await expectHttpsError(confirmGoal(db, UID, b.goalId, true), "failed-precondition", "safety-stop");

    const ok = await submitAssessment(db, UID, sampleAssessment(), NOW);
    await confirmGoal(db, UID, ok.goalId, false);
    await expectHttpsError(confirmGoal(db, UID, ok.goalId, false), "failed-precondition", "goal-not-proposed");
  });

  it("peringatan keselamatan wajib dikonfirmasi pengguna", async () => {
    const flagged = sampleAssessment({ safety: { medicalFlags: ["medication"] } });
    const { goalId } = await submitAssessment(db, UID, flagged, NOW);
    await expectHttpsError(confirmGoal(db, UID, goalId, false), "failed-precondition", "acknowledgement-required");
    await confirmGoal(db, UID, goalId, true);
    expect((await user().collection("goals").doc(goalId).get()).get("warningsAcknowledged")).toBe(true);
  });

  it("goal milik pengguna lain tidak ditemukan", async () => {
    const { goalId } = await submitAssessment(db, "bob", sampleAssessment(), NOW);
    await expectHttpsError(confirmGoal(db, UID, goalId, false), "not-found");
  });
});
