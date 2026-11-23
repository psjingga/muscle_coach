# Privasi & keamanan data — Muscle Coach

Dokumen ini menjelaskan data apa yang disimpan aplikasi, ke mana data dikirim, dan cara menghapusnya. Berlaku untuk versi lokal (tanpa akun/server) per 23 November 2026.

## Ringkasan

- **Semua data tersimpan di perangkat** dalam basis data SQLite di folder privat aplikasi. Tidak ada akun, server, analitik, atau pelacakan.
- **Satu-satunya data yang keluar dari perangkat** adalah permintaan ke Google Gemini (termasuk foto makanan saat memakai *Scan makanan*), dan hanya bila pengguna sendiri memasukkan API key, menyetujui pemrosesan data, lalu menekan tombol "… dengan AI".
- Data **tidak ikut cadangan cloud** (Google Drive/iCloud). Akibatnya, data hilang bila aplikasi dihapus atau perangkat hilang.

## Data yang disimpan di perangkat

| Data | Tabel | Sifat |
|---|---|---|
| Assessment (usia/tanggal lahir, jenis kelamin opsional, tinggi, berat, tujuan, pengalaman, jadwal, alat, aktivitas, pola makan, alergi, kondisi medis opsional, cedera) | `assessments` | Sensitif (kesehatan) |
| Target & kalkulasi (BMR/TDEE/makro), status keselamatan | `goals`, `nutrition_targets` | Turunan data kesehatan |
| Program & sesi latihan, set aktual, catatan nyeri | `workout_plans`, `plan_days`, `workout_sessions`, `set_logs` | Sensitif |
| Catatan makanan, makanan sendiri, menu | `food_logs`, `custom_foods`, `meal_plans` | Sensitif |
| Berat badan, check-in (tidur, energi, suasana hati, nyeri, catatan), ringkasan mingguan | `body_metrics`, `daily_check_ins`, `weekly_reviews` | Sensitif |
| Lingkar badan (pinggang, dada, lengan, paha, pinggul) | `body_measurements` | Sensitif |
| Foto progres: metadata (tanggal, pose) di basis data, berkas JPG di folder privat `progress_photos` | `progress_photos` + berkas | **Sangat sensitif**; tidak pernah dikirim ke AI |
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
| Scan makanan (`food_scan.v1`) | foto makanan yang diambil/dipilih pengguna (diperkecil, tanpa metadata lengkap), daftar kode & nama bahan TKPI | nama, umur, berat, data kesehatan lain. Foto **tidak disimpan** aplikasi: berkas sementara dihapus setelah dicatat/dibatalkan/gagal |
| Ringkasan mingguan (`weekly_review.v1`) | tujuan, level, status target, **perubahan** rata-rata berat, kepatuhan latihan & makan (persen), rata-rata tidur & energi, jumlah hari ada keluhan nyeri | berat absolut, isi catatan/keluhan, nama, umur |

Catatan: pada tier gratis Gemini, Google dapat memakai isi permintaan untuk meningkatkan produknya (lihat ketentuan Google AI Studio). Persetujuan di Pengaturan AI menjelaskan hal ini, dan bisa dicabut kapan saja.

Hasil AI selalu divalidasi aplikasi sebelum disimpan sebagai **draft**, lalu baru dipakai setelah pengguna menyetujuinya. Hasil scan makanan ditinjau dulu (gram bisa diubah, item bisa dihapus); gizi item yang cocok dengan TKPI dihitung dari katalog, sisanya dicatat dengan label *Estimasi AI*. AI tidak pernah mengubah target, program aktif, atau jadwal notifikasi secara otomatis.

## Perlindungan

- **Android**:
  - Cadangan cloud dimatikan untuk basis data, preferensi, dan file (`data_extraction_rules.xml`, `backup_rules.xml`).
  - Pindah perangkat langsung (kabel/Wi-Fi, terenkripsi) membawa basis data, tapi tidak membawa key.
  - Lalu lintas HTTP tanpa enkripsi ditolak.
  - Tidak ada izin selain internet, notifikasi, dan jadwal ulang setelah reboot (tanpa *exact alarm*).
- **iOS**: API key di Keychain dengan akses `first_unlock_this_device` (tidak ikut cadangan, tidak pindah perangkat). Folder basis data (Documents) dan foto (Application Support) ditandai *exclude from backup* saat aplikasi dibuka, sehingga tidak ikut cadangan iCloud/komputer. App Transport Security bawaan (HTTPS saja).
- **Foto progres**: diambil lewat kamera/galeri sistem (Android tanpa izin tambahan; iOS meminta izin kamera/galeri saat dipakai), diperkecil & dikompres ulang tanpa metadata lengkap, lalu disalin ke folder privat aplikasi. Tidak dikirim ke Gemini maupun layanan lain.
- **Basis data**:
  - Berada di sandbox aplikasi dan dilindungi enkripsi perangkat (aktif bila HP memakai kunci layar). Basis data sendiri tidak dienkripsi terpisah (lihat "Keterbatasan").
  - `PRAGMA secure_delete` aktif, sehingga baris yang dihapus ditimpa.
- **Kuota AI**: maks. 10 pemanggilan per hari (lokal), timeout 120 dtk, maks. 1 retry.

## Cadangan (ekspor/impor)

- **Profil → Cadangkan data** membuat satu berkas `.mcbackup` berisi salinan basis data (`VACUUM INTO`), foto progres, dan manifest, lalu **dienkripsi AES-256-GCM** dengan kunci dari kata sandi pengguna (PBKDF2-HMAC-SHA256, 210.000 iterasi, salt acak). Header ikut diautentikasi; berkas yang diubah atau kata sandi salah ditolak.
- Berkas dibagikan lewat lembar bagikan sistem (Files, Drive, WhatsApp, dll.) — **tujuan sepenuhnya pilihan pengguna**; aplikasi tidak mengunggah ke mana pun. Kata sandi tidak disimpan dan tidak bisa dipulihkan.
- **API key Gemini tidak ikut dicadangkan** (tetap di Keystore/Keychain); di perangkat baru key perlu dimasukkan lagi.
- **Profil → Pulihkan dari cadangan** memeriksa berkas (kata sandi, format, versi skema) sebelum mengganti data; cadangan dari versi aplikasi yang lebih baru ditolak. Setelah dipulihkan, aplikasi dimuat ulang dan migrasi basis data berjalan otomatis bila cadangan berasal dari versi lama.
- Berkas sementara ada di folder cache aplikasi dan diganti setiap kali membuat cadangan baru.

## Penghapusan & retensi

- **Profil → Hapus semua data**: mengosongkan semua tabel, menjalankan `VACUUM`, menghapus folder foto progres, menghapus API key, dan membatalkan semua notifikasi. Tidak bisa dibatalkan.
- Menghapus aplikasi menghapus seluruh data aplikasi dari perangkat.
- Data disimpan sampai pengguna menghapusnya; tidak ada penghapusan otomatis.
- Data yang sudah dikirim ke Gemini tunduk pada kebijakan Google; aplikasi tidak menyimpan salinan prompt.

## Keterbatasan & keputusan terbuka

- Basis data SQLite **tidak dienkripsi tersendiri** (mis. SQLCipher). Untuk penggunaan pribadi, sandbox + enkripsi perangkat dianggap cukup. Tinjau ulang bila aplikasi dirilis publik.
- Data TKPI dipakai dengan atribusi; lisensi resmi perlu ditinjau sebelum rilis publik.
- Rilis publik membutuhkan kebijakan privasi resmi, penanganan permintaan pengguna, dan penilaian kepatuhan (mis. UU PDP Indonesia untuk data kesehatan).
