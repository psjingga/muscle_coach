import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    projects: [
      { test: { name: "unit", include: ["test/unit/**/*.test.ts"] } },
      {
        // Dijalankan lewat `npm run test:emulator` (butuh Auth & Firestore Emulator).
        test: {
          name: "emulator",
          include: ["test/emulator/**/*.test.ts"],
          fileParallelism: false,
          testTimeout: 20000,
        },
      },
    ],
  },
});
