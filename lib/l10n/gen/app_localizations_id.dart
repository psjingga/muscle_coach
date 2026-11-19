// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get tabHome => 'Beranda';

  @override
  String get tabWorkout => 'Latihan';

  @override
  String get tabNutrition => 'Nutrisi';

  @override
  String get tabProgress => 'Progres';

  @override
  String get tabProfile => 'Profil';

  @override
  String get cancel => 'Batal';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Kata sandi';

  @override
  String get confirmPasswordLabel => 'Ulangi kata sandi';

  @override
  String get showPassword => 'Tampilkan kata sandi';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String loginTitle(String appName) {
    return 'Masuk ke $appName';
  }

  @override
  String get loginSubtitle => 'Lanjutkan program latihan dan catatan progres Anda.';

  @override
  String get loginButton => 'Masuk';

  @override
  String get forgotPasswordLink => 'Lupa kata sandi?';

  @override
  String get createAccountButton => 'Buat akun baru';

  @override
  String get registerTitle => 'Buat akun';

  @override
  String get registerSubtitle => 'Satu akun untuk menyimpan assessment, program, dan progres Anda.';

  @override
  String passwordRule(int min) {
    return 'Minimal $min karakter, berisi huruf dan angka.';
  }

  @override
  String get registerButton => 'Daftar';

  @override
  String get registerSuccess => 'Akun dibuat. Kami mengirim tautan verifikasi ke email Anda.';

  @override
  String get forgotPasswordTitle => 'Atur ulang kata sandi';

  @override
  String get forgotPasswordSubtitle =>
      'Masukkan email akun Anda. Kami akan mengirim tautan untuk membuat kata sandi baru.';

  @override
  String get forgotPasswordSent =>
      'Jika email tersebut terdaftar, tautan atur ulang sudah dikirim. Periksa juga folder spam.';

  @override
  String get forgotPasswordButton => 'Kirim tautan';

  @override
  String get forgotPasswordResend => 'Kirim ulang tautan';

  @override
  String get validationEmailRequired => 'Email wajib diisi.';

  @override
  String get validationEmailInvalid => 'Format email tidak valid.';

  @override
  String get validationPasswordRequired => 'Kata sandi wajib diisi.';

  @override
  String validationPasswordTooShort(int min) {
    return 'Kata sandi minimal $min karakter.';
  }

  @override
  String get validationPasswordTooWeak => 'Kata sandi harus berisi huruf dan angka.';

  @override
  String get validationPasswordMismatch => 'Kata sandi tidak sama.';

  @override
  String get errorNetwork => 'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.';

  @override
  String get errorUnauthenticated => 'Sesi Anda berakhir. Silakan masuk kembali.';

  @override
  String get errorPermissionDenied => 'Anda tidak memiliki akses untuk tindakan ini.';

  @override
  String get errorNotFound => 'Data tidak ditemukan.';

  @override
  String get errorInvalidInput => 'Data yang dikirim tidak valid.';

  @override
  String get errorQuotaExceeded => 'Batas penggunaan tercapai. Coba lagi nanti.';

  @override
  String get errorUnavailable => 'Layanan sedang tidak tersedia. Coba lagi beberapa saat lagi.';

  @override
  String get errorTimeout => 'Permintaan terlalu lama. Coba lagi.';

  @override
  String get errorInvalidCredentials => 'Email atau kata sandi salah.';

  @override
  String get errorEmailInUse =>
      'Email ini sudah terdaftar. Silakan masuk atau atur ulang kata sandi.';

  @override
  String get errorWeakPassword => 'Kata sandi terlalu lemah.';

  @override
  String get errorTooManyRequests => 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';

  @override
  String get errorRequiresRecentLogin => 'Demi keamanan, masukkan kata sandi Anda lagi.';

  @override
  String get errorUserDisabled => 'Akun ini dinonaktifkan.';

  @override
  String get errorUnknown => 'Terjadi kesalahan. Coba lagi.';

  @override
  String get emptyHomeTitle => 'Selamat datang!';

  @override
  String get emptyHomeMessage =>
      'Ringkasan harian — latihan berikutnya, sisa kalori & makro, dan check-in — akan tampil di sini setelah assessment dan program Anda siap.';

  @override
  String get emptyWorkoutTitle => 'Belum ada program latihan';

  @override
  String get emptyWorkoutMessage =>
      'Program mingguan dan pencatatan set akan tersedia setelah assessment selesai.';

  @override
  String get emptyNutritionTitle => 'Belum ada target nutrisi';

  @override
  String get emptyNutritionMessage =>
      'Target kalori & makro, menu, dan catatan makanan akan tersedia setelah assessment selesai.';

  @override
  String get emptyProgressTitle => 'Belum ada data progres';

  @override
  String get emptyProgressMessage =>
      'Grafik berat badan, performa latihan, dan ringkasan mingguan akan muncul setelah Anda mulai mencatat.';

  @override
  String get accountSection => 'Akun';

  @override
  String get emailVerified => 'Email terverifikasi';

  @override
  String get emailNotVerified =>
      'Email belum diverifikasi. Buka tautan yang kami kirim ke email Anda.';

  @override
  String get resendVerification => 'Kirim ulang verifikasi';

  @override
  String get checkVerification => 'Saya sudah verifikasi';

  @override
  String get verificationSent => 'Email verifikasi dikirim.';

  @override
  String get signOut => 'Keluar';

  @override
  String get signOutConfirmTitle => 'Keluar dari akun?';

  @override
  String get signOutConfirmMessage =>
      'Anda perlu masuk lagi untuk melihat program dan progres Anda.';

  @override
  String get dangerZone => 'Zona berbahaya';

  @override
  String get deleteAccount => 'Hapus akun dan semua data';

  @override
  String get deleteAccountTitle => 'Hapus akun?';

  @override
  String get deleteAccountMessage =>
      'Seluruh data Anda — assessment, program, catatan latihan & makanan, dan progres — akan dihapus permanen dan tidak dapat dipulihkan.';

  @override
  String get deleteAccountPasswordLabel => 'Kata sandi untuk konfirmasi';

  @override
  String get deleteAccountConfirm => 'Hapus permanen';
}
