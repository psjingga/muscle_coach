# Muscle Coach

Aplikasi Flutter untuk membangun massa otot dengan dumbbell & barbell, memakai Firebase dan Gemini (lewat Cloud Functions).
Brief produk: [`CLAUDE.md`](CLAUDE.md) · Rencana & status fase: [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md).

> Rekomendasi aplikasi bersifat edukatif dan tidak menggantikan dokter, ahli gizi, atau personal trainer.

## Prasyarat

| Alat | Versi | Catatan |
|---|---|---|
| [fvm](https://fvm.app) | 3.x | Flutter dikunci di `.fvmrc` (3.47.9) → `fvm install` |
| Node.js | ≥ 22 | Runtime Cloud Functions: Node 22 |
| JDK | ≥ 21 | Wajib untuk Firebase Emulator. `tool/firebase.sh` mencari JDK 21 otomatis (mis. `brew install openjdk@21`) tanpa mengubah `java` default |
| Firebase CLI | ≥ 15 | `npm i -g firebase-tools` |
| FlutterFire CLI | ≥ 1.5 | `dart pub global activate flutterfire_cli` (baru dibutuhkan saat menghubungkan project Firebase) |
| Xcode / Android SDK | — | iOS ≥ 15, Android minSdk 24 |

## Menjalankan secara lokal (Firebase Emulator)

Belum ada project Firebase sungguhan: semua berjalan di Emulator dengan project `demo-musclecoach` (project `demo-*` tidak pernah menyentuh resource cloud).

```bash
# 1. Dependency
fvm flutter pub get
(cd functions && npm ci)

# 2. Terminal 1 — Emulator Auth, Firestore, Functions (+ UI di http://localhost:4000)
cd functions && npm run serve

# 3. Terminal 2 — aplikasi (default APP_ENV=emulator)
fvm flutter run                       # emulator Android / simulator iOS
fvm flutter run --dart-define=EMULATOR_HOST=192.168.x.x   # HP fisik: IP Mac di LAN yang sama
```

- Tautan verifikasi email & reset kata sandi tidak dikirim sungguhan; buka **Emulator UI → Authentication**, atau lihat log terminal emulator.
- Data emulator hilang saat emulator dimatikan. Untuk menyimpannya: `../tool/firebase.sh emulators:start --import=../emulator-data --export-on-exit` dari folder `functions/`.

## Lingkungan

`--dart-define=APP_ENV=<emulator|dev|prod>` (default `emulator`), dibaca di `lib/app/config/app_environment.dart`.

| APP_ENV | Firebase | Status |
|---|---|---|
| `emulator` | Emulator lokal, project `demo-musclecoach` | ✅ siap |
| `dev` | Project Firebase pengembangan | ⏳ belum dibuat |
| `prod` | Project Firebase produksi | ⏳ belum dibuat |

### Menghubungkan project Firebase (nanti)
1. Buat project `dev` & `prod` di Firebase Console; aktifkan Authentication (Email/Password) dan Firestore (region `asia-southeast2`).
2. Cloud Functions & Secret Manager memerlukan **paket Blaze** — pasang *budget alert* lebih dulu.
3. `flutterfire configure --project=<id> --out=lib/app/config/firebase_options_<env>.dart --android-package-name=com.panjijingga.musclecoach --ios-bundle-id=com.panjijingga.musclecoach`, lalu sambungkan ke `FirebaseConfig.optionsFor`.
4. `firebase use --add` untuk alias `dev`/`prod`, kemudian `tool/firebase.sh deploy --only firestore,functions`.

## Pemeriksaan & test

```bash
tool/check.sh                 # format, analyze, flutter test, functions typecheck+test, rules test (Emulator)
tool/check.sh --no-emulator   # tanpa test Emulator
```

Atau satu per satu:

```bash
fvm flutter analyze && fvm flutter test
cd functions && npm run typecheck && npm test && npm run test:emulator
```

Setelah mengubah kelas `@freezed` / `@riverpod`: `fvm dart run build_runner build`.
Teks UI ada di `lib/l10n/app_id.arb` (dibuat ulang otomatis oleh `flutter pub get`).

## Struktur

```text
lib/
  app/          bootstrap, config (environment, Firebase), router (go_router + redirect), theme & branding
  core/         errors (AppFailure + mapper), network (Functions client), firebase providers, logging, widgets
  features/     <fitur>/{data, domain, application, presentation} — auth, dashboard, workout, nutrition, progress, profile, …
  l10n/         teks Bahasa Indonesia (ARB) + kode hasil generate
functions/      Cloud Functions TypeScript (callable `createUserProfile`, `deleteUserData`) + test unit/emulator
firestore.rules, firestore.indexes.json, firebase.json
tool/           check.sh (quality gate), firebase.sh (Firebase CLI dengan JDK 21)
```

## Keamanan

- Tidak ada API key Gemini di aplikasi; semua panggilan AI lewat Cloud Functions + Secret Manager (Fase 4).
- `firestore.rules` default-deny; pengguna hanya mengakses `users/{uid}` miliknya — diuji di `functions/test/emulator/firestore.rules.test.ts`.
- Jangan commit `.env`, secret, atau data pengguna (lihat `.gitignore`).
