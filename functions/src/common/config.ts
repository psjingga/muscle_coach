import { setGlobalOptions } from "firebase-functions/v2";

/** Region Jakarta. Harus sama dengan `FirebaseConfig.functionsRegion` di Flutter. */
export const REGION = "asia-southeast2";

/** Versi skema dokumen yang ditulis server. */
export const SCHEMA_VERSION = 1;

/** Batas umum untuk menahan biaya pada MVP pribadi. */
export function applyGlobalOptions(): void {
  setGlobalOptions({ region: REGION, maxInstances: 5, memory: "256MiB", timeoutSeconds: 60 });
}
