import { HttpsError } from "firebase-functions/v2/https";
import { describe, expect, it } from "vitest";

import { requireAuth, requireRecentLogin } from "../../src/common/auth";

const now = Date.UTC(2026, 10, 19, 10, 0, 0);
const authAt = (secondsAgo: number) => ({
  uid: "u1",
  token: { auth_time: now / 1000 - secondsAgo },
});

function codeOf(fn: () => unknown): string | undefined {
  try {
    fn();
  } catch (e) {
    return e instanceof HttpsError ? e.code : "not-https-error";
  }
  return undefined;
}

describe("requireAuth", () => {
  it("mengembalikan uid bila login", () => {
    expect(requireAuth({ uid: "u1", token: {} })).toBe("u1");
  });

  it("menolak tanpa auth", () => {
    expect(codeOf(() => requireAuth(undefined))).toBe("unauthenticated");
  });
});

describe("requireRecentLogin", () => {
  it("lolos bila login < 5 menit", () => {
    expect(requireRecentLogin(authAt(60), now)).toBe("u1");
  });

  it("menolak bila login > 5 menit", () => {
    expect(codeOf(() => requireRecentLogin(authAt(301), now))).toBe("failed-precondition");
  });

  it("menolak bila auth_time tidak ada", () => {
    expect(codeOf(() => requireRecentLogin({ uid: "u1", token: {} }, now))).toBe("failed-precondition");
  });

  it("menolak tanpa auth", () => {
    expect(codeOf(() => requireRecentLogin(undefined, now))).toBe("unauthenticated");
  });
});
