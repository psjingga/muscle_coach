import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('id')];

  /// No description provided for @tabHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get tabHome;

  /// No description provided for @tabWorkout.
  ///
  /// In id, this message translates to:
  /// **'Latihan'**
  String get tabWorkout;

  /// No description provided for @tabNutrition.
  ///
  /// In id, this message translates to:
  /// **'Nutrisi'**
  String get tabNutrition;

  /// No description provided for @tabProgress.
  ///
  /// In id, this message translates to:
  /// **'Progres'**
  String get tabProgress;

  /// No description provided for @tabProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get tabProfile;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @emailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In id, this message translates to:
  /// **'Ulangi kata sandi'**
  String get confirmPasswordLabel;

  /// No description provided for @showPassword.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan kata sandi'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan kata sandi'**
  String get hidePassword;

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke {appName}'**
  String loginTitle(String appName);

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan program latihan dan catatan progres Anda.'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginButton;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In id, this message translates to:
  /// **'Lupa kata sandi?'**
  String get forgotPasswordLink;

  /// No description provided for @createAccountButton.
  ///
  /// In id, this message translates to:
  /// **'Buat akun baru'**
  String get createAccountButton;

  /// No description provided for @registerTitle.
  ///
  /// In id, this message translates to:
  /// **'Buat akun'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Satu akun untuk menyimpan assessment, program, dan progres Anda.'**
  String get registerSubtitle;

  /// No description provided for @passwordRule.
  ///
  /// In id, this message translates to:
  /// **'Minimal {min} karakter, berisi huruf dan angka.'**
  String passwordRule(int min);

  /// No description provided for @registerButton.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerButton;

  /// No description provided for @registerSuccess.
  ///
  /// In id, this message translates to:
  /// **'Akun dibuat. Kami mengirim tautan verifikasi ke email Anda.'**
  String get registerSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In id, this message translates to:
  /// **'Atur ulang kata sandi'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan email akun Anda. Kami akan mengirim tautan untuk membuat kata sandi baru.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordSent.
  ///
  /// In id, this message translates to:
  /// **'Jika email tersebut terdaftar, tautan atur ulang sudah dikirim. Periksa juga folder spam.'**
  String get forgotPasswordSent;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In id, this message translates to:
  /// **'Kirim tautan'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordResend.
  ///
  /// In id, this message translates to:
  /// **'Kirim ulang tautan'**
  String get forgotPasswordResend;

  /// No description provided for @validationEmailRequired.
  ///
  /// In id, this message translates to:
  /// **'Email wajib diisi.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi wajib diisi.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi minimal {min} karakter.'**
  String validationPasswordTooShort(int min);

  /// No description provided for @validationPasswordTooWeak.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi harus berisi huruf dan angka.'**
  String get validationPasswordTooWeak;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi tidak sama.'**
  String get validationPasswordMismatch;

  /// No description provided for @errorNetwork.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.'**
  String get errorNetwork;

  /// No description provided for @errorUnauthenticated.
  ///
  /// In id, this message translates to:
  /// **'Sesi Anda berakhir. Silakan masuk kembali.'**
  String get errorUnauthenticated;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In id, this message translates to:
  /// **'Anda tidak memiliki akses untuk tindakan ini.'**
  String get errorPermissionDenied;

  /// No description provided for @errorNotFound.
  ///
  /// In id, this message translates to:
  /// **'Data tidak ditemukan.'**
  String get errorNotFound;

  /// No description provided for @errorInvalidInput.
  ///
  /// In id, this message translates to:
  /// **'Data yang dikirim tidak valid.'**
  String get errorInvalidInput;

  /// No description provided for @errorQuotaExceeded.
  ///
  /// In id, this message translates to:
  /// **'Batas penggunaan tercapai. Coba lagi nanti.'**
  String get errorQuotaExceeded;

  /// No description provided for @errorUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Layanan sedang tidak tersedia. Coba lagi beberapa saat lagi.'**
  String get errorUnavailable;

  /// No description provided for @errorTimeout.
  ///
  /// In id, this message translates to:
  /// **'Permintaan terlalu lama. Coba lagi.'**
  String get errorTimeout;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In id, this message translates to:
  /// **'Email atau kata sandi salah.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailInUse.
  ///
  /// In id, this message translates to:
  /// **'Email ini sudah terdaftar. Silakan masuk atau atur ulang kata sandi.'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi terlalu lemah.'**
  String get errorWeakPassword;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.'**
  String get errorTooManyRequests;

  /// No description provided for @errorRequiresRecentLogin.
  ///
  /// In id, this message translates to:
  /// **'Demi keamanan, masukkan kata sandi Anda lagi.'**
  String get errorRequiresRecentLogin;

  /// No description provided for @errorUserDisabled.
  ///
  /// In id, this message translates to:
  /// **'Akun ini dinonaktifkan.'**
  String get errorUserDisabled;

  /// No description provided for @errorUnknown.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Coba lagi.'**
  String get errorUnknown;

  /// No description provided for @emptyHomeTitle.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang!'**
  String get emptyHomeTitle;

  /// No description provided for @emptyHomeMessage.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan harian — latihan berikutnya, sisa kalori & makro, dan check-in — akan tampil di sini setelah assessment dan program Anda siap.'**
  String get emptyHomeMessage;

  /// No description provided for @emptyWorkoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada program latihan'**
  String get emptyWorkoutTitle;

  /// No description provided for @emptyWorkoutMessage.
  ///
  /// In id, this message translates to:
  /// **'Program mingguan dan pencatatan set akan tersedia setelah assessment selesai.'**
  String get emptyWorkoutMessage;

  /// No description provided for @emptyNutritionTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada target nutrisi'**
  String get emptyNutritionTitle;

  /// No description provided for @emptyNutritionMessage.
  ///
  /// In id, this message translates to:
  /// **'Target kalori & makro, menu, dan catatan makanan akan tersedia setelah assessment selesai.'**
  String get emptyNutritionMessage;

  /// No description provided for @emptyProgressTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data progres'**
  String get emptyProgressTitle;

  /// No description provided for @emptyProgressMessage.
  ///
  /// In id, this message translates to:
  /// **'Grafik berat badan, performa latihan, dan ringkasan mingguan akan muncul setelah Anda mulai mencatat.'**
  String get emptyProgressMessage;

  /// No description provided for @accountSection.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get accountSection;

  /// No description provided for @emailVerified.
  ///
  /// In id, this message translates to:
  /// **'Email terverifikasi'**
  String get emailVerified;

  /// No description provided for @emailNotVerified.
  ///
  /// In id, this message translates to:
  /// **'Email belum diverifikasi. Buka tautan yang kami kirim ke email Anda.'**
  String get emailNotVerified;

  /// No description provided for @resendVerification.
  ///
  /// In id, this message translates to:
  /// **'Kirim ulang verifikasi'**
  String get resendVerification;

  /// No description provided for @checkVerification.
  ///
  /// In id, this message translates to:
  /// **'Saya sudah verifikasi'**
  String get checkVerification;

  /// No description provided for @verificationSent.
  ///
  /// In id, this message translates to:
  /// **'Email verifikasi dikirim.'**
  String get verificationSent;

  /// No description provided for @signOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get signOut;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari akun?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In id, this message translates to:
  /// **'Anda perlu masuk lagi untuk melihat program dan progres Anda.'**
  String get signOutConfirmMessage;

  /// No description provided for @dangerZone.
  ///
  /// In id, this message translates to:
  /// **'Zona berbahaya'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In id, this message translates to:
  /// **'Hapus akun dan semua data'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus akun?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In id, this message translates to:
  /// **'Seluruh data Anda — assessment, program, catatan latihan & makanan, dan progres — akan dihapus permanen dan tidak dapat dipulihkan.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountPasswordLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi untuk konfirmasi'**
  String get deleteAccountPasswordLabel;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In id, this message translates to:
  /// **'Hapus permanen'**
  String get deleteAccountConfirm;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
