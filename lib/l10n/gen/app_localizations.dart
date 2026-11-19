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

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get retry;

  /// No description provided for @next.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get next;

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get back;

  /// No description provided for @optionalSuffix.
  ///
  /// In id, this message translates to:
  /// **'opsional'**
  String get optionalSuffix;

  /// No description provided for @unitCm.
  ///
  /// In id, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitKg.
  ///
  /// In id, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitWeeks.
  ///
  /// In id, this message translates to:
  /// **'minggu'**
  String get unitWeeks;

  /// No description provided for @unitHours.
  ///
  /// In id, this message translates to:
  /// **'jam'**
  String get unitHours;

  /// No description provided for @unitPerWeek.
  ///
  /// In id, this message translates to:
  /// **'kali/minggu'**
  String get unitPerWeek;

  /// No description provided for @unitIdr.
  ///
  /// In id, this message translates to:
  /// **'Rp'**
  String get unitIdr;

  /// No description provided for @onboardingTitle.
  ///
  /// In id, this message translates to:
  /// **'Mari kenali Anda dulu'**
  String get onboardingTitle;

  /// No description provided for @onboardingMessage.
  ///
  /// In id, this message translates to:
  /// **'Kami akan menanyakan 7 bagian singkat: profil, tujuan, pengalaman, jadwal & alat, aktivitas, pola makan, dan keselamatan. Sekitar 5–8 menit, dan jawaban tersimpan sebagai draft.'**
  String get onboardingMessage;

  /// No description provided for @onboardingPoint1.
  ///
  /// In id, this message translates to:
  /// **'Kebutuhan kalori & makro dihitung dengan rumus terdokumentasi, bukan oleh AI.'**
  String get onboardingPoint1;

  /// No description provided for @onboardingPoint2.
  ///
  /// In id, this message translates to:
  /// **'Anda melihat asumsi perhitungan dan menyetujui target sebelum dipakai.'**
  String get onboardingPoint2;

  /// No description provided for @onboardingPoint3.
  ///
  /// In id, this message translates to:
  /// **'Data Anda privat dan dapat dihapus kapan saja dari Profil.'**
  String get onboardingPoint3;

  /// No description provided for @disclaimerShort.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi bersifat edukatif dan tidak menggantikan dokter, ahli gizi, atau personal trainer.'**
  String get disclaimerShort;

  /// No description provided for @startAssessment.
  ///
  /// In id, this message translates to:
  /// **'Mulai assessment'**
  String get startAssessment;

  /// No description provided for @continueAssessment.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan assessment'**
  String get continueAssessment;

  /// No description provided for @assessmentTitle.
  ///
  /// In id, this message translates to:
  /// **'Assessment awal'**
  String get assessmentTitle;

  /// No description provided for @assessmentStepCounter.
  ///
  /// In id, this message translates to:
  /// **'Langkah {current} dari {total}'**
  String assessmentStepCounter(Object current, Object total);

  /// No description provided for @stepProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil dasar'**
  String get stepProfile;

  /// No description provided for @stepGoal.
  ///
  /// In id, this message translates to:
  /// **'Tujuan'**
  String get stepGoal;

  /// No description provided for @stepExperience.
  ///
  /// In id, this message translates to:
  /// **'Pengalaman latihan'**
  String get stepExperience;

  /// No description provided for @stepAvailability.
  ///
  /// In id, this message translates to:
  /// **'Jadwal & peralatan'**
  String get stepAvailability;

  /// No description provided for @stepActivity.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas & pemulihan'**
  String get stepActivity;

  /// No description provided for @stepNutrition.
  ///
  /// In id, this message translates to:
  /// **'Pola makan'**
  String get stepNutrition;

  /// No description provided for @stepSafety.
  ///
  /// In id, this message translates to:
  /// **'Keselamatan & persetujuan'**
  String get stepSafety;

  /// No description provided for @draftSavedHint.
  ///
  /// In id, this message translates to:
  /// **'Jawaban tersimpan sebagai draft setiap kali Anda lanjut.'**
  String get draftSavedHint;

  /// No description provided for @submitAssessment.
  ///
  /// In id, this message translates to:
  /// **'Hitung target saya'**
  String get submitAssessment;

  /// No description provided for @fieldNickname.
  ///
  /// In id, this message translates to:
  /// **'Nama panggilan (opsional)'**
  String get fieldNickname;

  /// No description provided for @fieldBirthDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal lahir'**
  String get fieldBirthDate;

  /// No description provided for @birthDateHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal'**
  String get birthDateHint;

  /// No description provided for @ageYears.
  ///
  /// In id, this message translates to:
  /// **'{age} tahun'**
  String ageYears(Object age);

  /// No description provided for @fieldSex.
  ///
  /// In id, this message translates to:
  /// **'Jenis kelamin biologis'**
  String get fieldSex;

  /// No description provided for @sexHelp.
  ///
  /// In id, this message translates to:
  /// **'Hanya dipakai untuk rumus energi. Bila tidak ingin menjawab, kami tampilkan rentang perkiraan.'**
  String get sexHelp;

  /// No description provided for @sexMale.
  ///
  /// In id, this message translates to:
  /// **'Laki-laki'**
  String get sexMale;

  /// No description provided for @sexFemale.
  ///
  /// In id, this message translates to:
  /// **'Perempuan'**
  String get sexFemale;

  /// No description provided for @sexUndisclosed.
  ///
  /// In id, this message translates to:
  /// **'Tidak ingin menjawab'**
  String get sexUndisclosed;

  /// No description provided for @fieldHeight.
  ///
  /// In id, this message translates to:
  /// **'Tinggi badan'**
  String get fieldHeight;

  /// No description provided for @fieldWeight.
  ///
  /// In id, this message translates to:
  /// **'Berat badan saat ini'**
  String get fieldWeight;

  /// No description provided for @fieldPrimaryGoal.
  ///
  /// In id, this message translates to:
  /// **'Tujuan utama'**
  String get fieldPrimaryGoal;

  /// No description provided for @goalMuscleGain.
  ///
  /// In id, this message translates to:
  /// **'Menambah massa otot'**
  String get goalMuscleGain;

  /// No description provided for @goalStrength.
  ///
  /// In id, this message translates to:
  /// **'Meningkatkan kekuatan'**
  String get goalStrength;

  /// No description provided for @goalRecomposition.
  ///
  /// In id, this message translates to:
  /// **'Body recomposition'**
  String get goalRecomposition;

  /// No description provided for @recompositionHelp.
  ///
  /// In id, this message translates to:
  /// **'Recomposition: menambah otot dengan berat badan relatif stabil.'**
  String get recompositionHelp;

  /// No description provided for @fieldTargetWeight.
  ///
  /// In id, this message translates to:
  /// **'Berat badan target (opsional)'**
  String get fieldTargetWeight;

  /// No description provided for @targetWeightHelp.
  ///
  /// In id, this message translates to:
  /// **'Kosongkan bila target utama Anda bukan angka berat badan.'**
  String get targetWeightHelp;

  /// No description provided for @fieldTargetWeeks.
  ///
  /// In id, this message translates to:
  /// **'Target waktu'**
  String get fieldTargetWeeks;

  /// No description provided for @targetWeeksHelp.
  ///
  /// In id, this message translates to:
  /// **'4–104 minggu. Perkiraan tanggal: {date}'**
  String targetWeeksHelp(Object date);

  /// No description provided for @fieldPriorityMuscles.
  ///
  /// In id, this message translates to:
  /// **'Otot prioritas (opsional)'**
  String get fieldPriorityMuscles;

  /// No description provided for @muscleChest.
  ///
  /// In id, this message translates to:
  /// **'Dada'**
  String get muscleChest;

  /// No description provided for @muscleBack.
  ///
  /// In id, this message translates to:
  /// **'Punggung'**
  String get muscleBack;

  /// No description provided for @muscleShoulders.
  ///
  /// In id, this message translates to:
  /// **'Bahu'**
  String get muscleShoulders;

  /// No description provided for @muscleArms.
  ///
  /// In id, this message translates to:
  /// **'Lengan'**
  String get muscleArms;

  /// No description provided for @muscleLegs.
  ///
  /// In id, this message translates to:
  /// **'Kaki'**
  String get muscleLegs;

  /// No description provided for @muscleGlutes.
  ///
  /// In id, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleCore.
  ///
  /// In id, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @fieldMotivation.
  ///
  /// In id, this message translates to:
  /// **'Motivasi atau ekspektasi (opsional)'**
  String get fieldMotivation;

  /// No description provided for @fieldLevel.
  ///
  /// In id, this message translates to:
  /// **'Level latihan beban'**
  String get fieldLevel;

  /// No description provided for @levelBeginner.
  ///
  /// In id, this message translates to:
  /// **'Pemula'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In id, this message translates to:
  /// **'Menengah'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In id, this message translates to:
  /// **'Berpengalaman'**
  String get levelAdvanced;

  /// No description provided for @fieldTrainingAge.
  ///
  /// In id, this message translates to:
  /// **'Sudah berapa lama latihan beban?'**
  String get fieldTrainingAge;

  /// No description provided for @trainingAgeNone.
  ///
  /// In id, this message translates to:
  /// **'Belum pernah'**
  String get trainingAgeNone;

  /// No description provided for @trainingAgeUnder6Months.
  ///
  /// In id, this message translates to:
  /// **'< 6 bulan'**
  String get trainingAgeUnder6Months;

  /// No description provided for @trainingAge6mTo2y.
  ///
  /// In id, this message translates to:
  /// **'6 bulan – 2 tahun'**
  String get trainingAge6mTo2y;

  /// No description provided for @trainingAge2To5y.
  ///
  /// In id, this message translates to:
  /// **'2–5 tahun'**
  String get trainingAge2To5y;

  /// No description provided for @trainingAgeOver5y.
  ///
  /// In id, this message translates to:
  /// **'> 5 tahun'**
  String get trainingAgeOver5y;

  /// No description provided for @fieldCurrentSessions.
  ///
  /// In id, this message translates to:
  /// **'Frekuensi latihan saat ini'**
  String get fieldCurrentSessions;

  /// No description provided for @fieldKnownExercises.
  ///
  /// In id, this message translates to:
  /// **'Gerakan yang sudah dikuasai (opsional)'**
  String get fieldKnownExercises;

  /// No description provided for @knownExercisesHint.
  ///
  /// In id, this message translates to:
  /// **'mis. squat, bench press, dumbbell row'**
  String get knownExercisesHint;

  /// No description provided for @fieldWorkingWeights.
  ///
  /// In id, this message translates to:
  /// **'Beban kerja / PR yang diketahui (opsional)'**
  String get fieldWorkingWeights;

  /// No description provided for @workingWeightsHint.
  ///
  /// In id, this message translates to:
  /// **'mis. bench press 50 kg × 8. Tidak wajib untuk pemula.'**
  String get workingWeightsHint;

  /// No description provided for @fieldTrainingDays.
  ///
  /// In id, this message translates to:
  /// **'Hari yang bisa dipakai latihan'**
  String get fieldTrainingDays;

  /// No description provided for @weekday1.
  ///
  /// In id, this message translates to:
  /// **'Sen'**
  String get weekday1;

  /// No description provided for @weekday2.
  ///
  /// In id, this message translates to:
  /// **'Sel'**
  String get weekday2;

  /// No description provided for @weekday3.
  ///
  /// In id, this message translates to:
  /// **'Rab'**
  String get weekday3;

  /// No description provided for @weekday4.
  ///
  /// In id, this message translates to:
  /// **'Kam'**
  String get weekday4;

  /// No description provided for @weekday5.
  ///
  /// In id, this message translates to:
  /// **'Jum'**
  String get weekday5;

  /// No description provided for @weekday6.
  ///
  /// In id, this message translates to:
  /// **'Sab'**
  String get weekday6;

  /// No description provided for @weekday7.
  ///
  /// In id, this message translates to:
  /// **'Min'**
  String get weekday7;

  /// No description provided for @fieldSessionMinutes.
  ///
  /// In id, this message translates to:
  /// **'Durasi per sesi'**
  String get fieldSessionMinutes;

  /// No description provided for @minutesValue.
  ///
  /// In id, this message translates to:
  /// **'{minutes} menit'**
  String minutesValue(Object minutes);

  /// No description provided for @fieldLocation.
  ///
  /// In id, this message translates to:
  /// **'Lokasi latihan'**
  String get fieldLocation;

  /// No description provided for @locationHome.
  ///
  /// In id, this message translates to:
  /// **'Rumah'**
  String get locationHome;

  /// No description provided for @locationGym.
  ///
  /// In id, this message translates to:
  /// **'Gym'**
  String get locationGym;

  /// No description provided for @fieldEquipment.
  ///
  /// In id, this message translates to:
  /// **'Peralatan yang tersedia'**
  String get fieldEquipment;

  /// No description provided for @equipmentHelp.
  ///
  /// In id, this message translates to:
  /// **'Program hanya akan memakai alat yang Anda centang.'**
  String get equipmentHelp;

  /// No description provided for @equipDumbbell.
  ///
  /// In id, this message translates to:
  /// **'Dumbbell'**
  String get equipDumbbell;

  /// No description provided for @equipBarbell.
  ///
  /// In id, this message translates to:
  /// **'Barbell'**
  String get equipBarbell;

  /// No description provided for @equipBench.
  ///
  /// In id, this message translates to:
  /// **'Bench'**
  String get equipBench;

  /// No description provided for @equipRack.
  ///
  /// In id, this message translates to:
  /// **'Squat rack / power rack'**
  String get equipRack;

  /// No description provided for @equipPullUpBar.
  ///
  /// In id, this message translates to:
  /// **'Pull-up bar'**
  String get equipPullUpBar;

  /// No description provided for @fieldDumbbellMax.
  ///
  /// In id, this message translates to:
  /// **'Dumbbell terberat per tangan (opsional)'**
  String get fieldDumbbellMax;

  /// No description provided for @fieldBarbellMax.
  ///
  /// In id, this message translates to:
  /// **'Beban barbell maks. termasuk bar (opsional)'**
  String get fieldBarbellMax;

  /// No description provided for @fieldTrainingPreferences.
  ///
  /// In id, this message translates to:
  /// **'Preferensi latihan (opsional)'**
  String get fieldTrainingPreferences;

  /// No description provided for @fieldActivityLevel.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas harian di luar latihan'**
  String get fieldActivityLevel;

  /// No description provided for @activitySedentary.
  ///
  /// In id, this message translates to:
  /// **'Sangat sedikit bergerak'**
  String get activitySedentary;

  /// No description provided for @activityLight.
  ///
  /// In id, this message translates to:
  /// **'Ringan'**
  String get activityLight;

  /// No description provided for @activityModerate.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get activityModerate;

  /// No description provided for @activityHigh.
  ///
  /// In id, this message translates to:
  /// **'Tinggi'**
  String get activityHigh;

  /// No description provided for @activityHelp.
  ///
  /// In id, this message translates to:
  /// **'Ringan: sesekali jalan kaki. Sedang: banyak berjalan/berdiri. Tinggi: kerja fisik berat.'**
  String get activityHelp;

  /// No description provided for @fieldOccupation.
  ///
  /// In id, this message translates to:
  /// **'Pekerjaan dominan'**
  String get fieldOccupation;

  /// No description provided for @occupationSitting.
  ///
  /// In id, this message translates to:
  /// **'Duduk'**
  String get occupationSitting;

  /// No description provided for @occupationStanding.
  ///
  /// In id, this message translates to:
  /// **'Berdiri'**
  String get occupationStanding;

  /// No description provided for @occupationActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif/fisik'**
  String get occupationActive;

  /// No description provided for @fieldSleep.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata tidur per malam'**
  String get fieldSleep;

  /// No description provided for @fieldStress.
  ///
  /// In id, this message translates to:
  /// **'Tingkat stres (opsional)'**
  String get fieldStress;

  /// No description provided for @stressLow.
  ///
  /// In id, this message translates to:
  /// **'Rendah'**
  String get stressLow;

  /// No description provided for @stressMedium.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get stressMedium;

  /// No description provided for @stressHigh.
  ///
  /// In id, this message translates to:
  /// **'Tinggi'**
  String get stressHigh;

  /// No description provided for @fieldCardio.
  ///
  /// In id, this message translates to:
  /// **'Kardio/olahraga lain (opsional)'**
  String get fieldCardio;

  /// No description provided for @fieldDiet.
  ///
  /// In id, this message translates to:
  /// **'Pola makan'**
  String get fieldDiet;

  /// No description provided for @dietOmnivore.
  ///
  /// In id, this message translates to:
  /// **'Omnivora'**
  String get dietOmnivore;

  /// No description provided for @dietVegetarian.
  ///
  /// In id, this message translates to:
  /// **'Vegetarian'**
  String get dietVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In id, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietOther.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get dietOther;

  /// No description provided for @fieldAllergies.
  ///
  /// In id, this message translates to:
  /// **'Alergi & pantangan (opsional)'**
  String get fieldAllergies;

  /// No description provided for @fieldDislikes.
  ///
  /// In id, this message translates to:
  /// **'Makanan yang tidak disukai (opsional)'**
  String get fieldDislikes;

  /// No description provided for @fieldFoodPreferences.
  ///
  /// In id, this message translates to:
  /// **'Makanan favorit/preferensi (opsional)'**
  String get fieldFoodPreferences;

  /// No description provided for @fieldBudget.
  ///
  /// In id, this message translates to:
  /// **'Anggaran makan per hari (opsional)'**
  String get fieldBudget;

  /// No description provided for @fieldMealsPerDay.
  ///
  /// In id, this message translates to:
  /// **'Jumlah waktu makan per hari'**
  String get fieldMealsPerDay;

  /// No description provided for @fieldCooking.
  ///
  /// In id, this message translates to:
  /// **'Akses memasak'**
  String get fieldCooking;

  /// No description provided for @cookingSelf.
  ///
  /// In id, this message translates to:
  /// **'Masak sendiri'**
  String get cookingSelf;

  /// No description provided for @cookingCatering.
  ///
  /// In id, this message translates to:
  /// **'Katering/beli'**
  String get cookingCatering;

  /// No description provided for @cookingMixed.
  ///
  /// In id, this message translates to:
  /// **'Campuran'**
  String get cookingMixed;

  /// No description provided for @foodLocationIndonesia.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi makanan disesuaikan untuk Indonesia.'**
  String get foodLocationIndonesia;

  /// No description provided for @fieldNutritionNotes.
  ///
  /// In id, this message translates to:
  /// **'Catatan pola makan (opsional)'**
  String get fieldNutritionNotes;

  /// No description provided for @safetyIntro.
  ///
  /// In id, this message translates to:
  /// **'Bagian ini membantu kami menghindari rekomendasi yang tidak aman. Data kesehatan disimpan privat di akun Anda dan dapat dihapus kapan saja.'**
  String get safetyIntro;

  /// No description provided for @fieldInjuries.
  ///
  /// In id, this message translates to:
  /// **'Cedera saat ini/riwayat yang masih berdampak (opsional)'**
  String get fieldInjuries;

  /// No description provided for @fieldAvoidedMovements.
  ///
  /// In id, this message translates to:
  /// **'Gerakan yang dilarang/tidak nyaman (opsional)'**
  String get fieldAvoidedMovements;

  /// No description provided for @fieldMedicalFlags.
  ///
  /// In id, this message translates to:
  /// **'Apakah ada kondisi berikut?'**
  String get fieldMedicalFlags;

  /// No description provided for @medicalFlagsHelp.
  ///
  /// In id, this message translates to:
  /// **'Cukup centang bila ada; tidak perlu menyebut diagnosis.'**
  String get medicalFlagsHelp;

  /// No description provided for @medicalPregnant.
  ///
  /// In id, this message translates to:
  /// **'Sedang hamil'**
  String get medicalPregnant;

  /// No description provided for @medicalChronic.
  ///
  /// In id, this message translates to:
  /// **'Penyakit kronis (mis. jantung, diabetes, hipertensi)'**
  String get medicalChronic;

  /// No description provided for @medicalEatingDisorder.
  ///
  /// In id, this message translates to:
  /// **'Riwayat gangguan makan'**
  String get medicalEatingDisorder;

  /// No description provided for @medicalInjuryRecovery.
  ///
  /// In id, this message translates to:
  /// **'Sedang pemulihan cedera/operasi'**
  String get medicalInjuryRecovery;

  /// No description provided for @medicalMedication.
  ///
  /// In id, this message translates to:
  /// **'Mengonsumsi obat yang relevan'**
  String get medicalMedication;

  /// No description provided for @fieldRedFlags.
  ///
  /// In id, this message translates to:
  /// **'Dalam beberapa minggu terakhir, apakah Anda mengalami:'**
  String get fieldRedFlags;

  /// No description provided for @redChestPain.
  ///
  /// In id, this message translates to:
  /// **'Nyeri dada saat beraktivitas'**
  String get redChestPain;

  /// No description provided for @redFainting.
  ///
  /// In id, this message translates to:
  /// **'Pingsan atau hampir pingsan'**
  String get redFainting;

  /// No description provided for @redBreathless.
  ///
  /// In id, this message translates to:
  /// **'Sesak napas yang tidak wajar'**
  String get redBreathless;

  /// No description provided for @redAcuteInjury.
  ///
  /// In id, this message translates to:
  /// **'Cedera akut yang belum ditangani'**
  String get redAcuteInjury;

  /// No description provided for @consentTitle.
  ///
  /// In id, this message translates to:
  /// **'Persetujuan'**
  String get consentTitle;

  /// No description provided for @consentDisclaimer.
  ///
  /// In id, this message translates to:
  /// **'Saya memahami bahwa Muscle Coach memberi estimasi edukatif dan tidak menggantikan dokter, ahli gizi, atau pelatih.'**
  String get consentDisclaimer;

  /// No description provided for @consentHealthData.
  ///
  /// In id, this message translates to:
  /// **'Saya setuju data assessment, termasuk data kesehatan di atas, diproses untuk menghitung target dan menyusun program saya.'**
  String get consentHealthData;

  /// No description provided for @issueRequired.
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi.'**
  String get issueRequired;

  /// No description provided for @issueChoose.
  ///
  /// In id, this message translates to:
  /// **'Pilih salah satu.'**
  String get issueChoose;

  /// No description provided for @issueAge.
  ///
  /// In id, this message translates to:
  /// **'Usia harus {min}–{max} tahun.'**
  String issueAge(Object min, Object max);

  /// No description provided for @issueRange.
  ///
  /// In id, this message translates to:
  /// **'Masukkan angka {min}–{max}.'**
  String issueRange(Object min, Object max);

  /// No description provided for @issueTrainingDays.
  ///
  /// In id, this message translates to:
  /// **'Pilih minimal satu hari.'**
  String get issueTrainingDays;

  /// No description provided for @issueEquipment.
  ///
  /// In id, this message translates to:
  /// **'Centang minimal dumbbell atau barbell.'**
  String get issueEquipment;

  /// No description provided for @issueConsent.
  ///
  /// In id, this message translates to:
  /// **'Centang kedua persetujuan untuk melanjutkan.'**
  String get issueConsent;

  /// No description provided for @goalReviewTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan target'**
  String get goalReviewTitle;

  /// No description provided for @goalActiveTitle.
  ///
  /// In id, this message translates to:
  /// **'Target aktif'**
  String get goalActiveTitle;

  /// No description provided for @verdictRealistic.
  ///
  /// In id, this message translates to:
  /// **'Target realistis'**
  String get verdictRealistic;

  /// No description provided for @verdictRealisticMessage.
  ///
  /// In id, this message translates to:
  /// **'Target dan waktunya berada dalam batas laju kenaikan yang aman untuk level Anda.'**
  String get verdictRealisticMessage;

  /// No description provided for @verdictNeedsAdjustment.
  ///
  /// In id, this message translates to:
  /// **'Target perlu disesuaikan'**
  String get verdictNeedsAdjustment;

  /// No description provided for @reasonTargetBelowCurrent.
  ///
  /// In id, this message translates to:
  /// **'Tujuan Anda menambah otot/kekuatan, tetapi berat target lebih rendah dari berat sekarang. Pilih body recomposition atau naikkan berat target.'**
  String get reasonTargetBelowCurrent;

  /// No description provided for @reasonRateTooFast.
  ///
  /// In id, this message translates to:
  /// **'Target ini menuntut kenaikan {rate} kg/minggu, melebihi batas {max} kg/minggu ({maxPct}% berat badan) untuk level Anda. Kenaikan terlalu cepat cenderung menambah lebih banyak lemak.'**
  String reasonRateTooFast(Object rate, Object max, Object maxPct);

  /// No description provided for @reasonRecomposition.
  ///
  /// In id, this message translates to:
  /// **'Body recomposition berarti berat relatif stabil, tetapi target Anda berubah {delta} kg. Pilih \"Menambah massa otot\" atau dekatkan target ke berat sekarang.'**
  String reasonRecomposition(Object delta);

  /// No description provided for @suggestionWeeks.
  ///
  /// In id, this message translates to:
  /// **'Saran waktu: minimal {weeks} minggu untuk target ini.'**
  String suggestionWeeks(Object weeks);

  /// No description provided for @suggestionTarget.
  ///
  /// In id, this message translates to:
  /// **'Saran target: {kg} kg dalam {weeks} minggu.'**
  String suggestionTarget(Object kg, Object weeks);

  /// No description provided for @adjustTarget.
  ///
  /// In id, this message translates to:
  /// **'Sesuaikan target'**
  String get adjustTarget;

  /// No description provided for @editAnswers.
  ///
  /// In id, this message translates to:
  /// **'Ubah jawaban'**
  String get editAnswers;

  /// No description provided for @safetyStopTitle.
  ///
  /// In id, this message translates to:
  /// **'Tunda dulu rencana latihan'**
  String get safetyStopTitle;

  /// No description provided for @safetyStopMessage.
  ///
  /// In id, this message translates to:
  /// **'Anda melaporkan gejala yang perlu diperiksa (nyeri dada, pingsan, sesak tidak wajar, atau cedera akut). Segera konsultasikan dengan tenaga medis. Bila gejala berat atau mendadak, hubungi layanan darurat 119 atau 112. Target dan program tidak kami aktifkan sampai kondisi Anda aman.'**
  String get safetyStopMessage;

  /// No description provided for @sectionWeightGoal.
  ///
  /// In id, this message translates to:
  /// **'Berat badan'**
  String get sectionWeightGoal;

  /// No description provided for @labelGoal.
  ///
  /// In id, this message translates to:
  /// **'Tujuan'**
  String get labelGoal;

  /// No description provided for @labelStartWeight.
  ///
  /// In id, this message translates to:
  /// **'Berat awal'**
  String get labelStartWeight;

  /// No description provided for @labelTargetWeight.
  ///
  /// In id, this message translates to:
  /// **'Berat target'**
  String get labelTargetWeight;

  /// No description provided for @labelDelta.
  ///
  /// In id, this message translates to:
  /// **'Selisih'**
  String get labelDelta;

  /// No description provided for @labelPeriod.
  ///
  /// In id, this message translates to:
  /// **'Periode'**
  String get labelPeriod;

  /// No description provided for @labelTargetDate.
  ///
  /// In id, this message translates to:
  /// **'Target tanggal'**
  String get labelTargetDate;

  /// No description provided for @labelWeeklyRate.
  ///
  /// In id, this message translates to:
  /// **'Laju per minggu'**
  String get labelWeeklyRate;

  /// No description provided for @noTargetWeight.
  ///
  /// In id, this message translates to:
  /// **'Tidak ditetapkan'**
  String get noTargetWeight;

  /// No description provided for @weeksValue.
  ///
  /// In id, this message translates to:
  /// **'{weeks} minggu'**
  String weeksValue(Object weeks);

  /// No description provided for @kgValue.
  ///
  /// In id, this message translates to:
  /// **'{kg} kg'**
  String kgValue(Object kg);

  /// No description provided for @kgPerWeekValue.
  ///
  /// In id, this message translates to:
  /// **'{kg} kg/minggu'**
  String kgPerWeekValue(Object kg);

  /// No description provided for @expectedGainNote.
  ///
  /// In id, this message translates to:
  /// **'Kenaikan berat yang wajar sekitar {min}–{max} kg/minggu. Ini bukan janji: berat badan tidak sama dengan massa otot, dan evaluasi memakai tren beberapa minggu.'**
  String expectedGainNote(Object min, Object max);

  /// No description provided for @recompositionNote.
  ///
  /// In id, this message translates to:
  /// **'Recomposition: berat diharapkan relatif stabil; progres dinilai dari kekuatan, ukuran tubuh, dan tren beberapa minggu.'**
  String get recompositionNote;

  /// No description provided for @sectionNutrition.
  ///
  /// In id, this message translates to:
  /// **'Target nutrisi harian'**
  String get sectionNutrition;

  /// No description provided for @kcalValue.
  ///
  /// In id, this message translates to:
  /// **'{kcal} kcal'**
  String kcalValue(Object kcal);

  /// No description provided for @kcalRangeValue.
  ///
  /// In id, this message translates to:
  /// **'{min}–{max} kcal'**
  String kcalRangeValue(Object min, Object max);

  /// No description provided for @macroProtein.
  ///
  /// In id, this message translates to:
  /// **'Protein'**
  String get macroProtein;

  /// No description provided for @macroCarbs.
  ///
  /// In id, this message translates to:
  /// **'Karbohidrat'**
  String get macroCarbs;

  /// No description provided for @macroFat.
  ///
  /// In id, this message translates to:
  /// **'Lemak'**
  String get macroFat;

  /// No description provided for @gramValue.
  ///
  /// In id, this message translates to:
  /// **'{grams} g'**
  String gramValue(Object grams);

  /// No description provided for @macroDetail.
  ///
  /// In id, this message translates to:
  /// **'{gPerKg} g/kg · {pct}% energi'**
  String macroDetail(Object gPerKg, Object pct);

  /// No description provided for @macroCarbsDetail.
  ///
  /// In id, this message translates to:
  /// **'{pct}% energi'**
  String macroCarbsDetail(Object pct);

  /// No description provided for @estimateLabel.
  ///
  /// In id, this message translates to:
  /// **'Estimasi'**
  String get estimateLabel;

  /// No description provided for @rangeNote.
  ///
  /// In id, this message translates to:
  /// **'Jenis kelamin tidak diisi, jadi kebutuhan energi berupa rentang. Angka makro memakai titik tengah rentang.'**
  String get rangeNote;

  /// No description provided for @sectionAssumptions.
  ///
  /// In id, this message translates to:
  /// **'Asumsi & cara hitung'**
  String get sectionAssumptions;

  /// No description provided for @assumptionBmr.
  ///
  /// In id, this message translates to:
  /// **'BMR (energi saat istirahat) {value}, rumus Mifflin–St Jeor. Ini perkiraan populasi: kurang akurat untuk orang sangat berotot atau dengan obesitas, dan tidak berlaku saat hamil.'**
  String assumptionBmr(Object value);

  /// No description provided for @assumptionTdee.
  ///
  /// In id, this message translates to:
  /// **'TDEE {value} = BMR × faktor aktivitas {factor}.'**
  String assumptionTdee(Object value, Object factor);

  /// No description provided for @assumptionSurplus.
  ///
  /// In id, this message translates to:
  /// **'Energi target = TDEE + surplus konservatif {pct}% ≈ {value}.'**
  String assumptionSurplus(Object pct, Object value);

  /// No description provided for @assumptionMaintenance.
  ///
  /// In id, this message translates to:
  /// **'Energi target ≈ TDEE (maintenance) karena tujuan recomposition: {value}.'**
  String assumptionMaintenance(Object value);

  /// No description provided for @assumptionProtein.
  ///
  /// In id, this message translates to:
  /// **'Protein {gPerKg} g/kg × {basis} kg berat acuan.'**
  String assumptionProtein(Object gPerKg, Object basis);

  /// No description provided for @assumptionProteinBasis.
  ///
  /// In id, this message translates to:
  /// **'Karena BMI tinggi, protein memakai berat acuan pada BMI 25.'**
  String get assumptionProteinBasis;

  /// No description provided for @assumptionFat.
  ///
  /// In id, this message translates to:
  /// **'Lemak sekitar 0,8 g/kg, dijaga 20–35% energi dan minimal 0,6 g/kg.'**
  String get assumptionFat;

  /// No description provided for @assumptionCarbs.
  ///
  /// In id, this message translates to:
  /// **'Karbohidrat = sisa energi setelah protein dan lemak.'**
  String get assumptionCarbs;

  /// No description provided for @assumptionRounding.
  ///
  /// In id, this message translates to:
  /// **'Makro dibulatkan ke kelipatan 5 g; total kalori dihitung ulang dari makro (protein & karbohidrat 4 kcal/g, lemak 9 kcal/g).'**
  String get assumptionRounding;

  /// No description provided for @assumptionConservative.
  ///
  /// In id, this message translates to:
  /// **'Karena ada faktor keselamatan, surplus energi dan batas laju kenaikan dibuat lebih konservatif.'**
  String get assumptionConservative;

  /// No description provided for @assumptionReview.
  ///
  /// In id, this message translates to:
  /// **'Semua angka adalah estimasi awal dan akan dievaluasi dari tren berat badan 2–4 minggu, bukan dari satu kali timbang.'**
  String get assumptionReview;

  /// No description provided for @assumptionVersion.
  ///
  /// In id, this message translates to:
  /// **'Versi konfigurasi: {version}'**
  String assumptionVersion(Object version);

  /// No description provided for @sectionWarnings.
  ///
  /// In id, this message translates to:
  /// **'Perlu diperhatikan'**
  String get sectionWarnings;

  /// No description provided for @warningMinorAge.
  ///
  /// In id, this message translates to:
  /// **'Usia di bawah 18 tahun: diskusikan program dengan orang tua dan tenaga kesehatan.'**
  String get warningMinorAge;

  /// No description provided for @warningLowBmi.
  ///
  /// In id, this message translates to:
  /// **'BMI Anda {bmi} tergolong rendah. Konsultasikan dengan tenaga kesehatan.'**
  String warningLowBmi(Object bmi);

  /// No description provided for @warningHighBmi.
  ///
  /// In id, this message translates to:
  /// **'BMI Anda {bmi} tergolong tinggi; perkiraan energi bisa kurang akurat. Pertimbangkan konsultasi dengan tenaga kesehatan.'**
  String warningHighBmi(Object bmi);

  /// No description provided for @warningPregnant.
  ///
  /// In id, this message translates to:
  /// **'Kehamilan: perhitungan ini tidak dirancang untuk kehamilan. Konsultasikan dengan dokter atau bidan sebelum memakai target ini.'**
  String get warningPregnant;

  /// No description provided for @warningChronic.
  ///
  /// In id, this message translates to:
  /// **'Penyakit kronis: konsultasikan dengan dokter sebelum menaikkan intensitas latihan atau asupan.'**
  String get warningChronic;

  /// No description provided for @warningEatingDisorder.
  ///
  /// In id, this message translates to:
  /// **'Riwayat gangguan makan: angka kalori dapat memicu kekhawatiran. Diskusikan dengan tenaga kesehatan; Anda bisa berfokus pada kebiasaan, bukan angka.'**
  String get warningEatingDisorder;

  /// No description provided for @warningInjuryRecovery.
  ///
  /// In id, this message translates to:
  /// **'Pemulihan cedera: ikuti arahan tenaga kesehatan atau fisioterapis; gerakan terkait akan dihindari.'**
  String get warningInjuryRecovery;

  /// No description provided for @warningMedication.
  ///
  /// In id, this message translates to:
  /// **'Obat-obatan: tanyakan kepada dokter bila obat memengaruhi nafsu makan, berat badan, atau kemampuan latihan.'**
  String get warningMedication;

  /// No description provided for @warningRedFlag.
  ///
  /// In id, this message translates to:
  /// **'Gejala berbahaya dilaporkan: konsultasikan dengan tenaga medis sebelum berlatih.'**
  String get warningRedFlag;

  /// No description provided for @acknowledgeWarnings.
  ///
  /// In id, this message translates to:
  /// **'Saya sudah membaca peringatan di atas dan akan berkonsultasi dengan tenaga kesehatan bila perlu.'**
  String get acknowledgeWarnings;

  /// No description provided for @confirmGoal.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi target'**
  String get confirmGoal;

  /// No description provided for @goalConfirmed.
  ///
  /// In id, this message translates to:
  /// **'Target aktif! Program latihan akan disusun pada tahap berikutnya.'**
  String get goalConfirmed;

  /// No description provided for @goalNotFound.
  ///
  /// In id, this message translates to:
  /// **'Target tidak ditemukan.'**
  String get goalNotFound;

  /// No description provided for @homeGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}!'**
  String homeGreeting(Object name);

  /// No description provided for @homeGreetingNoName.
  ///
  /// In id, this message translates to:
  /// **'Halo!'**
  String get homeGreetingNoName;

  /// No description provided for @homeNextSteps.
  ///
  /// In id, this message translates to:
  /// **'Program latihan, menu harian, dan check-in akan muncul di sini setelah fitur berikutnya aktif.'**
  String get homeNextSteps;

  /// No description provided for @seeDetails.
  ///
  /// In id, this message translates to:
  /// **'Lihat detail & asumsi'**
  String get seeDetails;

  /// No description provided for @profileAssessmentSection.
  ///
  /// In id, this message translates to:
  /// **'Assessment & target'**
  String get profileAssessmentSection;

  /// No description provided for @viewActiveGoal.
  ///
  /// In id, this message translates to:
  /// **'Lihat target aktif'**
  String get viewActiveGoal;

  /// No description provided for @redoAssessment.
  ///
  /// In id, this message translates to:
  /// **'Ulangi assessment'**
  String get redoAssessment;

  /// No description provided for @redoAssessmentHelp.
  ///
  /// In id, this message translates to:
  /// **'Target baru berlaku setelah Anda konfirmasi; target lama diarsipkan.'**
  String get redoAssessmentHelp;
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
