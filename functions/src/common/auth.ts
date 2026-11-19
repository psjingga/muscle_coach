import { HttpsError } from "firebase-functions/v2/https";

/** Bentuk minimum `request.auth` dari callable (memudahkan test). */
export interface CallableAuth {
  uid: string;
  token: { auth_time?: number } & Record<string, unknown>;
}

/** Kembalikan UID pemanggil atau tolak bila belum login. */
export function requireAuth(auth: CallableAuth | undefined): string {
  if (!auth?.uid) {
    throw new HttpsError("unauthenticated", "Silakan masuk terlebih dahulu.");
  }
  return auth.uid;
}

/**
 * Operasi sensitif (mis. hapus akun) mensyaratkan login/re-auth dalam
 * `maxAgeSeconds` terakhir.
 */
export function requireRecentLogin(
  auth: CallableAuth | undefined,
  nowMs: number = Date.now(),
  maxAgeSeconds = 300,
): string {
  const uid = requireAuth(auth);
  const authTime = auth?.token.auth_time;
  if (typeof authTime !== "number" || nowMs / 1000 - authTime > maxAgeSeconds) {
    throw new HttpsError("failed-precondition", "Masukkan kata sandi Anda lagi untuk melanjutkan.", {
      reason: "requires-recent-login",
    });
  }
  return uid;
}
