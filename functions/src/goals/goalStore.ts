import { FieldValue, type Firestore } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";

import { type Assessment, ageOn, CONSENT_VERSION } from "../assessment/schema";
import { SCHEMA_VERSION } from "../common/config";
import { NUTRITION_CONFIG } from "../nutrition/config";
import { ensureUserProfile } from "../users/userProfile";
import { buildGoalProposal, canConfirm, type GoalProposal } from "./goalPlanner";

/** ID dokumen draft assessment yang ditulis aplikasi. */
export const DRAFT_ID = "draft";

export interface SubmitResult {
  assessmentId: string;
  goalId: string;
}

/**
 * Simpan assessment final, consent, peralatan, dan usulan goal (status
 * `proposed`). Usulan sebelumnya yang belum dikonfirmasi dihapus.
 */
export async function submitAssessment(
  db: Firestore,
  uid: string,
  assessment: Assessment,
  now: Date = new Date(),
): Promise<SubmitResult> {
  const age = ageOn(assessment.profile.birthDate, now);
  if (age < NUTRITION_CONFIG.age.min || age > NUTRITION_CONFIG.age.max) {
    throw new HttpsError("invalid-argument", "Data yang dikirim tidak valid.", {
      fields: ["assessment.profile.birthDate"],
      reason: "age-out-of-range",
    });
  }
  const proposal = buildGoalProposal(assessment, now);

  await ensureUserProfile(db, uid);
  const user = db.doc(`users/${uid}`);
  const assessmentRef = user.collection("assessments").doc();
  const goalRef = user.collection("goals").doc();
  const ts = FieldValue.serverTimestamp();
  const meta = { schemaVersion: SCHEMA_VERSION, createdAt: ts, updatedAt: ts };

  const staleProposals = await user.collection("goals").where("status", "==", "proposed").get();

  const batch = db.batch();
  batch.create(assessmentRef, {
    ...meta,
    ...assessment,
    status: "final",
    source: "user_input",
    consentVersion: CONSENT_VERSION,
  });
  batch.delete(user.collection("assessments").doc(DRAFT_ID));
  batch.set(user.collection("consents").doc("assessment_health_data"), {
    ...meta,
    type: "assessment_health_data",
    version: CONSENT_VERSION,
    accepted: true,
    acceptedAt: ts,
    source: "user_input",
  });
  const { availability } = assessment;
  batch.set(user.collection("equipment").doc("current"), {
    ...meta,
    ...availability.equipment,
    dumbbellMaxKg: availability.dumbbellMaxKg,
    barbellMaxKg: availability.barbellMaxKg,
    location: availability.location,
    assessmentId: assessmentRef.id,
    source: "user_input",
  });
  for (const doc of staleProposals.docs) batch.delete(doc.ref);
  batch.create(goalRef, {
    ...meta,
    ...proposal,
    status: "proposed",
    assessmentId: assessmentRef.id,
    source: "calculated",
  });
  const profileUpdate: Record<string, unknown> = {
    latestAssessmentId: assessmentRef.id,
    updatedAt: ts,
  };
  if (assessment.profile.nickname) profileUpdate.displayName = assessment.profile.nickname;
  batch.update(user.collection("profile").doc("current"), profileUpdate);
  await batch.commit();

  return { assessmentId: assessmentRef.id, goalId: goalRef.id };
}

/**
 * Aktifkan goal yang diusulkan: arsipkan goal & target nutrisi aktif
 * sebelumnya, buat target nutrisi baru, tandai onboarding selesai.
 */
export async function confirmGoal(
  db: Firestore,
  uid: string,
  goalId: string,
  acknowledgedWarnings: boolean,
): Promise<{ goalId: string; nutritionTargetId: string }> {
  const user = db.doc(`users/${uid}`);
  const goalRef = user.collection("goals").doc(goalId);

  return db.runTransaction(async (tx) => {
    const snap = await tx.get(goalRef);
    if (!snap.exists) throw new HttpsError("not-found", "Target tidak ditemukan.");
    const goal = snap.data() as GoalProposal & { status: string };

    const reject = (reason: string, message: string) => {
      throw new HttpsError("failed-precondition", message, { reason });
    };
    if (goal.status !== "proposed") reject("goal-not-proposed", "Target ini sudah diproses.");
    if (goal.safety.stop) reject("safety-stop", "Konsultasikan dengan tenaga medis terlebih dahulu.");
    if (!canConfirm(goal)) reject("goal-needs-adjustment", "Sesuaikan target terlebih dahulu.");
    if (goal.safety.warnings.length > 0 && !acknowledgedWarnings) {
      reject("acknowledgement-required", "Konfirmasi bahwa Anda telah membaca peringatan.");
    }

    const [activeGoals, activeTargets] = await Promise.all([
      tx.get(user.collection("goals").where("status", "==", "active")),
      tx.get(user.collection("nutritionTargets").where("status", "==", "active")),
    ]);

    const ts = FieldValue.serverTimestamp();
    for (const doc of [...activeGoals.docs, ...activeTargets.docs]) {
      tx.update(doc.ref, { status: "archived", archivedAt: ts, updatedAt: ts });
    }

    const targetRef = user.collection("nutritionTargets").doc();
    tx.create(targetRef, {
      ...goal.nutrition,
      schemaVersion: SCHEMA_VERSION,
      status: "active",
      goalId,
      configVersion: goal.configVersion,
      source: "calculated",
      createdAt: ts,
      updatedAt: ts,
    });
    tx.update(goalRef, {
      status: "active",
      activatedAt: ts,
      warningsAcknowledged: goal.safety.warnings.length > 0,
      nutritionTargetId: targetRef.id,
      updatedAt: ts,
    });
    tx.update(user.collection("profile").doc("current"), {
      onboardingCompleted: true,
      activeGoalId: goalId,
      activeNutritionTargetId: targetRef.id,
      updatedAt: ts,
    });
    return { goalId, nutritionTargetId: targetRef.id };
  });
}
