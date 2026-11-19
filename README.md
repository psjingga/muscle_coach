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
- API key Gemini (Fase 4) tidak pernah ditanam di APK atau repo; dimasukkan di aplikasi dan disimpan terenkripsi di perangkat.

## Pemeriksaan & test

```bash
tool/check.sh                                   # format, analyze, flutter test
fvm flutter test integration_test -d <device>   # E2E di perangkat/simulator
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
