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
