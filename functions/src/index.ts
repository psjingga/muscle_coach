import { getAuth } from "firebase-admin/auth";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { onCall } from "firebase-functions/v2/https";
import { z } from "zod";

import { requireAuth, requireRecentLogin } from "./common/auth";
import { applyGlobalOptions } from "./common/config";
import { parsePayload } from "./common/validation";
import { deleteUserDocuments, ensureUserProfile } from "./users/userProfile";

initializeApp();
applyGlobalOptions();

/** Dipanggil aplikasi setelah daftar/login. Idempoten. */
export const createUserProfile = onCall(async (request) => {
  const uid = requireAuth(request.auth);
  const result = await ensureUserProfile(getFirestore(), uid);
  if (result.created) logger.info("Profil pengguna dibuat", { uid });
  return result;
});

const deleteUserDataSchema = z.object({ confirm: z.literal(true) }).strict();

/** Hapus seluruh data pengguna lalu akun Auth-nya. Wajib login ulang < 5 menit. */
export const deleteUserData = onCall(async (request) => {
  const uid = requireRecentLogin(request.auth);
  parsePayload(deleteUserDataSchema, request.data);
  await deleteUserDocuments(getFirestore(), uid);
  await getAuth().deleteUser(uid);
  logger.info("Akun & data pengguna dihapus", { uid });
  return { deleted: true };
});
