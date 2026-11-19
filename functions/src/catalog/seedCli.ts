/**
 * Seed katalog latihan dari lingkungan tepercaya.
 *
 *   Emulator:  npm run seed:emulator
 *   Project:   GOOGLE_APPLICATION_CREDENTIALS=… GCLOUD_PROJECT=<id> node lib/catalog/seedCli.js --force
 */
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

import { seedExerciseCatalog } from "./seed";

async function main(): Promise<void> {
  const projectId = process.env.GCLOUD_PROJECT ?? "demo-musclecoach";
  initializeApp({ projectId });
  const result = await seedExerciseCatalog(getFirestore(), { force: process.argv.includes("--force") });
  const target = process.env.FIRESTORE_EMULATOR_HOST ? `emulator ${process.env.FIRESTORE_EMULATOR_HOST}` : projectId;
  console.log(result.seeded ? `Katalog (${result.count} latihan) ditulis ke ${target}.` : "Katalog sudah versi terbaru.");
}

main().catch((e: unknown) => {
  console.error(e);
  process.exit(1);
});
