import { deleteApp, initializeApp, type App } from "firebase-admin/app";
import { getFirestore, type Firestore } from "firebase-admin/firestore";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";

import { deleteUserDocuments, ensureUserProfile } from "../../src/users/userProfile";

const PROJECT_ID = "demo-musclecoach";
let app: App;
let db: Firestore;

beforeAll(() => {
  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    throw new Error("Jalankan lewat `npm run test:emulator`.");
  }
  app = initializeApp({ projectId: PROJECT_ID }, "user-profile-test");
  db = getFirestore(app);
});

afterAll(async () => {
  await deleteApp(app);
});

beforeEach(async () => {
  await fetch(
    `http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/${PROJECT_ID}/databases/(default)/documents`,
    { method: "DELETE" },
  );
});

describe("ensureUserProfile", () => {
  it("membuat user, profil, dan entitlement", async () => {
    expect(await ensureUserProfile(db, "alice")).toEqual({ created: true });

    const user = await db.doc("users/alice").get();
    const profile = await db.doc("users/alice/profile/current").get();
    const entitlement = await db.doc("users/alice/entitlement/current").get();
    expect(user.get("schemaVersion")).toBe(1);
    expect(profile.get("unitSystem")).toBe("metric");
    expect(profile.get("displayName")).toBeNull();
    expect(profile.data()).not.toHaveProperty("email");
    expect(entitlement.get("plan")).toBe("free_personal");
  });

  it("idempoten dan tidak menimpa data yang sudah ada", async () => {
    await ensureUserProfile(db, "alice");
    await db.doc("users/alice/profile/current").update({ displayName: "Alice" });

    expect(await ensureUserProfile(db, "alice")).toEqual({ created: false });
    expect((await db.doc("users/alice/profile/current").get()).get("displayName")).toBe("Alice");
  });
});

describe("deleteUserDocuments", () => {
  it("menghapus seluruh data milik pengguna saja", async () => {
    await ensureUserProfile(db, "alice");
    await ensureUserProfile(db, "bob");
    await db.doc("users/alice/bodyMetrics/m1").set({ weightKg: 70 });
    await db.doc("usage/alice").set({ aiCallsToday: 1 });

    await deleteUserDocuments(db, "alice");

    expect((await db.doc("users/alice").get()).exists).toBe(false);
    expect((await db.doc("users/alice/profile/current").get()).exists).toBe(false);
    expect((await db.doc("users/alice/bodyMetrics/m1").get()).exists).toBe(false);
    expect((await db.doc("usage/alice").get()).exists).toBe(false);
    expect((await db.doc("users/bob/profile/current").get()).exists).toBe(true);
  });
});
