# CLAUDE.md — Muscle Coach (Flutter + Firebase + Gemini)

> **Keputusan produk yang telah dikonfirmasi:** MVP untuk penggunaan pribadi; backend Firebase; target mendukung muscle gain dan body recomposition; peralatan MVP dumbbell dan barbell; nutrisi memakai database makanan Indonesia + AI; login email/password; gratis untuk tahap awal tetapi arsitektur disiapkan agar subscription dapat ditambahkan di masa depan.

> Dokumen ini adalah product brief sekaligus instruksi implementasi untuk Claude Code. Bangun aplikasi secara bertahap, jalankan analisis dan test, dan jangan menganggap rekomendasi AI sebagai pengganti dokter, ahli gizi, atau personal trainer.

## 1. Ringkasan produk

Buat aplikasi mobile Flutter untuk membantu pengguna meningkatkan massa otot (*muscle building*) dengan latihan beban yang berfokus pada **dumbbell dan barbell**.

Aplikasi harus:
1. Mengumpulkan assessment awal pengguna.
2. Membantu pengguna menentukan target yang realistis dan terukur.
3. Menghasilkan program latihan harian/mingguan yang dipersonalisasi menggunakan **Google Gemini**.
4. Menghitung estimasi kebutuhan kalori dan makronutrien harian sebagai baseline.
5. Memberikan referensi makanan harian yang sesuai dengan target.
6. Mencatat latihan, beban, repetisi, set, asupan makanan, berat badan, dan progres.
7. Mengevaluasi progres secara berkala dan menyesuaikan rekomendasi dengan persetujuan pengguna.

Nama aplikasi, logo, dan branding belum ditentukan. Gunakan nama sementara `Muscle Coach` dan buat branding mudah diganti.

## 2. Prinsip produk dan batasan keselamatan

- Fokus utama: hipertrofi/peningkatan massa otot dengan dumbbell dan barbell.
- Rekomendasi harus disesuaikan dengan pengalaman, peralatan, jadwal, kondisi, dan kemampuan pengguna.
- Jangan menjanjikan kenaikan berat badan atau massa otot dalam jumlah/waktu tertentu.
- Bedakan **berat badan** dari **massa otot**. Kenaikan berat badan tidak otomatis berarti kenaikan otot.
- Target, kalori, dan makro adalah estimasi awal; evaluasi berdasarkan tren beberapa minggu, bukan fluktuasi harian.
- Jangan mendiagnosis penyakit, memberi terapi, atau menyarankan latihan yang mengabaikan cedera/kontraindikasi.
- Jika pengguna melaporkan nyeri dada, pingsan, sesak yang tidak wajar, cedera akut, atau gejala berbahaya, hentikan rekomendasi latihan dan arahkan mencari pertolongan medis.
- Jika pengguna hamil, memiliki penyakit kronis, riwayat gangguan makan, sedang dalam pemulihan cedera, atau menyebut kondisi medis/obat yang relevan, tampilkan peringatan dan sarankan konsultasi tenaga kesehatan sebelum membuat target agresif.
- Jangan membuat rekomendasi ekstrem: defisit/surplus kalori besar, dehidrasi, latihan sampai gagal pada setiap set, atau peningkatan beban mendadak.
- Gemini hanya menghasilkan **draft rekomendasi terstruktur**. Validasi di backend sebelum disimpan atau ditampilkan.
- API key Gemini tidak boleh ditanam di aplikasi Flutter. Semua panggilan Gemini dilakukan melalui backend.

## 3. Platform dan stack teknis

### Mobile
- Flutter stable dan Dart stable versi yang kompatibel dengan project saat implementasi.
- Arsitektur: **feature-first + Clean Architecture**.
- State management: **Riverpod**.
- Navigasi: `go_router`.
- HTTP client: `dio`.
- Model/serialisasi: `freezed` + `json_serializable` (atau solusi setara yang konsisten).
- Form validation: gunakan validator terpusat per fitur.
- Penyimpanan token: `flutter_secure_storage`.
- Penyimpanan preferensi lokal: `shared_preferences` hanya untuk data non-sensitif.
- **Local notification:** `flutter_local_notifications` + `timezone` untuk pengingat terjadwal di perangkat. Local notification bukan pengganti Firebase Cloud Messaging; MVP menggunakan pengingat lokal dan tidak memerlukan push notification.
- Grafik progres: pilih package Flutter yang terawat dan sesuai kebutuhan.
- Logging: gunakan logger terstruktur; jangan gunakan `print()` untuk logging aplikasi.

### Backend (keputusan: Firebase)
Gunakan Firebase sebagai backend utama:
- **Firebase Authentication** untuk email/password.
- **Cloud Firestore** sebagai database utama.
- **Cloud Functions for Firebase** untuk business logic server-side dan integrasi Gemini.
- **Firebase Storage** untuk file pengguna bila memang dibutuhkan (misalnya foto progres); jangan menyimpan file besar sebagai dokumen Firestore.
- **Firebase App Check** untuk membantu melindungi resource backend.
- **Firebase Security Rules** untuk membatasi akses berdasarkan UID.
- Firebase Emulator Suite untuk pengembangan dan integration test lokal.
- Firebase Analytics/Crashlytics hanya bila dibutuhkan dan setelah konfigurasi privasi yang sesuai.

Gunakan Cloud Functions callable atau HTTPS functions dengan kontrak request/response yang konsisten. Letakkan seluruh secret Gemini di Google Secret Manager / konfigurasi secret Cloud Functions. Jangan pernah menaruh Gemini API key di Flutter atau Firestore.

Jangan menambahkan NestJS/PostgreSQL untuk MVP kecuali ada kebutuhan nyata yang disetujui. Jika repository sudah memiliki backend lain, inspeksi dahulu sebelum mengubah arsitektur.

### Struktur Flutter yang diharapkan

```text
lib/
  app/
    app.dart
    router/
    theme/
    config/
  core/
    network/
    errors/
    logging/
    storage/
    notifications/
    utils/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    onboarding/
    assessment/
    goals/
    dashboard/
    workout/
    exercise_library/
    nutrition/
    food_log/
    progress/
    check_in/
    ai_coach/
    profile/
```

Setiap feature memisahkan:
- `presentation`: screen, widget, provider/controller.
- `application`: use case/orchestrator bila dibutuhkan.
- `domain`: entity, repository contract, business rules.
- `data`: DTO/model, data source, repository implementation, mapper.

Jangan menaruh business logic, kalkulasi, atau pemanggilan API di dalam widget UI.

## 4. Alur pengguna utama

1. Pengguna membuka aplikasi dan membuat akun/login.
2. Pengguna mengisi onboarding dan assessment awal.
3. Aplikasi menampilkan ringkasan kondisi awal dan meminta pengguna mengonfirmasi target.
4. Backend menghitung baseline kebutuhan energi/makro dengan formula yang terdokumentasi.
5. Pengguna memilih hari latihan yang tersedia, durasi, dan peralatan.
6. Gemini menyusun program awal, termasuk jadwal mingguan, sesi latihan, instruksi, dan alternatif gerakan.
7. Pengguna melihat dashboard dan rencana latihan hari ini.
8. Pengguna menjalankan latihan dan mencatat set aktual.
9. Pengguna mencatat makanan/asupan dan berat badan sesuai kebutuhan.
10. Aplikasi menampilkan progres, kepatuhan, dan ringkasan mingguan.
11. Pada check-in berkala, sistem mengevaluasi tren dan meminta konfirmasi sebelum mengubah target/program.

## 5. Assessment awal

Buat form bertahap (multi-step), tampilkan progress pengisian, simpan draft, dan izinkan pengguna kembali ke langkah sebelumnya.

### A. Profil dasar
- Nama panggilan (opsional).
- Tanggal lahir atau usia.
- Jenis kelamin biologis untuk formula estimasi energi (opsional dengan penjelasan; sediakan pilihan “tidak ingin menjawab” dan fallback yang aman).
- Tinggi badan (cm).
- Berat badan saat ini (kg).
- Satuan metrik sebagai default.

### B. Tujuan
- Tujuan utama: menambah massa otot / meningkatkan kekuatan / body recomposition.
- Berat badan target (kg), opsional bila target utama bukan berat badan.
- Target waktu (tanggal atau rentang minggu/bulan).
- Area/kelompok otot prioritas (opsional).
- Ekspektasi dan motivasi (opsional).

Validasi target:
- Target harus masuk akal dan tidak menghasilkan laju perubahan berat yang agresif.
- Jika target atau waktunya tidak realistis, jelaskan alasannya dan minta pengguna menyesuaikan.
- Jangan otomatis menyetujui target hanya karena dimasukkan pengguna.

### C. Pengalaman latihan
- Pemula / menengah / berpengalaman.
- Sudah berapa lama latihan beban.
- Frekuensi latihan saat ini.
- Riwayat latihan dan gerakan yang sudah dikenal.
- PR/working weight jika diketahui (opsional, jangan wajib untuk pemula).

### D. Ketersediaan dan peralatan
- Hari yang bisa digunakan untuk latihan.
- Durasi per sesi (misalnya 30, 45, 60, 75, 90 menit).
- Peralatan MVP: dumbbell dan barbell. Tanyakan ketersediaan bench/rack/alat tambahan secara eksplisit sebelum membuat latihan yang memerlukannya.
- Rentang beban dumbbell/barbell yang tersedia.
- Lokasi latihan: rumah / gym.
- Preferensi latihan (opsional).

### E. Aktivitas dan pemulihan
- Aktivitas harian: sedentary / ringan / sedang / tinggi.
- Pekerjaan dominan duduk/berdiri/aktif.
- Rata-rata tidur per malam.
- Tingkat stres (opsional).
- Aktivitas kardio lain (opsional).

### F. Nutrisi
- Pola makan: omnivore / vegetarian / vegan / lainnya.
- Alergi dan pantangan makanan.
- Preferensi makanan dan makanan yang tidak disukai.
- Anggaran makan harian (opsional).
- Jumlah waktu makan yang diinginkan.
- Akses memasak: memasak sendiri / katering / campuran.
- Negara/lokasi makanan: Indonesia sebagai default; dapat diubah.
- Catatan khusus terkait pola makan (opsional).

### G. Keselamatan
- Cedera saat ini atau riwayat cedera yang masih berdampak.
- Kondisi medis yang relevan (opsional, bersifat sensitif; jelaskan tujuan pengumpulan dan minimalkan data).
- Gerakan yang dilarang/tidak nyaman.
- Persetujuan disclaimer dan pemrosesan data.

**Catatan privasi:** kumpulkan hanya data yang benar-benar diperlukan. Data kesehatan harus diperlakukan sebagai data sensitif, dibatasi aksesnya, dienkripsi saat transit dan saat tersimpan sesuai kemampuan infrastruktur, serta dapat dihapus oleh pengguna.

## 6. Goal setting dan kalkulasi nutrisi

Tampilkan:
- Berat badan awal.
- Berat badan target.
- Selisih target (kg).
- Target tanggal/periode.
- Tren berat badan aktual.
- Status target: on track / perlu evaluasi / target perlu disesuaikan.

### Kalkulasi awal
Implementasikan kalkulasi baseline secara deterministik di backend, bukan meminta Gemini menghitung angka dasar secara bebas.

- Estimasi BMR menggunakan formula yang dipilih dan didokumentasikan (misalnya Mifflin–St Jeor, dengan keterbatasan dijelaskan).
- Estimasi TDEE = BMR × faktor aktivitas yang dapat dikonfigurasi.
- Untuk muscle gain, gunakan surplus konservatif yang dapat dikonfigurasi, bukan angka agresif universal.
- Protein, lemak, dan karbohidrat dihitung dari berat badan, tujuan, preferensi, dan batas aman yang ditetapkan bersama ahli/rujukan yang kredibel.
- Pastikan total kalori konsisten dengan makro: protein 4 kcal/g, karbohidrat 4 kcal/g, lemak 9 kcal/g.
- Pembulatan angka harus konsisten dan dijelaskan sebagai estimasi.
- Jika data penting tidak tersedia, tampilkan rentang atau minta data; jangan membuat presisi palsu.
- Sediakan konfigurasi agar formula, faktor aktivitas, dan rentang target dapat diperbarui tanpa mengubah UI.

### Penyesuaian berkala
- Gunakan rata-rata/tren berat badan, bukan satu kali penimbangan.
- Evaluasi mingguan atau dua mingguan.
- Pertimbangkan kepatuhan asupan, latihan, tidur, dan perubahan aktivitas.
- Usulkan penyesuaian kecil; jangan mengubah target otomatis tanpa persetujuan pengguna.
- Jangan menyimpulkan kegagalan dari data yang belum cukup.

## 7. Program latihan yang dihasilkan AI

Gemini menyusun:
1. Program mingguan berdasarkan hari tersedia.
2. Fokus tiap sesi (misalnya upper/lower, full body, atau split lain yang sesuai).
3. Daftar latihan yang terutama menggunakan dumbbell/barbell.
4. Set, rentang repetisi, waktu istirahat, tempo bila relevan, dan RIR/RPE.
5. Pemanasan dan cooldown yang sesuai.
6. Instruksi teknik singkat dan cue keselamatan.
7. Alternatif latihan bila alat tidak tersedia atau gerakan tidak nyaman.
8. Perkiraan durasi sesi.
9. Aturan progresi beban/repetisi yang bertahap.
10. Hari istirahat dan opsi aktivitas pemulihan.

### Aturan program
- Program harus sesuai level dan jumlah hari yang tersedia.
- Atur volume latihan secara konservatif untuk pemula.
- Hindari melatih kelompok otot yang sama secara berat pada hari berurutan tanpa alasan pemrograman yang jelas.
- Berikan pemanasan yang relevan dan set pemanasan bila diperlukan.
- Jangan menyarankan 1RM test untuk pemula.
- Berikan instruksi meminta bantuan spotter untuk gerakan berisiko bila relevan.
- Jangan menganggap pengguna memiliki rack, bench, atau alat lain kecuali tercatat di assessment.
- Jika ada cedera/pembatasan, jangan sekadar mengganti nama latihan; hindari pola gerak terkait dan tampilkan peringatan.
- Pengguna dapat mengganti latihan, tetapi perubahan harus tetap divalidasi terhadap batasan alat dan keselamatan.

### Log latihan
Untuk setiap latihan, pengguna dapat mencatat:
- Beban aktual (kg).
- Repetisi aktual tiap set.
- Jumlah set.
- RIR atau RPE (opsional).
- Durasi istirahat (opsional).
- Status selesai / dilewati.
- Catatan teknik, rasa nyeri/tidak nyaman, dan energi.

Simpan target AI dan hasil aktual secara terpisah agar progres dapat dibandingkan.

## 8. Program nutrisi dan pencatatan makanan

Tampilkan target harian:
- Kalori.
- Protein (gram).
- Karbohidrat (gram).
- Lemak (gram).
- Air sebagai pengingat kebiasaan umum, bukan instruksi medis individual.

Buat rekomendasi menu harian yang realistis dan mudah ditemukan di Indonesia, mempertimbangkan:
- Preferensi/pantangan/alergi.
- Anggaran dan akses memasak.
- Jumlah waktu makan.
- Ketersediaan bahan.
- Porsi dalam gram atau ukuran rumah tangga yang masuk akal.
- Estimasi kalori dan makro per makanan serta total harian.

Pengguna dapat:
- Mencatat makanan secara manual.
- Memilih dari katalog makanan.
- Mengubah porsi.
- Menandai makanan yang dikonsumsi.
- Mencatat kalori/makro aktual.
- Melihat sisa target harian.

Jangan mengklaim nilai nutrisi sangat akurat bila sumber datanya hanya estimasi. Siapkan abstraksi sumber data makanan agar kelak dapat dihubungkan dengan database nutrisi yang tepercaya. Gemini boleh membantu menyusun menu, tetapi angka nutrisi harus divalidasi/ditandai sebagai estimasi dan total dihitung ulang oleh backend.

## 9. Check-in harian dan progres

### Check-in harian
- Berat badan (opsional; tidak harus setiap hari).
- Latihan selesai/tidak.
- Asupan makanan dan makro.
- Durasi tidur.
- Energi/mood (opsional).
- Catatan kendala.
- Rasa nyeri atau ketidaknyamanan saat latihan.

### Check-in mingguan
- Rata-rata berat badan.
- Perubahan dari minggu sebelumnya.
- Kepatuhan latihan.
- Rata-rata asupan.
- Catatan pemulihan.
- Ringkasan AI: apa yang berjalan baik, hambatan, dan saran minggu berikutnya.

### Visualisasi
- Grafik berat badan dari waktu ke waktu.
- Grafik beban/repetisi per gerakan.
- Volume latihan per minggu.
- Kepatuhan latihan.
- Asupan kalori dan makro vs target.
- Ringkasan pencapaian milestone.

Jangan membuat grafik yang menyiratkan kenaikan massa otot jika hanya ada data berat badan. Labeli metrik secara akurat.

## 10. AI Gemini: desain integrasi

### Prinsip arsitektur
Flutter → NestJS API → Gemini API. Flutter tidak pernah memegang API key Gemini.

Buat `GeminiService` di backend dan `AiCoachService` sebagai lapisan use case. Model Gemini harus dapat diganti melalui konfigurasi.

### Kegunaan Gemini
- Generate program latihan awal dari assessment.
- Generate detail sesi latihan harian.
- Memberi alternatif gerakan berdasarkan alat dan batasan.
- Menyusun contoh menu harian.
- Membuat ringkasan check-in mingguan.
- Mengusulkan penyesuaian program berdasarkan data aktual.

### Input AI
Kirim hanya konteks minimum yang dibutuhkan:
- Profil yang relevan dan telah disetujui pengguna.
- Goal.
- Level latihan.
- Peralatan.
- Hari/durasi latihan.
- Preferensi makanan.
- Batasan dan pantangan yang relevan.
- Ringkasan log terbaru.

Jangan mengirim identifier pribadi atau data yang tidak relevan ke model.

### Output AI
Wajib berupa JSON sesuai schema/version yang ditentukan backend. Jangan parsing jawaban bebas sebagai data aplikasi. Validasi:
- JSON valid.
- Schema version dikenali.
- Semua exercise ID ada di katalog atau ditandai sebagai usulan yang belum terverifikasi.
- Set/repetisi/rest berada dalam batas konfigurasi.
- Peralatan sesuai assessment.
- Tidak bertentangan dengan batasan keselamatan.
- Total nutrisi dihitung ulang di backend.
- Konten berbahaya ditolak atau diganti dengan respons aman.

Jika output invalid, lakukan maksimal satu retry terkontrol dengan instruksi perbaikan. Jika tetap invalid, tampilkan error yang ramah dan jangan simpan sebagai program aktif.

### Prompting
Simpan system prompt dan template prompt di backend, berversi, dapat diuji, dan tidak ditulis tersebar di widget Flutter. Instruksikan Gemini:
- Bertindak sebagai penyusun draft edukatif, bukan dokter/ahli gizi.
- Tidak mengarang data assessment yang kosong.
- Menyebutkan asumsi dan data yang belum tersedia.
- Mengutamakan keselamatan dan progres bertahap.
- Menghasilkan JSON saja sesuai schema.
- Menggunakan exercise catalog internal sebagai sumber gerakan yang diizinkan.

### Exercise catalog
Bangun katalog terstruktur yang dikelola aplikasi:
- ID, nama, nama alternatif.
- Target otot utama/sekunder.
- Pola gerak.
- Peralatan.
- Level.
- Instruksi teknik.
- Kesalahan umum.
- Peringatan keselamatan.
- Video/ilustrasi (URL opsional).
- Alternatif gerakan.

AI sebaiknya memilih dari katalog, bukan bebas menciptakan nama latihan. Mulai dengan katalog dasar dumbbell/barbell dan perluas bertahap.

## 11. Layar utama / navigasi

Rancang UI modern, mudah digunakan saat berada di gym, responsif, dan mendukung dark/light theme.

Tab utama yang disarankan:
1. **Home** — ringkasan hari ini, target, latihan berikutnya, kalori/makro tersisa, check-in.
2. **Workout** — jadwal mingguan, detail sesi, timer istirahat, log set.
3. **Nutrition** — target nutrisi, menu, food log.
4. **Progress** — grafik dan riwayat.
5. **Profile** — assessment, goal, peralatan, preferensi, pengaturan, privasi.

Layar tambahan:
- Splash dan onboarding.
- Login/register/forgot password.
- Assessment wizard.
- Goal confirmation.
- AI plan generation/loading/error.
- Workout detail dan exercise detail.
- Daily check-in.
- Weekly review.
- Notification settings.
- Consent/privacy settings.

### UX penting
- Jangan menampilkan seluruh assessment dalam satu form panjang.
- Tampilkan unit di setiap input.
- Beri empty state, loading, error, retry, dan offline state.
- Konfirmasi sebelum menghapus log atau mengganti program aktif.
- Pengguna dapat melihat alasan ringkas mengapa latihan/menu direkomendasikan.
- Tampilkan sumber/label “estimasi AI” untuk rekomendasi yang memang hasil generasi.
- Sediakan akses cepat untuk mencatat set tanpa banyak navigasi.

## 12. Model data minimum

Gunakan koleksi/subkoleksi Firestore dengan dokumen yang ukurannya terkontrol. Terapkan pola data yang cocok untuk query yang benar-benar diperlukan; jangan menyalin seluruh data relasional secara berlebihan. Semua dokumen milik pengguna harus memiliki ownership yang jelas dan Security Rules yang membatasi akses berdasarkan `request.auth.uid`.

Struktur awal yang disarankan:
```text
users/{uid}
  profile/current
  settings/notifications             # preferensi local notification per pengguna
  assessments/{assessmentId}
  goals/{goalId}
  equipment/current
  workoutPlans/{planId}
  workoutSessions/{sessionId}
  nutritionTargets/{targetId}
  mealPlans/{mealPlanId}
  foodLogs/{foodLogId}
  bodyMetrics/{metricId}
  dailyCheckIns/{checkInId}
  weeklyReviews/{reviewId}
  consents/{consentId}
  aiGenerationLogs/{generationId}

exerciseCatalog/{exerciseId}       # katalog referensi global, read-only dari client
foodCatalog/{foodId}               # katalog referensi global, read-only dari client
appConfig/{configId}               # konfigurasi non-secret yang aman dibaca client
```

Untuk koleksi global `exerciseCatalog` dan `foodCatalog`, client hanya boleh membaca data yang dipublikasikan; hanya proses admin/seed tepercaya yang boleh menulis. Jangan menyimpan secret di `appConfig`.

Sertakan pada dokumen yang relevan:
- `createdAt`, `updatedAt` (Firestore Timestamp).
- `schemaVersion`.
- status draft/active/archived bila relevan.
- sumber data (user input / calculated / AI generated / curated database).
- unit yang eksplisit.
- versi assessment, goal, workout plan, nutrition target, dan prompt AI.
- audit metadata untuk perubahan penting.

Entitas inti minimum yang perlu dimodelkan (sebagai dokumen atau subkoleksi):
- users/profiles, assessments, goals, equipment.
- exercise catalog, workout plans, plan days, workout exercises.
- workout sessions, set logs.
- nutrition targets, meal plans, meal items.
- food catalog, food logs.
- body metrics, daily check-ins, weekly reviews.
- AI generation logs, user consents.
- subscription entitlement placeholder (untuk masa depan; jangan aktifkan pembayaran di MVP).

Jangan menyimpan seluruh domain sebagai satu dokumen JSON besar. Perhatikan batas ukuran dokumen Firestore, indeks komposit, biaya baca/tulis, pagination dengan cursor, dan query berdasarkan UID/tanggal/status.

- `users`
- `user_profiles`
- `assessments`
- `fitness_goals`
- `equipment`
- `user_equipment`
- `exercise_catalog`
- `workout_plans`
- `workout_plan_days`
- `workout_exercises`
- `workout_sessions`
- `workout_set_logs`
- `nutrition_targets`
- `meal_plans`
- `meal_items`
- `food_catalog`
- `food_logs`
- `body_metrics`
- `daily_check_ins`
- `weekly_reviews`
- `ai_generation_logs`
- `user_consents`
- `notifications`

Sertakan:
- UUID primary key.
- `created_at`, `updated_at`.
- Ownership/user ID dan authorization.
- Versioning pada assessment, goal, workout plan, nutrition target, dan AI prompt.
- Status draft/active/archived bila relevan.
- Sumber data (user input / calculated / AI generated / external database).
- Unit yang eksplisit.
- Audit log untuk perubahan penting.
- Soft delete hanya jika benar-benar diperlukan; sediakan mekanisme penghapusan data pengguna.

Jangan menyimpan satu JSON besar sebagai pengganti relasi untuk seluruh domain. JSONB boleh digunakan untuk raw AI response atau metadata yang memang fleksibel, sambil tetap menyimpan data inti dalam kolom/tabel terstruktur.

## 13. Kontrak Cloud Functions

Karena backend menggunakan Firebase, jangan membuat REST controller NestJS. Buat Cloud Functions yang memiliki kontrak input/output eksplisit, misalnya:
- `generateWorkoutPlan`
- `generateDailyWorkout`
- `generateMealPlan`
- `generateWeeklyReview`
- `calculateNutritionTargets`
- `createUserProfile` (opsional trigger Auth)
- `deleteUserData` (proses penghapusan data pengguna)

Untuk setiap function:
- Verifikasi Firebase Auth dan UID.
- Validasi payload server-side.
- Terapkan App Check bila sesuai.
- Rate limit dan batasi kuota untuk endpoint AI.
- Verifikasi ownership pada semua ID dokumen yang diterima.
- Kembalikan error code yang stabil dan pesan aman.
- Catat metadata generasi AI tanpa menyimpan data sensitif yang tidak diperlukan.
- Jangan mengandalkan Security Rules sebagai pengganti validasi Cloud Functions.

Flutter mengakses Firestore langsung hanya untuk operasi yang memang aman dan dilindungi Security Rules. Semua kalkulasi sensitif, perubahan program aktif, validasi AI, dan pemanggilan Gemini dilakukan di Cloud Functions.

Contoh kontrak REST lama di bawah ini tidak digunakan untuk MVP Firebase.

```text
POST   /auth/register
POST   /auth/login
POST   /auth/refresh
POST   /auth/logout

GET    /me
PATCH  /me/profile

POST   /assessments
GET    /assessments/latest
GET    /assessments/:id

POST   /goals
GET    /goals/active
PATCH  /goals/:id

GET    /exercises
GET    /exercises/:id

POST   /ai/workout-plan/generate
POST   /ai/daily-workout/generate
POST   /ai/meal-plan/generate
POST   /ai/weekly-review/generate

GET    /workout-plans/active
GET    /workout-plans/:id
POST   /workout-sessions
POST   /workout-sessions/:id/sets
PATCH  /workout-sessions/:id/complete

GET    /nutrition/targets/current
POST   /food-logs
GET    /food-logs?date=YYYY-MM-DD
DELETE /food-logs/:id

POST   /body-metrics
GET    /body-metrics
POST   /check-ins
GET    /check-ins
GET    /progress/summary
```

Semua endpoint harus:
- Memvalidasi input.
- Memeriksa autentikasi dan kepemilikan resource.
- Mengembalikan response envelope yang konsisten.
- Memiliki pagination/filter untuk daftar yang berpotensi besar.
- Tidak membocorkan stack trace atau secret.
- Memiliki test unit/integration untuk aturan penting.

## 14. Keamanan, privasi, dan reliabilitas

- Simpan secret Gemini di Google Secret Manager; jangan di source code atau konfigurasi Flutter.
- Jangan commit `.env`, API key, token, atau data pengguna.
- Gunakan Firebase Authentication untuk pengelolaan kredensial; jangan menyimpan password sendiri.
- Gunakan HTTPS untuk seluruh komunikasi.
- Terapkan Firebase Security Rules default-deny dan uji dengan Emulator Suite.
- Rate limit endpoint AI dan operasi yang berbiaya; tetapkan batas penggunaan pribadi untuk mencegah biaya tidak terduga.
- Batasi ukuran input dan output Gemini.
- Validasi output AI sebelum disimpan.
- Terapkan authorization per user.
- Hindari log data kesehatan, makanan, atau profil secara lengkap.
- Buat kebijakan retensi dan penghapusan data.
- Berikan consent yang jelas untuk penggunaan data pada fitur AI.
- Siapkan timeout, retry terbatas, circuit breaker atau fallback untuk layanan AI.
- Cache katalog latihan dan data referensi yang relatif statis.
- Jangan mengandalkan AI untuk kalkulasi inti atau validasi keselamatan.

## 15. Implementasi Firebase secara spesifik

### Firebase Authentication
- Gunakan email/password untuk MVP.
- Implementasikan register, login, logout, reset password, dan verifikasi email bila diperlukan.
- Tangani status akun dan auth state dengan benar pada Riverpod.
- Jangan menyimpan password atau token secara manual di Firestore.
- Sediakan alur penghapusan akun dan data pengguna.

### Cloud Firestore
- Buat `firestore.rules` dengan default deny.
- User hanya dapat membaca/menulis dokumen di bawah `users/{request.auth.uid}` sesuai validasi field.
- Katalog global hanya read-only untuk client.
- Operasi admin/seed dilakukan dari lingkungan tepercaya.
- Buat `firestore.indexes.json` untuk query yang digunakan.
- Hindari listener realtime yang tidak dibutuhkan agar biaya terkendali.
- Gunakan pagination/cursor untuk riwayat log.
- Simpan tanggal sebagai Timestamp dan tetapkan strategi timezone; tanggal log harian mengikuti timezone pengguna.

### Cloud Functions dan Gemini
- Pilih runtime Node.js/TypeScript yang didukung Firebase saat implementasi.
- Gunakan Secret Manager untuk Gemini API key.
- Validasi Firebase Auth, App Check, payload, quota, dan ownership.
- Gunakan structured output/JSON schema jika tersedia pada model Gemini yang dipilih; tetap lakukan validasi server-side.
- Simpan model ID dan prompt version pada log generasi.
- Buat timeout, retry terbatas, dan fallback yang aman.
- Jangan pernah mengaktifkan hasil AI sebelum lolos validasi dan disetujui pengguna.

### Database makanan Indonesia
- Buat skema `foodCatalog` dengan nama, nama alternatif, kategori, unit/porsi, berat gram, kalori, protein, karbohidrat, lemak, sumber, tanggal verifikasi, dan status kualitas.
- Prioritaskan sumber data yang legal digunakan dan dapat ditelusuri; dokumentasikan atribusi dan lisensi.
- Bedakan nilai per 100 gram dari nilai per porsi.
- Simpan sumber dan tingkat kepastian data nutrisi.
- Jangan mengarang data makanan untuk melengkapi katalog. Jika data tidak tersedia, tandai sebagai estimasi atau minta pengguna memasukkan label nutrisi.
- AI boleh menyarankan kombinasi menu, tetapi perhitungan total gizi dilakukan dari data katalog/porsi oleh aplikasi/backend.

### Local notification dan pengingat terjadwal (WAJIB untuk MVP)

Gunakan **local notification** pada perangkat dengan package Flutter `flutter_local_notifications` dan `timezone`. Pengingat harus tetap dapat berjalan tanpa memanggil Gemini dan, setelah jadwal berhasil dibuat di perangkat, tidak bergantung pada koneksi internet.

#### Jenis pengingat
- **Sesi latihan:** pengingat pada hari latihan sesuai workout plan aktif dan waktu yang dipilih pengguna.
- **Makan:** pengingat sarapan, makan siang, makan malam, atau snack; setiap kategori dapat diaktifkan/nonaktifkan.
- **Timbang berat badan:** jadwal berkala yang dipilih pengguna (misalnya mingguan).
- **Daily check-in:** pengingat untuk mencatat progres, energi, tidur, atau catatan harian.

#### Preferensi dan UX
- Buat halaman **Notification Settings** untuk mengaktifkan/nonaktifkan setiap kategori, memilih hari, jam, dan timezone, serta mengatur jeda/quiet hours bila diperlukan.
- Tampilkan alasan dan contoh waktu pengingat sebelum meminta izin notifikasi sistem. Jangan meminta permission saat aplikasi baru dibuka tanpa konteks.
- Waktu rekomendasi dari Gemini hanya berupa saran; pengguna harus mengonfirmasi atau mengubahnya. Gemini tidak boleh mengaktifkan atau menjadwalkan notifikasi secara diam-diam.
- Sediakan aksi **Snooze**, **Mark as done** bila sesuai, dan navigasi dari notifikasi ke layar terkait (misalnya detail sesi latihan atau check-in).
- Hormati timezone perangkat/pengguna, perubahan timezone, daylight saving time bila berlaku, serta preferensi quiet hours.

#### Aturan penjadwalan dan sinkronisasi
- Buat abstraction `NotificationService` di `core/notifications/`; UI tidak boleh memanggil plugin secara langsung. Sediakan repository/use case untuk permission, schedule, cancel, reschedule, dan membaca status izin.
- Simpan **preferensi** notifikasi di Firestore pada dokumen milik pengguna (misalnya `users/{uid}/settings/notifications`), termasuk kategori aktif, hari, jam lokal, timezone, dan `updatedAt`. Jangan menyimpan jadwal OS sebagai sumber kebenaran; jadwal lokal dibangun ulang dari preferensi dan data rencana aktif.
- Jadwalkan pengingat sesi latihan dari workout plan yang berstatus aktif. Ketika plan/jadwal berubah atau dinonaktifkan, batalkan notifikasi lama yang terkait lalu jadwalkan ulang.
- Ketika sesi latihan ditandai selesai, batalkan pengingat untuk sesi tersebut agar tidak muncul lagi. Jangan membatalkan pengingat sesi lain atau kategori lain.
- Gunakan notification ID yang stabil dan deterministik berdasarkan kategori + entity/tanggal agar proses reschedule tidak membuat duplikat. Simpan metadata pemetaan ID bila diperlukan.
- Saat login, perubahan akun, perubahan preferensi, perubahan plan, dan aplikasi dibuka kembali, rekonsiliasi jadwal lokal dengan data terbaru. Saat logout, batalkan jadwal spesifik akun dan bersihkan state lokal akun tersebut.
- Tangani batas jumlah pending scheduled notifications pada platform; prioritaskan jadwal terdekat dan jadwalkan ulang secara bertahap bila perlu.
- Minta izin Android/iOS sesuai versi OS. Untuk Android, deklarasikan permission yang memang diperlukan dan tangani notification channel. Hindari meminta exact-alarm permission kecuali ada kebutuhan produk yang benar-benar mengharuskan alarm presisi; pengingat latihan biasa dapat menggunakan jadwal tidak-presisi.
- Tangani permission ditolak/nonaktif dengan UX yang jelas dan tautan ke pengaturan sistem; jangan menganggap schedule berhasil jika OS menolak permission.
- Pastikan penjadwalan ulang setelah reboot/update aplikasi sesuai kemampuan plugin/platform dan lakukan rekonsiliasi saat aplikasi aktif kembali. Jangan menjanjikan notifikasi selalu muncul tepat waktu karena OS dapat menunda notifikasi untuk optimasi baterai.
- Jangan gunakan Firebase Cloud Messaging untuk pengingat lokal yang waktunya sudah diketahui di perangkat. FCM dapat dipertimbangkan kelak untuk pesan server-to-device yang benar-benar membutuhkan push.

#### Model data preferensi
Contoh dokumen `users/{uid}/settings/notifications`:
```json
{
  "enabled": true,
  "timezone": "Asia/Jakarta",
  "workout": { "enabled": true, "daysOfWeek": [1, 3, 5], "time": "17:00" },
  "meals": {
    "breakfast": { "enabled": true, "time": "07:00" },
    "lunch": { "enabled": true, "time": "12:00" },
    "dinner": { "enabled": true, "time": "19:00" },
    "snack": { "enabled": false, "time": "15:00" }
  },
  "weighIn": { "enabled": true, "daysOfWeek": [1], "time": "07:00" },
  "dailyCheckIn": { "enabled": true, "time": "21:00" },
  "quietHours": { "enabled": false, "start": "22:00", "end": "06:00" },
  "updatedAt": "Firestore Timestamp"
}
```
Gunakan konvensi hari yang terdokumentasi (misalnya ISO 1=Senin sampai 7=Minggu). Validasi format jam, timezone, dan hari di domain layer. Nilai jam di atas hanya contoh default; pengguna dapat mengubahnya.

#### Testing dan acceptance criteria
- Unit test untuk konversi timezone, perhitungan tanggal/jam berikutnya, quiet hours, notification ID, dan aturan reschedule/cancel.
- Test bahwa sesi yang selesai tidak lagi memiliki pengingat, perubahan plan tidak meninggalkan jadwal lama, dan reschedule berulang tidak membuat duplikat.
- Widget/integration test untuk permission denied, pengaturan kategori, tap notification, dan navigasi ke tujuan yang benar.
- Verifikasi manual pada Android dan iOS, termasuk reboot, perubahan timezone, aplikasi di foreground/background/terminated, serta permission yang ditolak.
- Acceptance: pengguna dapat mengatur pengingat latihan berdasarkan hari dan jam; notifikasi mengarah ke sesi yang benar; menyelesaikan latihan membatalkan pengingat sesi terkait; perubahan plan/preferences merekonsiliasi jadwal; kategori lain tetap berjalan independen.

### Subscription di masa depan
- MVP tidak memiliki paywall atau pembayaran.
- Buat interface `EntitlementRepository` atau service abstrak agar fitur dapat dibatasi berdasarkan entitlement di masa depan.
- Jangan hardcode asumsi bahwa semua fitur akan selalu gratis.
- Jangan membangun integrasi pembayaran sampai diminta.

## 16. Testing dan quality gate

### Flutter
- Unit test untuk kalkulasi/validator/use case.
- Provider tests.
- Widget tests untuk form assessment, workout logging, dan food logging.
- Integration test untuk alur onboarding sampai program tampil.
- `flutter analyze` harus bersih dari error.
- Format dengan `dart format`.

### Backend
- Unit test untuk kalkulasi BMR/TDEE/makro dan validasi goal.
- Unit test untuk validator output Gemini.
- Integration test endpoint dan authorization.
- Test untuk AI timeout, invalid JSON, rate limit, dan fallback.
- Test bahwa pengguna tidak dapat membaca data pengguna lain.

### Acceptance criteria
- Pengguna dapat menyelesaikan assessment dan menyimpan draft.
- Target awal dan asumsi kalkulasi terlihat jelas.
- Program latihan sesuai alat, level, jadwal, dan batasan.
- AI output tervalidasi sebelum menjadi program aktif.
- Pengguna dapat mencatat set aktual dan melihat riwayatnya.
- Pengguna dapat mencatat makanan dan melihat total harian.
- Pengguna dapat mencatat berat badan dan melihat grafik.
- Pengguna dapat mengatur local notification untuk sesi latihan, waktu makan, timbang berat badan, dan daily check-in.
- Pengingat sesi latihan dibatalkan setelah sesi selesai dan dijadwalkan ulang saat workout plan berubah tanpa membuat notifikasi duplikat.
- Weekly review menggunakan data aktual yang tersedia.
- Tidak ada Gemini API key di binary Flutter.
- Tidak ada business logic penting di widget.

## 17. Tahapan implementasi untuk Claude Code

Jangan mencoba membangun seluruh aplikasi sekaligus. Kerjakan per fase, laporkan file yang dibuat/diubah, jalankan test, dan tunggu evaluasi sebelum melanjutkan bila ada keputusan produk yang belum jelas.

### Fase 0 — Repository discovery
1. Periksa struktur repository, versi Flutter/Dart, backend yang tersedia, dependency, lint, dan pola kode.
2. Jangan menghapus atau mengganti konfigurasi yang sudah berfungsi tanpa alasan.
3. Buat `IMPLEMENTATION_PLAN.md` berisi temuan, asumsi, arsitektur, risiko, dan urutan kerja.
4. Ajukan pertanyaan hanya untuk blocker; gunakan asumsi yang tertulis untuk detail yang bisa ditunda.

### Fase 1 — Foundation
1. Setup struktur feature-first/Clean Architecture.
2. Setup Riverpod, go_router, theme, network layer, error handling, logging.
3. Setup environment dev/staging/prod.
4. Setup Firebase Auth, Firestore, Cloud Functions, Security Rules, indexes, dan Emulator Suite.
5. Setup CI/check commands bila sesuai repository.

### Fase 2 — Assessment dan goal
1. Implementasikan onboarding dan assessment wizard.
2. Validasi input dan simpan draft.
3. Implementasikan goal confirmation.
4. Implementasikan kalkulasi baseline di backend dengan unit test.
5. Tampilkan hasil kalkulasi dan asumsi kepada pengguna.

### Fase 3 — Exercise catalog dan workout logging
1. Buat katalog latihan dumbbell/barbell awal.
2. Buat jadwal dan detail sesi.
3. Implementasikan logging set, repetisi, beban, RIR/RPE.
4. Simpan planned vs actual secara terpisah.

### Fase 4 — Gemini workout generation
1. Integrasikan Gemini dari backend.
2. Buat prompt berversi dan JSON schema.
3. Buat validator dan safety checks.
4. Buat endpoint generate program.
5. Tampilkan draft dan minta persetujuan pengguna sebelum aktivasi.

### Fase 5 — Nutrition
1. Implementasikan target kalori/makro.
2. Buat meal plan generator.
3. Buat food log dan perhitungan total.
4. Tandai estimasi dan sumber nutrisi.

### Fase 6 — Progress dan AI review
1. Grafik berat badan dan performa latihan.
2. Check-in harian/mingguan.
3. Weekly review.
4. Rekomendasi penyesuaian dengan persetujuan pengguna.

### Fase 7 — Hardening
1. Lengkapi tests.
2. Audit keamanan dan privasi.
3. Uji offline/error/loading states.
4. Uji perangkat Android dan iOS.
5. Dokumentasikan setup, environment variables, API, dan deployment.

## 18. Cara kerja Claude Code

Sebelum mengubah kode:
- Baca seluruh instruksi project (`CLAUDE.md`, README, aturan repository).
- Inspeksi implementasi yang sudah ada.
- Tulis rencana singkat untuk fase yang sedang dikerjakan.
- Jangan menebak nama endpoint, schema, atau dependency bila bisa memeriksa sumbernya.

Saat mengimplementasikan:
- Kerjakan satu fase/fitur pada satu waktu.
- Buat kode yang benar-benar dapat dijalankan, bukan hanya mockup, kecuali diminta membuat prototype.
- Hindari placeholder/TODO untuk fungsi inti.
- Jangan membuat data dummy seolah-olah data produksi.
- Pisahkan konfigurasi dev/staging/prod.
- Jangan menambahkan package sebelum memeriksa kompatibilitas dan pemeliharaannya.
- Jaga kompatibilitas Android dan iOS.
- Jangan melakukan refactor besar yang tidak berkaitan.

Setelah setiap fase:
1. Jalankan formatter.
2. Jalankan analyzer/linter.
3. Jalankan test terkait.
4. Perbaiki error yang diperkenalkan.
5. Ringkas file yang berubah, keputusan, test, dan hal yang belum selesai.
6. Berikan perintah untuk menjalankan aplikasi/backend.

## 19. Asumsi awal yang perlu dikonfirmasi

Untuk memulai implementasi, gunakan asumsi berikut kecuali pengguna mengubahnya:

- Bahasa UI: Bahasa Indonesia.
- Unit: kg, cm, gram, kcal.
- Pasar makanan: Indonesia.
- Fokus latihan MVP: dumbbell dan barbell; alat tambahan hanya jika pengguna menyatakan memilikinya.
- Platform: Android dan iOS.
- Arsitektur Flutter: Clean Architecture + Riverpod + go_router.
- Backend: Firebase Auth + Firestore + Cloud Functions.
- AI: Gemini melalui Cloud Functions, bukan langsung dari Flutter.
- Satu akun untuk satu profil pengguna pada MVP.
- Program AI harus disetujui pengguna sebelum aktif.
- MVP tidak membutuhkan integrasi wearable, kamera penghitung repetisi, atau pembayaran.

## 20. Pertanyaan produk yang perlu diputuskan bersama

Jangan menghambat fase discovery/foundation untuk pertanyaan yang belum dijawab. Sebelum mengunci desain final, konfirmasi:

1. **Mode penggunaan:** apakah aplikasi untuk penggunaan pribadi sendiri terlebih dahulu, atau langsung multi-user/public app?
2. **Backend:** Firebase (sudah diputuskan); periksa apakah Firebase project sudah tersedia.
3. **Login:** email/password (sudah diputuskan).
4. **Fokus target:** apakah fokus utama menaikkan berat badan sekaligus massa otot, atau body recomposition (otot naik dengan berat relatif stabil) juga harus menjadi tujuan utama?
5. **Peralatan MVP:** apakah hanya dumbbell/barbell, atau termasuk bench, squat rack, pull-up bar, dan resistance band jika dimiliki?
6. **Pencatatan makanan:** database makanan Indonesia + rekomendasi AI + input manual (sudah diputuskan). Tentukan sumber data, lisensi, dan kualitas nutrisi sebelum mengisi katalog.
7. **Bahasa dan satuan:** apakah Bahasa Indonesia dan kg/cm sudah sesuai?
8. **Model bisnis:** gratis untuk penggunaan pribadi pada MVP; siapkan abstraksi entitlement/feature access agar subscription dapat ditambahkan kelak, tetapi jangan implementasikan pembayaran sekarang.

## 21. Instruksi pertama untuk Claude

Mulai dari **Fase 0 — Repository discovery**. Jangan langsung menghasilkan semua fitur. Periksa repository, tulis `IMPLEMENTATION_PLAN.md`, identifikasi blocker, lalu ajukan pertanyaan produk yang benar-benar diperlukan. Setelah keputusan dikonfirmasi, implementasikan fase demi fase dengan test dan laporan yang jelas.
