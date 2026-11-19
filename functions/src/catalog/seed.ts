import { FieldValue, type Firestore } from "firebase-admin/firestore";

import { SCHEMA_VERSION } from "../common/config";
import { CATALOG_VERSION, EXERCISES } from "./exercises";

const CONFIG_DOC = "appConfig/exerciseCatalog";

/**
 * Tulis katalog latihan ke `exerciseCatalog` (lingkungan tepercaya saja).
 * Dilewati bila versi di `appConfig/exerciseCatalog` sudah sama, kecuali `force`.
 */
export async function seedExerciseCatalog(
  db: Firestore,
  { force = false }: { force?: boolean } = {},
): Promise<{ seeded: boolean; count: number }> {
  const config = await db.doc(CONFIG_DOC).get();
  if (!force && config.get("version") === CATALOG_VERSION) return { seeded: false, count: 0 };

  const batch = db.batch();
  const ts = FieldValue.serverTimestamp();
  for (const ex of EXERCISES) {
    batch.set(db.collection("exerciseCatalog").doc(ex.id), {
      ...ex,
      status: "published",
      source: "curated_database",
      catalogVersion: CATALOG_VERSION,
      videoUrl: null,
      schemaVersion: SCHEMA_VERSION,
      updatedAt: ts,
    });
  }
  // Latihan yang dihapus dari katalog ditandai tidak dipublikasikan (riwayat tetap utuh).
  const existing = await db.collection("exerciseCatalog").select().get();
  const ids = new Set(EXERCISES.map((e) => e.id));
  for (const doc of existing.docs) {
    if (!ids.has(doc.id)) batch.update(doc.ref, { status: "retired", updatedAt: ts });
  }
  batch.set(db.doc(CONFIG_DOC), { version: CATALOG_VERSION, count: EXERCISES.length, updatedAt: ts });
  await batch.commit();
  return { seeded: true, count: EXERCISES.length };
}
