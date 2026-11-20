# Muscle Coach

Aplikasi Flutter untuk membangun massa otot dengan dumbbell & barbell. **Semua data tersimpan di perangkat** (SQLite) — tanpa akun dan tanpa server. AI Gemini (Fase 4) dipanggil langsung dari aplikasi memakai API key milik pengguna.
Brief produk: [`CLAUDE.md`](CLAUDE.md) · Rencana, status fase & keputusan arsitektur: [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md) (§0).

> Rekomendasi aplikasi bersifat edukatif dan tidak menggantikan dokter, ahli gizi, atau personal trainer.

## Prasyarat

| Alat | Versi | Catatan |
|---|---|---|
| [fvm](https://fvm.app) | 3.x | Flutter dikunci di `.fvmrc` (3.47.9) → `fvm install` |
| Xcode / Android SDK | — | iOS ≥ 15, Android minSdk 24 |

## Menjalankan

```bash
fvm flutter pub get
fvm flutter run                 # emulator Android / simulator iOS / HP via USB atau wireless adb
```

### APK untuk dipasang di HP

```bash
fvm flutter build apk --release --split-per-abi
# HP modern (arm64): build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

APK release saat ini ditandatangani dengan kunci debug (cukup untuk pemakaian pribadi/sideload). Untuk Play Store perlu keystore release sendiri — jangan di-commit.

## Data & privasi

- Basis data: `musclecoach.sqlite` di folder data aplikasi (drift). Skema di `lib/core/database/app_database.dart`; ubah `schemaVersion` + migrasi bila struktur berubah.
- Tidak ada backup otomatis: menghapus aplikasi atau kehilangan HP = data hilang (fitur ekspor/impor menyusul).
- Profil → **Hapus semua data** menghapus seluruh isi basis data.
- API key Gemini tidak pernah ditanam di APK atau repo; dimasukkan di aplikasi dan disimpan terenkripsi di perangkat. *Hapus semua data* ikut menghapus key.

## AI Coach (Gemini)

- Di aplikasi: **Profil → AI Coach (Gemini)** → tempel API key dari [Google AI Studio](https://aistudio.google.com) → *Simpan & uji* → setujui pemrosesan data.
- Key disimpan terenkripsi di perangkat (Keystore/Keychain); tidak pernah ada di kode, APK, repo, log, atau basis data.
- Batasi key di Google AI Studio / Cloud Console (hanya *Generative Language API*, pasang kuota). Tier gratis: Google dapat memakai isi permintaan untuk meningkatkan produknya.
- Model default `gemini-3.5-flash-lite` (dapat diganti di Pengaturan). Prompt berversi di `lib/features/ai_coach/domain/prompts/`; output selalu divalidasi dan disimpan sebagai **draft** yang harus disetujui.

## Pengingat (notifikasi lokal)

- **Profil → Pengingat**: aktifkan, atur jam latihan (hari mengikuti program aktif), makan, timbang, check-in, dan jam tenang. Izin notifikasi diminta di sini dengan penjelasan — tidak saat aplikasi dibuka.
- Dijadwalkan di perangkat (14 hari ke depan, maks. 60) dan disinkronkan ulang saat aplikasi dibuka, pengaturan/program berubah, atau sesi selesai. Tetap jalan tanpa internet & tanpa AI.
- Jadwal tidak presisi (tanpa izin *exact alarm*); bila tidak muncul, matikan optimasi baterai untuk aplikasi di pengaturan HP.

## Ilustrasi latihan

Foto gerakan di `assets/exercises/` berasal dari [Free Exercise DB](https://github.com/yuhonas/free-exercise-db) (Unlicense, domain publik), diperkecil untuk aplikasi. Peta otot digambar di aplikasi (`exercise_library/presentation/widgets/muscle_map.dart`). Untuk menambah foto: simpan `<exerciseId>_0.jpg` (awal) dan `_1.jpg` (akhir) lalu isi `images` di `assets/catalog/exercises.json`; test `exercise_media_test.dart` memeriksa kelengkapannya.

## Pemeriksaan & test

```bash
tool/check.sh                                   # format, analyze, flutter test
fvm flutter test integration_test -d <device>   # E2E di perangkat/simulator
#   + alur Gemini: --dart-define=GEMINI_API_KEY=<key>  (hanya build tes; uninstall setelahnya)
GEMINI_API_KEY=<key> fvm flutter test test/live --tags live   # uji prompt ke Gemini sungguhan
```

Setelah mengubah kelas `@freezed` / `@riverpod` / tabel drift: `fvm dart run build_runner build`.
Teks UI ada di `lib/l10n/app_id.arb` (dibuat ulang otomatis oleh `flutter pub get`).

## Struktur

```text
assets/catalog/exercises.json   katalog latihan terkurasi (43 gerakan, versi di file)
lib/
  app/          bootstrap, router (go_router + gerbang onboarding), theme & branding
  core/         database (drift), errors, logging, utils, widgets
  features/     <fitur>/{data, domain, application, presentation}
                assessment · goals (kalkulasi target) · workout (planner, validator, sesi)
                exercise_library · onboarding · dashboard · profile · nutrition/progress (menyusul)
  l10n/         teks Bahasa Indonesia (ARB) + kode hasil generate
tool/check.sh   quality gate lokal
```

Angka default kalkulasi (BMR/TDEE/surplus/makro/batas laju) ada di `lib/features/goals/domain/nutrition_config.dart` dan **perlu ditinjau** terhadap rujukan kredibel sebelum dipakai luas.

Versi dengan backend Firebase (Auth, Firestore, Cloud Functions, Emulator) diarsipkan di branch `firebase-backend`.
