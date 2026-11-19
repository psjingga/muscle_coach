import { HttpsError } from "firebase-functions/v2/https";
import type { z } from "zod";

/** Validasi payload callable; detail error hanya berisi path field. */
export function parsePayload<T extends z.ZodType>(schema: T, data: unknown): z.infer<T> {
  const result = schema.safeParse(data ?? {});
  if (!result.success) {
    const fields = result.error.issues.map((i) => i.path.join(".") || "(root)");
    throw new HttpsError("invalid-argument", "Data yang dikirim tidak valid.", { fields });
  }
  return result.data;
}
