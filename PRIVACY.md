# Privasi & keamanan data — Muscle Coach

Dokumen ini menjelaskan data apa yang disimpan aplikasi, ke mana data dikirim, dan cara menghapusnya. Berlaku untuk versi lokal (tanpa akun/server) per 20 November 2026.

## Ringkasan

- **Semua data tersimpan di perangkat** dalam basis data SQLite di folder privat aplikasi. Tidak ada akun, server, analitik, atau pelacakan.
- **Satu-satunya data yang keluar dari perangkat** adalah permintaan ke Google Gemini, dan hanya bila pengguna sendiri memasukkan API key, menyetujui pemrosesan data, lalu menekan tombol "… dengan AI".
- Data **tidak ikut cadangan cloud** (Google Drive/iCloud). Akibatnya, data hilang bila aplikasi dihapus atau perangkat hilang.

## Data yang disimpan di perangkat

| Data | Tabel | Sifat |
|---|---|---|
| Assessment (usia/tanggal lahir, jenis kelamin opsional, tinggi, berat, tujuan, pengalaman, jadwal, alat, aktivitas, pola makan, alergi, kondisi medis opsional, cedera) | `assessments` | Sensitif (kesehatan) |
| Target & kalkulasi (BMR/TDEE/makro), status keselamatan | `goals`, `nutrition_targets` | Turunan data kesehatan |
| Program & sesi latihan, set aktual, catatan nyeri | `workout_plans`, `plan_days`, `workout_sessions`, `set_logs` | Sensitif |
| Catatan makanan, makanan sendiri, menu | `food_logs`, `custom_foods`, `meal_plans` | Sensitif |
| Berat badan, check-in (tidur, energi, suasana hati, nyeri, catatan), ringkasan mingguan | `body_metrics`, `daily_check_ins`, `weekly_reviews` | Sensitif |
| Persetujuan, preferensi pengingat | `consents`, `app_settings` | — |
| Log pemanggilan AI: jenis, model, versi prompt, status, durasi, jumlah token, kode error — **tanpa isi prompt/jawaban** | `ai_generation_logs` | Metadata |
| API key Gemini & pilihan model | Android Keystore / iOS Keychain (`this device only`) | Rahasia |

Log aplikasi (logcat/Xcode) hanya berisi kode error teknis, tanpa data kesehatan atau makanan. Build rilis hanya mencatat peringatan dan error.

## Data yang dikirim ke Google Gemini

Dikirim lewat HTTPS dengan API key di header (bukan di URL). Isi permintaan dibatasi pada konteks minimum:

| Fitur | Yang dikirim | Yang **tidak** dikirim |
|---|---|---|
| Program latihan (`workout_plan.v1`) | tujuan, level, pengalaman, hari & durasi, alat & beban maks., otot prioritas, preferensi latihan, catatan cedera/gerakan dihindari, flag mode konservatif, katalog gerakan | nama, umur/tanggal lahir, tinggi, berat, jenis kelamin, jenis kondisi medis |
| Menu harian (`meal_plan.v2`) | target kalori & makro, jumlah waktu makan, pola makan, alergi, makanan tidak disukai, preferensi, anggaran, akses memasak, catatan pola makan, daftar bahan TKPI | nama, umur, tinggi, berat, jenis kelamin, kondisi medis |
| Ringkasan mingguan (`weekly_review.v1`) | tujuan, level, status target, **perubahan** rata-rata berat, kepatuhan latihan & makan (persen), rata-rata tidur & energi, jumlah hari ada keluhan nyeri | berat absolut, isi catatan/keluhan, nama, umur |

Catatan: pada tier gratis Gemini, Google dapat memakai isi permintaan untuk meningkatkan produknya (lihat ketentuan Google AI Studio). Persetujuan di Pengaturan AI menjelaskan hal ini, dan bisa dicabut kapan saja.

Hasil AI selalu divalidasi aplikasi sebelum disimpan sebagai **draft**, lalu baru dipakai setelah pengguna menyetujuinya. AI tidak pernah mengubah target, program aktif, atau jadwal notifikasi secara otomatis.

## Perlindungan

- **Android**:
  - Cadangan cloud dimatikan untuk basis data, preferensi, dan file (`data_extraction_rules.xml`, `backup_rules.xml`).
  - Pindah perangkat langsung (kabel/Wi-Fi, terenkripsi) membawa basis data, tapi tidak membawa key.
  - Lalu lintas HTTP tanpa enkripsi ditolak.
  - Tidak ada izin selain internet, notifikasi, dan jadwal ulang setelah reboot (tanpa *exact alarm*).
- **iOS**: API key di Keychain dengan akses `first_unlock_this_device` (tidak ikut cadangan, tidak pindah perangkat). App Transport Security bawaan (HTTPS saja).
- **Basis data**:
  - Berada di sandbox aplikasi dan dilindungi enkripsi perangkat (aktif bila HP memakai kunci layar). Basis data sendiri tidak dienkripsi terpisah (lihat "Keterbatasan").
  - `PRAGMA secure_delete` aktif, sehingga baris yang dihapus ditimpa.
- **Kuota AI**: maks. 10 pemanggilan per hari (lokal), timeout 120 dtk, maks. 1 retry.

## Penghapusan & retensi

- **Profil → Hapus semua data**: mengosongkan semua tabel, menjalankan `VACUUM`, menghapus API key, dan membatalkan semua notifikasi. Tidak bisa dibatalkan.
- Menghapus aplikasi menghapus seluruh data aplikasi dari perangkat.
- Data disimpan sampai pengguna menghapusnya; tidak ada penghapusan otomatis.
- Data yang sudah dikirim ke Gemini tunduk pada kebijakan Google; aplikasi tidak menyimpan salinan prompt.

## Keterbatasan & keputusan terbuka

- Basis data SQLite **tidak dienkripsi tersendiri** (mis. SQLCipher). Untuk penggunaan pribadi, sandbox + enkripsi perangkat dianggap cukup. Tinjau ulang bila aplikasi dirilis publik.
- Belum ada ekspor/impor cadangan manual.
- Data TKPI dipakai dengan atribusi; lisensi resmi perlu ditinjau sebelum rilis publik.
- Rilis publik membutuhkan kebijakan privasi resmi, penanganan permintaan pengguna, dan penilaian kepatuhan (mis. UU PDP Indonesia untuk data kesehatan).
