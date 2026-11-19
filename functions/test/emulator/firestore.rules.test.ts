import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, getDoc, serverTimestamp, setDoc, updateDoc, deleteDoc } from "firebase/firestore";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { afterAll, beforeAll, beforeEach, describe, it } from "vitest";

let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-musclecoach",
    firestore: { rules: readFileSync(resolve(__dirname, "../../../firestore.rules"), "utf8") },
  });
});

afterAll(async () => {
  await env.cleanup();
});

beforeEach(async () => {
  await env.clearFirestore();
  // Data awal ditulis tanpa rules (seperti Cloud Functions/Admin SDK).
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    for (const uid of ["alice", "bob"]) {
      await setDoc(doc(db, `users/${uid}`), { schemaVersion: 1 });
      await setDoc(doc(db, `users/${uid}/profile/current`), {
        displayName: null,
        unitSystem: "metric",
        schemaVersion: 1,
        updatedAt: new Date(0),
      });
      await setDoc(doc(db, `users/${uid}/entitlement/current`), { plan: "free_personal" });
    }
    await setDoc(doc(db, "exerciseCatalog/bench-press"), { status: "published" });
    await setDoc(doc(db, "exerciseCatalog/draft-move"), { status: "draft" });
    await setDoc(doc(db, "appConfig/nutrition"), { version: 1 });
    await setDoc(doc(db, "usage/alice"), { aiCallsToday: 0 });
  });
});

const alice = () => env.authenticatedContext("alice").firestore();
const guest = () => env.unauthenticatedContext().firestore();

describe("users/{uid}", () => {
  it("pemilik boleh membaca dokumennya", async () => {
    await assertSucceeds(getDoc(doc(alice(), "users/alice")));
    await assertSucceeds(getDoc(doc(alice(), "users/alice/profile/current")));
    await assertSucceeds(getDoc(doc(alice(), "users/alice/entitlement/current")));
  });

  it("tidak boleh membaca data pengguna lain", async () => {
    await assertFails(getDoc(doc(alice(), "users/bob")));
    await assertFails(getDoc(doc(alice(), "users/bob/profile/current")));
    await assertFails(getDoc(doc(guest(), "users/alice")));
  });

  it("client tidak boleh membuat/menghapus dokumen user", async () => {
    await assertFails(setDoc(doc(alice(), "users/alice"), { schemaVersion: 1 }));
    await assertFails(deleteDoc(doc(alice(), "users/alice")));
    await assertFails(deleteDoc(doc(alice(), "users/alice/profile/current")));
  });

  it("subkoleksi yang belum diatur ditolak (default deny)", async () => {
    await assertFails(setDoc(doc(alice(), "users/alice/bodyMetrics/m1"), { weightKg: 70 }));
    await assertFails(getDoc(doc(alice(), "users/alice/bodyMetrics/m1")));
  });

  it("entitlement hanya bisa ditulis server", async () => {
    await assertFails(updateDoc(doc(alice(), "users/alice/entitlement/current"), { plan: "pro" }));
  });
});

describe("users/{uid}/profile/current", () => {
  const path = "users/alice/profile/current";

  it("boleh mengubah displayName dengan updatedAt = waktu server", async () => {
    await assertSucceeds(updateDoc(doc(alice(), path), { displayName: "Alice", updatedAt: serverTimestamp() }));
  });

  it("menolak field lain", async () => {
    await assertFails(updateDoc(doc(alice(), path), { unitSystem: "imperial", updatedAt: serverTimestamp() }));
  });

  it("menolak tanpa updatedAt server", async () => {
    await assertFails(updateDoc(doc(alice(), path), { displayName: "Alice" }));
  });

  it("menolak displayName terlalu panjang atau bukan string", async () => {
    await assertFails(updateDoc(doc(alice(), path), { displayName: "x".repeat(41), updatedAt: serverTimestamp() }));
    await assertFails(updateDoc(doc(alice(), path), { displayName: 42, updatedAt: serverTimestamp() }));
  });

  it("tidak boleh mengubah profil orang lain", async () => {
    await assertFails(
      updateDoc(doc(alice(), "users/bob/profile/current"), { displayName: "x", updatedAt: serverTimestamp() }),
    );
  });
});

describe("koleksi global & server-only", () => {
  it("katalog: baca hanya yang published dan hanya saat login", async () => {
    await assertSucceeds(getDoc(doc(alice(), "exerciseCatalog/bench-press")));
    await assertFails(getDoc(doc(alice(), "exerciseCatalog/draft-move")));
    await assertFails(getDoc(doc(guest(), "exerciseCatalog/bench-press")));
    await assertFails(setDoc(doc(alice(), "exerciseCatalog/new"), { status: "published" }));
  });

  it("appConfig: baca saat login, tulis ditolak", async () => {
    await assertSucceeds(getDoc(doc(alice(), "appConfig/nutrition")));
    await assertFails(setDoc(doc(alice(), "appConfig/nutrition"), { version: 2 }));
  });

  it("usage: tertutup untuk client", async () => {
    await assertFails(getDoc(doc(alice(), "usage/alice")));
    await assertFails(setDoc(doc(alice(), "usage/alice"), { aiCallsToday: 0 }));
  });
});

describe("users/{uid}/assessments", () => {
  const draftPath = "users/alice/assessments/draft";
  const draft = (overrides: Record<string, unknown> = {}) => ({
    status: "draft",
    schemaVersion: 1,
    step: 2,
    data: { profile: { heightCm: 175 }, goal: {} },
    updatedAt: serverTimestamp(),
    ...overrides,
  });

  it("pemilik boleh menyimpan, membaca, dan menghapus draft", async () => {
    await assertSucceeds(setDoc(doc(alice(), draftPath), draft()));
    await assertSucceeds(getDoc(doc(alice(), draftPath)));
    await assertSucceeds(setDoc(doc(alice(), draftPath), draft({ step: 6 })));
    await assertSucceeds(deleteDoc(doc(alice(), draftPath)));
  });

  it("menolak draft dengan amplop tidak valid", async () => {
    await assertFails(setDoc(doc(alice(), draftPath), draft({ status: "final" })));
    await assertFails(setDoc(doc(alice(), draftPath), draft({ step: 7 })));
    await assertFails(setDoc(doc(alice(), draftPath), draft({ extra: true })));
    await assertFails(setDoc(doc(alice(), draftPath), draft({ updatedAt: new Date(0) })));
    await assertFails(setDoc(doc(alice(), draftPath), draft({ data: { email: "x@y.z" } })));
  });

  it("client tidak boleh menulis assessment final atau draft orang lain", async () => {
    await assertFails(setDoc(doc(alice(), "users/alice/assessments/a1"), draft()));
    await assertFails(setDoc(doc(alice(), "users/bob/assessments/draft"), draft()));
    await assertFails(getDoc(doc(alice(), "users/bob/assessments/draft")));
  });
});

describe("dokumen hasil server (goal, target nutrisi, consent, peralatan)", () => {
  const paths = [
    "goals/g1",
    "nutritionTargets/t1",
    "consents/assessment_health_data",
    "equipment/current",
  ];

  beforeEach(async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      for (const p of paths) {
        await setDoc(doc(ctx.firestore(), `users/alice/${p}`), { status: "active" });
        await setDoc(doc(ctx.firestore(), `users/bob/${p}`), { status: "active" });
      }
    });
  });

  it("pemilik hanya boleh membaca", async () => {
    for (const p of paths) {
      await assertSucceeds(getDoc(doc(alice(), `users/alice/${p}`)));
      await assertFails(setDoc(doc(alice(), `users/alice/${p}`), { status: "active" }));
      await assertFails(updateDoc(doc(alice(), `users/alice/${p}`), { status: "archived" }));
      await assertFails(deleteDoc(doc(alice(), `users/alice/${p}`)));
    }
  });

  it("tidak boleh membaca milik pengguna lain", async () => {
    for (const p of paths) await assertFails(getDoc(doc(alice(), `users/bob/${p}`)));
  });
});

describe("program & sesi latihan", () => {
  const planned = [
    {
      exerciseId: "goblet_squat",
      name: "Goblet Squat",
      sets: 3,
      repMin: 8,
      repMax: 12,
      repUnit: "reps",
      loadType: "total",
      restSec: 120,
      rirMin: 2,
      rirMax: 3,
      priority: false,
    },
  ];
  const session = (overrides: Record<string, unknown> = {}) => ({
    planId: "p1",
    dayId: "d1",
    date: "2026-11-19",
    weekday: 4,
    focus: "full_body_a",
    status: "in_progress",
    planned,
    startedAt: serverTimestamp(),
    completedAt: null,
    notes: null,
    energy: null,
    discomfort: null,
    schemaVersion: 1,
    updatedAt: serverTimestamp(),
    ...overrides,
  });
  const set = (overrides: Record<string, unknown> = {}) => ({
    exerciseId: "goblet_squat",
    exerciseIndex: 0,
    setNumber: 1,
    weightKg: 16,
    reps: 10,
    rir: 2,
    status: "done",
    loggedAt: serverTimestamp(),
    schemaVersion: 1,
    updatedAt: serverTimestamp(),
    ...overrides,
  });
  const sPath = "users/alice/workoutSessions/s1";

  beforeEach(async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "users/alice/workoutPlans/p1"), { status: "active" });
      await setDoc(doc(ctx.firestore(), "users/alice/workoutPlans/p1/days/d1"), { weekday: 1 });
    });
  });

  it("program hanya bisa dibaca pemilik, tidak bisa ditulis client", async () => {
    await assertSucceeds(getDoc(doc(alice(), "users/alice/workoutPlans/p1")));
    await assertSucceeds(getDoc(doc(alice(), "users/alice/workoutPlans/p1/days/d1")));
    await assertFails(updateDoc(doc(alice(), "users/alice/workoutPlans/p1"), { status: "archived" }));
    await assertFails(setDoc(doc(alice(), "users/alice/workoutPlans/p2"), { status: "active" }));
    await assertFails(getDoc(doc(env.authenticatedContext("bob").firestore(), "users/alice/workoutPlans/p1")));
  });

  it("membuat sesi, mencatat set, lalu menyelesaikan", async () => {
    await assertSucceeds(setDoc(doc(alice(), sPath), session()));
    await assertSucceeds(setDoc(doc(alice(), `${sPath}/sets/a`), set()));
    await assertSucceeds(setDoc(doc(alice(), `${sPath}/sets/b`), set({ setNumber: 2, weightKg: 17.5, rir: null })));
    await assertSucceeds(setDoc(doc(alice(), `${sPath}/sets/c`), set({ setNumber: 3, weightKg: null, status: "skipped", reps: 0 })));
    await assertSucceeds(deleteDoc(doc(alice(), `${sPath}/sets/c`)));
    await assertSucceeds(
      updateDoc(doc(alice(), sPath), {
        status: "completed",
        completedAt: serverTimestamp(),
        energy: 4,
        notes: "Lancar",
        updatedAt: serverTimestamp(),
      }),
    );
  });

  it("menolak sesi tidak valid", async () => {
    await assertFails(setDoc(doc(alice(), sPath), session({ status: "completed" })));
    await assertFails(setDoc(doc(alice(), sPath), session({ date: "19-11-2026" })));
    await assertFails(setDoc(doc(alice(), sPath), session({ planned: [] })));
    await assertFails(setDoc(doc(alice(), sPath), session({ energy: 9 })));
    await assertFails(setDoc(doc(alice(), sPath), session({ extra: 1 })));
    await assertFails(setDoc(doc(alice(), "users/bob/workoutSessions/s1"), session()));
  });

  it("target (planned) tidak boleh diubah dan completedAt harus waktu server", async () => {
    await assertSucceeds(setDoc(doc(alice(), sPath), session()));
    await assertFails(updateDoc(doc(alice(), sPath), { planned: [], updatedAt: serverTimestamp() }));
    await assertFails(
      updateDoc(doc(alice(), sPath), { status: "completed", completedAt: new Date(0), updatedAt: serverTimestamp() }),
    );
  });

  it("menolak set dengan nilai di luar batas", async () => {
    await assertSucceeds(setDoc(doc(alice(), sPath), session()));
    await assertFails(setDoc(doc(alice(), `${sPath}/sets/a`), set({ weightKg: -5 })));
    await assertFails(setDoc(doc(alice(), `${sPath}/sets/a`), set({ reps: 2.5 })));
    await assertFails(setDoc(doc(alice(), `${sPath}/sets/a`), set({ status: "maybe" })));
    await assertFails(setDoc(doc(alice(), `${sPath}/sets/a`), set({ setNumber: 0 })));
    await assertFails(setDoc(doc(alice(), `${sPath}/sets/a`), set({ updatedAt: new Date(0) })));
  });
});
