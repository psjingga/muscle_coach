# IMPLEMENTATION_PLAN — Muscle Coach

> Hasil **Fase 0 (Repository discovery)** sesuai `CLAUDE_Muscle_Coach_Flutter_Gemini-1.md` §17 & §21.
> Disusun: 19 November 2026. Dokumen ini diperbarui setiap kali keputusan/fase berubah.


> ⚠️ **Perubahan arsitektur (19 Nov 2026) — lihat §0.** Aplikasi kini **lokal penuh** (SQLite/drift + Gemini dari aplikasi). Bagian tentang Firebase/Cloud Functions di bawah adalah catatan historis; kodenya diarsipkan di branch `firebase-backend`.

## 0. Arsitektur saat ini: lokal penuh (keputusan 19 Nov 2026)

**Alasan**: pengguna memilih tetap gratis (tanpa paket Blaze). Paket Spark tidak dapat menjalankan Cloud Functions, sedangkan Emulator hanya berjalan selama Mac menyala di jaringan yang sama — tidak dapat dipakai di gym. Untuk MVP pribadi, data disimpan di perangkat.

| Aspek | Sekarang | Sebelumnya (branch `firebase-backend`) |
|---|---|---|
| Data | SQLite via **drift** (`lib/core/database/app_database.dart`), FK cascade, indeks sesi | Firestore + Security Rules |
| Logika inti (kalkulasi target, evaluasi, keselamatan, planner, validator) | **Dart** murni di `features/*/domain/` — porting 1:1 dari TypeScript, test ikut diporting | Cloud Functions TypeScript |
| Katalog latihan | Aset `assets/catalog/exercises.json` (versi `2026-11-v1`, 43 gerakan) | Seed ke `exerciseCatalog` |
| Akun | **Tanpa akun/login**; satu profil per perangkat | Firebase Auth email/password |
| Hapus data | Profil → *Hapus semua data* (seluruh tabel) | `deleteUserData` |
| Gemini (Fase 4) | Dipanggil langsung dari aplikasi; **API key dimasukkan pengguna di Pengaturan & disimpan terenkripsi** (`flutter_secure_storage`), tidak pernah di APK/repo | Cloud Functions + Secret Manager |

**Konsekuensi yang diterima**: tidak ada sinkronisasi/backup otomatis (fitur ekspor/impor backup direncanakan), satu perangkat, validasi bisnis dijalankan di lapisan data aplikasi (repository memvalidasi ulang, bukan hanya UI). Brief §3/§10/§13/§14 tentang backend & Secret Manager **tidak berlaku** untuk arsitektur ini; prinsip keselamatan, validasi output AI, dan minimisasi data tetap berlaku.

**Struktur lapisan tetap**: presentation → application/controller → domain (entity, validator, planner) → data (repository drift/aset). Repository diakses lewat interface sehingga backend server dapat ditambahkan kembali kelak.

**Test** (setelah migrasi): Flutter 99 — domain hasil porting (kalkulator, evaluasi target, keselamatan, katalog, planner, validator), repository drift in-memory (submit/konfirmasi/arsip, program, sesi, cascade, hapus data), wiring provider, widget, controller · E2E di perangkat: onboarding → assessment → target → program → catat set → riwayat → hapus data.

---

## 1. Temuan

### 1.1 Repository
| Hal | Kondisi |
|---|---|
| Isi folder `~/Mobile/Muscle_coach/` | Hanya brief `CLAUDE_Muscle_Coach_Flutter_Gemini-1.md` (kini `CLAUDE.md`) |
| Project Flutter | **Belum ada** |
| Backend / Firebase config (`firebase.json`, `functions/`, rules) | **Belum ada** |
| Git | Belum diinisialisasi |
| Lint, CI, README | Belum ada |

Tidak ada kode atau konfigurasi yang perlu dipertahankan; project dibuat dari nol (greenfield).

### 1.2 Lingkungan pengembangan (Mac ini)
| Alat | Versi / status | Catatan |
|---|---|---|
| fvm | 3.2.1 | Flutter terpasang: 3.35.7 (global), 3.44.0–3.44.9 |
| Flutter stable terbaru | 3.50.0 (Dart 3.14, rilis 11 Nov 2026) — belum terpasang | Masih sangat baru |
| Flutter 3.47.9 | Dart 3.13.7, rilis 29 Okt 2026 — belum terpasang | **Usulan dipakai** (lihat §3.1) |
| Xcode / CocoaPods | 26.0.1 / 1.16.2 | OK untuk iOS |
| Android SDK | platform 28 – 37 | OK |
| Java | OpenJDK 17 (default) + OpenJDK 21 (keg-only, Fase 1) | 17 untuk Gradle; 21 wajib untuk Firebase Emulator (dipakai via `tool/firebase.sh`) |
| Node.js / npm | v25.2.0 / 11.7.0 | Cloud Functions memakai runtime **Node 22** (LTS); v25 lokal cukup untuk tooling, tetapi `engines.node` di `functions/` dikunci ke 22 |
| Firebase CLI (`firebase-tools`) | **Tidak terpasang** | Perlu untuk emulator & deploy (terbaru 15.37.0) |
| FlutterFire CLI | **Tidak terpasang** | Perlu untuk `flutterfire configure` |
| gcloud | Tidak terpasang | Tidak wajib (Secret Manager bisa via `firebase functions:secrets:set`) |

### 1.3 Versi package (dicek di pub.dev / npm, 19 Nov 2026)
| Package | Versi terbaru | Batas SDK Dart |
|---|---|---|
| flutter_riverpod / riverpod_annotation / riverpod_generator | 3.5.0 / 4.0.8 / 4.0.10 | ^3.12 |
| go_router | 18.1.4 | ^3.12 |
| freezed / freezed_annotation | 4.0.3 / 3.1.0 | **freezed 4 butuh Dart ≥ 3.13** |
| json_serializable / build_runner | 6.15.2 / 2.17.1 | ^3.12 / ^3.11 |
| firebase_core / firebase_auth / cloud_firestore / cloud_functions / firebase_app_check | 5.2.0 / 7.1.0 / 7.2.0 / 7.1.0 / 0.5.2 | ^3.12 |
| flutter_local_notifications / timezone / flutter_timezone | 23.0.3 / 0.11.2 / 5.1.1 | ^3.12 |
| flutter_secure_storage / shared_preferences | 11.2.0 / 2.5.6 | — |
| fl_chart / logger / intl | 1.3.1 / 2.8.0 / 0.20.3 | — |
| dio | 5.11.1 | — |
| npm: firebase-functions / firebase-admin / @google/genai / zod | 7.4.0 / 14.5.1 / 3.6.1 / 4.6.7 | firebase-admin & genai butuh Node ≥ 22 |

Versi pasti dikunci saat Fase 1 (`pubspec.lock`, `package-lock.json`).

### 1.4 Inkonsistensi di brief (diselesaikan dengan asumsi)
| Bagian | Isi | Keputusan |
|---|---|---|
| §10 | "Flutter → **NestJS** API → Gemini" | Diabaikan. Alur: **Flutter → Cloud Functions → Gemini** (sesuai §3, §13). |
| §12 | Daftar tabel gaya PostgreSQL (UUID, JSONB, `snake_case`) setelah struktur Firestore | Diabaikan. Hanya struktur Firestore (`camelCase`, ID dokumen Firestore). |
| §13 | Kontrak REST lama | Diabaikan (brief sendiri menyatakan tidak dipakai). |
| §3 | `dio` sebagai HTTP client | Panggilan backend memakai SDK `cloud_functions` (callable), yang otomatis mengirim token Auth & App Check. **`dio` tidak dipasang di MVP**; ditambahkan bila nanti ada API HTTP pihak ketiga. |
| §20 | Pertanyaan yang sudah dijawab di kepala brief | Mengikuti jawaban di kepala brief. |

---

## 2. Asumsi kerja

Mengikuti §19 brief, ditambah:

1. **Bahasa UI** Bahasa Indonesia; teks lewat `intl`/ARB agar kelak bisa ditambah bahasa lain.
2. **Satuan** kg, cm, gram, kcal; hari ISO (1 = Senin … 7 = Minggu); timezone default `Asia/Jakarta`, mengikuti perangkat.
3. **Peralatan:** dumbbell & barbell selalu ada; bench, rack, pull-up bar, resistance band **ditanyakan di assessment** dan hanya dipakai bila dimiliki (§5D).
4. **Lingkungan:** `emulator` (lokal), `dev`, `prod` — dua project Firebase terpisah. *Staging* ditunda karena MVP pribadi; struktur flavor tetap mendukung penambahannya.
5. **Satu akun = satu profil**; tidak ada role admin di aplikasi. Seed katalog dijalankan dari skrip tepercaya (Admin SDK) di `tools/`.
6. **Gemini model** dibaca dari konfigurasi Functions (bukan hardcode); default dipilih saat Fase 4.
7. Belum ada foto progres → **Firebase Storage belum dipakai** di MVP.
8. Analytics/Crashlytics **tidak** dipasang di MVP (§3, privasi).

---

## 3. Arsitektur

### 3.1 Versi & tooling
- **Flutter 3.47.9 (Dart 3.13.7)** dikunci lewat `.fvmrc`. Alasan: patch matang (rilis ke-10 seri 3.47) dan mendukung freezed 4 / Riverpod 3. Flutter 3.50.0 baru 8 hari; bisa naik setelah patch pertamanya.
- Codegen: `build_runner` + `freezed` + `json_serializable` + `riverpod_generator`.
- Lint: `flutter_lints` + aturan tambahan (`avoid_print`, `prefer_final_locals`, dll.) di `analysis_options.yaml`.
- Functions: TypeScript strict, Node 22, `firebase-functions` v2 (`onCall`), validasi `zod`, test `vitest` + Emulator.

### 3.2 Struktur repository
```text
Muscle_coach/
  CLAUDE.md                     # brief produk + instruksi
  IMPLEMENTATION_PLAN.md
  README.md
  .fvmrc
  pubspec.yaml, analysis_options.yaml
  lib/                          # app Flutter (struktur §3 brief)
    main.dart                   # satu entrypoint; lingkungan via --dart-define=APP_ENV
    app/{app.dart, router/, theme/, config/}
    core/{network/, errors/, logging/, storage/, notifications/, utils/, widgets/}
    features/{auth, onboarding, assessment, goals, dashboard, workout,
              exercise_library, nutrition, food_log, progress, check_in,
              ai_coach, profile}/{data, domain, application, presentation}
  test/, integration_test/
  android/, ios/
  firebase.json, .firebaserc
  firestore.rules, firestore.indexes.json
  functions/                    # Cloud Functions (TypeScript)
    src/
      index.ts                  # ekspor function
      common/                   # auth guard, error code, quota, logger
      nutrition/                # BMR/TDEE/makro (deterministik)
      goals/                    # validasi target
      ai/                       # GeminiService, AiCoachService, prompt/, schema/, validator/
      users/                    # createUserProfile, deleteUserData
    test/
  tools/seed/                   # seed exerciseCatalog & foodCatalog (Admin SDK)
  firestore-tests/              # test Security Rules (@firebase/rules-unit-testing)
```

### 3.3 Lapisan Flutter
- `presentation` (screen, widget, Riverpod Notifier) → `application` (use case) → `domain` (entity freezed, kontrak repository, aturan bisnis murni) ← `data` (DTO, datasource Firestore/Functions, repository impl, mapper).
- Widget tidak memanggil Firestore/Functions/plugin langsung; kalkulasi tidak di widget.
- `core/network/functions_client.dart`: pembungkus `FirebaseFunctions.httpsCallable` → memetakan `FirebaseFunctionsException` ke `AppFailure` (kode stabil).
- `core/errors/`: `AppFailure` sealed class (network, unauthenticated, permissionDenied, validation, quotaExceeded, aiUnavailable, unknown).
- `core/logging/`: `logger` dengan filter — **tanpa** isi data kesehatan/makanan di log.
- Router `go_router` dengan redirect berbasis status: belum login → auth; belum assessment → wizard; belum ada goal terkonfirmasi → goal; selain itu → shell 5 tab (Home, Workout, Nutrition, Progress, Profile).

### 3.4 Backend (Cloud Functions)
| Function | Tipe | Fase |
|---|---|---|
| `createUserProfile` | callable idempoten, dipanggil app setelah daftar/login (tanpa race seperti trigger `onCreate`, tanpa syarat Identity Platform seperti blocking function) | 1 |
| `calculateNutritionTargets` | callable | 2 |
| `confirmGoal` (validasi target + simpan) | callable | 2 |
| `generateWorkoutPlan`, `activateWorkoutPlan` | callable | 4 |
| `generateDailyWorkout`, `suggestExerciseAlternative` | callable | 4 |
| `generateMealPlan` | callable | 5 |
| `generateWeeklyReview` | callable | 6 |
| `deleteUserData` | callable | 1 (kerangka) / 7 (lengkap) |

Setiap callable: cek `request.auth`, `enforceAppCheck` (prod), validasi `zod`, cek ownership ID, kuota per UID, error code stabil (`invalid-argument`, `failed-precondition`, `resource-exhausted`, `unavailable`, …), tanpa stack trace ke client.

**Kalkulasi baseline (Fase 2, deterministik, dapat dikonfigurasi di `functions/src/nutrition/config.ts`):**
- BMR Mifflin–St Jeor: pria `10W + 6.25H − 5A + 5`, wanita `… − 161`. Bila jenis kelamin tidak diisi → hitung keduanya dan tampilkan **rentang** (tidak memilih salah satu diam-diam).
- TDEE = BMR × faktor aktivitas (default 1.2 / 1.375 / 1.55 / 1.725).
- Muscle gain: surplus konservatif (default +5–10 % TDEE); recomposition: sekitar maintenance.
- Protein (default 1.6–2.2 g/kg), lemak (default ≥ 0.6 g/kg dan 20–35 % energi), karbohidrat = sisa energi. Total kcal dihitung ulang dari makro (4/4/9).
- Batas laju kenaikan berat (default ≤ 0.5 % BB/minggu, lebih rendah untuk yang berpengalaman) dipakai untuk menilai realistis-tidaknya target.
- Semua angka default di atas **perlu ditinjau** terhadap rujukan kredibel sebelum rilis (lihat §5).

**Integrasi Gemini (Fase 4):** `@google/genai`, secret `GEMINI_API_KEY` via `defineSecret`, structured output (JSON schema) + validasi `zod` + validator domain (exercise ID ada di katalog, alat sesuai assessment, set/reps/rest dalam batas, tidak melanggar batasan cedera). Maks. 1 retry terkontrol. Prompt berversi di `functions/src/ai/prompts/` (`workout_plan.v1.ts`, …). Log ke `aiGenerationLogs` (model ID, versi prompt, durasi, status, token — tanpa data pribadi mentah).

### 3.5 Model data Firestore
Mengikuti §12 brief, ditambah:
```text
users/{uid}
  profile/current
  settings/notifications
  assessments/{id}            # draft & final, schemaVersion
  goals/{id}                  # status draft/active/archived
  equipment/current
  workoutPlans/{id}
    days/{dayId}              # subkoleksi agar dokumen plan tetap kecil
  workoutSessions/{id}
    sets/{setId}              # log set aktual (planned disalin terpisah)
  nutritionTargets/{id}
  mealPlans/{id}
  foodLogs/{id}               # field `date` (YYYY-MM-DD lokal) untuk query harian
  bodyMetrics/{id}
  dailyCheckIns/{yyyy-mm-dd}  # ID = tanggal lokal → satu per hari
  weeklyReviews/{isoWeek}
  consents/{id}
  aiGenerationLogs/{id}       # read-only client
  entitlement/current         # placeholder subscription, read-only client
usage/{uid}                   # kuota AI, hanya server
exerciseCatalog/{id}          # read-only client
foodCatalog/{id}              # read-only client
appConfig/{id}                # konfigurasi non-secret, read-only client
```
**Hak tulis client vs server:**
- Client boleh tulis (dengan validasi field di rules): `profile`, `settings`, `assessments` (draft), `equipment`, `workoutSessions` + `sets`, `foodLogs`, `bodyMetrics`, `dailyCheckIns`, `consents`.
- Hanya server (client baca saja): `goals` aktif, `nutritionTargets`, `workoutPlans`, `mealPlans`, `weeklyReviews`, `aiGenerationLogs`, `entitlement`, `usage`.

Field standar: `createdAt`, `updatedAt` (serverTimestamp), `schemaVersion`, `source` (`user_input` | `calculated` | `ai_generated` | `curated_database`), unit eksplisit pada nama/field.

### 3.6 Notifikasi lokal
`core/notifications/NotificationService` (abstraksi plugin) + use case `ReconcileReminders` yang membangun ulang jadwal dari `settings/notifications` + workout plan aktif. ID deterministik = hash stabil `kategori + entity + tanggal`. Rekonsiliasi saat login, app resume, perubahan preferensi/plan; cancel per sesi saat sesi selesai; cancel semua saat logout. Android: channel per kategori, `POST_NOTIFICATIONS`, inexact scheduling (tanpa exact-alarm). iOS: batas 64 pending → jadwalkan ±14 hari ke depan, prioritas terdekat.

### 3.7 Entitlement
`EntitlementRepository` (domain) dengan implementasi MVP yang membaca `users/{uid}/entitlement/current` (default `free_personal`, semua fitur aktif). Fitur memanggil `canUse(Feature)` — tanpa pembayaran.

---

## 4. Urutan kerja

| Fase | Isi | Output yang dapat diuji |
|---|---|---|
| **0** | Discovery & rencana (dokumen ini) | `IMPLEMENTATION_PLAN.md` |
| **1 — Foundation** | `git init`; pasang Flutter 3.47.9 (fvm), `firebase-tools`, FlutterFire CLI; `flutter create` (Android+iOS); struktur folder; Riverpod, go_router, theme light/dark, `AppFailure`, logger, flavor `dev`/`prod`; Firebase init (Auth, Firestore, Functions, Emulator); `firestore.rules` default-deny + test rules; `functions/` TS skeleton + `createUserProfile`; auth flow (register, login, logout, reset password, verifikasi email); shell 5 tab kosong; `README.md` | App jalan di emulator Android/iOS terhubung Firebase Emulator; register/login berfungsi; `flutter analyze`, `flutter test`, `npm test` (functions + rules) hijau |
| **2 — Assessment & goal** | Wizard 7 langkah + draft; consent; kalkulasi BMR/TDEE/makro + validasi target di Functions (unit test); layar goal confirmation dengan asumsi | Assessment selesai → target & makro tampil dengan penjelasan |
| **3 — Katalog & workout logging** | Seed katalog dumbbell/barbell (~40 gerakan); jadwal & detail sesi; log set/reps/beban/RIR; timer istirahat; planned vs actual | Program contoh manual dapat dicatat |
| **4 — Gemini workout** | GeminiService, prompt v1, schema, validator, kuota; generate → draft → setuju → aktif; notifikasi sesi latihan | Program AI tervalidasi & aktif setelah disetujui |
| **5 — Nutrition** | Target harian; `foodCatalog` (sumber terlisensi); food log; meal plan AI + hitung ulang total; notifikasi makan | Food log & sisa target harian |
| **6 — Progress & review** | Grafik berat/beban/volume/kepatuhan; check-in harian & mingguan; weekly review AI; usulan penyesuaian dengan persetujuan; notifikasi timbang & check-in | Weekly review dari data nyata |
| **7 — Hardening** | Lengkapi test; audit keamanan/privasi; offline/error states; uji perangkat Android & iOS; App Check prod; dokumentasi deploy; `deleteUserData` lengkap | Checklist acceptance §16 brief |

Setiap fase diakhiri: `dart format`, `flutter analyze`, test, ringkasan perubahan, perintah menjalankan — lalu menunggu evaluasi.

---

## 5. Risiko

| Risiko | Dampak | Mitigasi |
|---|---|---|
| **Cloud Functions & Secret Manager membutuhkan paket Blaze** (bayar sesuai pemakaian) | Tidak bisa deploy Functions di paket Spark | Pengembangan Fase 1–3 sepenuhnya di Emulator; aktifkan Blaze + **budget alert** sebelum deploy |
| Biaya Gemini tak terduga | Tagihan | Kuota per UID per hari (`usage/{uid}`), batas ukuran input/output, model murah sebagai default |
| Sumber data gizi Indonesia & lisensinya belum jelas (mis. TKPI Kemenkes) | Katalog makanan tidak bisa diisi secara sah | Abstraksi `FoodDataSource`; input manual + label "estimasi" sampai sumber diputuskan (Fase 5) |
| Angka default kalori/makro/laju kenaikan | Rekomendasi kurang tepat | Semua dapat dikonfigurasi; ditandai "estimasi"; tinjau rujukan sebelum rilis |
| Kualitas/keamanan output AI | Program tidak aman | Katalog tertutup, validator domain, persetujuan pengguna, fallback aman |
| Notifikasi ditunda/dimatikan OS (Android OEM agresif, batas iOS 64) | Pengingat tidak muncul | Inexact scheduling, rekonsiliasi saat app dibuka, UX izin & panduan pengaturan baterai; tidak menjanjikan tepat waktu |
| Data kesehatan = data pribadi spesifik (UU PDP No. 27/2022) | Kewajiban privasi | Minimalisasi data, consent eksplisit, rules ketat per UID, tanpa log data sensitif, fitur hapus data |
| Biaya baca Firestore dari listener | Biaya | Query terbatas + pagination; listener hanya untuk layar aktif |
| Flutter 3.50 / package sangat baru | Bug regresi | Kunci 3.47.9 dan versi package via lockfile |

---

## 6. Status Fase 1 — Foundation (selesai 19 Nov 2026)

**Hasil**
- Project Flutter `musclecoach` (Android `com.panjijingga.musclecoach`, iOS sama; minSdk 24, iOS 15), Flutter 3.47.9 via `.fvmrc`.
- Struktur feature-first; Riverpod 3 (codegen), go_router 18 (redirect berbasis status login, shell 5 tab), tema light/dark + `Brand`, `AppFailure` + `FailureMapper`, `FunctionsClient`, logger, teks Bahasa Indonesia via ARB.
- Lingkungan `emulator`/`dev`/`prod` via `APP_ENV`; Firebase Emulator Suite (Auth 9099, Firestore 8080, Functions 5001, UI 4000) dengan project `demo-musclecoach`.
- Auth: daftar (kirim verifikasi email), masuk, lupa kata sandi, status verifikasi + kirim ulang, keluar, **hapus akun & semua data** (login ulang → `deleteUserData`).
- Cloud Functions TS (Node 22, region `asia-southeast2`): `createUserProfile` (idempoten), `deleteUserData` (wajib login < 5 menit, payload `{confirm:true}`).
- `firestore.rules` default-deny + validasi field profil; katalog global hanya baca dokumen `published`; `usage` & `entitlement` khusus server.
- `tool/check.sh` (quality gate lokal), `tool/firebase.sh` (Firebase CLI + JDK 21), README.

**Test**: Flutter 25 (validator, mapper, redirect, controller, widget login) · Functions unit 12 · Emulator 16 (rules + profil/hapus data). `flutter analyze` bersih. Build APK debug & iOS simulator berhasil.

**Penyesuaian terhadap rencana awal**
- Satu `main.dart` + `APP_ENV`, bukan `main_dev/main_prod`. *Native flavor* (sufiks `.dev`) ditunda sampai project Firebase dev/prod dibuat, karena konfigurasinya bergantung pada file `flutterfire configure`.
- `flutter_secure_storage` belum dipasang: token sesi disimpan aman oleh Firebase Auth SDK sendiri; dipasang bila nanti ada secret lain di perangkat.
- App Check belum aktif (tidak bisa diuji di Emulator) — diaktifkan saat project nyata dibuat (Fase 7 / sebelum deploy).
- CI cloud belum ada (repo belum punya remote); `tool/check.sh` siap dipakai di CI.

**Belum dikerjakan (sesuai rencana)**: onboarding/assessment & gerbang redirect-nya (Fase 2), notifikasi lokal (Fase 4–6), App Check, project Firebase nyata.

## 6b. Status Fase 2 — Assessment & goal (selesai 19 Nov 2026)

**Alur**: daftar/login → gerbang onboarding (router) → layar onboarding → wizard 7 langkah (A–G brief §5) → `submitAssessment` → ringkasan target → `confirmGoal` → Home menampilkan target nutrisi & goal aktif. Profil: lihat target aktif / ulangi assessment.

**Backend (Cloud Functions)**
- `submitAssessment` (callable): validasi penuh zod (`functions/src/assessment/schema.ts`, `.strict()`, batas angka, consent `2026-11-v1` wajib), usia 16–90. Menyimpan `assessments/{id}` (final), `consents/assessment_health_data`, `equipment/current`, usulan `goals/{id}` (`proposed`, usulan lama dihapus), `profile.latestAssessmentId`; draft dihapus. Isi assessment tidak di-log.
- `confirmGoal` (callable, transaksi): hanya `proposed`, tidak `safety.stop`, verdict `realistic`, peringatan wajib di-*acknowledge*. Mengarsipkan goal & target nutrisi aktif lama, membuat `nutritionTargets/{id}` aktif, menandai `profile.onboardingCompleted`.
- Kalkulasi murni & dapat dikonfigurasi (`functions/src/nutrition/config.ts`, versi `2026-11-v1`): Mifflin–St Jeor; TDEE = BMR × 1,2/1,375/1,55/1,725; surplus 10/7,5/5 % (muscle gain pemula/menengah/lanjut), 5 % strength, 0 % recomposition, maks. 5 % bila mode konservatif; protein 1,8 g/kg (2,0 recomposition; berat acuan BMI 25 bila BMI > 30); lemak 0,8 g/kg dibatasi 20–35 % energi & ≥ 0,6 g/kg; karbohidrat = sisa; makro dibulatkan 5 g, kcal dihitung ulang 4/4/9. Jenis kelamin tidak diisi → rentang BMR/TDEE/energi, makro di titik tengah.
- Evaluasi target: batas laju 0,5/0,35/0,25 % BB per minggu (0,25 % bila konservatif); muscle gain/strength dengan target < berat sekarang dan recomposition dengan perubahan > 3 % BB → `needs_adjustment` + saran minggu/target. Target tidak realistis **tidak bisa dikonfirmasi**.
- Keselamatan: gejala bahaya (nyeri dada, pingsan, sesak, cedera akut) → `stop` (arahkan ke tenaga medis, 119/112; tidak ada target aktif). Hamil, penyakit kronis, riwayat gangguan makan, pemulihan cedera, obat, usia < 18, BMI < 18,5 → peringatan + mode konservatif; BMI ≥ 35 → peringatan.

**Firestore rules**: client hanya boleh menulis `assessments/draft` (amplop divalidasi: status, schemaVersion, step 0–6, `data` hanya 7 bagian, `updatedAt` = waktu server). `goals`, `nutritionTargets`, `consents`, `equipment` baca-saja milik sendiri.

**Flutter**: `features/assessment` (model freezed draft-friendly, `AssessmentValidator` terpusat sinkron dengan server, repository Firestore+Functions, controller wizard: muat draft → atau isi ulang dari assessment terakhir, simpan draft tiap "Lanjut" tanpa menunggu server/offline-friendly), `features/goals` (entity, repository, layar ringkasan & konfirmasi dengan asumsi perhitungan dan peringatan), `features/onboarding`, `features/profile` (stream profil + status onboarding). Router: `authRedirect` kini memperhitungkan status onboarding.

**Test**: Functions unit 40 (kalkulator, evaluasi target, keselamatan, skema) · Emulator 29 (rules + submit/confirm: arsip goal lama, tolak target tidak realistis/gejala bahaya/konfirmasi ganda/tanpa acknowledgement, goal milik orang lain) · Flutter 56 (validator, payload JSON, entity goal, redirect onboarding, controller wizard, widget wizard & ringkasan target) · E2E integration (daftar → assessment → konfirmasi → Home → keluar/masuk → hapus akun).

**Asumsi/keputusan Fase 2** (dapat diubah):
- Usia 16–90 tahun; < 18 diberi peringatan & mode konservatif.
- Target waktu dalam minggu (4–104), tanggal target ditampilkan.
- Kondisi medis hanya berupa centang (tanpa teks diagnosis) — minimisasi data.
- Lokasi makanan tetap Indonesia (pilihan negara lain menyusul bila dibutuhkan).
- Draft assessment satu per pengguna (`assessments/draft`).
- `calculateNutritionTargets` dari brief §13 diwujudkan sebagai bagian `submitAssessment` (kalkulasi selalu di server bersama evaluasi target).

**Belum**: pengubahan target dari check-in berkala (Fase 6), layar pengaturan consent/privasi tersendiri (Fase 7).

## 6c. Status Fase 3 — Katalog & pencatatan latihan (selesai 19 Nov 2026)

**Alur**: tab Latihan → *Buat program awal* (`createStarterPlan`) → pratinjau draft (peringatan, target per latihan, aturan progresi, penjelasan RIR) → *Aktifkan program* (`activateWorkoutPlan`, konfirmasi bila mengganti program aktif) → jadwal mingguan (penanda hari ini) → detail hari (pemanasan/pendinginan) → *Mulai sesi* → catat set (beban, repetisi/detik, RIR opsional, lewati, hapus) + timer istirahat (+15 dtk/selesai) → *Selesaikan sesi* (energi, nyeri, catatan) → Riwayat (target vs aktual). Home menampilkan latihan hari ini/berikutnya. Katalog latihan dapat dicari; detail berisi cara melakukan, kesalahan umum, keselamatan, alternatif, peringatan spotter.

**Backend**
- Katalog terkurasi 43 gerakan (`functions/src/catalog/exercises.ts`, versi `2026-11-v1`): dumbbell/barbell + push-up, pull-up/chin-up, plank, dead bug. Field: otot utama/pendukung, pola gerak, alat wajib, level minimum, satuan (repetisi/detik), tipe beban (per tangan/total/berat badan), instruksi, kesalahan, keselamatan, spotter, alternatif. Di-seed ke `exerciseCatalog` (`status: published`); latihan yang dihapus → `retired`. Emulator: seed otomatis saat Functions dimuat; project nyata: `node lib/catalog/seedCli.js`.
- Planner berbasis aturan (`functions/src/workout/templatePlanner.ts`, deterministik): hari maks. 4/5/6 (pemula/menengah/lanjut), utamakan hari tidak berurutan; ≤ 3 hari tanpa hari berurutan → full body A/B/C, selain itu upper/lower. Slot gerak dengan daftar kandidat → dipilih yang alat & levelnya cocok (tidak menganggap ada bench/rack). Set 3/2 (compound/isolasi pemula), +1 untuk otot prioritas (maks. 5); repetisi 8–12 / 6–10 / 10–15; istirahat 150/120/75/60 dtk; RIR 2–3 / 1–3 / 1–2 (tidak sampai gagal). Jumlah latihan disesuaikan durasi sesi (min. 3).
- Validator rencana (`functions/src/workout/plan.ts`) — dipakai ulang untuk output Gemini di Fase 4: latihan harus ada di katalog, alat tersedia, level sesuai, angka dalam batas, tanpa duplikat; peringatan untuk spotter dan otot sama di hari berurutan.
- Peringatan program: cedera/gerakan dihindari, hari dikurangi, alat terbatas, spotter.

**Data & rules**: `workoutPlans/{id}` + `days/{dayId}` ditulis server (baca-saja). `workoutSessions/{id}` ditulis aplikasi: `planned` = salinan target (tidak bisa diubah), `completedAt` = waktu server; hasil aktual di `sets/{setId}` (beban 0–1000 kg, repetisi 0–300, RIR 0–10, status done/skipped). Indeks komposit: riwayat (`status`, `date`) & sesi terakhir per hari program (`planId`, `dayId`, `status`, `date`). Penulisan set tidak menunggu server (sinyal gym lemah; tersinkron otomatis).

**Test**: Functions unit 58 (+18: katalog, pemilihan hari/split, planner, validator) · Emulator 38 (+9: rules program/sesi/set, create/activate plan, seed) · Flutter 75 (+19: volume, progresi ganda, validasi set, hari berikutnya, timer istirahat, pencatat set, widget tab/pratinjau/sesi) · E2E diperluas sampai program aktif → catat set → riwayat.

**Ditunda**: ganti latihan di tengah sesi (butuh validasi alat/keselamatan bersama Fase 4), pengingat sesi (notifikasi lokal), grafik per gerakan (Fase 6).

## 6d. Status Fase 4 — Program latihan dari Gemini (selesai 19 Nov 2026, arsitektur lokal)

**Alur**: Profil → *AI Coach (Gemini)*: tempel API key → *Simpan & uji* (diverifikasi ke API, disimpan terenkripsi di Android Keystore/iOS Keychain; UI hanya menampilkan 4 karakter terakhir) → pilih model → setujui pemrosesan data (daftar data yang dikirim & tidak dikirim, catatan tier gratis). Tab Latihan → *Susun dengan AI* (atau dari program aktif: *Buat ulang program* → AI/template) → dialog progres → draft dengan badge **"Estimasi AI · model"**, alasan program & per gerakan → *Aktifkan program* (konfirmasi bila mengganti). Gagal → pesan jelas + *Coba lagi* / *Pakai template* / *Buka pengaturan AI*. *Hapus semua data* juga menghapus key.

**Komponen** (`lib/features/ai_coach/`)
- `GeminiClient` (dio, REST `generateContent`, key di header `x-goog-api-key`, tidak pernah di URL/log; timeout 120 dtk; bagian *thought* diabaikan; error HTTP → `AppFailure` stabil: key tidak valid, izin, kuota 429, 5xx, timeout, jaringan).
- Prompt berversi `workout_plan.v1` (`domain/prompts/`): instruksi sistem (draft edukatif, hanya ID katalog, hari & durasi tersedia, volume konservatif, RIR pemula ≥ 2, hindari otot sama di hari berurutan, patuhi cedera, JSON saja) + **structured output** (`responseSchema`, `exerciseId` dibatasi `enum` katalog yang lolos filter alat & level).
- **Minimisasi data**: dikirim tujuan, level/pengalaman, hari & durasi, alat & beban maks., otot prioritas, preferensi, catatan cedera/gerakan dihindari, mode konservatif (boolean). Tidak dikirim: nama, umur/tanggal lahir, tinggi/berat, jenis kelamin, jenis kondisi medis, data makan.
- `AiPlanParser`: JSON → `PlanDraft`; nama/satuan/tipe beban dari katalog; tolak hari di luar ketersediaan, > maks. hari per level, < 3 gerakan, sesi > 115 % durasi, pemula RIR < 2, plus seluruh `PlanValidator` (katalog, alat, level, batas angka, duplikat).
- `AiPlanService`: cek key → persetujuan → kuota lokal 10/hari → prompt → panggil → validasi → **maks. 1 retry** dengan daftar masalah → simpan sebagai **draft** (`source: ai_generated`, versi prompt, model). Gagal 2× → tidak ada yang disimpan; tersedia fallback template.
- Log generasi (`ai_generation_logs`): model & versi, versi prompt, status, percobaan, durasi, token, kode error — **tanpa** isi prompt/data pengguna.
- Basis data v2 (migrasi otomatis dari v1: kolom `rationale`/`model` di program + tabel log) — terverifikasi di Realme (DB v1 dari instalasi sebelumnya).

**Uji live** (`test/live`, hanya dengan `--tags live` + env `GEMINI_API_KEY`): `gemini-3.5-flash-lite` valid 4/4 (pemula 3 hari & menengah 4 hari dengan cedera bahu → AI menghindari overhead press), 5–12 dtk. `gemini-3.5-flash` (thinking) 35 dtk s.d. timeout 120 dtk / 503 → default diganti ke flash-lite; `gemini-2.5-flash` 404 untuk key ini.

**Test**: Flutter 116 (+17: client Gemini, minimisasi prompt, parser/validator, service retry/kuota/consent/log, widget pengaturan & badge AI) · E2E di Realme RMX1971 **lolos** termasuk penyusunan program oleh Gemini sungguhan, aktivasi, lalu hapus data.

**Belum/ditunda**: notifikasi pengingat sesi (dipindah ke fase notifikasi tersendiri), ganti gerakan di tengah sesi dengan validasi, AI untuk menu makan (Fase 5) & weekly review (Fase 6).

## 6e. Status — Pengingat lewat notifikasi lokal (selesai 19 Nov 2026)

**Alur**: Profil → *Pengingat* → saklar utama → dialog penjelasan + **contoh jadwal** (sebelum izin sistem diminta; izin tidak pernah diminta saat aplikasi dibuka) → izin ditolak → tidak dianggap aktif, panduan + *Buka pengaturan sistem*. Atur per kategori: **sesi latihan** (hari dari program aktif, jam pilihan), **makan** (sarapan/siang/malam/snack), **timbang** (hari & jam), **check-in harian**, **jam tenang**. Tampil jumlah jadwal 14 hari, zona waktu, *Kirim notifikasi uji*, saran pengaturan baterai. Ketuk notifikasi → layar terkait (detail hari latihan, Nutrisi, Progres, Beranda); Android: aksi **Tunda 10 menit** (berjalan di latar belakang).

**Desain** (brief §15)
- `core/notifications/NotificationService` (abstraksi) + `LocalNotificationService` (flutter_local_notifications 23, timezone, flutter_timezone). UI tidak memanggil plugin langsung.
- Preferensi = sumber kebenaran, disimpan di `app_settings` (JSON, basis data v3); bentuk mengikuti contoh brief (ISO 1=Senin…7=Minggu, `HH:mm`), divalidasi di domain. Jadwal OS selalu dibangun ulang.
- `ReminderPlanner` (murni): 14 hari ke depan, **maks. 60** (batas iOS 64, prioritas terdekat), **ID stabil** FNV-1a 31-bit dari kategori + entitas + tanggal → penjadwalan ulang menimpa, tanpa duplikat; jam di jam tenang dilewati; hari yang sesinya sudah selesai tidak diingatkan; aritmetika kalender aman DST.
- `ReminderScheduler.reconcile()`: batalkan ID tertunda yang tidak diinginkan → jadwalkan yang diinginkan. Dipicu saat aplikasi dibuka & kembali aktif (zona waktu bisa berubah), preferensi berubah, program aktif berubah, sesi selesai; *Hapus semua data* → batalkan semua.
- Android: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED` + receiver boot/package-replaced (jadwal pulih setelah reboot/update), channel per kategori, **jadwal tidak presisi** (`inexactAllowWhileIdle`, tanpa izin exact alarm). compileSdk 37 & AGP 9.1.1 (syarat plugin; targetSdk tidak berubah). iOS: delegate `UNUserNotificationCenter` (tampil di foreground), izin diminta dari layar pengaturan.

**Verifikasi di Realme RMX1971**: E2E mengaktifkan pengingat → layar "60 pengingat terjadwal"; `adb dumpsys alarm` menunjukkan alarm aplikasi (mis. makan malam 19:00, check-in 21:00, sarapan besok 07:00 dengan jendela tidak presisi); notifikasi uji tampil; 5 channel terbuat; setelah *Hapus semua data* alarm aplikasi = 0.

**Test**: Flutter 135 (+19: planner — hari program, sesi selesai, jam lewat, ID stabil, ganti program, jam tenang lintas tengah malam, hari timbang, batas 60, DST Eropa; validasi preferensi; rekonsiliasi — tanpa duplikat, sesi selesai hanya membatalkan pengingat sesi itu, ganti program tanpa sisa, izin ditolak; widget izin & penjelasan).

**Catatan/keterbatasan**: aksi *Tunda* hanya Android (iOS: ketuk membuka aplikasi). Notifikasi bisa tertunda oleh optimasi baterai OEM (tidak dijanjikan tepat waktu). Tujuan "Nutrisi/Progres/check-in" masih layar placeholder sampai Fase 5–6. "Mark as done" ditunda sampai fitur check-in ada.

## 6f. Status — Ilustrasi gerakan & peta otot (selesai 20 Nov 2026)

**Foto gerakan**: 42 dari 43 latihan punya 2 foto fase gerakan (urutan sumber tidak selalu awal → akhir, jadi label di UI netral "1/2") dari [Free Exercise DB](https://github.com/yuhonas/free-exercise-db) (Unlicense / domain publik; turunan dari wrkout/exercises.json yang juga Unlicense). Pemetaan ID dicek manual per gerakan (lihat contact sheet saat implementasi); beberapa memakai variasi terdekat (mis. *Dumbbell Glute Bridge* → bridge tanpa beban, *Rear Delt Fly* → versi duduk, *Farmer Carry* → farmer handle). `dumbbell_single_leg_rdl` sengaja tanpa foto (hanya ada versi kettlebell). Foto diperkecil ke 480 px JPEG q65 → ±1,5 MB total, dibundel di `assets/exercises/` (offline). Atribusi ditampilkan di bawah foto.

**Peta otot**: `MuscleMap` (CustomPainter, tanpa aset) — figur depan & belakang, otot utama = warna primer, pendukung = primer transparan; mendukung dark mode; label aksesibilitas berisi daftar otot.

**UI**: detail latihan (2 foto bergantian otomatis tiap 1,4 dtk seperti animasi + tombol jeda; diam bila animasi sistem dimatikan) + peta otot; daftar katalog & kartu sesi menampilkan thumbnail → ketuk = *tampilan cepat* (bottom sheet: gerakan, peta otot, langkah) tanpa meninggalkan sesi. Latihan tanpa foto memakai peta otot sebagai thumbnail.

**Data**: field `images` (opsional) di `Exercise`/katalog; versi katalog tidak diubah (isi untuk AI tidak berubah).

**Test**: Flutter 143 (+8: semua foto yang dirujuk ada & berpasangan, tidak ada file yatim, semua kode otot katalog tergambar, pewarnaan, animasi/jeda, animasi dimatikan, tanpa foto, tampilan cepat).

## 6g. Status — Logo & ikon aplikasi (selesai 20 Nov 2026)

Konsep "dumbbell di atas grafik naik" (dipilih pengguna dari 3 konsep). Sumber tunggal vektor `AppLogoPainter` (lapisan full/latar/depan/monokrom); `tool/app_icon/generate.sh` merender: ikon iOS (semua ukuran Contents.json, tanpa alpha), Android lama + adaptif (latar gradien, gambar depan di zona aman 66%) + monokrom (ikon bertema Android 13+), ikon kecil notifikasi `@drawable/ic_notification` (siluet putih), dan LaunchImage iOS. Logo yang sama dipakai di splash & onboarding. Tanpa package tambahan.

Juga dari uji E2E iOS (20 Nov): peringatan "izin ditolak" tidak lagi tampil sebelum izin diminta (iOS & Android 13+ tidak membedakan belum-ditanya vs ditolak); saran optimasi baterai hanya di Android; label foto netral "1/2"; label peta otot sejajar figur. E2E iOS lolos penuh (ketuk "Allow" dialog izin dilakukan manual).

## 6h. Status — Fase 5 Nutrisi (20 Nov 2026)

**Sumber data (keputusan pengguna: TKPI)**: Tabel Komposisi Pangan Indonesia (Kemenkes RI, panganku.org). Dipakai snapshot CSV 1.146 baris dari rilis `nichsedge/indoscraping` `dataset-panganku-latest` (28 Okt 2026), disalin ke `tool/food_catalog/source/panganku.csv` (sha256 dicatat).
- `tool/food_catalog/build_tkpi_catalog.py` → `assets/catalog/foods_tkpi.json` (versi `tkpi-panganku-2026-10-28`) berisi 1.144 makanan per 100 g BDD: kode TKPI, kategori, mentah/olahan, asal daerah, keterangan, serat, dan % BDD.
- Angka tidak diubah dan tidak ditebak. 2 baris tanpa makro lengkap dilewati. 16 baris yang energinya tidak konsisten dengan 4/4/9 diberi `quality: inconsistent` (tampil "cek data" dan tidak ditawarkan ke AI).
- Cek acak cocok dengan TKPI (mis. Nasi AP001 180 kcal, P 3, L 0,3, K 39,8).
- Ukuran rumah tangga (URT) tidak dikarang. Porsi diisi dalam gram, dengan pilihan cepat 50/100/150/200 g, gram terakhir dicatat, dan porsi dari label.
- Lisensi: publikasi pemerintah tanpa lisensi terbuka eksplisit. Untuk penggunaan pribadi dipakai dengan atribusi di aplikasi. Perlu ditinjau sebelum rilis publik.

**Arsitektur**:
- `FoodDataSource` (abstraksi; implementasi `TkpiAssetFoodDataSource`).
- `NutritionRepository` (drift, DB v4 dengan tabel baru `custom_foods`, `food_logs` (indeks tanggal & makanan), dan `meal_plans`).
- Domain murni: `Nutrients`, `FoodSearch`, `DayNutrition`, `MealPlanCandidates`, `MealPlanValidator`.

**Food log**:
- Sumber catatan: katalog, makanan dari label (`user_label`), atau kalori/makro manual (`manual`). Nilai gizi disalin saat dicatat.
- Porsi dan waktu makan bisa diubah (dihitung ulang dari katalog), dan catatan bisa dihapus.
- Ringkasan harian vs target dan sisa tampil di tab Nutrisi dan Home. Label estimasi muncul bila ada catatan non-sumber.
- Ada pengingat minum air sebagai kebiasaan umum, tanpa angka anjuran.

**Menu AI** (`meal_plan.v1`):
- Kandidat bahan disaring deterministik sebelum dikirim: pola makan (vegetarian/vegan per kategori + kata kunci nama), alergi & tidak disukai (frasa nama), produk bayi, dan data tidak konsisten. AI hanya mengembalikan `code` + `grams`.
- Validator menolak:
  - kode di luar daftar;
  - gram di luar 5–600;
  - bahan yang dihindari;
  - jumlah/slot waktu makan yang salah;
  - total di luar batas: kcal ±10 %, protein 90–130 %, lemak/karbo ±30 %.
- Total **dihitung aplikasi**. Retry maks. 1 dengan umpan balik berisi angka hitungan aplikasi. Hasil disimpan sebagai draft, ditinjau, lalu "Pakai".
- Peringatan ditampilkan untuk riwayat gangguan makan dan pengecekan alergen (yang hanya berbasis nama). Log generasi tanpa data pribadi.
- Data yang dikirim: target + preferensi makan saja.

**Belum/ditunda**:
- Uji live menu dengan key Gemini (butuh key pengguna; jalankan lewat Pengaturan AI).
- URT/porsi rumah tangga terverifikasi.
- Menu lebih dari 1 hari.
- Grafik asupan vs target (Fase 6).

## 7. Keputusan & blocker

**Diputuskan (19 Nov 2026):**
1. **Application ID / bundle ID:** `com.panjijingga.musclecoach` (Android `applicationId` & iOS bundle ID; flavor dev memakai sufiks `.dev`).
2. **Firebase:** project belum ada → Fase 1 berjalan penuh di **Firebase Emulator**; project `dev`/`prod` dibuat & dihubungkan (`flutterfire configure`) kemudian.
3. **Tool:** pasang Flutter 3.47.9 (fvm), `firebase-tools` (npm global), FlutterFire CLI.
4. **Brief** di-rename menjadi `CLAUDE.md` (isi tidak diubah; bagian yang diabaikan dicatat di §1.4).

**Ditunda (bukan blocker sekarang):**
- Gemini API key & pilihan model — Fase 4.
- Pembuatan project Firebase, paket Blaze & budget alert — sebelum deploy pertama.
- Sumber & lisensi data gizi — Fase 5.
- Peninjauan angka default nutrisi — sebelum rilis.
