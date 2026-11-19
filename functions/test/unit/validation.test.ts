import { HttpsError } from "firebase-functions/v2/https";
import { describe, expect, it } from "vitest";
import { z } from "zod";

import { parsePayload } from "../../src/common/validation";

const schema = z.object({ confirm: z.literal(true) }).strict();

describe("parsePayload", () => {
  it("mengembalikan data valid", () => {
    expect(parsePayload(schema, { confirm: true })).toEqual({ confirm: true });
  });

  it.each([[undefined], [null], [{}], [{ confirm: false }], [{ confirm: true, extra: 1 }]])(
    "menolak %j dengan invalid-argument",
    (input) => {
      let error: unknown;
      try {
        parsePayload(schema, input);
      } catch (e) {
        error = e;
      }
      expect(error).toBeInstanceOf(HttpsError);
      expect((error as HttpsError).code).toBe("invalid-argument");
    },
  );
});
