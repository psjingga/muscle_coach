import { FieldValue, type Firestore } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";

import { type Assessment, assessmentSchema } from "../assessment/schema";
import { CATALOG_VERSION } from "../catalog/exercises";
import { SCHEMA_VERSION } from "../common/config";
import { buildTemplatePlan, TEMPLATE_GENERATOR_VERSION } from "./templatePlanner";

const precondition = (reason: string, message: string) =>
  new HttpsError("failed-precondition", message, { reason });

/**
 * Buat draft program awal (template) dari assessment terakhir. Draft lama
 * yang belum diaktifkan dihapus. Program baru aktif setelah pengguna setuju.
 */
export async function createStarterPlan(db: Firestore, uid: string): Promise<{ planId: string }> {
  const user = db.doc(`users/${uid}`);
  const profile = await user.collection("profile").doc("current").get();
  if (profile.get("onboardingCompleted") !== true) {
    throw precondition("onboarding-required", "Selesaikan assessment dan konfirmasi target dulu.");
  }
  const assessmentId = profile.get("latestAssessmentId") as string | undefined;
  const snap = assessmentId ? await user.collection("assessments").doc(assessmentId).get() : null;
  const parsed = assessmentSchema.safeParse(stripMeta(snap?.data()));
  if (!snap?.exists || !parsed.success) {
    throw precondition("assessment-missing", "Assessment tidak ditemukan. Ulangi assessment.");
  }
  const assessment: Assessment = parsed.data;
  if (assessment.safety.redFlags.length > 0) {
    throw precondition("safety-stop", "Konsultasikan dengan tenaga medis terlebih dahulu.");
  }

  const draft = buildTemplatePlan(assessment);
  const oldDrafts = await user.collection("workoutPlans").where("status", "==", "draft").get();
  await Promise.all(oldDrafts.docs.map((d) => db.recursiveDelete(d.ref)));

  const planRef = user.collection("workoutPlans").doc();
  const ts = FieldValue.serverTimestamp();
  const batch = db.batch();
  batch.create(planRef, {
    status: "draft",
    source: "template",
    generatorVersion: TEMPLATE_GENERATOR_VERSION,
    catalogVersion: CATALOG_VERSION,
    assessmentId,
    split: draft.split,
    level: draft.level,
    daysPerWeek: draft.daysPerWeek,
    sessionMinutes: draft.sessionMinutes,
    warnings: draft.warnings,
    schemaVersion: SCHEMA_VERSION,
    createdAt: ts,
    updatedAt: ts,
  });
  for (const day of draft.days) {
    batch.create(planRef.collection("days").doc(day.id), { ...day, schemaVersion: SCHEMA_VERSION });
  }
  await batch.commit();
  return { planId: planRef.id };
}

/** Aktifkan draft program; program aktif sebelumnya diarsipkan. */
export async function activateWorkoutPlan(db: Firestore, uid: string, planId: string): Promise<{ planId: string }> {
  const user = db.doc(`users/${uid}`);
  const planRef = user.collection("workoutPlans").doc(planId);
  return db.runTransaction(async (tx) => {
    const plan = await tx.get(planRef);
    if (!plan.exists) throw new HttpsError("not-found", "Program tidak ditemukan.");
    if (plan.get("status") !== "draft") throw precondition("plan-not-draft", "Program ini sudah diproses.");
    const active = await tx.get(user.collection("workoutPlans").where("status", "==", "active"));
    const ts = FieldValue.serverTimestamp();
    for (const doc of active.docs) tx.update(doc.ref, { status: "archived", archivedAt: ts, updatedAt: ts });
    tx.update(planRef, { status: "active", activatedAt: ts, updatedAt: ts });
    tx.update(user.collection("profile").doc("current"), { activeWorkoutPlanId: planId, updatedAt: ts });
    return { planId };
  });
}

/** Buang field metadata dokumen assessment sebelum divalidasi skema. */
function stripMeta(data: Record<string, unknown> | undefined): unknown {
  if (!data) return undefined;
  const { profile, goal, experience, availability, activity, nutrition, safety } = data;
  return { profile, goal, experience, availability, activity, nutrition, safety };
}
