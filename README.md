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

### Variabel lingkungan (`--dart-define`)

Aplikasi tidak butuh variabel lingkungan untuk berjalan. Yang ada hanya untuk test:

| Nama | Dipakai di | Keterangan |
|---|---|---|
| `GEMINI_API_KEY` | `integration_test`, `test/live` | Opsional; menguji alur AI sungguhan. **Jangan** dipakai untuk build yang dibagikan — key masuk ke binary. |

Di aplikasi, key Gemini dimasukkan lewat **Profil → AI Coach (Gemini)**.

### Rilis (Android)

1. Buat keystore sekali: `keytool -genkey -v -keystore ~/musclecoach-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias musclecoach`. Simpan file & sandinya di luar repo.
2. Buat `android/key.properties` (sudah di-*gitignore*):
   ```properties
   storeFile=/Users/<nama>/musclecoach-release.jks
   storePassword=...
   keyAlias=musclecoach
   keyPassword=...
   ```
3. `fvm flutter build appbundle --release` (Play Store) atau `build apk --release --split-per-abi`.

Tanpa `key.properties`, build rilis memakai kunci debug — cukup untuk sideload pribadi, tidak untuk Play Store. Ganti `version:` di `pubspec.yaml` setiap rilis.

**iOS**: buka `ios/Runner.xcworkspace`, set *Team* & *Signing* di Xcode, lalu `fvm flutter build ipa`. Bundle ID `com.panjijingga.musclecoach`.

## Data & privasi

Ringkasan lengkap (data apa disimpan, apa yang dikirim ke Gemini, retensi, penghapusan): [`PRIVACY.md`](PRIVACY.md).

- Basis data: `musclecoach.sqlite` di folder data aplikasi (drift). Skema di `lib/core/database/app_database.dart`.
- **Tidak ikut cadangan cloud** (Android: aturan `data_extraction_rules`/`backup_rules`; iOS: key di Keychain hanya untuk perangkat ini). Pindah HP Android langsung (kabel/Wi-Fi) tetap membawa basis data; API key harus dimasukkan ulang. Menghapus aplikasi = data hilang (fitur ekspor/impor belum ada).
- Profil → **Hapus semua data**: semua tabel dikosongkan, berkas dipadatkan (`VACUUM`, `secure_delete`), API key dihapus, semua pengingat dibatalkan.
- API key Gemini tidak pernah ditanam di APK atau repo; disimpan terenkripsi (Android Keystore / iOS Keychain) dan dikirim hanya lewat header HTTPS.

### Mengubah skema basis data

1. Naikkan `schemaVersion` dan tambah langkah di `onUpgrade` (`app_database.dart`).
2. `fvm dart run build_runner build`
3. `fvm dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/drift_schema_v<N>.json`
4. `fvm dart run drift_dev schema generate --data-classes --companions drift_schemas/ test/generated_migrations/`
5. `test/data/migration_test.dart` otomatis menguji migrasi dari setiap versi lama ke versi terbaru.

## AI Coach (Gemini)

- Di aplikasi: **Profil → AI Coach (Gemini)** → tempel API key dari [Google AI Studio](https://aistudio.google.com) → *Simpan & uji* → setujui pemrosesan data.
- Key disimpan terenkripsi di perangkat (Keystore/Keychain); tidak pernah ada di kode, APK, repo, log, atau basis data.
- Batasi key di Google AI Studio / Cloud Console (hanya *Generative Language API*, pasang kuota). Tier gratis: Google dapat memakai isi permintaan untuk meningkatkan produknya.
- Model default `gemini-3.5-flash-lite` (dapat diganti di Pengaturan). Prompt berversi di `lib/features/ai_coach/domain/prompts/`; output selalu divalidasi dan disimpan sebagai **draft** yang harus disetujui.

## Nutrisi & data makanan

- **Tab Nutrisi**: asupan per hari (sarapan, makan siang, makan malam, snack) dibandingkan target kalori & makro, beserta sisa target. Hari sebelumnya bisa dilihat. Catatan bisa diketuk untuk mengubah porsi, memindahkan waktu makan, atau menghapus.
- **Tambah makanan**: cari di katalog TKPI, atau masukkan makanan dari **label kemasan** (nilai per sajian otomatis diubah ke per 100 g), atau **catat kalori/makro saja**. Nilai gizi disalin ke catatan saat dicatat, jadi riwayat tidak berubah bila katalog diperbarui.
- **Contoh menu (AI)**: Gemini memilih bahan **hanya** dari katalog TKPI dan memperkirakan gramnya. Aplikasi lalu **menyesuaikan porsi** (skala per kelompok makro, 0,4–2,5×) dan menghitung ulang total dari katalog × gram, menolak menu yang meleset dari target (kcal ±10 %, protein 90–130 %, lemak & karbohidrat ±30 %), dan menyaring pola makan, alergi, serta makanan yang tidak disukai **sebelum** daftar bahan dikirim. Retry maksimal 1 kali. Menu disimpan sebagai draft dan baru dipakai setelah disetujui. Tiap waktu makan di menu bisa ditandai "dimakan" dan langsung tercatat. Yang dikirim ke AI hanya target & preferensi makan, tanpa nama, umur, berat, atau kondisi medis.
- **Sumber data**: [Tabel Komposisi Pangan Indonesia (TKPI)](https://www.panganku.org), Kementerian Kesehatan RI. Dipakai snapshot 1.146 baris dari [nichsedge/indoscraping](https://github.com/nichsedge/indoscraping/releases/tag/dataset-panganku-latest) (rilis 28 Okt 2026), disalin ke `tool/food_catalog/source/panganku.csv`. Hash sha256 tercatat di katalog. Semua nilai per 100 g bagian yang dapat dimakan (BDD).
  - Angka tidak diubah. Yang dilakukan hanya pembulatan float hasil scraping dan perapian spasi nama.
  - 2 baris tanpa makro lengkap (Melase, Salak segar) **tidak dimasukkan**.
  - 16 baris yang energinya jauh berbeda dari 4/4/9 × makro ditandai **"cek data"** di aplikasi dan tidak dipakai AI.
  - Lisensi: TKPI adalah publikasi pemerintah tanpa lisensi terbuka yang eksplisit. Untuk penggunaan pribadi ini dipakai dengan atribusi. **Tinjau ketentuannya sebelum rilis publik/komersial.**
- Membangun ulang katalog: `python3 tool/food_catalog/build_tkpi_catalog.py` → `assets/catalog/foods_tkpi.json`.

## Progres, check-in & ringkasan mingguan

- **Tab Progres**:
  - Check-in hari ini.
  - Berat badan: grafik penimbangan + rata-rata 7 hari, dengan label "bukan massa otot".
  - **Status target**: on track / perlu evaluasi / target perlu disesuaikan / data belum cukup.
  - Asupan vs target (14 hari), volume latihan per minggu, progres per gerakan (set terberat per sesi), dan pencapaian.
- **Check-in harian**: berat (opsional), tidur, energi & suasana hati 1–5, nyeri, dan catatan. Status latihan & asupan hari itu diambil otomatis. Bila ada keluhan nyeri, muncul saran keselamatan. Notifikasi check-in membuka layar ini.
- **Status target** dinilai dari rata-rata berat **mingguan** (minimal 2 penimbangan per minggu, minggu berjalan tidak dihitung), dibandingkan laju yang diharapkan dari target. Muscle gain/strength memakai rentang dari kalkulasi target; recomposition dianggap stabil bila berubah ≤ 0,3 % BB.
  - 1 minggu menyimpang → "perlu evaluasi".
  - 2 minggu menyimpang searah → "target perlu disesuaikan".
- **Usulan penyesuaian** dihitung aplikasi (bukan AI): ±100 kcal lewat karbohidrat. Usulan hanya muncul bila:
  - makan tercatat ≥ 4 hari/minggu dengan rata-rata dalam ±15 % target selama 2 minggu;
  - tidak menurunkan target di bawah perkiraan TDEE untuk muscle gain;
  - tidak ada riwayat gangguan makan.

  Target baru baru berlaku setelah kamu memilih **Terapkan**. Target lama diarsipkan.
- **Ringkasan AI** (opsional, `weekly_review.v1`): Gemini hanya menerima statistik agregat — perubahan berat, kepatuhan, % target, tidur, dan jumlah hari nyeri. Yang **tidak** dikirim: berat absolut, nama, umur, isi catatan. Ringkasan ditolak bila AI menyebut angka kalori/gram atau istilah diagnosis/obat.
- Grafik memakai package [fl_chart](https://pub.dev/packages/fl_chart) (MIT).

## Pengingat (notifikasi lokal)

- **Profil → Pengingat**: aktifkan, atur jam latihan (hari mengikuti program aktif), makan, timbang, check-in, dan jam tenang. Izin notifikasi diminta di sini dengan penjelasan — tidak saat aplikasi dibuka.
- Dijadwalkan di perangkat (14 hari ke depan, maks. 60) dan disinkronkan ulang saat aplikasi dibuka, pengaturan/program berubah, atau sesi selesai. Tetap jalan tanpa internet & tanpa AI.
- Jadwal tidak presisi (tanpa izin *exact alarm*); bila tidak muncul, matikan optimasi baterai untuk aplikasi di pengaturan HP.

## Logo & ikon aplikasi

Logo (dumbbell di atas grafik naik) digambar sebagai vektor di `lib/app/theme/app_logo.dart` dan dipakai juga di splash & onboarding. Semua ikon dibuat dari sumber itu:

```bash
bash tool/app_icon/generate.sh   # ikon iOS, Android (adaptif + monokrom), notifikasi, layar pembuka iOS
```

Salinan 1024 px ada di `assets/branding/`.

## Ilustrasi latihan

Foto gerakan di `assets/exercises/` berasal dari [Free Exercise DB](https://github.com/yuhonas/free-exercise-db) (Unlicense, domain publik), diperkecil untuk aplikasi. Peta otot digambar di aplikasi (`exercise_library/presentation/widgets/muscle_map.dart`). Untuk menambah foto: simpan `<exerciseId>_0.jpg` dan `_1.jpg` (dua fase gerakan) lalu isi `images` di `assets/catalog/exercises.json`; test `exercise_media_test.dart` memeriksa kelengkapannya.

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
assets/catalog/foods_tkpi.json  katalog makanan TKPI (1.144 makanan per 100 g)
drift_schemas/                  snapshot skema basis data per versi (test migrasi)
lib/
  app/          bootstrap, router (go_router + gerbang onboarding), theme & branding
  core/         database (drift), errors, logging, utils, widgets
  features/     <fitur>/{data, domain, application, presentation}
                assessment · goals (kalkulasi target) · workout (planner, validator, sesi)
                exercise_library · onboarding · dashboard · profile · nutrition · progress · reminders · ai_coach
  l10n/         teks Bahasa Indonesia (ARB) + kode hasil generate
tool/check.sh   quality gate lokal
tool/app_icon/  generator ikon dari logo vektor
tool/food_catalog/  pembangun katalog TKPI + CSV sumber
```

Angka default kalkulasi (BMR/TDEE/surplus/makro/batas laju) ada di `lib/features/goals/domain/nutrition_config.dart` dan **perlu ditinjau** terhadap rujukan kredibel sebelum dipakai luas.

Versi dengan backend Firebase (Auth, Firestore, Cloud Functions, Emulator) diarsipkan di branch `firebase-backend`.
