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

  /// No description provided for @errorNetwork.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.'**
  String get errorNetwork;

  /// No description provided for @errorUnauthenticated.
  ///
  /// In id, this message translates to:
  /// **'API key tidak valid atau kedaluwarsa. Periksa di Pengaturan AI.'**
  String get errorUnauthenticated;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In id, this message translates to:
  /// **'Akses ditolak. Periksa izin atau pembatasan API key Anda.'**
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

  /// No description provided for @errorUnknown.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Coba lagi.'**
  String get errorUnknown;

  /// No description provided for @emptyWorkoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada program latihan'**
  String get emptyWorkoutTitle;

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

  /// No description provided for @dangerZone.
  ///
  /// In id, this message translates to:
  /// **'Zona berbahaya'**
  String get dangerZone;

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
  /// **'Data Anda tersimpan hanya di perangkat ini dan dapat dihapus kapan saja dari Profil.'**
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
  /// **'Target ini menuntut kenaikan {rate} kg/minggu, melebihi batas {max} kg/minggu ({maxPct}% berat badan) untuk Anda. Kenaikan terlalu cepat cenderung menambah lebih banyak lemak.'**
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

  /// No description provided for @conservativeLimitNote.
  ///
  /// In id, this message translates to:
  /// **'Batas ini lebih ketat dari biasanya karena {reasons}. Ini demi keamanan; sebaiknya diskusikan target kenaikan berat dengan dokter atau ahli gizi.'**
  String conservativeLimitNote(Object reasons);

  /// No description provided for @conservativeReasonLowBmi.
  ///
  /// In id, this message translates to:
  /// **'BMI Anda di bawah normal'**
  String get conservativeReasonLowBmi;

  /// No description provided for @conservativeReasonMinor.
  ///
  /// In id, this message translates to:
  /// **'usia Anda di bawah 18 tahun'**
  String get conservativeReasonMinor;

  /// No description provided for @conservativeReasonMedical.
  ///
  /// In id, this message translates to:
  /// **'ada kondisi kesehatan yang Anda laporkan'**
  String get conservativeReasonMedical;

  /// No description provided for @targetRejectedHint.
  ///
  /// In id, this message translates to:
  /// **'Sesuaikan target dulu agar bisa melanjutkan.'**
  String get targetRejectedHint;

  /// No description provided for @useSuggestion.
  ///
  /// In id, this message translates to:
  /// **'Pakai saran ({kg} kg)'**
  String useSuggestion(Object kg);

  /// No description provided for @useNoTargetWeight.
  ///
  /// In id, this message translates to:
  /// **'Tanpa berat target'**
  String get useNoTargetWeight;

  /// No description provided for @editMyself.
  ///
  /// In id, this message translates to:
  /// **'Ubah sendiri'**
  String get editMyself;

  /// No description provided for @suggestionApplied.
  ///
  /// In id, this message translates to:
  /// **'Berat target diubah ke {kg} kg.'**
  String suggestionApplied(Object kg);

  /// No description provided for @noTargetWeightApplied.
  ///
  /// In id, this message translates to:
  /// **'Berat target dikosongkan; kemajuan dinilai dari tren berat & performa latihan.'**
  String get noTargetWeightApplied;

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

  /// No description provided for @workoutNoPlanMessage.
  ///
  /// In id, this message translates to:
  /// **'Buat program awal dari jawaban assessment Anda. Program disusun dengan aturan terdokumentasi (bukan AI) dan baru aktif setelah Anda setujui.'**
  String get workoutNoPlanMessage;

  /// No description provided for @createStarterPlan.
  ///
  /// In id, this message translates to:
  /// **'Buat program awal'**
  String get createStarterPlan;

  /// No description provided for @planDraftTitle.
  ///
  /// In id, this message translates to:
  /// **'Draft program'**
  String get planDraftTitle;

  /// No description provided for @planActiveTitle.
  ///
  /// In id, this message translates to:
  /// **'Program aktif'**
  String get planActiveTitle;

  /// No description provided for @planSummary.
  ///
  /// In id, this message translates to:
  /// **'{days} hari/minggu · ± {minutes} menit/sesi'**
  String planSummary(Object days, Object minutes);

  /// No description provided for @splitFullBody.
  ///
  /// In id, this message translates to:
  /// **'Seluruh tubuh (full body)'**
  String get splitFullBody;

  /// No description provided for @splitUpperLower.
  ///
  /// In id, this message translates to:
  /// **'Tubuh atas/bawah (upper/lower)'**
  String get splitUpperLower;

  /// No description provided for @planSourceTemplate.
  ///
  /// In id, this message translates to:
  /// **'Disusun dari aturan terdokumentasi, bukan AI'**
  String get planSourceTemplate;

  /// No description provided for @activatePlan.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan program'**
  String get activatePlan;

  /// No description provided for @replacePlanTitle.
  ///
  /// In id, this message translates to:
  /// **'Ganti program aktif?'**
  String get replacePlanTitle;

  /// No description provided for @replacePlanMessage.
  ///
  /// In id, this message translates to:
  /// **'Program yang sedang aktif akan diarsipkan. Riwayat latihan tetap tersimpan.'**
  String get replacePlanMessage;

  /// No description provided for @replace.
  ///
  /// In id, this message translates to:
  /// **'Ganti'**
  String get replace;

  /// No description provided for @planActivated.
  ///
  /// In id, this message translates to:
  /// **'Program aktif! Selamat berlatih.'**
  String get planActivated;

  /// No description provided for @newPlan.
  ///
  /// In id, this message translates to:
  /// **'Buat ulang program'**
  String get newPlan;

  /// No description provided for @planWarningReviewInjuries.
  ///
  /// In id, this message translates to:
  /// **'Anda mencatat cedera atau gerakan yang tidak nyaman. Periksa setiap gerakan; lewati bila terasa nyeri dan konsultasikan dengan tenaga kesehatan.'**
  String get planWarningReviewInjuries;

  /// No description provided for @planWarningDaysReduced.
  ///
  /// In id, this message translates to:
  /// **'Demi pemulihan, jumlah hari latihan dibatasi sesuai level Anda; hari lain menjadi hari istirahat.'**
  String get planWarningDaysReduced;

  /// No description provided for @planWarningLimitedEquipment.
  ///
  /// In id, this message translates to:
  /// **'Beberapa gerakan dilewati karena alatnya tidak tersedia.'**
  String get planWarningLimitedEquipment;

  /// No description provided for @planWarningSpotter.
  ///
  /// In id, this message translates to:
  /// **'Program memuat gerakan barbell di bench/rack: gunakan spotter atau safety bar.'**
  String get planWarningSpotter;

  /// No description provided for @planWarningConsecutive.
  ///
  /// In id, this message translates to:
  /// **'Ada otot yang dilatih berat pada hari berurutan; perhatikan pemulihan.'**
  String get planWarningConsecutive;

  /// No description provided for @progressionRule.
  ///
  /// In id, this message translates to:
  /// **'Progresi: bila semua set mencapai batas atas repetisi dengan RIR sesuai target, naikkan beban sedikit (±2,5 kg barbell / 1–2 kg dumbbell) di sesi berikutnya.'**
  String get progressionRule;

  /// No description provided for @rirExplain.
  ///
  /// In id, this message translates to:
  /// **'RIR = sisa repetisi yang masih sanggup dilakukan. RIR 2 berarti berhenti saat masih kuat ±2 repetisi lagi — tidak perlu sampai gagal.'**
  String get rirExplain;

  /// No description provided for @restDaysNote.
  ///
  /// In id, this message translates to:
  /// **'Hari lain: istirahat atau aktivitas ringan seperti jalan kaki dan peregangan.'**
  String get restDaysNote;

  /// No description provided for @focusFullBodyA.
  ///
  /// In id, this message translates to:
  /// **'Seluruh tubuh A'**
  String get focusFullBodyA;

  /// No description provided for @focusFullBodyB.
  ///
  /// In id, this message translates to:
  /// **'Seluruh tubuh B'**
  String get focusFullBodyB;

  /// No description provided for @focusFullBodyC.
  ///
  /// In id, this message translates to:
  /// **'Seluruh tubuh C'**
  String get focusFullBodyC;

  /// No description provided for @focusUpperA.
  ///
  /// In id, this message translates to:
  /// **'Tubuh atas A'**
  String get focusUpperA;

  /// No description provided for @focusUpperB.
  ///
  /// In id, this message translates to:
  /// **'Tubuh atas B'**
  String get focusUpperB;

  /// No description provided for @focusLowerA.
  ///
  /// In id, this message translates to:
  /// **'Tubuh bawah A'**
  String get focusLowerA;

  /// No description provided for @focusLowerB.
  ///
  /// In id, this message translates to:
  /// **'Tubuh bawah B'**
  String get focusLowerB;

  /// No description provided for @weekdayLong1.
  ///
  /// In id, this message translates to:
  /// **'Senin'**
  String get weekdayLong1;

  /// No description provided for @weekdayLong2.
  ///
  /// In id, this message translates to:
  /// **'Selasa'**
  String get weekdayLong2;

  /// No description provided for @weekdayLong3.
  ///
  /// In id, this message translates to:
  /// **'Rabu'**
  String get weekdayLong3;

  /// No description provided for @weekdayLong4.
  ///
  /// In id, this message translates to:
  /// **'Kamis'**
  String get weekdayLong4;

  /// No description provided for @weekdayLong5.
  ///
  /// In id, this message translates to:
  /// **'Jumat'**
  String get weekdayLong5;

  /// No description provided for @weekdayLong6.
  ///
  /// In id, this message translates to:
  /// **'Sabtu'**
  String get weekdayLong6;

  /// No description provided for @weekdayLong7.
  ///
  /// In id, this message translates to:
  /// **'Minggu'**
  String get weekdayLong7;

  /// No description provided for @todayBadge.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get todayBadge;

  /// No description provided for @dayMeta.
  ///
  /// In id, this message translates to:
  /// **'{count} latihan · ± {minutes} menit'**
  String dayMeta(Object count, Object minutes);

  /// No description provided for @warmupNote.
  ///
  /// In id, this message translates to:
  /// **'Pemanasan {minutes} menit: kardio ringan, lalu 1–2 set ringan untuk gerakan pertama.'**
  String warmupNote(Object minutes);

  /// No description provided for @cooldownNote.
  ///
  /// In id, this message translates to:
  /// **'Pendinginan: peregangan ringan 3–5 menit.'**
  String get cooldownNote;

  /// No description provided for @prescription.
  ///
  /// In id, this message translates to:
  /// **'{sets} set × {min}–{max} repetisi'**
  String prescription(Object sets, Object min, Object max);

  /// No description provided for @prescriptionTimed.
  ///
  /// In id, this message translates to:
  /// **'{sets} set × {min}–{max} detik'**
  String prescriptionTimed(Object sets, Object min, Object max);

  /// No description provided for @restAndRir.
  ///
  /// In id, this message translates to:
  /// **'Istirahat {rest} · RIR {min}–{max}'**
  String restAndRir(Object rest, Object min, Object max);

  /// No description provided for @secondsValue.
  ///
  /// In id, this message translates to:
  /// **'{seconds} dtk'**
  String secondsValue(Object seconds);

  /// No description provided for @minutesShortValue.
  ///
  /// In id, this message translates to:
  /// **'{minutes} mnt'**
  String minutesShortValue(Object minutes);

  /// No description provided for @priorityBadge.
  ///
  /// In id, this message translates to:
  /// **'Prioritas'**
  String get priorityBadge;

  /// No description provided for @startSession.
  ///
  /// In id, this message translates to:
  /// **'Mulai sesi'**
  String get startSession;

  /// No description provided for @history.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get history;

  /// No description provided for @historyTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat latihan'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada sesi yang selesai.'**
  String get historyEmpty;

  /// No description provided for @exerciseLibrary.
  ///
  /// In id, this message translates to:
  /// **'Katalog latihan'**
  String get exerciseLibrary;

  /// No description provided for @sessionTitle.
  ///
  /// In id, this message translates to:
  /// **'Sesi latihan'**
  String get sessionTitle;

  /// No description provided for @lastTime.
  ///
  /// In id, this message translates to:
  /// **'Terakhir: {value}'**
  String lastTime(Object value);

  /// No description provided for @increaseLoadHint.
  ///
  /// In id, this message translates to:
  /// **'Sesi lalu semua set mencapai target — coba naikkan beban sedikit.'**
  String get increaseLoadHint;

  /// No description provided for @setLabel.
  ///
  /// In id, this message translates to:
  /// **'Set {number}'**
  String setLabel(Object number);

  /// No description provided for @weightLabelPerHand.
  ///
  /// In id, this message translates to:
  /// **'Beban (kg/tangan)'**
  String get weightLabelPerHand;

  /// No description provided for @weightLabelTotal.
  ///
  /// In id, this message translates to:
  /// **'Beban (kg)'**
  String get weightLabelTotal;

  /// No description provided for @weightLabelBodyweight.
  ///
  /// In id, this message translates to:
  /// **'Beban tambahan (kg)'**
  String get weightLabelBodyweight;

  /// No description provided for @repsLabel.
  ///
  /// In id, this message translates to:
  /// **'Repetisi'**
  String get repsLabel;

  /// No description provided for @secondsLabel.
  ///
  /// In id, this message translates to:
  /// **'Detik'**
  String get secondsLabel;

  /// No description provided for @rirLabel.
  ///
  /// In id, this message translates to:
  /// **'RIR'**
  String get rirLabel;

  /// No description provided for @logSet.
  ///
  /// In id, this message translates to:
  /// **'Catat set'**
  String get logSet;

  /// No description provided for @skipSet.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get skipSet;

  /// No description provided for @setSkipped.
  ///
  /// In id, this message translates to:
  /// **'dilewati'**
  String get setSkipped;

  /// No description provided for @setsProgress.
  ///
  /// In id, this message translates to:
  /// **'{done}/{planned} set'**
  String setsProgress(Object done, Object planned);

  /// No description provided for @restTimerLabel.
  ///
  /// In id, this message translates to:
  /// **'Istirahat'**
  String get restTimerLabel;

  /// No description provided for @restAdd.
  ///
  /// In id, this message translates to:
  /// **'+15 dtk'**
  String get restAdd;

  /// No description provided for @restSkip.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get restSkip;

  /// No description provided for @finishSession.
  ///
  /// In id, this message translates to:
  /// **'Selesaikan sesi'**
  String get finishSession;

  /// No description provided for @finishSessionTitle.
  ///
  /// In id, this message translates to:
  /// **'Selesaikan sesi?'**
  String get finishSessionTitle;

  /// No description provided for @energyLabel.
  ///
  /// In id, this message translates to:
  /// **'Energi hari ini (opsional)'**
  String get energyLabel;

  /// No description provided for @discomfortLabel.
  ///
  /// In id, this message translates to:
  /// **'Nyeri/tidak nyaman (opsional)'**
  String get discomfortLabel;

  /// No description provided for @sessionNotesLabel.
  ///
  /// In id, this message translates to:
  /// **'Catatan (opsional)'**
  String get sessionNotesLabel;

  /// No description provided for @finishConfirm.
  ///
  /// In id, this message translates to:
  /// **'Simpan & selesai'**
  String get finishConfirm;

  /// No description provided for @painWarning.
  ///
  /// In id, this message translates to:
  /// **'Hentikan latihan bila muncul nyeri tajam, pusing, nyeri dada, atau sesak tidak wajar.'**
  String get painWarning;

  /// No description provided for @sessionCompleted.
  ///
  /// In id, this message translates to:
  /// **'Sesi tersimpan. Kerja bagus!'**
  String get sessionCompleted;

  /// No description provided for @deleteSession.
  ///
  /// In id, this message translates to:
  /// **'Hapus sesi'**
  String get deleteSession;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus sesi ini?'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionMessage.
  ///
  /// In id, this message translates to:
  /// **'Semua set yang tercatat di sesi ini akan dihapus permanen.'**
  String get deleteSessionMessage;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @deleteSetTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus set ini?'**
  String get deleteSetTitle;

  /// No description provided for @setInputRepsRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi repetisi.'**
  String get setInputRepsRequired;

  /// No description provided for @setInputRepsRange.
  ///
  /// In id, this message translates to:
  /// **'Repetisi 1–300.'**
  String get setInputRepsRange;

  /// No description provided for @setInputWeightRange.
  ///
  /// In id, this message translates to:
  /// **'Beban 0–1000 kg.'**
  String get setInputWeightRange;

  /// No description provided for @sessionSummary.
  ///
  /// In id, this message translates to:
  /// **'{done}/{planned} set · volume {volume} kg'**
  String sessionSummary(Object done, Object planned, Object volume);

  /// No description provided for @completedBadge.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get completedBadge;

  /// No description provided for @targetLabel.
  ///
  /// In id, this message translates to:
  /// **'Target'**
  String get targetLabel;

  /// No description provided for @exerciseInstructions.
  ///
  /// In id, this message translates to:
  /// **'Cara melakukan'**
  String get exerciseInstructions;

  /// No description provided for @exerciseMistakes.
  ///
  /// In id, this message translates to:
  /// **'Kesalahan umum'**
  String get exerciseMistakes;

  /// No description provided for @exerciseSafety.
  ///
  /// In id, this message translates to:
  /// **'Keselamatan'**
  String get exerciseSafety;

  /// No description provided for @exerciseAlternatives.
  ///
  /// In id, this message translates to:
  /// **'Alternatif'**
  String get exerciseAlternatives;

  /// No description provided for @exercisePrimaryMuscles.
  ///
  /// In id, this message translates to:
  /// **'Otot utama'**
  String get exercisePrimaryMuscles;

  /// No description provided for @exerciseSecondaryMuscles.
  ///
  /// In id, this message translates to:
  /// **'Otot pendukung'**
  String get exerciseSecondaryMuscles;

  /// No description provided for @noEquipment.
  ///
  /// In id, this message translates to:
  /// **'Tanpa alat (berat badan)'**
  String get noEquipment;

  /// No description provided for @spotterNeeded.
  ///
  /// In id, this message translates to:
  /// **'Gunakan spotter atau safety bar'**
  String get spotterNeeded;

  /// No description provided for @exerciseNotFound.
  ///
  /// In id, this message translates to:
  /// **'Latihan tidak ditemukan di katalog.'**
  String get exerciseNotFound;

  /// No description provided for @searchExercise.
  ///
  /// In id, this message translates to:
  /// **'Cari latihan'**
  String get searchExercise;

  /// No description provided for @muscleUpperBack.
  ///
  /// In id, this message translates to:
  /// **'Punggung atas'**
  String get muscleUpperBack;

  /// No description provided for @muscleLats.
  ///
  /// In id, this message translates to:
  /// **'Latissimus'**
  String get muscleLats;

  /// No description provided for @muscleTraps.
  ///
  /// In id, this message translates to:
  /// **'Trapezius'**
  String get muscleTraps;

  /// No description provided for @muscleFrontDelts.
  ///
  /// In id, this message translates to:
  /// **'Bahu depan'**
  String get muscleFrontDelts;

  /// No description provided for @muscleSideDelts.
  ///
  /// In id, this message translates to:
  /// **'Bahu samping'**
  String get muscleSideDelts;

  /// No description provided for @muscleRearDelts.
  ///
  /// In id, this message translates to:
  /// **'Bahu belakang'**
  String get muscleRearDelts;

  /// No description provided for @muscleBiceps.
  ///
  /// In id, this message translates to:
  /// **'Biseps'**
  String get muscleBiceps;

  /// No description provided for @muscleTriceps.
  ///
  /// In id, this message translates to:
  /// **'Triseps'**
  String get muscleTriceps;

  /// No description provided for @muscleForearms.
  ///
  /// In id, this message translates to:
  /// **'Lengan bawah'**
  String get muscleForearms;

  /// No description provided for @muscleQuads.
  ///
  /// In id, this message translates to:
  /// **'Paha depan'**
  String get muscleQuads;

  /// No description provided for @muscleHamstrings.
  ///
  /// In id, this message translates to:
  /// **'Paha belakang'**
  String get muscleHamstrings;

  /// No description provided for @muscleAdductors.
  ///
  /// In id, this message translates to:
  /// **'Paha dalam'**
  String get muscleAdductors;

  /// No description provided for @muscleCalves.
  ///
  /// In id, this message translates to:
  /// **'Betis'**
  String get muscleCalves;

  /// No description provided for @homeTodayWorkout.
  ///
  /// In id, this message translates to:
  /// **'Latihan hari ini'**
  String get homeTodayWorkout;

  /// No description provided for @homeNextWorkout.
  ///
  /// In id, this message translates to:
  /// **'Latihan berikutnya · {day}'**
  String homeNextWorkout(Object day);

  /// No description provided for @homeNoPlan.
  ///
  /// In id, this message translates to:
  /// **'Belum ada program latihan. Buat program awal di tab Latihan.'**
  String get homeNoPlan;

  /// No description provided for @openWorkout.
  ///
  /// In id, this message translates to:
  /// **'Buka'**
  String get openWorkout;

  /// No description provided for @dataPrivacySection.
  ///
  /// In id, this message translates to:
  /// **'Data & privasi'**
  String get dataPrivacySection;

  /// No description provided for @dataLocalOnly.
  ///
  /// In id, this message translates to:
  /// **'Semua data tersimpan hanya di perangkat ini, tanpa akun dan tanpa server. Bila aplikasi dihapus atau HP hilang, data ikut hilang — fitur backup menyusul.'**
  String get dataLocalOnly;

  /// No description provided for @wipeData.
  ///
  /// In id, this message translates to:
  /// **'Hapus semua data'**
  String get wipeData;

  /// No description provided for @wipeDataTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus semua data?'**
  String get wipeDataTitle;

  /// No description provided for @wipeDataMessage.
  ///
  /// In id, this message translates to:
  /// **'Assessment, target, program, dan seluruh catatan latihan di perangkat ini akan dihapus permanen dan tidak dapat dipulihkan.'**
  String get wipeDataMessage;

  /// No description provided for @wipeDataConfirm.
  ///
  /// In id, this message translates to:
  /// **'Hapus permanen'**
  String get wipeDataConfirm;

  /// No description provided for @aiSettingsTitle.
  ///
  /// In id, this message translates to:
  /// **'AI Coach (Gemini)'**
  String get aiSettingsTitle;

  /// No description provided for @aiSettingsIntro.
  ///
  /// In id, this message translates to:
  /// **'Program latihan dapat disusun oleh Google Gemini memakai API key Anda sendiri. Key disimpan terenkripsi hanya di perangkat ini — tidak di aplikasi, server, atau backup.'**
  String get aiSettingsIntro;

  /// No description provided for @aiStatusReady.
  ///
  /// In id, this message translates to:
  /// **'Siap dipakai'**
  String get aiStatusReady;

  /// No description provided for @aiStatusNotReady.
  ///
  /// In id, this message translates to:
  /// **'Belum siap: simpan API key dan setujui pemrosesan data.'**
  String get aiStatusNotReady;

  /// No description provided for @aiKeyLabel.
  ///
  /// In id, this message translates to:
  /// **'API key Gemini'**
  String get aiKeyLabel;

  /// No description provided for @aiKeyHint.
  ///
  /// In id, this message translates to:
  /// **'Tempel key dari Google AI Studio'**
  String get aiKeyHint;

  /// No description provided for @aiKeySaved.
  ///
  /// In id, this message translates to:
  /// **'Key tersimpan (…{suffix})'**
  String aiKeySaved(Object suffix);

  /// No description provided for @aiSaveKey.
  ///
  /// In id, this message translates to:
  /// **'Simpan & uji'**
  String get aiSaveKey;

  /// No description provided for @aiKeyVerified.
  ///
  /// In id, this message translates to:
  /// **'API key valid dan tersimpan.'**
  String get aiKeyVerified;

  /// No description provided for @aiDeleteKey.
  ///
  /// In id, this message translates to:
  /// **'Hapus key'**
  String get aiDeleteKey;

  /// No description provided for @aiKeyDeleted.
  ///
  /// In id, this message translates to:
  /// **'API key dihapus dari perangkat.'**
  String get aiKeyDeleted;

  /// No description provided for @aiModelLabel.
  ///
  /// In id, this message translates to:
  /// **'Model'**
  String get aiModelLabel;

  /// No description provided for @aiConsentTitle.
  ///
  /// In id, this message translates to:
  /// **'Persetujuan pemrosesan data oleh AI'**
  String get aiConsentTitle;

  /// No description provided for @aiConsentBody.
  ///
  /// In id, this message translates to:
  /// **'Aplikasi hanya mengirim data ke Google Gemini saat kamu menekan tombol \"… dengan AI\":\n• Program latihan: tujuan, level & pengalaman, hari & durasi latihan, alat dan beban maksimal, otot prioritas, preferensi latihan, catatan cedera/gerakan yang dihindari, daftar gerakan katalog.\n• Menu harian: target kalori & makro, jumlah waktu makan, pola makan, alergi, makanan yang tidak disukai, preferensi, anggaran, akses memasak, daftar bahan TKPI.\n• Ringkasan mingguan: perubahan rata-rata berat, kepatuhan latihan & makan (persen), rata-rata tidur & energi, jumlah hari ada keluhan nyeri.\nTidak pernah dikirim: nama, umur, tanggal lahir, tinggi, berat badan absolut, jenis kondisi medis, atau isi catatan pribadi.'**
  String get aiConsentBody;

  /// No description provided for @aiFreeTierNote.
  ///
  /// In id, this message translates to:
  /// **'Di tier gratis Google AI Studio, Google dapat memakai isi permintaan untuk meningkatkan produknya. Gunakan tier berbayar bila Anda tidak menginginkannya.'**
  String get aiFreeTierNote;

  /// No description provided for @aiConsentCheckbox.
  ///
  /// In id, this message translates to:
  /// **'Saya setuju data di atas dikirim ke Google Gemini untuk fitur AI.'**
  String get aiConsentCheckbox;

  /// No description provided for @aiQuotaNote.
  ///
  /// In id, this message translates to:
  /// **'Batas {limit} kali penyusunan AI per hari (menahan biaya).'**
  String aiQuotaNote(Object limit);

  /// No description provided for @generateWithAi.
  ///
  /// In id, this message translates to:
  /// **'Susun dengan AI'**
  String get generateWithAi;

  /// No description provided for @generateTemplate.
  ///
  /// In id, this message translates to:
  /// **'Program template (tanpa AI)'**
  String get generateTemplate;

  /// No description provided for @aiGenerating.
  ///
  /// In id, this message translates to:
  /// **'Menyusun program dengan AI…'**
  String get aiGenerating;

  /// No description provided for @aiGeneratingHint.
  ///
  /// In id, this message translates to:
  /// **'Biasanya 10–60 detik. Hasilnya diperiksa aplikasi sebelum ditampilkan.'**
  String get aiGeneratingHint;

  /// No description provided for @aiErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Program AI belum bisa disusun'**
  String get aiErrorTitle;

  /// No description provided for @aiErrorSetup.
  ///
  /// In id, this message translates to:
  /// **'Simpan API key Gemini dan setujui pemrosesan data di Pengaturan AI terlebih dulu.'**
  String get aiErrorSetup;

  /// No description provided for @aiErrorQuota.
  ///
  /// In id, this message translates to:
  /// **'Batas penyusunan AI hari ini tercapai. Coba lagi besok atau pakai program template.'**
  String get aiErrorQuota;

  /// No description provided for @aiErrorInvalid.
  ///
  /// In id, this message translates to:
  /// **'Hasil AI tidak lolos pemeriksaan keamanan aplikasi (dicoba 2 kali). Coba lagi, atau pakai program template.'**
  String get aiErrorInvalid;

  /// No description provided for @openAiSettings.
  ///
  /// In id, this message translates to:
  /// **'Buka pengaturan AI'**
  String get openAiSettings;

  /// No description provided for @useTemplate.
  ///
  /// In id, this message translates to:
  /// **'Pakai template'**
  String get useTemplate;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @aiPlanBadge.
  ///
  /// In id, this message translates to:
  /// **'Estimasi AI · {model}'**
  String aiPlanBadge(Object model);

  /// No description provided for @aiPlanRationaleTitle.
  ///
  /// In id, this message translates to:
  /// **'Alasan dari AI'**
  String get aiPlanRationaleTitle;

  /// No description provided for @aiPlanValidated.
  ///
  /// In id, this message translates to:
  /// **'Diperiksa aplikasi: gerakan dari katalog, alat & level sesuai, angka dalam batas aman. Tetap tinjau sebelum mengaktifkan.'**
  String get aiPlanValidated;

  /// No description provided for @chooseGenerator.
  ///
  /// In id, this message translates to:
  /// **'Buat program baru'**
  String get chooseGenerator;

  /// No description provided for @reminderWorkoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Waktunya latihan: {focus}'**
  String reminderWorkoutTitle(Object focus);

  /// No description provided for @reminderWorkoutBody.
  ///
  /// In id, this message translates to:
  /// **'{count} latihan · ± {minutes} menit. Ketuk untuk membuka sesi.'**
  String reminderWorkoutBody(Object count, Object minutes);

  /// No description provided for @reminderBreakfastTitle.
  ///
  /// In id, this message translates to:
  /// **'Waktunya sarapan'**
  String get reminderBreakfastTitle;

  /// No description provided for @reminderLunchTitle.
  ///
  /// In id, this message translates to:
  /// **'Waktunya makan siang'**
  String get reminderLunchTitle;

  /// No description provided for @reminderDinnerTitle.
  ///
  /// In id, this message translates to:
  /// **'Waktunya makan malam'**
  String get reminderDinnerTitle;

  /// No description provided for @reminderSnackTitle.
  ///
  /// In id, this message translates to:
  /// **'Waktunya snack'**
  String get reminderSnackTitle;

  /// No description provided for @reminderMealBody.
  ///
  /// In id, this message translates to:
  /// **'Makan cukup protein membantu pemulihan otot.'**
  String get reminderMealBody;

  /// No description provided for @reminderWeighInTitle.
  ///
  /// In id, this message translates to:
  /// **'Waktunya timbang berat badan'**
  String get reminderWeighInTitle;

  /// No description provided for @reminderWeighInBody.
  ///
  /// In id, this message translates to:
  /// **'Timbang dalam kondisi sama (pagi, setelah ke toilet, sebelum makan) agar trennya akurat.'**
  String get reminderWeighInBody;

  /// No description provided for @reminderCheckInTitle.
  ///
  /// In id, this message translates to:
  /// **'Check-in harian'**
  String get reminderCheckInTitle;

  /// No description provided for @reminderCheckInBody.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana energi, tidur, dan latihan hari ini?'**
  String get reminderCheckInBody;

  /// No description provided for @reminderExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: latihan {days} pukul {workout}, sarapan {breakfast}, check-in {checkIn}.'**
  String reminderExample(Object days, Object workout, Object breakfast, Object checkIn);

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengingat'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationIntro.
  ///
  /// In id, this message translates to:
  /// **'Pengingat dijadwalkan langsung di perangkat — tetap berjalan tanpa internet dan tanpa AI. Waktu dapat sedikit tertunda karena penghematan baterai.'**
  String get notificationIntro;

  /// No description provided for @notificationEnable.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan pengingat'**
  String get notificationEnable;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In id, this message translates to:
  /// **'Izinkan notifikasi?'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In id, this message translates to:
  /// **'Muscle Coach butuh izin notifikasi untuk mengingatkan sesi latihan, waktu makan, timbang, dan check-in sesuai jadwal yang Anda atur.'**
  String get notificationPermissionBody;

  /// No description provided for @notificationPermissionAllow.
  ///
  /// In id, this message translates to:
  /// **'Izinkan'**
  String get notificationPermissionAllow;

  /// No description provided for @notificationDenied.
  ///
  /// In id, this message translates to:
  /// **'Izin notifikasi ditolak. Aktifkan di pengaturan sistem agar pengingat dapat muncul.'**
  String get notificationDenied;

  /// No description provided for @openSystemSettings.
  ///
  /// In id, this message translates to:
  /// **'Buka pengaturan sistem'**
  String get openSystemSettings;

  /// No description provided for @notificationBatteryHint.
  ///
  /// In id, this message translates to:
  /// **'Bila pengingat tidak muncul, izinkan Muscle Coach berjalan di latar belakang / matikan optimasi baterai untuk aplikasi ini (pengaturan HP).'**
  String get notificationBatteryHint;

  /// No description provided for @notificationScheduled.
  ///
  /// In id, this message translates to:
  /// **'{count} pengingat terjadwal untuk 14 hari ke depan.'**
  String notificationScheduled(Object count);

  /// No description provided for @notificationTimezone.
  ///
  /// In id, this message translates to:
  /// **'Zona waktu: {zone}'**
  String notificationTimezone(Object zone);

  /// No description provided for @reminderWorkoutLabel.
  ///
  /// In id, this message translates to:
  /// **'Sesi latihan'**
  String get reminderWorkoutLabel;

  /// No description provided for @reminderWorkoutHelp.
  ///
  /// In id, this message translates to:
  /// **'Pada hari latihan program aktif: {days}.'**
  String reminderWorkoutHelp(Object days);

  /// No description provided for @reminderWorkoutNoPlan.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan program latihan agar pengingat sesi terjadwal.'**
  String get reminderWorkoutNoPlan;

  /// No description provided for @reminderMealsLabel.
  ///
  /// In id, this message translates to:
  /// **'Waktu makan'**
  String get reminderMealsLabel;

  /// No description provided for @breakfastLabel.
  ///
  /// In id, this message translates to:
  /// **'Sarapan'**
  String get breakfastLabel;

  /// No description provided for @lunchLabel.
  ///
  /// In id, this message translates to:
  /// **'Makan siang'**
  String get lunchLabel;

  /// No description provided for @dinnerLabel.
  ///
  /// In id, this message translates to:
  /// **'Makan malam'**
  String get dinnerLabel;

  /// No description provided for @snackLabel.
  ///
  /// In id, this message translates to:
  /// **'Snack'**
  String get snackLabel;

  /// No description provided for @reminderWeighInLabel.
  ///
  /// In id, this message translates to:
  /// **'Timbang berat badan'**
  String get reminderWeighInLabel;

  /// No description provided for @reminderCheckInLabel.
  ///
  /// In id, this message translates to:
  /// **'Check-in harian'**
  String get reminderCheckInLabel;

  /// No description provided for @quietHoursLabel.
  ///
  /// In id, this message translates to:
  /// **'Jam tenang'**
  String get quietHoursLabel;

  /// No description provided for @quietHoursHelp.
  ///
  /// In id, this message translates to:
  /// **'Pengingat yang jatuh di jam tenang dilewati.'**
  String get quietHoursHelp;

  /// No description provided for @quietStart.
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get quietStart;

  /// No description provided for @quietEnd.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get quietEnd;

  /// No description provided for @sendTestNotification.
  ///
  /// In id, this message translates to:
  /// **'Kirim notifikasi uji'**
  String get sendTestNotification;

  /// No description provided for @testNotificationTitle.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi uji'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In id, this message translates to:
  /// **'Pengingat Muscle Coach berfungsi.'**
  String get testNotificationBody;

  /// No description provided for @profileRemindersTile.
  ///
  /// In id, this message translates to:
  /// **'Pengingat'**
  String get profileRemindersTile;

  /// No description provided for @remindersOn.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get remindersOn;

  /// No description provided for @remindersOff.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif'**
  String get remindersOff;

  /// No description provided for @exerciseMovementTitle.
  ///
  /// In id, this message translates to:
  /// **'Gerakan'**
  String get exerciseMovementTitle;

  /// No description provided for @exercisePhotoCredit.
  ///
  /// In id, this message translates to:
  /// **'Foto: Free Exercise DB (domain publik). Variasi alat di foto bisa sedikit berbeda.'**
  String get exercisePhotoCredit;

  /// No description provided for @exercisePhotoSemantics.
  ///
  /// In id, this message translates to:
  /// **'Foto gerakan {name}, fase {frame}'**
  String exercisePhotoSemantics(String name, String frame);

  /// No description provided for @playMotion.
  ///
  /// In id, this message translates to:
  /// **'Putar gerakan'**
  String get playMotion;

  /// No description provided for @pauseMotion.
  ///
  /// In id, this message translates to:
  /// **'Jeda gerakan'**
  String get pauseMotion;

  /// No description provided for @muscleMapTitle.
  ///
  /// In id, this message translates to:
  /// **'Otot yang dilatih'**
  String get muscleMapTitle;

  /// No description provided for @muscleMapFront.
  ///
  /// In id, this message translates to:
  /// **'Depan'**
  String get muscleMapFront;

  /// No description provided for @muscleMapBack.
  ///
  /// In id, this message translates to:
  /// **'Belakang'**
  String get muscleMapBack;

  /// No description provided for @muscleMapSemantics.
  ///
  /// In id, this message translates to:
  /// **'Peta otot. Otot utama: {primary}. Otot pendukung: {secondary}.'**
  String muscleMapSemantics(String primary, String secondary);

  /// No description provided for @noneLabel.
  ///
  /// In id, this message translates to:
  /// **'tidak ada'**
  String get noneLabel;

  /// No description provided for @exerciseQuickViewHint.
  ///
  /// In id, this message translates to:
  /// **'Ketuk gambar untuk melihat gerakan'**
  String get exerciseQuickViewHint;

  /// No description provided for @exerciseOpenDetail.
  ///
  /// In id, this message translates to:
  /// **'Lihat detail lengkap'**
  String get exerciseOpenDetail;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @nutritionToday.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get nutritionToday;

  /// No description provided for @nutritionPrevDay.
  ///
  /// In id, this message translates to:
  /// **'Hari sebelumnya'**
  String get nutritionPrevDay;

  /// No description provided for @nutritionNextDay.
  ///
  /// In id, this message translates to:
  /// **'Hari berikutnya'**
  String get nutritionNextDay;

  /// No description provided for @nutritionConsumed.
  ///
  /// In id, this message translates to:
  /// **'Tercatat'**
  String get nutritionConsumed;

  /// No description provided for @nutritionRemaining.
  ///
  /// In id, this message translates to:
  /// **'Sisa'**
  String get nutritionRemaining;

  /// No description provided for @nutritionOver.
  ///
  /// In id, this message translates to:
  /// **'Lebih'**
  String get nutritionOver;

  /// No description provided for @nutritionOfTarget.
  ///
  /// In id, this message translates to:
  /// **'dari {target}'**
  String nutritionOfTarget(Object target);

  /// No description provided for @nutritionKcalLeft.
  ///
  /// In id, this message translates to:
  /// **'Sisa {kcal} kcal'**
  String nutritionKcalLeft(Object kcal);

  /// No description provided for @nutritionKcalOver.
  ///
  /// In id, this message translates to:
  /// **'Lebih {kcal} kcal'**
  String nutritionKcalOver(Object kcal);

  /// No description provided for @nutritionMacroProgress.
  ///
  /// In id, this message translates to:
  /// **'{got} / {target} g'**
  String nutritionMacroProgress(Object got, Object target);

  /// No description provided for @nutritionEstimateNote.
  ///
  /// In id, this message translates to:
  /// **'Angka gizi adalah estimasi dari TKPI per 100 g bagian yang dapat dimakan; porsi & cara masak bisa membuat nilainya berbeda.'**
  String get nutritionEstimateNote;

  /// No description provided for @nutritionHasEstimates.
  ///
  /// In id, this message translates to:
  /// **'Sebagian catatan memakai angka dari label/manual atau data sumber yang perlu dicek.'**
  String get nutritionHasEstimates;

  /// No description provided for @nutritionAddFood.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get nutritionAddFood;

  /// No description provided for @nutritionAddTo.
  ///
  /// In id, this message translates to:
  /// **'Tambah ke {meal}'**
  String nutritionAddTo(Object meal);

  /// No description provided for @nutritionEmptyMeal.
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan'**
  String get nutritionEmptyMeal;

  /// No description provided for @nutritionWaterTitle.
  ///
  /// In id, this message translates to:
  /// **'Minum air'**
  String get nutritionWaterTitle;

  /// No description provided for @nutritionWaterBody.
  ///
  /// In id, this message translates to:
  /// **'Biasakan minum air sepanjang hari, terutama saat latihan dan cuaca panas. Ini pengingat kebiasaan umum, bukan anjuran medis pribadi.'**
  String get nutritionWaterBody;

  /// No description provided for @nutritionHomeTitle.
  ///
  /// In id, this message translates to:
  /// **'Nutrisi hari ini'**
  String get nutritionHomeTitle;

  /// No description provided for @nutritionHomeLog.
  ///
  /// In id, this message translates to:
  /// **'Catat makanan'**
  String get nutritionHomeLog;

  /// No description provided for @entryGrams.
  ///
  /// In id, this message translates to:
  /// **'{grams} g'**
  String entryGrams(Object grams);

  /// No description provided for @entryMacros.
  ///
  /// In id, this message translates to:
  /// **'P {p} · K {c} · L {f}'**
  String entryMacros(Object p, Object c, Object f);

  /// No description provided for @entryManual.
  ///
  /// In id, this message translates to:
  /// **'manual'**
  String get entryManual;

  /// No description provided for @entryLabel.
  ///
  /// In id, this message translates to:
  /// **'label'**
  String get entryLabel;

  /// No description provided for @entryCheck.
  ///
  /// In id, this message translates to:
  /// **'cek data'**
  String get entryCheck;

  /// No description provided for @entryDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus catatan?'**
  String get entryDeleteTitle;

  /// No description provided for @entryDeleted.
  ///
  /// In id, this message translates to:
  /// **'Catatan dihapus'**
  String get entryDeleted;

  /// No description provided for @entrySaved.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan'**
  String get entrySaved;

  /// No description provided for @foodSearchTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah makanan'**
  String get foodSearchTitle;

  /// No description provided for @foodSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari makanan, mis. nasi, tempe, telur'**
  String get foodSearchHint;

  /// No description provided for @foodRecent.
  ///
  /// In id, this message translates to:
  /// **'Terakhir dicatat'**
  String get foodRecent;

  /// No description provided for @foodRecentEmpty.
  ///
  /// In id, this message translates to:
  /// **'Ketik nama makanan untuk mencari di Tabel Komposisi Pangan Indonesia (TKPI).'**
  String get foodRecentEmpty;

  /// No description provided for @foodNoResult.
  ///
  /// In id, this message translates to:
  /// **'Tidak ditemukan. Coba kata lain, atau tambahkan dari label kemasan.'**
  String get foodNoResult;

  /// No description provided for @foodPer100.
  ///
  /// In id, this message translates to:
  /// **'{kcal} kcal / 100 g'**
  String foodPer100(Object kcal);

  /// No description provided for @foodCustomBadge.
  ///
  /// In id, this message translates to:
  /// **'Milik saya'**
  String get foodCustomBadge;

  /// No description provided for @foodInconsistentBadge.
  ///
  /// In id, this message translates to:
  /// **'Cek data'**
  String get foodInconsistentBadge;

  /// No description provided for @foodAddCustom.
  ///
  /// In id, this message translates to:
  /// **'Makanan dari label kemasan'**
  String get foodAddCustom;

  /// No description provided for @foodAddManual.
  ///
  /// In id, this message translates to:
  /// **'Catat kalori/makro saja'**
  String get foodAddManual;

  /// No description provided for @foodSourceAttribution.
  ///
  /// In id, this message translates to:
  /// **'Sumber: {name}, {publisher} (panganku.org). Data diambil {date}.'**
  String foodSourceAttribution(Object name, Object publisher, Object date);

  /// No description provided for @portionTitle.
  ///
  /// In id, this message translates to:
  /// **'Porsi'**
  String get portionTitle;

  /// No description provided for @portionGrams.
  ///
  /// In id, this message translates to:
  /// **'Berat (g)'**
  String get portionGrams;

  /// No description provided for @portionGramsError.
  ///
  /// In id, this message translates to:
  /// **'Isi 1–5000 g'**
  String get portionGramsError;

  /// No description provided for @portionMeal.
  ///
  /// In id, this message translates to:
  /// **'Waktu makan'**
  String get portionMeal;

  /// No description provided for @portionEdible.
  ///
  /// In id, this message translates to:
  /// **'Nilai per 100 g bagian yang dapat dimakan ({pct}%). Timbang tanpa kulit/tulang.'**
  String portionEdible(Object pct);

  /// No description provided for @portionInconsistent.
  ///
  /// In id, this message translates to:
  /// **'Di sumber, energi makanan ini tidak cocok dengan protein/lemak/karbohidratnya. Angka tetap ditampilkan apa adanya — anggap sebagai perkiraan kasar.'**
  String get portionInconsistent;

  /// No description provided for @portionLast.
  ///
  /// In id, this message translates to:
  /// **'Terakhir {grams} g'**
  String portionLast(Object grams);

  /// No description provided for @customFoodTitle.
  ///
  /// In id, this message translates to:
  /// **'Makanan dari label'**
  String get customFoodTitle;

  /// No description provided for @customFoodName.
  ///
  /// In id, this message translates to:
  /// **'Nama makanan'**
  String get customFoodName;

  /// No description provided for @customFoodBasis.
  ///
  /// In id, this message translates to:
  /// **'Nilai gizi per (g)'**
  String get customFoodBasis;

  /// No description provided for @customFoodBasisHelp.
  ///
  /// In id, this message translates to:
  /// **'Isi sesuai label, mis. \"per sajian 30 g\" → 30.'**
  String get customFoodBasisHelp;

  /// No description provided for @customFoodKcal.
  ///
  /// In id, this message translates to:
  /// **'Energi (kcal)'**
  String get customFoodKcal;

  /// No description provided for @customFoodProtein.
  ///
  /// In id, this message translates to:
  /// **'Protein (g)'**
  String get customFoodProtein;

  /// No description provided for @customFoodCarbs.
  ///
  /// In id, this message translates to:
  /// **'Karbohidrat (g)'**
  String get customFoodCarbs;

  /// No description provided for @customFoodFat.
  ///
  /// In id, this message translates to:
  /// **'Lemak (g)'**
  String get customFoodFat;

  /// No description provided for @customFoodRequired.
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi'**
  String get customFoodRequired;

  /// No description provided for @customFoodNumber.
  ///
  /// In id, this message translates to:
  /// **'Isi angka 0–5000'**
  String get customFoodNumber;

  /// No description provided for @customFoodMismatch.
  ///
  /// In id, this message translates to:
  /// **'Energi pada label berbeda jauh dari hitungan makro (≈{kcal} kcal). Periksa lagi angkanya.'**
  String customFoodMismatch(Object kcal);

  /// No description provided for @customFoodSaved.
  ///
  /// In id, this message translates to:
  /// **'Makanan disimpan'**
  String get customFoodSaved;

  /// No description provided for @customFoodDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus makanan saya'**
  String get customFoodDelete;

  /// No description provided for @manualTitle.
  ///
  /// In id, this message translates to:
  /// **'Catat kalori/makro'**
  String get manualTitle;

  /// No description provided for @manualName.
  ///
  /// In id, this message translates to:
  /// **'Keterangan'**
  String get manualName;

  /// No description provided for @manualNameHint.
  ///
  /// In id, this message translates to:
  /// **'mis. Nasi padang (perkiraan)'**
  String get manualNameHint;

  /// No description provided for @mealPlanTitle.
  ///
  /// In id, this message translates to:
  /// **'Contoh menu harian'**
  String get mealPlanTitle;

  /// No description provided for @mealPlanEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada menu. AI bisa menyusun contoh menu dari bahan TKPI sesuai target dan preferensi makanmu.'**
  String get mealPlanEmpty;

  /// No description provided for @mealPlanGenerate.
  ///
  /// In id, this message translates to:
  /// **'Susun menu dengan AI'**
  String get mealPlanGenerate;

  /// No description provided for @mealPlanRegenerate.
  ///
  /// In id, this message translates to:
  /// **'Susun ulang'**
  String get mealPlanRegenerate;

  /// No description provided for @mealPlanGenerating.
  ///
  /// In id, this message translates to:
  /// **'Menyusun menu dengan AI…'**
  String get mealPlanGenerating;

  /// No description provided for @mealPlanErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Menu AI belum bisa disusun'**
  String get mealPlanErrorTitle;

  /// No description provided for @mealPlanErrorInvalid.
  ///
  /// In id, this message translates to:
  /// **'Hasil AI tidak memenuhi target atau aturan aplikasi (dicoba 2 kali). Coba lagi.'**
  String get mealPlanErrorInvalid;

  /// No description provided for @mealPlanErrorQuota.
  ///
  /// In id, this message translates to:
  /// **'Batas penyusunan AI hari ini tercapai. Coba lagi besok.'**
  String get mealPlanErrorQuota;

  /// No description provided for @mealPlanAiLabel.
  ///
  /// In id, this message translates to:
  /// **'Estimasi AI'**
  String get mealPlanAiLabel;

  /// No description provided for @mealPlanTotals.
  ///
  /// In id, this message translates to:
  /// **'Total menu: {kcal} · P {p} g · K {c} g · L {f} g'**
  String mealPlanTotals(Object kcal, Object p, Object c, Object f);

  /// No description provided for @mealPlanVsTarget.
  ///
  /// In id, this message translates to:
  /// **'Target: {kcal} · P {p} g · K {c} g · L {f} g'**
  String mealPlanVsTarget(Object kcal, Object p, Object c, Object f);

  /// No description provided for @mealPlanRecalc.
  ///
  /// In id, this message translates to:
  /// **'Total dihitung aplikasi dari data TKPI × gram, bukan dari AI.'**
  String get mealPlanRecalc;

  /// No description provided for @mealPlanUse.
  ///
  /// In id, this message translates to:
  /// **'Pakai menu ini'**
  String get mealPlanUse;

  /// No description provided for @mealPlanDiscard.
  ///
  /// In id, this message translates to:
  /// **'Buang'**
  String get mealPlanDiscard;

  /// No description provided for @mealPlanActivated.
  ///
  /// In id, this message translates to:
  /// **'Menu dipakai'**
  String get mealPlanActivated;

  /// No description provided for @mealPlanMarkEaten.
  ///
  /// In id, this message translates to:
  /// **'Tandai dimakan'**
  String get mealPlanMarkEaten;

  /// No description provided for @mealPlanEaten.
  ///
  /// In id, this message translates to:
  /// **'Sudah dicatat'**
  String get mealPlanEaten;

  /// No description provided for @mealPlanUndoEaten.
  ///
  /// In id, this message translates to:
  /// **'Batalkan'**
  String get mealPlanUndoEaten;

  /// No description provided for @mealPlanEatenSnack.
  ///
  /// In id, this message translates to:
  /// **'{meal} dicatat ke hari ini'**
  String mealPlanEatenSnack(Object meal);

  /// No description provided for @mealPlanOpen.
  ///
  /// In id, this message translates to:
  /// **'Lihat menu'**
  String get mealPlanOpen;

  /// No description provided for @mealPlanWarnEatingDisorder.
  ///
  /// In id, this message translates to:
  /// **'Kamu mencatat riwayat gangguan makan. Gunakan menu ini hanya sebagai gambaran dan diskusikan pola makanmu dengan tenaga kesehatan.'**
  String get mealPlanWarnEatingDisorder;

  /// No description provided for @mealPlanWarnAllergy.
  ///
  /// In id, this message translates to:
  /// **'Aplikasi hanya memeriksa alergen dari nama bahan. Selalu cek sendiri bahan & bumbu yang dipakai.'**
  String get mealPlanWarnAllergy;

  /// No description provided for @mealPlanWarnInconsistent.
  ///
  /// In id, this message translates to:
  /// **'Ada bahan yang angka sumbernya perlu dicek; totalnya bisa kurang tepat.'**
  String get mealPlanWarnInconsistent;

  /// No description provided for @mealPlanModel.
  ///
  /// In id, this message translates to:
  /// **'Disusun oleh {model} · {version}'**
  String mealPlanModel(Object model, Object version);

  /// No description provided for @weightTitle.
  ///
  /// In id, this message translates to:
  /// **'Berat badan'**
  String get weightTitle;

  /// No description provided for @weightNote.
  ///
  /// In id, this message translates to:
  /// **'Berat badan bukan massa otot. Nilai dinilai dari rata-rata mingguan, bukan satu penimbangan.'**
  String get weightNote;

  /// No description provided for @weightLog.
  ///
  /// In id, this message translates to:
  /// **'Catat berat'**
  String get weightLog;

  /// No description provided for @weightLatest.
  ///
  /// In id, this message translates to:
  /// **'Terakhir {kg} kg · {date}'**
  String weightLatest(Object kg, Object date);

  /// No description provided for @weightAvg7.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata 7 hari {kg} kg'**
  String weightAvg7(Object kg);

  /// No description provided for @weightEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada penimbangan. Timbang 2–3× per minggu pada kondisi yang sama (mis. pagi setelah ke toilet).'**
  String get weightEmpty;

  /// No description provided for @weightSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Catat berat badan'**
  String get weightSheetTitle;

  /// No description provided for @weightField.
  ///
  /// In id, this message translates to:
  /// **'Berat (kg)'**
  String get weightField;

  /// No description provided for @weightDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get weightDate;

  /// No description provided for @weightRangeError.
  ///
  /// In id, this message translates to:
  /// **'Isi 25–400 kg'**
  String get weightRangeError;

  /// No description provided for @weightSaved.
  ///
  /// In id, this message translates to:
  /// **'Berat tersimpan'**
  String get weightSaved;

  /// No description provided for @weightDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus penimbangan {date}?'**
  String weightDeleteTitle(Object date);

  /// No description provided for @goalStatusTitle.
  ///
  /// In id, this message translates to:
  /// **'Status target'**
  String get goalStatusTitle;

  /// No description provided for @goalStatusInsufficient.
  ///
  /// In id, this message translates to:
  /// **'Data belum cukup'**
  String get goalStatusInsufficient;

  /// No description provided for @goalStatusInsufficientBody.
  ///
  /// In id, this message translates to:
  /// **'Butuh minimal 2 minggu berurutan dengan ≥ 2 penimbangan per minggu sebelum tren bisa dinilai.'**
  String get goalStatusInsufficientBody;

  /// No description provided for @goalStatusOnTrack.
  ///
  /// In id, this message translates to:
  /// **'On track'**
  String get goalStatusOnTrack;

  /// No description provided for @goalStatusOnTrackBody.
  ///
  /// In id, this message translates to:
  /// **'Perubahan rata-rata minggu lalu {change} kg, dalam rentang yang diharapkan ({min}–{max} kg/minggu).'**
  String goalStatusOnTrackBody(Object change, Object min, Object max);

  /// No description provided for @goalStatusReview.
  ///
  /// In id, this message translates to:
  /// **'Perlu evaluasi'**
  String get goalStatusReview;

  /// No description provided for @goalStatusReviewBody.
  ///
  /// In id, this message translates to:
  /// **'Perubahan rata-rata minggu lalu {change} kg, di luar rentang {min}–{max} kg/minggu. Pantau satu minggu lagi sebelum mengubah apa pun.'**
  String goalStatusReviewBody(Object change, Object min, Object max);

  /// No description provided for @goalStatusAdjust.
  ///
  /// In id, this message translates to:
  /// **'Target perlu disesuaikan'**
  String get goalStatusAdjust;

  /// No description provided for @goalStatusAdjustBody.
  ///
  /// In id, this message translates to:
  /// **'Dua minggu berturut-turut perubahan berat di luar rentang {min}–{max} kg/minggu. Lihat usulan di ringkasan mingguan.'**
  String goalStatusAdjustBody(Object min, Object max);

  /// No description provided for @intakeChartTitle.
  ///
  /// In id, this message translates to:
  /// **'Asupan vs target (14 hari)'**
  String get intakeChartTitle;

  /// No description provided for @intakeChartEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan makan.'**
  String get intakeChartEmpty;

  /// No description provided for @intakeChartLegend.
  ///
  /// In id, this message translates to:
  /// **'Batang = kalori tercatat · garis = target {kcal}'**
  String intakeChartLegend(Object kcal);

  /// No description provided for @volumeChartTitle.
  ///
  /// In id, this message translates to:
  /// **'Volume latihan per minggu'**
  String get volumeChartTitle;

  /// No description provided for @volumeChartNote.
  ///
  /// In id, this message translates to:
  /// **'Volume = beban × repetisi dari set yang selesai (set berbasis waktu tidak dihitung).'**
  String get volumeChartNote;

  /// No description provided for @volumeChartEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada sesi selesai.'**
  String get volumeChartEmpty;

  /// No description provided for @volumeWeek.
  ///
  /// In id, this message translates to:
  /// **'{sessions} sesi'**
  String volumeWeek(Object sessions);

  /// No description provided for @exerciseChartTitle.
  ///
  /// In id, this message translates to:
  /// **'Progres per gerakan'**
  String get exerciseChartTitle;

  /// No description provided for @exerciseChartHint.
  ///
  /// In id, this message translates to:
  /// **'Set terberat per sesi'**
  String get exerciseChartHint;

  /// No description provided for @exerciseChartEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada set berbeban yang tercatat.'**
  String get exerciseChartEmpty;

  /// No description provided for @exerciseChartLatest.
  ///
  /// In id, this message translates to:
  /// **'Terakhir {kg} kg × {reps}'**
  String exerciseChartLatest(Object kg, Object reps);

  /// No description provided for @milestonesTitle.
  ///
  /// In id, this message translates to:
  /// **'Pencapaian'**
  String get milestonesTitle;

  /// No description provided for @milestoneSessions.
  ///
  /// In id, this message translates to:
  /// **'{n} sesi selesai'**
  String milestoneSessions(Object n);

  /// No description provided for @milestoneSets.
  ///
  /// In id, this message translates to:
  /// **'{n} set tercatat'**
  String milestoneSets(Object n);

  /// No description provided for @milestoneStreak.
  ///
  /// In id, this message translates to:
  /// **'{n} minggu berturut-turut latihan'**
  String milestoneStreak(Object n);

  /// No description provided for @milestoneWeight.
  ///
  /// In id, this message translates to:
  /// **'Berat {change} kg sejak awal (rata-rata mingguan)'**
  String milestoneWeight(Object change);

  /// No description provided for @checkInTitle.
  ///
  /// In id, this message translates to:
  /// **'Check-in harian'**
  String get checkInTitle;

  /// No description provided for @checkInToday.
  ///
  /// In id, this message translates to:
  /// **'Check-in hari ini'**
  String get checkInToday;

  /// No description provided for @checkInMarkedDone.
  ///
  /// In id, this message translates to:
  /// **'Ditandai selesai dari notifikasi. Tambahkan detail bila sempat.'**
  String get checkInMarkedDone;

  /// No description provided for @measurementsTitle.
  ///
  /// In id, this message translates to:
  /// **'Lingkar badan'**
  String get measurementsTitle;

  /// No description provided for @measurementsLog.
  ///
  /// In id, this message translates to:
  /// **'Catat ukuran'**
  String get measurementsLog;

  /// No description provided for @measurementsEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada ukuran. Lingkar badan membantu melihat perubahan bentuk tubuh yang tidak tampak dari berat saja.'**
  String get measurementsEmpty;

  /// No description provided for @measurementsNote.
  ///
  /// In id, this message translates to:
  /// **'Ukur di titik yang sama, pagi hari sebelum makan, dengan pita ukur tidak ditarik kencang. Lingkar badan tidak mengukur massa otot secara langsung.'**
  String get measurementsNote;

  /// No description provided for @siteWaist.
  ///
  /// In id, this message translates to:
  /// **'Pinggang'**
  String get siteWaist;

  /// No description provided for @siteChest.
  ///
  /// In id, this message translates to:
  /// **'Dada'**
  String get siteChest;

  /// No description provided for @siteArm.
  ///
  /// In id, this message translates to:
  /// **'Lengan atas'**
  String get siteArm;

  /// No description provided for @siteThigh.
  ///
  /// In id, this message translates to:
  /// **'Paha'**
  String get siteThigh;

  /// No description provided for @siteHip.
  ///
  /// In id, this message translates to:
  /// **'Pinggul'**
  String get siteHip;

  /// No description provided for @measurementLatest.
  ///
  /// In id, this message translates to:
  /// **'{value} cm · {date}'**
  String measurementLatest(Object value, Object date);

  /// No description provided for @measurementChange.
  ///
  /// In id, this message translates to:
  /// **'{delta} cm sejak {date}'**
  String measurementChange(Object delta, Object date);

  /// No description provided for @measurementSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Catat lingkar badan'**
  String get measurementSheetTitle;

  /// No description provided for @measurementSheetHint.
  ///
  /// In id, this message translates to:
  /// **'Isi ukuran yang Anda ukur saja; yang kosong tidak disimpan.'**
  String get measurementSheetHint;

  /// No description provided for @measurementDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal pengukuran'**
  String get measurementDate;

  /// No description provided for @measurementRangeError.
  ///
  /// In id, this message translates to:
  /// **'Antara 10–250 cm'**
  String get measurementRangeError;

  /// No description provided for @measurementSaved.
  ///
  /// In id, this message translates to:
  /// **'Ukuran tersimpan.'**
  String get measurementSaved;

  /// No description provided for @measurementChartLabel.
  ///
  /// In id, this message translates to:
  /// **'Grafik lingkar {site}'**
  String measurementChartLabel(Object site);

  /// No description provided for @photosTitle.
  ///
  /// In id, this message translates to:
  /// **'Foto progres'**
  String get photosTitle;

  /// No description provided for @photosAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah foto'**
  String get photosAdd;

  /// No description provided for @photosEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada foto. Foto dengan pose, tempat, dan cahaya yang sama tiap 2–4 minggu memudahkan melihat perubahan.'**
  String get photosEmpty;

  /// No description provided for @photosPrivacy.
  ///
  /// In id, this message translates to:
  /// **'Foto hanya disimpan di HP ini, tidak dikirim ke AI, dan ikut terhapus saat \"Hapus semua data\".'**
  String get photosPrivacy;

  /// No description provided for @poseFront.
  ///
  /// In id, this message translates to:
  /// **'Depan'**
  String get poseFront;

  /// No description provided for @poseSide.
  ///
  /// In id, this message translates to:
  /// **'Samping'**
  String get poseSide;

  /// No description provided for @poseBack.
  ///
  /// In id, this message translates to:
  /// **'Belakang'**
  String get poseBack;

  /// No description provided for @photoSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah foto progres'**
  String get photoSheetTitle;

  /// No description provided for @photoPose.
  ///
  /// In id, this message translates to:
  /// **'Pose'**
  String get photoPose;

  /// No description provided for @photoDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal foto'**
  String get photoDate;

  /// No description provided for @photoCamera.
  ///
  /// In id, this message translates to:
  /// **'Kamera'**
  String get photoCamera;

  /// No description provided for @photoGallery.
  ///
  /// In id, this message translates to:
  /// **'Galeri'**
  String get photoGallery;

  /// No description provided for @photoSaved.
  ///
  /// In id, this message translates to:
  /// **'Foto tersimpan.'**
  String get photoSaved;

  /// No description provided for @photoFailed.
  ///
  /// In id, this message translates to:
  /// **'Foto tidak bisa diambil atau disimpan. Periksa izin kamera/galeri di pengaturan.'**
  String get photoFailed;

  /// No description provided for @photoDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus foto ini?'**
  String get photoDeleteTitle;

  /// No description provided for @photoDeleteMessage.
  ///
  /// In id, this message translates to:
  /// **'Foto dihapus dari HP ini dan tidak bisa dikembalikan.'**
  String get photoDeleteMessage;

  /// No description provided for @photoDeleted.
  ///
  /// In id, this message translates to:
  /// **'Foto dihapus.'**
  String get photoDeleted;

  /// No description provided for @photoCompare.
  ///
  /// In id, this message translates to:
  /// **'Bandingkan'**
  String get photoCompare;

  /// No description provided for @photoCompareTitle.
  ///
  /// In id, this message translates to:
  /// **'Bandingkan foto'**
  String get photoCompareTitle;

  /// No description provided for @photoCompareNeedTwo.
  ///
  /// In id, this message translates to:
  /// **'Butuh minimal dua tanggal dengan pose yang sama.'**
  String get photoCompareNeedTwo;

  /// No description provided for @photoBefore.
  ///
  /// In id, this message translates to:
  /// **'Sebelum'**
  String get photoBefore;

  /// No description provided for @photoAfter.
  ///
  /// In id, this message translates to:
  /// **'Sesudah'**
  String get photoAfter;

  /// No description provided for @photoWeightOn.
  ///
  /// In id, this message translates to:
  /// **'Berat {kg} kg'**
  String photoWeightOn(Object kg);

  /// No description provided for @photoMissing.
  ///
  /// In id, this message translates to:
  /// **'Berkas foto tidak ditemukan'**
  String get photoMissing;

  /// No description provided for @photoOpenLabel.
  ///
  /// In id, this message translates to:
  /// **'Foto {pose} {date}'**
  String photoOpenLabel(Object pose, Object date);

  /// No description provided for @checkInDone.
  ///
  /// In id, this message translates to:
  /// **'Check-in hari ini sudah diisi'**
  String get checkInDone;

  /// No description provided for @checkInPrompt.
  ///
  /// In id, this message translates to:
  /// **'Catat tidur, energi, dan kendala hari ini (1 menit).'**
  String get checkInPrompt;

  /// No description provided for @checkInOpen.
  ///
  /// In id, this message translates to:
  /// **'Isi check-in'**
  String get checkInOpen;

  /// No description provided for @checkInEdit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get checkInEdit;

  /// No description provided for @checkInWeight.
  ///
  /// In id, this message translates to:
  /// **'Berat badan (kg, opsional)'**
  String get checkInWeight;

  /// No description provided for @checkInSleep.
  ///
  /// In id, this message translates to:
  /// **'Tidur semalam (jam)'**
  String get checkInSleep;

  /// No description provided for @checkInEnergy.
  ///
  /// In id, this message translates to:
  /// **'Energi'**
  String get checkInEnergy;

  /// No description provided for @checkInMood.
  ///
  /// In id, this message translates to:
  /// **'Suasana hati (opsional)'**
  String get checkInMood;

  /// No description provided for @checkInScaleLow.
  ///
  /// In id, this message translates to:
  /// **'rendah'**
  String get checkInScaleLow;

  /// No description provided for @checkInScaleHigh.
  ///
  /// In id, this message translates to:
  /// **'baik'**
  String get checkInScaleHigh;

  /// No description provided for @checkInDiscomfort.
  ///
  /// In id, this message translates to:
  /// **'Nyeri/tidak nyaman saat latihan (opsional)'**
  String get checkInDiscomfort;

  /// No description provided for @checkInNotes.
  ///
  /// In id, this message translates to:
  /// **'Catatan kendala (opsional)'**
  String get checkInNotes;

  /// No description provided for @checkInWorkoutDone.
  ///
  /// In id, this message translates to:
  /// **'Latihan hari ini: selesai ✓'**
  String get checkInWorkoutDone;

  /// No description provided for @checkInWorkoutNone.
  ///
  /// In id, this message translates to:
  /// **'Latihan hari ini: belum ada sesi selesai'**
  String get checkInWorkoutNone;

  /// No description provided for @checkInIntake.
  ///
  /// In id, this message translates to:
  /// **'Makan tercatat: {kcal} dari {target}'**
  String checkInIntake(Object kcal, Object target);

  /// No description provided for @checkInSaved.
  ///
  /// In id, this message translates to:
  /// **'Check-in tersimpan'**
  String get checkInSaved;

  /// No description provided for @checkInSleepError.
  ///
  /// In id, this message translates to:
  /// **'Isi 0–24 jam'**
  String get checkInSleepError;

  /// No description provided for @checkInDiscomfortWarning.
  ///
  /// In id, this message translates to:
  /// **'Bila nyeri tajam, bengkak, atau tidak membaik, hentikan gerakan pemicunya dan konsultasikan ke tenaga kesehatan.'**
  String get checkInDiscomfortWarning;

  /// No description provided for @weeklyTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan mingguan'**
  String get weeklyTitle;

  /// No description provided for @weeklyOpen.
  ///
  /// In id, this message translates to:
  /// **'Lihat ringkasan minggu lalu'**
  String get weeklyOpen;

  /// No description provided for @weeklyThisWeek.
  ///
  /// In id, this message translates to:
  /// **'Minggu ini (berjalan)'**
  String get weeklyThisWeek;

  /// No description provided for @weeklyRange.
  ///
  /// In id, this message translates to:
  /// **'{start} – {end}'**
  String weeklyRange(Object start, Object end);

  /// No description provided for @weeklyPrev.
  ///
  /// In id, this message translates to:
  /// **'Minggu sebelumnya'**
  String get weeklyPrev;

  /// No description provided for @weeklyNext.
  ///
  /// In id, this message translates to:
  /// **'Minggu berikutnya'**
  String get weeklyNext;

  /// No description provided for @weeklyNoData.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data pada minggu ini.'**
  String get weeklyNoData;

  /// No description provided for @weeklyWeight.
  ///
  /// In id, this message translates to:
  /// **'Berat rata-rata'**
  String get weeklyWeight;

  /// No description provided for @weeklyWeightValue.
  ///
  /// In id, this message translates to:
  /// **'{kg} kg ({n}× timbang)'**
  String weeklyWeightValue(Object kg, Object n);

  /// No description provided for @weeklyWeightChange.
  ///
  /// In id, this message translates to:
  /// **'{change} kg dari minggu sebelumnya'**
  String weeklyWeightChange(Object change);

  /// No description provided for @weeklyWeightMissing.
  ///
  /// In id, this message translates to:
  /// **'Kurang dari 2 penimbangan'**
  String get weeklyWeightMissing;

  /// No description provided for @weeklyTraining.
  ///
  /// In id, this message translates to:
  /// **'Latihan'**
  String get weeklyTraining;

  /// No description provided for @weeklyTrainingValue.
  ///
  /// In id, this message translates to:
  /// **'{done} dari {planned} sesi · {sets} set'**
  String weeklyTrainingValue(Object done, Object planned, Object sets);

  /// No description provided for @weeklyTrainingNoPlan.
  ///
  /// In id, this message translates to:
  /// **'{done} sesi · {sets} set'**
  String weeklyTrainingNoPlan(Object done, Object sets);

  /// No description provided for @weeklyVolume.
  ///
  /// In id, this message translates to:
  /// **'Volume {kg} kg'**
  String weeklyVolume(Object kg);

  /// No description provided for @weeklyVolumeChange.
  ///
  /// In id, this message translates to:
  /// **'{pct}% dari minggu sebelumnya'**
  String weeklyVolumeChange(Object pct);

  /// No description provided for @weeklyIntake.
  ///
  /// In id, this message translates to:
  /// **'Makan'**
  String get weeklyIntake;

  /// No description provided for @weeklyIntakeValue.
  ///
  /// In id, this message translates to:
  /// **'{days} hari tercatat · rata-rata {kcal} ({pct}% target)'**
  String weeklyIntakeValue(Object days, Object kcal, Object pct);

  /// No description provided for @weeklyIntakeNone.
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan makan'**
  String get weeklyIntakeNone;

  /// No description provided for @weeklyProtein.
  ///
  /// In id, this message translates to:
  /// **'Protein rata-rata {g} g dari {target} g'**
  String weeklyProtein(Object g, Object target);

  /// No description provided for @weeklyRecovery.
  ///
  /// In id, this message translates to:
  /// **'Pemulihan'**
  String get weeklyRecovery;

  /// No description provided for @weeklyRecoveryValue.
  ///
  /// In id, this message translates to:
  /// **'{n} check-in · tidur {sleep} jam · energi {energy}/5'**
  String weeklyRecoveryValue(Object n, Object sleep, Object energy);

  /// No description provided for @weeklyRecoveryNone.
  ///
  /// In id, this message translates to:
  /// **'Belum ada check-in'**
  String get weeklyRecoveryNone;

  /// No description provided for @weeklyDiscomfort.
  ///
  /// In id, this message translates to:
  /// **'Keluhan nyeri pada {n} hari'**
  String weeklyDiscomfort(Object n);

  /// No description provided for @adjustTitle.
  ///
  /// In id, this message translates to:
  /// **'Usulan penyesuaian target'**
  String get adjustTitle;

  /// No description provided for @adjustUp.
  ///
  /// In id, this message translates to:
  /// **'Berat naik lebih lambat dari rentang yang diharapkan selama 2 minggu, dengan makan tercatat konsisten. Usulan: naikkan target {delta} kcal (karbohidrat +{carbs} g) → {kcal}.'**
  String adjustUp(Object delta, Object carbs, Object kcal);

  /// No description provided for @adjustDown.
  ///
  /// In id, this message translates to:
  /// **'Berat naik lebih cepat dari rentang yang diharapkan selama 2 minggu, dengan makan tercatat konsisten. Usulan: turunkan target {delta} kcal (karbohidrat −{carbs} g) → {kcal}.'**
  String adjustDown(Object delta, Object carbs, Object kcal);

  /// No description provided for @adjustNote.
  ///
  /// In id, this message translates to:
  /// **'Perubahan kecil, dihitung aplikasi (bukan AI). Tidak berlaku sebelum kamu menyetujuinya.'**
  String get adjustNote;

  /// No description provided for @adjustAccept.
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get adjustAccept;

  /// No description provided for @adjustDecline.
  ///
  /// In id, this message translates to:
  /// **'Tidak sekarang'**
  String get adjustDecline;

  /// No description provided for @adjustAccepted.
  ///
  /// In id, this message translates to:
  /// **'Target baru aktif.'**
  String get adjustAccepted;

  /// No description provided for @adjustDeclined.
  ///
  /// In id, this message translates to:
  /// **'Usulan tidak diterapkan.'**
  String get adjustDeclined;

  /// No description provided for @adjustAcceptedLabel.
  ///
  /// In id, this message translates to:
  /// **'Diterapkan'**
  String get adjustAcceptedLabel;

  /// No description provided for @adjustDeclinedLabel.
  ///
  /// In id, this message translates to:
  /// **'Tidak diterapkan'**
  String get adjustDeclinedLabel;

  /// No description provided for @adjustBlockedIntake.
  ///
  /// In id, this message translates to:
  /// **'Tren berat di luar rentang, tetapi makan belum tercatat konsisten (≥ 4 hari/minggu, dekat target). Perbaiki pencatatan dulu sebelum target diubah.'**
  String get adjustBlockedIntake;

  /// No description provided for @adjustBlockedSafety.
  ///
  /// In id, this message translates to:
  /// **'Karena ada riwayat gangguan makan, perubahan target kalori sebaiknya didiskusikan dengan tenaga kesehatan.'**
  String get adjustBlockedSafety;

  /// No description provided for @weeklyAiTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan AI'**
  String get weeklyAiTitle;

  /// No description provided for @weeklyAiGenerate.
  ///
  /// In id, this message translates to:
  /// **'Buat ringkasan dengan AI'**
  String get weeklyAiGenerate;

  /// No description provided for @weeklyAiRegenerate.
  ///
  /// In id, this message translates to:
  /// **'Buat ulang'**
  String get weeklyAiRegenerate;

  /// No description provided for @weeklyAiGenerating.
  ///
  /// In id, this message translates to:
  /// **'Menyusun ringkasan…'**
  String get weeklyAiGenerating;

  /// No description provided for @weeklyAiWentWell.
  ///
  /// In id, this message translates to:
  /// **'Yang berjalan baik'**
  String get weeklyAiWentWell;

  /// No description provided for @weeklyAiObstacles.
  ///
  /// In id, this message translates to:
  /// **'Hambatan'**
  String get weeklyAiObstacles;

  /// No description provided for @weeklyAiSuggestions.
  ///
  /// In id, this message translates to:
  /// **'Saran minggu depan'**
  String get weeklyAiSuggestions;

  /// No description provided for @weeklyAiNote.
  ///
  /// In id, this message translates to:
  /// **'Ditulis AI dari statistik di atas (tanpa nama, umur, atau catatan pribadi). Tidak mengubah target.'**
  String get weeklyAiNote;

  /// No description provided for @weeklyAiError.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan AI belum bisa dibuat.'**
  String get weeklyAiError;

  /// No description provided for @weeklyHistory.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan tersimpan'**
  String get weeklyHistory;

  /// No description provided for @mealPlanWarnPortions.
  ///
  /// In id, this message translates to:
  /// **'Porsi (gram) dari AI disesuaikan aplikasi agar total mendekati targetmu. Pilihan bahan tetap dari AI.'**
  String get mealPlanWarnPortions;
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
