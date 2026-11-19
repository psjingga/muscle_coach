import { FieldValue, type Firestore } from "firebase-admin/firestore";

import { SCHEMA_VERSION } from "../common/config";

/**
 * Membuat `users/{uid}`, `profile/current`, dan `entitlement/current` bila
 * belum ada. Idempoten: aman dipanggil berulang tanpa menimpa data.
 * Email tidak disimpan (sudah ada di Firebase Auth; minimisasi data).
 */
export async function ensureUserProfile(db: Firestore, uid: string): Promise<{ created: boolean }> {
  const userRef = db.doc(`users/${uid}`);
  return db.runTransaction(async (tx) => {
    const snap = await tx.get(userRef);
    if (snap.exists) return { created: false };

    const now = FieldValue.serverTimestamp();
    const base = { schemaVersion: SCHEMA_VERSION, createdAt: now, updatedAt: now };
    tx.create(userRef, { ...base, status: "active" });
    tx.create(userRef.collection("profile").doc("current"), {
      ...base,
      displayName: null,
      unitSystem: "metric",
      locale: "id-ID",
      source: "user_input",
    });
    tx.create(userRef.collection("entitlement").doc("current"), {
      ...base,
      // Placeholder subscription: MVP gratis, semua fitur aktif.
      plan: "free_personal",
      status: "active",
      source: "calculated",
    });
    return { created: true };
  });
}

/** Hapus seluruh data milik pengguna di Firestore (rekursif). */
export async function deleteUserDocuments(db: Firestore, uid: string): Promise<void> {
  await db.recursiveDelete(db.doc(`users/${uid}`));
  await db.doc(`usage/${uid}`).delete();
}
