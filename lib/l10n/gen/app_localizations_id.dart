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
  String get pfSettingsSection => 'Pengaturan';

  @override
  String get pfStatusOn => 'Aktif';

  @override
  String get pfStatusOff => 'Nonaktif';

  @override
  String get pfRemindersSubtitle => 'Latihan, makan, timbang, check-in';

  @override
  String get pfFooter => 'Muscle Coach · rekomendasi bersifat edukatif';

  @override
  String get pfAiStatusSection => 'Status';

  @override
  String get pfAiKeySection => 'API key & model';

  @override
  String get pfAiConsentSection => 'Persetujuan data';

  @override
  String get pfRemindersCategorySection => 'Jenis pengingat';

  @override
  String get pfRemindersTrackingSection => 'Timbang & check-in';

  @override
  String get quickActions => 'Aksi cepat';

  @override
  String get qaLogFoodSub => 'Cari dari katalog TKPI atau catat manual';

  @override
  String get qaLogWeightSub => 'Sebaiknya pagi hari, sebelum makan';

  @override
  String get qaStartSessionSub => 'Mulai atau lanjutkan latihan hari ini';

  @override
  String get qaNoWorkoutToday => 'Tidak ada latihan terjadwal hari ini. Pilih hari di tab Latihan.';

  @override
  String get qaNoPlan => 'Belum ada program latihan. Buat dulu di tab Latihan.';

  @override
  String get openProfile => 'Buka profil';

  @override
  String get tabProfile => 'Profil';

  @override
  String get cancel => 'Batal';

  @override
  String get errorNetwork => 'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.';

  @override
  String get errorUnauthenticated =>
      'API key tidak valid atau kedaluwarsa. Periksa di Pengaturan AI.';

  @override
  String get errorPermissionDenied => 'Akses ditolak. Periksa izin atau pembatasan API key Anda.';

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
  String get errorUnknown => 'Terjadi kesalahan. Coba lagi.';

  @override
  String get emptyWorkoutTitle => 'Belum ada program latihan';

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
  String get dangerZone => 'Zona berbahaya';

  @override
  String get retry => 'Coba lagi';

  @override
  String get next => 'Lanjut';

  @override
  String get back => 'Kembali';

  @override
  String get unitCm => 'cm';

  @override
  String get unitKg => 'kg';

  @override
  String get unitWeeks => 'minggu';

  @override
  String get unitHours => 'jam';

  @override
  String get unitPerWeek => 'kali/minggu';

  @override
  String get unitIdr => 'Rp';

  @override
  String get obUnitKcal => 'kcal';

  @override
  String get obUnitSessions => 'sesi';

  @override
  String get obAiDraftPill => 'Draft AI · estimasi';

  @override
  String get onboardingTitle => 'Mari kenali Anda dulu';

  @override
  String get onboardingMessage =>
      'Kami akan menanyakan 7 bagian singkat: profil, tujuan, pengalaman, jadwal & alat, aktivitas, pola makan, dan keselamatan. Sekitar 5–8 menit, dan jawaban tersimpan sebagai draft.';

  @override
  String get onboardingPoint1 =>
      'Kebutuhan kalori & makro dihitung dengan rumus terdokumentasi, bukan oleh AI.';

  @override
  String get onboardingPoint2 =>
      'Anda melihat asumsi perhitungan dan menyetujui target sebelum dipakai.';

  @override
  String get onboardingPoint3 =>
      'Data Anda tersimpan hanya di perangkat ini dan dapat dihapus kapan saja dari Profil.';

  @override
  String get disclaimerShort =>
      'Rekomendasi bersifat edukatif dan tidak menggantikan dokter, ahli gizi, atau personal trainer.';

  @override
  String get startAssessment => 'Mulai assessment';

  @override
  String get assessmentTitle => 'Assessment awal';

  @override
  String assessmentStepCounter(Object current, Object total) {
    return 'Langkah $current dari $total';
  }

  @override
  String get stepProfile => 'Profil dasar';

  @override
  String get stepGoal => 'Tujuan';

  @override
  String get stepExperience => 'Pengalaman latihan';

  @override
  String get stepAvailability => 'Jadwal & peralatan';

  @override
  String get stepActivity => 'Aktivitas & pemulihan';

  @override
  String get stepNutrition => 'Pola makan';

  @override
  String get stepSafety => 'Keselamatan & persetujuan';

  @override
  String get draftSavedHint => 'Jawaban tersimpan sebagai draft setiap kali Anda lanjut.';

  @override
  String get submitAssessment => 'Hitung target saya';

  @override
  String get fieldNickname => 'Nama panggilan (opsional)';

  @override
  String get fieldBirthDate => 'Tanggal lahir';

  @override
  String get birthDateHint => 'Pilih tanggal';

  @override
  String ageYears(Object age) {
    return '$age tahun';
  }

  @override
  String get fieldSex => 'Jenis kelamin biologis';

  @override
  String get sexHelp =>
      'Hanya dipakai untuk rumus energi. Bila tidak ingin menjawab, kami tampilkan rentang perkiraan.';

  @override
  String get sexMale => 'Laki-laki';

  @override
  String get sexFemale => 'Perempuan';

  @override
  String get sexUndisclosed => 'Tidak ingin menjawab';

  @override
  String get fieldHeight => 'Tinggi badan';

  @override
  String get fieldWeight => 'Berat badan saat ini';

  @override
  String get fieldPrimaryGoal => 'Tujuan utama';

  @override
  String get goalMuscleGain => 'Menambah massa otot';

  @override
  String get goalStrength => 'Meningkatkan kekuatan';

  @override
  String get goalRecomposition => 'Body recomposition';

  @override
  String get recompositionHelp => 'Recomposition: menambah otot dengan berat badan relatif stabil.';

  @override
  String get fieldTargetWeight => 'Berat badan target (opsional)';

  @override
  String get targetWeightHelp => 'Kosongkan bila target utama Anda bukan angka berat badan.';

  @override
  String get fieldTargetWeeks => 'Target waktu';

  @override
  String targetWeeksHelp(Object date) {
    return '4–104 minggu. Perkiraan tanggal: $date';
  }

  @override
  String get fieldPriorityMuscles => 'Otot prioritas (opsional)';

  @override
  String get muscleChest => 'Dada';

  @override
  String get muscleBack => 'Punggung';

  @override
  String get muscleShoulders => 'Bahu';

  @override
  String get muscleArms => 'Lengan';

  @override
  String get muscleLegs => 'Kaki';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleCore => 'Core';

  @override
  String get fieldMotivation => 'Motivasi atau ekspektasi (opsional)';

  @override
  String get fieldLevel => 'Level latihan beban';

  @override
  String get levelBeginner => 'Pemula';

  @override
  String get levelIntermediate => 'Menengah';

  @override
  String get levelAdvanced => 'Berpengalaman';

  @override
  String get fieldTrainingAge => 'Sudah berapa lama latihan beban?';

  @override
  String get trainingAgeNone => 'Belum pernah';

  @override
  String get trainingAgeUnder6Months => '< 6 bulan';

  @override
  String get trainingAge6mTo2y => '6 bulan – 2 tahun';

  @override
  String get trainingAge2To5y => '2–5 tahun';

  @override
  String get trainingAgeOver5y => '> 5 tahun';

  @override
  String get optionalSuffix => '(opsional)';

  @override
  String get currentSessionsOptionalHelp =>
      'Boleh dikosongkan karena Anda belum pernah latihan beban (dianggap 0×/minggu).';

  @override
  String get fieldCurrentSessions => 'Frekuensi latihan saat ini';

  @override
  String get fieldKnownExercises => 'Gerakan yang sudah dikuasai (opsional)';

  @override
  String get knownExercisesHint => 'mis. squat, bench press, dumbbell row';

  @override
  String get fieldWorkingWeights => 'Beban kerja / PR yang diketahui (opsional)';

  @override
  String get workingWeightsHint => 'mis. bench press 50 kg × 8. Tidak wajib untuk pemula.';

  @override
  String get fieldTrainingDays => 'Hari yang bisa dipakai latihan';

  @override
  String get weekday1 => 'Sen';

  @override
  String get weekday2 => 'Sel';

  @override
  String get weekday3 => 'Rab';

  @override
  String get weekday4 => 'Kam';

  @override
  String get weekday5 => 'Jum';

  @override
  String get weekday6 => 'Sab';

  @override
  String get weekday7 => 'Min';

  @override
  String get fieldSessionMinutes => 'Durasi per sesi';

  @override
  String minutesValue(Object minutes) {
    return '$minutes menit';
  }

  @override
  String get fieldLocation => 'Lokasi latihan';

  @override
  String get locationHome => 'Rumah';

  @override
  String get locationGym => 'Gym';

  @override
  String get fieldEquipment => 'Peralatan yang tersedia';

  @override
  String get equipmentHelp => 'Program hanya akan memakai alat yang Anda centang.';

  @override
  String get equipDumbbell => 'Dumbbell';

  @override
  String get equipBarbell => 'Barbell';

  @override
  String get equipBench => 'Bench';

  @override
  String get equipRack => 'Squat rack / power rack';

  @override
  String get equipPullUpBar => 'Pull-up bar';

  @override
  String get fieldDumbbellMax => 'Dumbbell terberat per tangan (opsional)';

  @override
  String get fieldBarbellMax => 'Beban barbell maks. termasuk bar (opsional)';

  @override
  String get fieldTrainingPreferences => 'Preferensi latihan (opsional)';

  @override
  String get fieldActivityLevel => 'Aktivitas harian di luar latihan';

  @override
  String get activitySedentary => 'Sangat sedikit bergerak';

  @override
  String get activityLight => 'Ringan';

  @override
  String get activityModerate => 'Sedang';

  @override
  String get activityHigh => 'Tinggi';

  @override
  String get activityHelp =>
      'Ringan: sesekali jalan kaki. Sedang: banyak berjalan/berdiri. Tinggi: kerja fisik berat.';

  @override
  String get fieldOccupation => 'Pekerjaan dominan';

  @override
  String get occupationSitting => 'Duduk';

  @override
  String get occupationStanding => 'Berdiri';

  @override
  String get occupationActive => 'Aktif/fisik';

  @override
  String get fieldSleep => 'Rata-rata tidur per malam';

  @override
  String get fieldStress => 'Tingkat stres (opsional)';

  @override
  String get stressLow => 'Rendah';

  @override
  String get stressMedium => 'Sedang';

  @override
  String get stressHigh => 'Tinggi';

  @override
  String get fieldCardio => 'Kardio/olahraga lain (opsional)';

  @override
  String get fieldDiet => 'Pola makan';

  @override
  String get dietOmnivore => 'Omnivora';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietOther => 'Lainnya';

  @override
  String get fieldAllergies => 'Alergi & pantangan (opsional)';

  @override
  String get fieldDislikes => 'Makanan yang tidak disukai (opsional)';

  @override
  String get fieldFoodPreferences => 'Makanan favorit/preferensi (opsional)';

  @override
  String get fieldBudget => 'Anggaran makan per hari (opsional)';

  @override
  String get fieldMealsPerDay => 'Jumlah waktu makan per hari';

  @override
  String get fieldCooking => 'Akses memasak';

  @override
  String get cookingSelf => 'Masak sendiri';

  @override
  String get cookingCatering => 'Katering/beli';

  @override
  String get cookingMixed => 'Campuran';

  @override
  String get foodLocationIndonesia => 'Rekomendasi makanan disesuaikan untuk Indonesia.';

  @override
  String get fieldNutritionNotes => 'Catatan pola makan (opsional)';

  @override
  String get safetyIntro =>
      'Bagian ini membantu kami menghindari rekomendasi yang tidak aman. Data kesehatan disimpan privat di akun Anda dan dapat dihapus kapan saja.';

  @override
  String get fieldInjuries => 'Cedera saat ini/riwayat yang masih berdampak (opsional)';

  @override
  String get fieldAvoidedMovements => 'Gerakan yang dilarang/tidak nyaman (opsional)';

  @override
  String get fieldMedicalFlags => 'Apakah ada kondisi berikut?';

  @override
  String get medicalFlagsHelp => 'Cukup centang bila ada; tidak perlu menyebut diagnosis.';

  @override
  String get medicalPregnant => 'Sedang hamil';

  @override
  String get medicalChronic => 'Penyakit kronis (mis. jantung, diabetes, hipertensi)';

  @override
  String get medicalEatingDisorder => 'Riwayat gangguan makan';

  @override
  String get medicalInjuryRecovery => 'Sedang pemulihan cedera/operasi';

  @override
  String get medicalMedication => 'Mengonsumsi obat yang relevan';

  @override
  String get fieldRedFlags => 'Dalam beberapa minggu terakhir, apakah Anda mengalami:';

  @override
  String get redChestPain => 'Nyeri dada saat beraktivitas';

  @override
  String get redFainting => 'Pingsan atau hampir pingsan';

  @override
  String get redBreathless => 'Sesak napas yang tidak wajar';

  @override
  String get redAcuteInjury => 'Cedera akut yang belum ditangani';

  @override
  String get consentTitle => 'Persetujuan';

  @override
  String get consentDisclaimer =>
      'Saya memahami bahwa Muscle Coach memberi estimasi edukatif dan tidak menggantikan dokter, ahli gizi, atau pelatih.';

  @override
  String get consentHealthData =>
      'Saya setuju data assessment, termasuk data kesehatan di atas, diproses untuk menghitung target dan menyusun program saya.';

  @override
  String get issueRequired => 'Wajib diisi.';

  @override
  String get issueChoose => 'Pilih salah satu.';

  @override
  String issueAge(Object min, Object max) {
    return 'Usia harus $min–$max tahun.';
  }

  @override
  String issueRange(Object min, Object max) {
    return 'Masukkan angka $min–$max.';
  }

  @override
  String get issueTrainingDays => 'Pilih minimal satu hari.';

  @override
  String get issueEquipment => 'Centang minimal dumbbell atau barbell.';

  @override
  String get issueConsent => 'Centang kedua persetujuan untuk melanjutkan.';

  @override
  String get goalReviewTitle => 'Ringkasan target';

  @override
  String get goalActiveTitle => 'Target aktif';

  @override
  String get verdictRealistic => 'Target realistis';

  @override
  String get verdictRealisticMessage =>
      'Target dan waktunya berada dalam batas laju kenaikan yang aman untuk level Anda.';

  @override
  String get verdictNeedsAdjustment => 'Target perlu disesuaikan';

  @override
  String get reasonTargetBelowCurrent =>
      'Tujuan Anda menambah otot/kekuatan, tetapi berat target lebih rendah dari berat sekarang. Pilih body recomposition atau naikkan berat target.';

  @override
  String reasonRateTooFast(Object rate, Object max, Object maxPct) {
    return 'Target ini menuntut kenaikan $rate kg/minggu, melebihi batas $max kg/minggu ($maxPct% berat badan) untuk Anda. Kenaikan terlalu cepat cenderung menambah lebih banyak lemak.';
  }

  @override
  String reasonRecomposition(Object delta) {
    return 'Body recomposition berarti berat relatif stabil, tetapi target Anda berubah $delta kg. Pilih \"Menambah massa otot\" atau dekatkan target ke berat sekarang.';
  }

  @override
  String suggestionWeeks(Object weeks) {
    return 'Saran waktu: minimal $weeks minggu untuk target ini.';
  }

  @override
  String suggestionTarget(Object kg, Object weeks) {
    return 'Saran target: $kg kg dalam $weeks minggu.';
  }

  @override
  String conservativeLimitNote(Object reasons) {
    return 'Batas ini lebih ketat dari biasanya karena $reasons. Ini demi keamanan; sebaiknya diskusikan target kenaikan berat dengan dokter atau ahli gizi.';
  }

  @override
  String get conservativeReasonLowBmi => 'BMI Anda di bawah normal';

  @override
  String get conservativeReasonMinor => 'usia Anda di bawah 18 tahun';

  @override
  String get conservativeReasonMedical => 'ada kondisi kesehatan yang Anda laporkan';

  @override
  String get targetRejectedHint => 'Sesuaikan target dulu agar bisa melanjutkan.';

  @override
  String useSuggestion(Object kg) {
    return 'Pakai saran ($kg kg)';
  }

  @override
  String get useNoTargetWeight => 'Tanpa berat target';

  @override
  String get editMyself => 'Ubah sendiri';

  @override
  String suggestionApplied(Object kg) {
    return 'Berat target diubah ke $kg kg.';
  }

  @override
  String get noTargetWeightApplied =>
      'Berat target dikosongkan; kemajuan dinilai dari tren berat & performa latihan.';

  @override
  String get adjustTarget => 'Sesuaikan target';

  @override
  String get editAnswers => 'Ubah jawaban';

  @override
  String get safetyStopTitle => 'Tunda dulu rencana latihan';

  @override
  String get safetyStopMessage =>
      'Anda melaporkan gejala yang perlu diperiksa (nyeri dada, pingsan, sesak tidak wajar, atau cedera akut). Segera konsultasikan dengan tenaga medis. Bila gejala berat atau mendadak, hubungi layanan darurat 119 atau 112. Target dan program tidak kami aktifkan sampai kondisi Anda aman.';

  @override
  String get sectionWeightGoal => 'Berat badan';

  @override
  String get labelGoal => 'Tujuan';

  @override
  String get labelStartWeight => 'Berat awal';

  @override
  String get labelTargetWeight => 'Berat target';

  @override
  String get labelDelta => 'Selisih';

  @override
  String get labelPeriod => 'Periode';

  @override
  String get labelTargetDate => 'Target tanggal';

  @override
  String get labelWeeklyRate => 'Laju per minggu';

  @override
  String get noTargetWeight => 'Tidak ditetapkan';

  @override
  String weeksValue(Object weeks) {
    return '$weeks minggu';
  }

  @override
  String kgValue(Object kg) {
    return '$kg kg';
  }

  @override
  String kgPerWeekValue(Object kg) {
    return '$kg kg/minggu';
  }

  @override
  String expectedGainNote(Object min, Object max) {
    return 'Kenaikan berat yang wajar sekitar $min–$max kg/minggu. Ini bukan janji: berat badan tidak sama dengan massa otot, dan evaluasi memakai tren beberapa minggu.';
  }

  @override
  String get recompositionNote =>
      'Recomposition: berat diharapkan relatif stabil; progres dinilai dari kekuatan, ukuran tubuh, dan tren beberapa minggu.';

  @override
  String get sectionNutrition => 'Target nutrisi harian';

  @override
  String kcalValue(Object kcal) {
    return '$kcal kcal';
  }

  @override
  String kcalRangeValue(Object min, Object max) {
    return '$min–$max kcal';
  }

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Karbohidrat';

  @override
  String get macroFat => 'Lemak';

  @override
  String gramValue(Object grams) {
    return '$grams g';
  }

  @override
  String macroDetail(Object gPerKg, Object pct) {
    return '$gPerKg g/kg · $pct% energi';
  }

  @override
  String macroCarbsDetail(Object pct) {
    return '$pct% energi';
  }

  @override
  String get estimateLabel => 'Estimasi';

  @override
  String get rangeNote =>
      'Jenis kelamin tidak diisi, jadi kebutuhan energi berupa rentang. Angka makro memakai titik tengah rentang.';

  @override
  String get sectionAssumptions => 'Asumsi & cara hitung';

  @override
  String assumptionBmr(Object value) {
    return 'BMR (energi saat istirahat) $value, rumus Mifflin–St Jeor. Ini perkiraan populasi: kurang akurat untuk orang sangat berotot atau dengan obesitas, dan tidak berlaku saat hamil.';
  }

  @override
  String assumptionTdee(Object value, Object factor) {
    return 'TDEE $value = BMR × faktor aktivitas $factor.';
  }

  @override
  String assumptionSurplus(Object pct, Object value) {
    return 'Energi target = TDEE + surplus konservatif $pct% ≈ $value.';
  }

  @override
  String assumptionMaintenance(Object value) {
    return 'Energi target ≈ TDEE (maintenance) karena tujuan recomposition: $value.';
  }

  @override
  String assumptionProtein(Object gPerKg, Object basis) {
    return 'Protein $gPerKg g/kg × $basis kg berat acuan.';
  }

  @override
  String get assumptionProteinBasis =>
      'Karena BMI tinggi, protein memakai berat acuan pada BMI 25.';

  @override
  String get assumptionFat => 'Lemak sekitar 0,8 g/kg, dijaga 20–35% energi dan minimal 0,6 g/kg.';

  @override
  String get assumptionCarbs => 'Karbohidrat = sisa energi setelah protein dan lemak.';

  @override
  String get assumptionRounding =>
      'Makro dibulatkan ke kelipatan 5 g; total kalori dihitung ulang dari makro (protein & karbohidrat 4 kcal/g, lemak 9 kcal/g).';

  @override
  String get assumptionConservative =>
      'Karena ada faktor keselamatan, surplus energi dan batas laju kenaikan dibuat lebih konservatif.';

  @override
  String get assumptionReview =>
      'Semua angka adalah estimasi awal dan akan dievaluasi dari tren berat badan 2–4 minggu, bukan dari satu kali timbang.';

  @override
  String assumptionVersion(Object version) {
    return 'Versi konfigurasi: $version';
  }

  @override
  String get sectionWarnings => 'Perlu diperhatikan';

  @override
  String get warningMinorAge =>
      'Usia di bawah 18 tahun: diskusikan program dengan orang tua dan tenaga kesehatan.';

  @override
  String warningLowBmi(Object bmi) {
    return 'BMI Anda $bmi tergolong rendah. Konsultasikan dengan tenaga kesehatan.';
  }

  @override
  String warningHighBmi(Object bmi) {
    return 'BMI Anda $bmi tergolong tinggi; perkiraan energi bisa kurang akurat. Pertimbangkan konsultasi dengan tenaga kesehatan.';
  }

  @override
  String get warningPregnant =>
      'Kehamilan: perhitungan ini tidak dirancang untuk kehamilan. Konsultasikan dengan dokter atau bidan sebelum memakai target ini.';

  @override
  String get warningChronic =>
      'Penyakit kronis: konsultasikan dengan dokter sebelum menaikkan intensitas latihan atau asupan.';

  @override
  String get warningEatingDisorder =>
      'Riwayat gangguan makan: angka kalori dapat memicu kekhawatiran. Diskusikan dengan tenaga kesehatan; Anda bisa berfokus pada kebiasaan, bukan angka.';

  @override
  String get warningInjuryRecovery =>
      'Pemulihan cedera: ikuti arahan tenaga kesehatan atau fisioterapis; gerakan terkait akan dihindari.';

  @override
  String get warningMedication =>
      'Obat-obatan: tanyakan kepada dokter bila obat memengaruhi nafsu makan, berat badan, atau kemampuan latihan.';

  @override
  String get warningRedFlag =>
      'Gejala berbahaya dilaporkan: konsultasikan dengan tenaga medis sebelum berlatih.';

  @override
  String get acknowledgeWarnings =>
      'Saya sudah membaca peringatan di atas dan akan berkonsultasi dengan tenaga kesehatan bila perlu.';

  @override
  String get confirmGoal => 'Konfirmasi target';

  @override
  String get goalConfirmed => 'Target aktif! Program latihan akan disusun pada tahap berikutnya.';

  @override
  String get goalNotFound => 'Target tidak ditemukan.';

  @override
  String homeGreeting(Object name) {
    return 'Halo, $name!';
  }

  @override
  String get homeGreetingNoName => 'Halo!';

  @override
  String get homeNextSteps =>
      'Program latihan, menu harian, dan check-in akan muncul di sini setelah fitur berikutnya aktif.';

  @override
  String get seeDetails => 'Lihat detail & asumsi';

  @override
  String get profileAssessmentSection => 'Assessment & target';

  @override
  String get viewActiveGoal => 'Lihat target aktif';

  @override
  String get redoAssessment => 'Ulangi assessment';

  @override
  String get redoAssessmentHelp =>
      'Target baru berlaku setelah Anda konfirmasi; target lama diarsipkan.';

  @override
  String get workoutNoPlanMessage =>
      'Buat program awal dari jawaban assessment Anda. Program disusun dengan aturan terdokumentasi (bukan AI) dan baru aktif setelah Anda setujui.';

  @override
  String get createStarterPlan => 'Buat program awal';

  @override
  String get planDraftTitle => 'Draft program';

  @override
  String get workoutWeekProgress => 'Minggu ini';

  @override
  String workoutSessionsCount(Object done, Object total) {
    return '$done/$total sesi';
  }

  @override
  String get workoutViewPlan => 'Lihat program';

  @override
  String get workoutSchedule => 'Jadwal minggu ini';

  @override
  String workoutDayDone(Object day) {
    return '$day · Selesai';
  }

  @override
  String workoutDayMissed(Object day) {
    return '$day · Terlewat';
  }

  @override
  String get workoutRecent => 'Riwayat terakhir';

  @override
  String get workoutSeeAll => 'Lihat semua';

  @override
  String workoutEnergy(Object value) {
    return 'Energi $value/5';
  }

  @override
  String workoutSetsVolume(Object sets, Object volume) {
    return '$sets set · $volume kg';
  }

  @override
  String workoutMore(Object count) {
    return '+$count';
  }

  @override
  String wk2WarmupTitle(int minutes) {
    return 'Pemanasan $minutes mnt';
  }

  @override
  String get wk2WarmupBody => 'Kardio ringan + 1–2 set ringan';

  @override
  String get wk2CooldownTitle => 'Pendinginan';

  @override
  String get wk2CooldownBody => 'Peregangan 3–5 menit';

  @override
  String get wk2PlanDays => 'Jadwal mingguan';

  @override
  String get wk2PlanNotes => 'Catatan program';

  @override
  String wk2ExerciseCount(int count) {
    return '$count latihan';
  }

  @override
  String get planActiveTitle => 'Program aktif';

  @override
  String planSummary(Object days, Object minutes) {
    return '$days hari/minggu · ± $minutes menit/sesi';
  }

  @override
  String get splitFullBody => 'Seluruh tubuh (full body)';

  @override
  String get splitUpperLower => 'Tubuh atas/bawah (upper/lower)';

  @override
  String get planSourceTemplate => 'Disusun dari aturan terdokumentasi, bukan AI';

  @override
  String get activatePlan => 'Aktifkan program';

  @override
  String get replacePlanTitle => 'Ganti program aktif?';

  @override
  String get replacePlanMessage =>
      'Program yang sedang aktif akan diarsipkan. Riwayat latihan tetap tersimpan.';

  @override
  String get replace => 'Ganti';

  @override
  String get planActivated => 'Program aktif! Selamat berlatih.';

  @override
  String get newPlan => 'Buat ulang program';

  @override
  String get planWarningReviewInjuries =>
      'Anda mencatat cedera atau gerakan yang tidak nyaman. Periksa setiap gerakan; lewati bila terasa nyeri dan konsultasikan dengan tenaga kesehatan.';

  @override
  String get planWarningDaysReduced =>
      'Demi pemulihan, jumlah hari latihan dibatasi sesuai level Anda; hari lain menjadi hari istirahat.';

  @override
  String get planWarningLimitedEquipment =>
      'Beberapa gerakan dilewati karena alatnya tidak tersedia.';

  @override
  String get planWarningSpotter =>
      'Program memuat gerakan barbell di bench/rack: gunakan spotter atau safety bar.';

  @override
  String get planWarningConsecutive =>
      'Ada otot yang dilatih berat pada hari berurutan; perhatikan pemulihan.';

  @override
  String get progressionRule =>
      'Progresi: bila semua set mencapai batas atas repetisi dengan RIR sesuai target, naikkan beban sedikit (±2,5 kg barbell / 1–2 kg dumbbell) di sesi berikutnya.';

  @override
  String get rirExplain =>
      'RIR = sisa repetisi yang masih sanggup dilakukan. RIR 2 berarti berhenti saat masih kuat ±2 repetisi lagi — tidak perlu sampai gagal.';

  @override
  String get restDaysNote =>
      'Hari lain: istirahat atau aktivitas ringan seperti jalan kaki dan peregangan.';

  @override
  String get focusFullBodyA => 'Seluruh tubuh A';

  @override
  String get focusFullBodyB => 'Seluruh tubuh B';

  @override
  String get focusFullBodyC => 'Seluruh tubuh C';

  @override
  String get focusUpperA => 'Tubuh atas A';

  @override
  String get focusUpperB => 'Tubuh atas B';

  @override
  String get focusLowerA => 'Tubuh bawah A';

  @override
  String get focusLowerB => 'Tubuh bawah B';

  @override
  String get weekdayLong1 => 'Senin';

  @override
  String get weekdayLong2 => 'Selasa';

  @override
  String get weekdayLong3 => 'Rabu';

  @override
  String get weekdayLong4 => 'Kamis';

  @override
  String get weekdayLong5 => 'Jumat';

  @override
  String get weekdayLong6 => 'Sabtu';

  @override
  String get weekdayLong7 => 'Minggu';

  @override
  String get todayBadge => 'Hari ini';

  @override
  String dayMeta(Object count, Object minutes) {
    return '$count latihan · ± $minutes menit';
  }

  @override
  String warmupNote(Object minutes) {
    return 'Pemanasan $minutes menit: kardio ringan, lalu 1–2 set ringan untuk gerakan pertama.';
  }

  @override
  String get cooldownNote => 'Pendinginan: peregangan ringan 3–5 menit.';

  @override
  String prescription(Object sets, Object min, Object max) {
    return '$sets set × $min–$max repetisi';
  }

  @override
  String prescriptionTimed(Object sets, Object min, Object max) {
    return '$sets set × $min–$max detik';
  }

  @override
  String restAndRir(Object rest, Object min, Object max) {
    return 'Istirahat $rest · RIR $min–$max';
  }

  @override
  String secondsValue(Object seconds) {
    return '$seconds dtk';
  }

  @override
  String minutesShortValue(Object minutes) {
    return '$minutes mnt';
  }

  @override
  String get priorityBadge => 'Prioritas';

  @override
  String get startSession => 'Mulai sesi';

  @override
  String get history => 'Riwayat';

  @override
  String get historyTitle => 'Riwayat latihan';

  @override
  String get historyEmpty => 'Belum ada sesi yang selesai.';

  @override
  String get exerciseLibrary => 'Katalog latihan';

  @override
  String get sessionTitle => 'Sesi latihan';

  @override
  String sessionElapsed(Object time) {
    return 'Sesi latihan · $time';
  }

  @override
  String exerciseOfTotal(Object current, Object total) {
    return 'Gerakan $current dari $total';
  }

  @override
  String get colSet => 'Set';

  @override
  String get colPrevious => 'Sebelumnya';

  @override
  String get colKg => 'Kg';

  @override
  String get colReps => 'Reps';

  @override
  String get colSeconds => 'Dtk';

  @override
  String get colRir => 'RIR';

  @override
  String get seeTechnique => 'Lihat teknik';

  @override
  String get addSet => 'Tambah set';

  @override
  String get skipExercise => 'Lewati gerakan';

  @override
  String get rirNone => '–';

  @override
  String get setSkippedShort => 'Dilewati';

  @override
  String get deleteSetHint => 'Tekan lama untuk menghapus set';

  @override
  String lastTime(Object value) {
    return 'Terakhir: $value';
  }

  @override
  String get increaseLoadHint =>
      'Sesi lalu semua set mencapai target — coba naikkan beban sedikit.';

  @override
  String setLabel(Object number) {
    return 'Set $number';
  }

  @override
  String get weightLabelPerHand => 'Beban (kg/tangan)';

  @override
  String get weightLabelTotal => 'Beban (kg)';

  @override
  String get weightLabelBodyweight => 'Beban tambahan (kg)';

  @override
  String get repsLabel => 'Repetisi';

  @override
  String get secondsLabel => 'Detik';

  @override
  String get rirLabel => 'RIR';

  @override
  String get logSet => 'Catat set';

  @override
  String get skipSet => 'Lewati';

  @override
  String get setSkipped => 'dilewati';

  @override
  String setsProgress(Object done, Object planned) {
    return '$done/$planned set';
  }

  @override
  String get restTimerLabel => 'Istirahat';

  @override
  String get restAdd => '+15 dtk';

  @override
  String get restSkip => 'Selesai';

  @override
  String get finishSession => 'Selesaikan sesi';

  @override
  String get finishSessionTitle => 'Selesaikan sesi?';

  @override
  String get energyLabel => 'Energi hari ini (opsional)';

  @override
  String get discomfortLabel => 'Nyeri/tidak nyaman (opsional)';

  @override
  String get sessionNotesLabel => 'Catatan (opsional)';

  @override
  String get finishConfirm => 'Simpan & selesai';

  @override
  String get painWarning =>
      'Hentikan latihan bila muncul nyeri tajam, pusing, nyeri dada, atau sesak tidak wajar.';

  @override
  String get sessionCompleted => 'Sesi tersimpan. Kerja bagus!';

  @override
  String get deleteSession => 'Hapus sesi';

  @override
  String get deleteSessionTitle => 'Hapus sesi ini?';

  @override
  String get deleteSessionMessage => 'Semua set yang tercatat di sesi ini akan dihapus permanen.';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteSetTitle => 'Hapus set ini?';

  @override
  String get setInputRepsRequired => 'Isi repetisi.';

  @override
  String get setInputRepsRange => 'Repetisi 1–300.';

  @override
  String get setInputWeightRange => 'Beban 0–1000 kg.';

  @override
  String sessionSummary(Object done, Object planned, Object volume) {
    return '$done/$planned set · volume $volume kg';
  }

  @override
  String get completedBadge => 'Selesai';

  @override
  String get targetLabel => 'Target';

  @override
  String get exerciseInstructions => 'Cara melakukan';

  @override
  String get exerciseMistakes => 'Kesalahan umum';

  @override
  String get exerciseSafety => 'Keselamatan';

  @override
  String get exerciseAlternatives => 'Alternatif';

  @override
  String get exercisePrimaryMuscles => 'Otot utama';

  @override
  String get exerciseSecondaryMuscles => 'Otot pendukung';

  @override
  String get noEquipment => 'Tanpa alat (berat badan)';

  @override
  String get spotterNeeded => 'Gunakan spotter atau safety bar';

  @override
  String get exerciseNotFound => 'Latihan tidak ditemukan di katalog.';

  @override
  String get searchExercise => 'Cari latihan';

  @override
  String get muscleUpperBack => 'Punggung atas';

  @override
  String get muscleLats => 'Latissimus';

  @override
  String get muscleTraps => 'Trapezius';

  @override
  String get muscleFrontDelts => 'Bahu depan';

  @override
  String get muscleSideDelts => 'Bahu samping';

  @override
  String get muscleRearDelts => 'Bahu belakang';

  @override
  String get muscleBiceps => 'Biseps';

  @override
  String get muscleTriceps => 'Triseps';

  @override
  String get muscleForearms => 'Lengan bawah';

  @override
  String get muscleQuads => 'Paha depan';

  @override
  String get muscleHamstrings => 'Paha belakang';

  @override
  String get muscleAdductors => 'Paha dalam';

  @override
  String get muscleCalves => 'Betis';

  @override
  String get homeTodayWorkout => 'Latihan hari ini';

  @override
  String homeNextWorkout(Object day) {
    return 'Latihan berikutnya · $day';
  }

  @override
  String get homeKcalLeft => 'kcal tersisa';

  @override
  String get homeKcalOver => 'kcal berlebih';

  @override
  String get homeEstimate => 'Estimasi';

  @override
  String homeMoreExercises(Object count) {
    return '+$count gerakan lagi';
  }

  @override
  String get homeStartWorkout => 'Mulai latihan';

  @override
  String get homeViewWorkout => 'Lihat latihan';

  @override
  String get homeAvgWeight7 => 'Berat rata-rata 7 hari';

  @override
  String get homeSessionsWeek => 'Latihan minggu ini';

  @override
  String get homeCheckInFill => 'Isi';

  @override
  String get homeCheckInDoneShort => 'Check-in sudah diisi';

  @override
  String get homeEdit => 'Ubah';

  @override
  String homeMacroValue(Object got, Object target) {
    return '$got/$target';
  }

  @override
  String get homeNoNutritionTarget => 'Target nutrisi muncul setelah target dikonfirmasi.';

  @override
  String get homeWeekLabel => 'Minggu ini';

  @override
  String get homeNoPlan => 'Belum ada program latihan. Buat program awal di tab Latihan.';

  @override
  String get openWorkout => 'Buka';

  @override
  String get backupExport => 'Cadangkan data';

  @override
  String get backupExportSub => 'Berkas terenkripsi berisi data & foto progres';

  @override
  String backupLast(Object date) {
    return 'Terakhir dicadangkan $date';
  }

  @override
  String get backupNever => 'Belum pernah dicadangkan';

  @override
  String get backupRestore => 'Pulihkan dari cadangan';

  @override
  String get backupRestoreSub => 'Ganti data di HP ini dengan isi berkas cadangan';

  @override
  String get backupPasswordTitle => 'Kata sandi cadangan';

  @override
  String get backupPasswordBodyExport =>
      'Kata sandi ini dibutuhkan untuk memulihkan cadangan. Simpan baik-baik — bila lupa, cadangan tidak bisa dibuka oleh siapa pun.';

  @override
  String get backupPasswordBodyRestore => 'Masukkan kata sandi yang dipakai saat membuat cadangan.';

  @override
  String get backupPasswordLabel => 'Kata sandi';

  @override
  String get backupPasswordConfirm => 'Ulangi kata sandi';

  @override
  String get backupPasswordTooShort => 'Minimal 8 karakter';

  @override
  String get backupPasswordMismatch => 'Kata sandi tidak sama';

  @override
  String get backupContinue => 'Lanjut';

  @override
  String get backupCreating => 'Membuat cadangan…';

  @override
  String get backupShareSubject => 'Cadangan Muscle Coach';

  @override
  String get backupShared => 'Cadangan dibuat. Simpan berkasnya di tempat aman.';

  @override
  String get backupNotShared => 'Berkas cadangan belum disimpan ke mana pun.';

  @override
  String get backupFailed => 'Cadangan gagal dibuat. Coba lagi.';

  @override
  String get backupRestoreWarnTitle => 'Pulihkan dari cadangan?';

  @override
  String get backupRestoreWarnBody =>
      'Semua data di HP ini (assessment, program, catatan, foto progres) akan diganti dengan isi cadangan. API key Gemini tidak termasuk cadangan dan perlu dimasukkan lagi di HP baru.';

  @override
  String get backupChooseFile => 'Pilih berkas';

  @override
  String get backupChecking => 'Memeriksa cadangan…';

  @override
  String get backupWrongPassword => 'Kata sandi salah atau berkas rusak.';

  @override
  String get backupNotBackup => 'Berkas ini bukan cadangan Muscle Coach.';

  @override
  String get backupNewer =>
      'Cadangan dibuat oleh versi aplikasi yang lebih baru. Perbarui aplikasi dulu.';

  @override
  String get backupInvalid => 'Berkas cadangan tidak valid atau rusak.';

  @override
  String get backupConfirmTitle => 'Ganti data dengan cadangan ini?';

  @override
  String backupConfirmBody(Object date, Object photos) {
    return 'Cadangan $date · $photos foto progres. Data di HP ini akan diganti dan aplikasi dimuat ulang.';
  }

  @override
  String get backupRestoreAction => 'Pulihkan';

  @override
  String get backupRestoring => 'Memulihkan data…';

  @override
  String get backupRestoreFailed => 'Pemulihan gagal. Data lama tetap dipakai.';

  @override
  String get dataPrivacySection => 'Data & privasi';

  @override
  String get dataLocalOnly =>
      'Semua data tersimpan hanya di perangkat ini, tanpa akun dan tanpa server. Bila aplikasi dihapus atau HP hilang, data ikut hilang — buat cadangan terenkripsi secara berkala.';

  @override
  String get wipeData => 'Hapus semua data';

  @override
  String get wipeDataTitle => 'Hapus semua data?';

  @override
  String get wipeDataMessage =>
      'Assessment, target, program, dan seluruh catatan latihan di perangkat ini akan dihapus permanen dan tidak dapat dipulihkan.';

  @override
  String get wipeDataConfirm => 'Hapus permanen';

  @override
  String get aiSettingsTitle => 'AI Coach (Gemini)';

  @override
  String get aiSettingsIntro =>
      'Program latihan dapat disusun oleh Google Gemini memakai API key Anda sendiri. Key disimpan terenkripsi hanya di perangkat ini — tidak di aplikasi, server, atau backup.';

  @override
  String get aiStatusReady => 'Siap dipakai';

  @override
  String get aiStatusNotReady => 'Belum siap: simpan API key dan setujui pemrosesan data.';

  @override
  String get aiKeyLabel => 'API key Gemini';

  @override
  String get aiKeyHint => 'Tempel key dari Google AI Studio';

  @override
  String aiKeySaved(Object suffix) {
    return 'Key tersimpan (…$suffix)';
  }

  @override
  String get aiSaveKey => 'Simpan & uji';

  @override
  String get aiKeyVerified => 'API key valid dan tersimpan.';

  @override
  String get aiDeleteKey => 'Hapus key';

  @override
  String get aiKeyDeleted => 'API key dihapus dari perangkat.';

  @override
  String get aiModelLabel => 'Model';

  @override
  String get aiConsentTitle => 'Persetujuan pemrosesan data oleh AI';

  @override
  String get aiConsentBody =>
      'Aplikasi hanya mengirim data ke Google Gemini saat kamu menekan tombol \"… dengan AI\":\n• Program latihan: tujuan, level & pengalaman, hari & durasi latihan, alat dan beban maksimal, otot prioritas, preferensi latihan, catatan cedera/gerakan yang dihindari, daftar gerakan katalog.\n• Menu harian: target kalori & makro, jumlah waktu makan, pola makan, alergi, makanan yang tidak disukai, preferensi, anggaran, akses memasak, daftar bahan TKPI.\n• Scan makanan: foto makanan yang kamu ambil/pilih dan daftar nama bahan TKPI. Foto tidak disimpan aplikasi dan langsung dihapus setelah dianalisis.\n• Ringkasan mingguan: perubahan rata-rata berat, kepatuhan latihan & makan (persen), rata-rata tidur & energi, jumlah hari ada keluhan nyeri.\nTidak pernah dikirim: nama, umur, tanggal lahir, tinggi, berat badan absolut, jenis kondisi medis, atau isi catatan pribadi.';

  @override
  String get aiFreeTierNote =>
      'Di tier gratis Google AI Studio, Google dapat memakai isi permintaan untuk meningkatkan produknya. Gunakan tier berbayar bila Anda tidak menginginkannya.';

  @override
  String get aiConsentCheckbox =>
      'Saya setuju data di atas dikirim ke Google Gemini untuk fitur AI.';

  @override
  String aiQuotaNote(Object limit) {
    return 'Batas $limit kali penyusunan AI per hari (menahan biaya).';
  }

  @override
  String get generateWithAi => 'Susun dengan AI';

  @override
  String get generateTemplate => 'Program template (tanpa AI)';

  @override
  String get aiGenerating => 'Menyusun program dengan AI…';

  @override
  String get aiGeneratingHint =>
      'Biasanya 10–60 detik. Hasilnya diperiksa aplikasi sebelum ditampilkan.';

  @override
  String get aiErrorTitle => 'Program AI belum bisa disusun';

  @override
  String get aiErrorSetup =>
      'Simpan API key Gemini dan setujui pemrosesan data di Pengaturan AI terlebih dulu.';

  @override
  String get aiErrorQuota =>
      'Batas penyusunan AI hari ini tercapai. Coba lagi besok atau pakai program template.';

  @override
  String get aiErrorInvalid =>
      'Hasil AI tidak lolos pemeriksaan keamanan aplikasi (dicoba 2 kali). Coba lagi, atau pakai program template.';

  @override
  String get openAiSettings => 'Buka pengaturan AI';

  @override
  String get useTemplate => 'Pakai template';

  @override
  String get close => 'Tutup';

  @override
  String aiPlanBadge(Object model) {
    return 'Estimasi AI · $model';
  }

  @override
  String get aiPlanRationaleTitle => 'Alasan dari AI';

  @override
  String get aiPlanValidated =>
      'Diperiksa aplikasi: gerakan dari katalog, alat & level sesuai, angka dalam batas aman. Tetap tinjau sebelum mengaktifkan.';

  @override
  String get chooseGenerator => 'Buat program baru';

  @override
  String reminderWorkoutTitle(Object focus) {
    return 'Waktunya latihan: $focus';
  }

  @override
  String reminderWorkoutBody(Object count, Object minutes) {
    return '$count latihan · ± $minutes menit. Ketuk untuk membuka sesi.';
  }

  @override
  String get reminderBreakfastTitle => 'Waktunya sarapan';

  @override
  String get reminderLunchTitle => 'Waktunya makan siang';

  @override
  String get reminderDinnerTitle => 'Waktunya makan malam';

  @override
  String get reminderSnackTitle => 'Waktunya snack';

  @override
  String get reminderMealBody => 'Makan cukup protein membantu pemulihan otot.';

  @override
  String get reminderWeighInTitle => 'Waktunya timbang berat badan';

  @override
  String get reminderWeighInBody =>
      'Timbang dalam kondisi sama (pagi, setelah ke toilet, sebelum makan) agar trennya akurat.';

  @override
  String get reminderCheckInTitle => 'Check-in harian';

  @override
  String get reminderCheckInBody => 'Bagaimana energi, tidur, dan latihan hari ini?';

  @override
  String reminderExample(Object days, Object workout, Object breakfast, Object checkIn) {
    return 'Contoh: latihan $days pukul $workout, sarapan $breakfast, check-in $checkIn.';
  }

  @override
  String get notificationSettingsTitle => 'Pengingat';

  @override
  String get notificationIntro =>
      'Pengingat dijadwalkan langsung di perangkat — tetap berjalan tanpa internet dan tanpa AI. Waktu dapat sedikit tertunda karena penghematan baterai.';

  @override
  String get notificationEnable => 'Aktifkan pengingat';

  @override
  String get notificationPermissionTitle => 'Izinkan notifikasi?';

  @override
  String get notificationPermissionBody =>
      'Muscle Coach butuh izin notifikasi untuk mengingatkan sesi latihan, waktu makan, timbang, dan check-in sesuai jadwal yang Anda atur.';

  @override
  String get notificationPermissionAllow => 'Izinkan';

  @override
  String get notificationDenied =>
      'Izin notifikasi ditolak. Aktifkan di pengaturan sistem agar pengingat dapat muncul.';

  @override
  String get openSystemSettings => 'Buka pengaturan sistem';

  @override
  String get notificationBatteryHint =>
      'Bila pengingat tidak muncul, izinkan Muscle Coach berjalan di latar belakang / matikan optimasi baterai untuk aplikasi ini (pengaturan HP).';

  @override
  String notificationScheduled(Object count) {
    return '$count pengingat terjadwal untuk 14 hari ke depan.';
  }

  @override
  String notificationTimezone(Object zone) {
    return 'Zona waktu: $zone';
  }

  @override
  String get reminderWorkoutLabel => 'Sesi latihan';

  @override
  String reminderWorkoutHelp(Object days) {
    return 'Pada hari latihan program aktif: $days.';
  }

  @override
  String get reminderWorkoutNoPlan => 'Aktifkan program latihan agar pengingat sesi terjadwal.';

  @override
  String get reminderMealsLabel => 'Waktu makan';

  @override
  String get breakfastLabel => 'Sarapan';

  @override
  String get lunchLabel => 'Makan siang';

  @override
  String get dinnerLabel => 'Makan malam';

  @override
  String get snackLabel => 'Snack';

  @override
  String get reminderWeighInLabel => 'Timbang berat badan';

  @override
  String get reminderCheckInLabel => 'Check-in harian';

  @override
  String get quietHoursLabel => 'Jam tenang';

  @override
  String get quietHoursHelp => 'Pengingat yang jatuh di jam tenang dilewati.';

  @override
  String get quietStart => 'Mulai';

  @override
  String get quietEnd => 'Selesai';

  @override
  String get sendTestNotification => 'Kirim notifikasi uji';

  @override
  String get testNotificationTitle => 'Notifikasi uji';

  @override
  String get testNotificationBody => 'Pengingat Muscle Coach berfungsi.';

  @override
  String get profileRemindersTile => 'Pengingat';

  @override
  String get remindersOn => 'Aktif';

  @override
  String get remindersOff => 'Nonaktif';

  @override
  String get exerciseMovementTitle => 'Gerakan';

  @override
  String get exercisePhotoCredit =>
      'Foto: Free Exercise DB (domain publik). Variasi alat di foto bisa sedikit berbeda.';

  @override
  String exercisePhotoSemantics(String name, String frame) {
    return 'Foto gerakan $name, fase $frame';
  }

  @override
  String get playMotion => 'Putar gerakan';

  @override
  String get pauseMotion => 'Jeda gerakan';

  @override
  String get muscleMapTitle => 'Otot yang dilatih';

  @override
  String get muscleMapFront => 'Depan';

  @override
  String get muscleMapBack => 'Belakang';

  @override
  String muscleMapSemantics(String primary, String secondary) {
    return 'Peta otot. Otot utama: $primary. Otot pendukung: $secondary.';
  }

  @override
  String get noneLabel => 'tidak ada';

  @override
  String get exerciseQuickViewHint => 'Ketuk gambar untuk melihat gerakan';

  @override
  String get exerciseOpenDetail => 'Lihat detail lengkap';

  @override
  String get save => 'Simpan';

  @override
  String get nutritionToday => 'Hari ini';

  @override
  String get nutritionPrevDay => 'Hari sebelumnya';

  @override
  String get nutritionNextDay => 'Hari berikutnya';

  @override
  String get nutritionConsumed => 'Tercatat';

  @override
  String get nutritionRemaining => 'Sisa';

  @override
  String get nutritionOver => 'Lebih';

  @override
  String nutritionOfTarget(Object target) {
    return 'dari $target';
  }

  @override
  String nutritionKcalLeft(Object kcal) {
    return 'Sisa $kcal kcal';
  }

  @override
  String nutritionKcalOver(Object kcal) {
    return 'Lebih $kcal kcal';
  }

  @override
  String nutritionMacroProgress(Object got, Object target) {
    return '$got / $target g';
  }

  @override
  String get nutritionEstimateNote =>
      'Angka gizi adalah estimasi dari TKPI per 100 g bagian yang dapat dimakan; porsi & cara masak bisa membuat nilainya berbeda.';

  @override
  String get nutritionHasEstimates =>
      'Sebagian catatan memakai angka dari label/manual atau data sumber yang perlu dicek.';

  @override
  String get nutritionAddFood => 'Tambah';

  @override
  String nutritionAddTo(Object meal) {
    return 'Tambah ke $meal';
  }

  @override
  String get nutritionEmptyMeal => 'Belum ada catatan';

  @override
  String get nutritionWaterTitle => 'Minum air';

  @override
  String get nutritionWaterBody =>
      'Biasakan minum air sepanjang hari, terutama saat latihan dan cuaca panas. Ini pengingat kebiasaan umum, bukan anjuran medis pribadi.';

  @override
  String get nutritionHomeTitle => 'Nutrisi hari ini';

  @override
  String get nutritionHomeLog => 'Catat makanan';

  @override
  String entryGrams(Object grams) {
    return '$grams g';
  }

  @override
  String entryMacros(Object p, Object c, Object f) {
    return 'P $p · K $c · L $f';
  }

  @override
  String get entryManual => 'manual';

  @override
  String get entryLabel => 'label';

  @override
  String get entryCheck => 'cek data';

  @override
  String get entryDeleteTitle => 'Hapus catatan?';

  @override
  String get entryDeleted => 'Catatan dihapus';

  @override
  String get entrySaved => 'Tersimpan';

  @override
  String get foodSearchTitle => 'Tambah makanan';

  @override
  String get foodSearchHint => 'Cari makanan, mis. nasi, tempe, telur';

  @override
  String get foodRecent => 'Terakhir dicatat';

  @override
  String get foodRecentEmpty =>
      'Ketik nama makanan untuk mencari di Tabel Komposisi Pangan Indonesia (TKPI).';

  @override
  String get foodNoResult => 'Tidak ditemukan. Coba kata lain, atau tambahkan dari label kemasan.';

  @override
  String foodPer100(Object kcal) {
    return '$kcal kcal / 100 g';
  }

  @override
  String get foodCustomBadge => 'Milik saya';

  @override
  String get foodInconsistentBadge => 'Cek data';

  @override
  String get foodAddCustom => 'Makanan dari label kemasan';

  @override
  String get foodAddManual => 'Catat kalori/makro saja';

  @override
  String foodSourceAttribution(Object name, Object publisher, Object date) {
    return 'Sumber: $name, $publisher (panganku.org). Data diambil $date.';
  }

  @override
  String get portionTitle => 'Porsi';

  @override
  String get portionGrams => 'Berat (g)';

  @override
  String get portionGramsError => 'Isi 1–5000 g';

  @override
  String get portionMeal => 'Waktu makan';

  @override
  String portionEdible(Object pct) {
    return 'Nilai per 100 g bagian yang dapat dimakan ($pct%). Timbang tanpa kulit/tulang.';
  }

  @override
  String get portionInconsistent =>
      'Di sumber, energi makanan ini tidak cocok dengan protein/lemak/karbohidratnya. Angka tetap ditampilkan apa adanya — anggap sebagai perkiraan kasar.';

  @override
  String portionLast(Object grams) {
    return 'Terakhir $grams g';
  }

  @override
  String get customFoodTitle => 'Makanan dari label';

  @override
  String get customFoodName => 'Nama makanan';

  @override
  String get customFoodBasis => 'Nilai gizi per (g)';

  @override
  String get customFoodBasisHelp => 'Isi sesuai label, mis. \"per sajian 30 g\" → 30.';

  @override
  String get customFoodKcal => 'Energi (kcal)';

  @override
  String get customFoodProtein => 'Protein (g)';

  @override
  String get customFoodCarbs => 'Karbohidrat (g)';

  @override
  String get customFoodFat => 'Lemak (g)';

  @override
  String get customFoodRequired => 'Wajib diisi';

  @override
  String get customFoodNumber => 'Isi angka 0–5000';

  @override
  String customFoodMismatch(Object kcal) {
    return 'Energi pada label berbeda jauh dari hitungan makro (≈$kcal kcal). Periksa lagi angkanya.';
  }

  @override
  String get customFoodSaved => 'Makanan disimpan';

  @override
  String get customFoodDelete => 'Hapus makanan saya';

  @override
  String get manualTitle => 'Catat kalori/makro';

  @override
  String get manualName => 'Keterangan';

  @override
  String get manualNameHint => 'mis. Nasi padang (perkiraan)';

  @override
  String get mealPlanTitle => 'Contoh menu harian';

  @override
  String get mealPlanEmpty =>
      'Belum ada menu. AI bisa menyusun contoh menu dari bahan TKPI sesuai target dan preferensi makanmu.';

  @override
  String get mealPlanGenerate => 'Susun menu dengan AI';

  @override
  String get mealPlanRegenerate => 'Susun ulang';

  @override
  String get mealPlanGenerating => 'Menyusun menu dengan AI…';

  @override
  String get mealPlanErrorTitle => 'Menu AI belum bisa disusun';

  @override
  String get entryAiEstimate => 'Estimasi AI';

  @override
  String get scanFood => 'Scan makanan';

  @override
  String get scanFoodSubtitle => 'Foto makanan, AI memperkirakan isinya';

  @override
  String get scanSheetTitle => 'Scan makanan dengan AI';

  @override
  String get scanSheetBody =>
      'Foto dikirim ke Google Gemini untuk dianalisis, lalu langsung dihapus dari HP. Hasilnya perkiraan — periksa sebelum dicatat.';

  @override
  String get scanMealLabel => 'Catat ke';

  @override
  String get scanAnalyzing => 'Menganalisis foto…';

  @override
  String get scanErrorTitle => 'Scan makanan gagal';

  @override
  String get scanErrorInvalid =>
      'AI tidak memberi hasil yang valid (dicoba 2 kali). Coba foto lain yang lebih jelas.';

  @override
  String get scanErrorQuota => 'Batas pemakaian AI hari ini tercapai. Coba lagi besok.';

  @override
  String get scanNotFoodTitle => 'Makanan tidak terdeteksi';

  @override
  String get scanNotFoodBody =>
      'Foto ini tidak tampak berisi makanan. Coba foto lain dengan makanan terlihat jelas dari atas.';

  @override
  String get scanReviewTitle => 'Hasil scan';

  @override
  String get scanReviewHint =>
      'Periksa item dan perkiraan gram. Gizi item TKPI dihitung dari katalog; item lain adalah perkiraan AI.';

  @override
  String get scanGramsLabel => 'Gram';

  @override
  String get scanTotal => 'Total perkiraan';

  @override
  String scanSave(Object count) {
    return 'Catat $count item';
  }

  @override
  String scanSaved(Object count, Object meal) {
    return '$count item tercatat di $meal.';
  }

  @override
  String get scanEmpty => 'Semua item dihapus. Batalkan atau scan ulang.';

  @override
  String get scanDiscard => 'Batal';

  @override
  String get scanSourceTkpi => 'TKPI';

  @override
  String scanMatchedAs(Object name) {
    return 'Dicatat sebagai: $name';
  }

  @override
  String get scanRemove => 'Hapus item';

  @override
  String get mealPlanErrorInvalid =>
      'Hasil AI tidak memenuhi target atau aturan aplikasi (dicoba 2 kali). Coba lagi.';

  @override
  String get mealPlanErrorQuota => 'Batas penyusunan AI hari ini tercapai. Coba lagi besok.';

  @override
  String get mealPlanAiLabel => 'Estimasi AI';

  @override
  String mealPlanTotals(Object kcal, Object p, Object c, Object f) {
    return 'Total menu: $kcal · P $p g · K $c g · L $f g';
  }

  @override
  String mealPlanVsTarget(Object kcal, Object p, Object c, Object f) {
    return 'Target: $kcal · P $p g · K $c g · L $f g';
  }

  @override
  String get mealPlanRecalc => 'Total dihitung aplikasi dari data TKPI × gram, bukan dari AI.';

  @override
  String get mealPlanUse => 'Pakai menu ini';

  @override
  String get mealPlanDiscard => 'Buang';

  @override
  String get mealPlanActivated => 'Menu dipakai';

  @override
  String get mealPlanMarkEaten => 'Tandai dimakan';

  @override
  String get mealPlanEaten => 'Sudah dicatat';

  @override
  String get mealPlanUndoEaten => 'Batalkan';

  @override
  String mealPlanEatenSnack(Object meal) {
    return '$meal dicatat ke hari ini';
  }

  @override
  String get mealPlanOpen => 'Lihat menu';

  @override
  String get mealPlanWarnEatingDisorder =>
      'Kamu mencatat riwayat gangguan makan. Gunakan menu ini hanya sebagai gambaran dan diskusikan pola makanmu dengan tenaga kesehatan.';

  @override
  String get mealPlanWarnAllergy =>
      'Aplikasi hanya memeriksa alergen dari nama bahan. Selalu cek sendiri bahan & bumbu yang dipakai.';

  @override
  String get mealPlanWarnInconsistent =>
      'Ada bahan yang angka sumbernya perlu dicek; totalnya bisa kurang tepat.';

  @override
  String mealPlanModel(Object model, Object version) {
    return 'Disusun oleh $model · $version';
  }

  @override
  String get weightTitle => 'Berat badan';

  @override
  String get weightNote =>
      'Berat badan bukan massa otot. Nilai dinilai dari rata-rata mingguan, bukan satu penimbangan.';

  @override
  String get weightLog => 'Catat berat';

  @override
  String weightLatest(Object kg, Object date) {
    return 'Terakhir $kg kg · $date';
  }

  @override
  String weightAvg7(Object kg) {
    return 'Rata-rata 7 hari $kg kg';
  }

  @override
  String get weightEmpty =>
      'Belum ada penimbangan. Timbang 2–3× per minggu pada kondisi yang sama (mis. pagi setelah ke toilet).';

  @override
  String get weightSheetTitle => 'Catat berat badan';

  @override
  String get weightField => 'Berat (kg)';

  @override
  String get weightDate => 'Tanggal';

  @override
  String get weightRangeError => 'Isi 25–400 kg';

  @override
  String get weightSaved => 'Berat tersimpan';

  @override
  String weightDeleteTitle(Object date) {
    return 'Hapus penimbangan $date?';
  }

  @override
  String get goalStatusTitle => 'Status target';

  @override
  String get goalStatusInsufficient => 'Data belum cukup';

  @override
  String get goalStatusInsufficientBody =>
      'Butuh minimal 2 minggu berurutan dengan ≥ 2 penimbangan per minggu sebelum tren bisa dinilai.';

  @override
  String get goalStatusOnTrack => 'On track';

  @override
  String goalStatusOnTrackBody(Object change, Object min, Object max) {
    return 'Perubahan rata-rata minggu lalu $change kg, dalam rentang yang diharapkan ($min–$max kg/minggu).';
  }

  @override
  String get goalStatusReview => 'Perlu evaluasi';

  @override
  String goalStatusReviewBody(Object change, Object min, Object max) {
    return 'Perubahan rata-rata minggu lalu $change kg, di luar rentang $min–$max kg/minggu. Pantau satu minggu lagi sebelum mengubah apa pun.';
  }

  @override
  String get goalStatusAdjust => 'Target perlu disesuaikan';

  @override
  String goalStatusAdjustBody(Object min, Object max) {
    return 'Dua minggu berturut-turut perubahan berat di luar rentang $min–$max kg/minggu. Lihat usulan di ringkasan mingguan.';
  }

  @override
  String get intakeChartTitle => 'Asupan vs target (14 hari)';

  @override
  String get intakeChartEmpty => 'Belum ada catatan makan.';

  @override
  String intakeChartLegend(Object kcal) {
    return 'Batang = kalori tercatat · garis = target $kcal';
  }

  @override
  String get volumeChartTitle => 'Volume latihan per minggu';

  @override
  String get volumeChartNote =>
      'Volume = beban × repetisi dari set yang selesai (set berbasis waktu tidak dihitung).';

  @override
  String get volumeChartEmpty => 'Belum ada sesi selesai.';

  @override
  String volumeWeek(Object sessions) {
    return '$sessions sesi';
  }

  @override
  String get exerciseChartTitle => 'Progres per gerakan';

  @override
  String get exerciseChartHint => 'Set terberat per sesi';

  @override
  String get exerciseChartEmpty => 'Belum ada set berbeban yang tercatat.';

  @override
  String exerciseChartLatest(Object kg, Object reps) {
    return 'Terakhir $kg kg × $reps';
  }

  @override
  String get milestonesTitle => 'Pencapaian';

  @override
  String milestoneSessions(Object n) {
    return '$n sesi selesai';
  }

  @override
  String milestoneSets(Object n) {
    return '$n set tercatat';
  }

  @override
  String milestoneStreak(Object n) {
    return '$n minggu berturut-turut latihan';
  }

  @override
  String milestoneWeight(Object change) {
    return 'Berat $change kg sejak awal (rata-rata mingguan)';
  }

  @override
  String get fmCheckInWorkoutLabel => 'Latihan';

  @override
  String get fmCheckInIntakeLabel => 'Asupan';

  @override
  String get fmCheckInWorkoutDone => 'Selesai ✓';

  @override
  String get fmCheckInWorkoutNone => 'Belum ada sesi selesai';

  @override
  String fmCheckInIntakeValue(Object kcal, Object target) {
    return '$kcal / $target';
  }

  @override
  String get fmCheckInWeight => 'Berat badan (opsional)';

  @override
  String get fmCheckInSleep => 'Tidur semalam';

  @override
  String get fmCheckInHours => 'jam';

  @override
  String get fmKcalPer100 => 'kcal / 100 g';

  @override
  String get fmSourceTkpi => 'TKPI';

  @override
  String get fmOtherWays => 'Cara lain';

  @override
  String get checkInTitle => 'Check-in harian';

  @override
  String get checkInToday => 'Check-in hari ini';

  @override
  String get checkInMarkedDone => 'Ditandai selesai dari notifikasi. Tambahkan detail bila sempat.';

  @override
  String get measurementsTitle => 'Lingkar badan';

  @override
  String get measurementsLog => 'Catat ukuran';

  @override
  String get measurementsEmpty =>
      'Belum ada ukuran. Lingkar badan membantu melihat perubahan bentuk tubuh yang tidak tampak dari berat saja.';

  @override
  String get measurementsNote =>
      'Ukur di titik yang sama, pagi hari sebelum makan, dengan pita ukur tidak ditarik kencang. Lingkar badan tidak mengukur massa otot secara langsung.';

  @override
  String get siteWaist => 'Pinggang';

  @override
  String get siteChest => 'Dada';

  @override
  String get siteArm => 'Lengan atas';

  @override
  String get siteThigh => 'Paha';

  @override
  String get siteHip => 'Pinggul';

  @override
  String measurementLatest(Object value, Object date) {
    return '$value cm · $date';
  }

  @override
  String measurementChange(Object delta, Object date) {
    return '$delta cm sejak $date';
  }

  @override
  String get measurementSheetTitle => 'Catat lingkar badan';

  @override
  String get measurementSheetHint => 'Isi ukuran yang Anda ukur saja; yang kosong tidak disimpan.';

  @override
  String get measurementDate => 'Tanggal pengukuran';

  @override
  String get measurementRangeError => 'Antara 10–250 cm';

  @override
  String get measurementSaved => 'Ukuran tersimpan.';

  @override
  String measurementChartLabel(Object site) {
    return 'Grafik lingkar $site';
  }

  @override
  String get photosTitle => 'Foto progres';

  @override
  String get photosAdd => 'Tambah foto';

  @override
  String get photosEmpty =>
      'Belum ada foto. Foto dengan pose, tempat, dan cahaya yang sama tiap 2–4 minggu memudahkan melihat perubahan.';

  @override
  String get photosPrivacy =>
      'Foto hanya disimpan di HP ini, tidak dikirim ke AI, dan ikut terhapus saat \"Hapus semua data\".';

  @override
  String get poseFront => 'Depan';

  @override
  String get poseSide => 'Samping';

  @override
  String get poseBack => 'Belakang';

  @override
  String get photoSheetTitle => 'Tambah foto progres';

  @override
  String get photoPose => 'Pose';

  @override
  String get photoDate => 'Tanggal foto';

  @override
  String get photoCamera => 'Kamera';

  @override
  String get photoGallery => 'Galeri';

  @override
  String get photoSaved => 'Foto tersimpan.';

  @override
  String get photoFailed =>
      'Foto tidak bisa diambil atau disimpan. Periksa izin kamera/galeri di pengaturan.';

  @override
  String get photoDeleteTitle => 'Hapus foto ini?';

  @override
  String get photoDeleteMessage => 'Foto dihapus dari HP ini dan tidak bisa dikembalikan.';

  @override
  String get photoDeleted => 'Foto dihapus.';

  @override
  String get photoCompare => 'Bandingkan';

  @override
  String get photoCompareTitle => 'Bandingkan foto';

  @override
  String get photoCompareNeedTwo => 'Butuh minimal dua tanggal dengan pose yang sama.';

  @override
  String get photoBefore => 'Sebelum';

  @override
  String get photoAfter => 'Sesudah';

  @override
  String photoWeightOn(Object kg) {
    return 'Berat $kg kg';
  }

  @override
  String get photoMissing => 'Berkas foto tidak ditemukan';

  @override
  String photoOpenLabel(Object pose, Object date) {
    return 'Foto $pose $date';
  }

  @override
  String get checkInDone => 'Check-in hari ini sudah diisi';

  @override
  String get checkInPrompt => 'Catat tidur, energi, dan kendala hari ini (1 menit).';

  @override
  String get checkInOpen => 'Isi check-in';

  @override
  String get checkInEdit => 'Ubah';

  @override
  String get checkInWeight => 'Berat badan (kg, opsional)';

  @override
  String get checkInSleep => 'Tidur semalam (jam)';

  @override
  String get checkInEnergy => 'Energi';

  @override
  String get checkInMood => 'Suasana hati (opsional)';

  @override
  String get checkInScaleLow => 'rendah';

  @override
  String get checkInScaleHigh => 'baik';

  @override
  String get checkInDiscomfort => 'Nyeri/tidak nyaman saat latihan (opsional)';

  @override
  String get checkInNotes => 'Catatan kendala (opsional)';

  @override
  String get checkInWorkoutDone => 'Latihan hari ini: selesai ✓';

  @override
  String get checkInWorkoutNone => 'Latihan hari ini: belum ada sesi selesai';

  @override
  String checkInIntake(Object kcal, Object target) {
    return 'Makan tercatat: $kcal dari $target';
  }

  @override
  String get checkInSaved => 'Check-in tersimpan';

  @override
  String get checkInSleepError => 'Isi 0–24 jam';

  @override
  String get checkInDiscomfortWarning =>
      'Bila nyeri tajam, bengkak, atau tidak membaik, hentikan gerakan pemicunya dan konsultasikan ke tenaga kesehatan.';

  @override
  String get weeklyTitle => 'Ringkasan mingguan';

  @override
  String get weeklyStatTraining => 'Latihan';

  @override
  String get weeklyStatIntake => 'Asupan';

  @override
  String get weeklyStatWeight => 'Berat';

  @override
  String get weeklyOpenShort => 'Buka ringkasan';

  @override
  String weightLatestDate(Object date) {
    return 'kg · $date';
  }

  @override
  String get weeklyOpen => 'Lihat ringkasan minggu lalu';

  @override
  String get weeklyThisWeek => 'Minggu ini (berjalan)';

  @override
  String weeklyRange(Object start, Object end) {
    return '$start – $end';
  }

  @override
  String get weeklyPrev => 'Minggu sebelumnya';

  @override
  String get weeklyNext => 'Minggu berikutnya';

  @override
  String get weeklyNoData => 'Belum ada data pada minggu ini.';

  @override
  String get weeklyWeight => 'Berat rata-rata';

  @override
  String weeklyWeightValue(Object kg, Object n) {
    return '$kg kg ($n× timbang)';
  }

  @override
  String weeklyWeightChange(Object change) {
    return '$change kg dari minggu sebelumnya';
  }

  @override
  String get weeklyWeightMissing => 'Kurang dari 2 penimbangan';

  @override
  String get weeklyTraining => 'Latihan';

  @override
  String weeklyTrainingValue(Object done, Object planned, Object sets) {
    return '$done dari $planned sesi · $sets set';
  }

  @override
  String weeklyTrainingNoPlan(Object done, Object sets) {
    return '$done sesi · $sets set';
  }

  @override
  String weeklyVolume(Object kg) {
    return 'Volume $kg kg';
  }

  @override
  String weeklyVolumeChange(Object pct) {
    return '$pct% dari minggu sebelumnya';
  }

  @override
  String get weeklyIntake => 'Makan';

  @override
  String weeklyIntakeValue(Object days, Object kcal, Object pct) {
    return '$days hari tercatat · rata-rata $kcal ($pct% target)';
  }

  @override
  String get weeklyIntakeNone => 'Belum ada catatan makan';

  @override
  String weeklyProtein(Object g, Object target) {
    return 'Protein rata-rata $g g dari $target g';
  }

  @override
  String get weeklyRecovery => 'Pemulihan';

  @override
  String weeklyRecoveryValue(Object n, Object sleep, Object energy) {
    return '$n check-in · tidur $sleep jam · energi $energy/5';
  }

  @override
  String get weeklyRecoveryNone => 'Belum ada check-in';

  @override
  String weeklyDiscomfort(Object n) {
    return 'Keluhan nyeri pada $n hari';
  }

  @override
  String get adjustTitle => 'Usulan penyesuaian target';

  @override
  String adjustUp(Object delta, Object carbs, Object kcal) {
    return 'Berat naik lebih lambat dari rentang yang diharapkan selama 2 minggu, dengan makan tercatat konsisten. Usulan: naikkan target $delta kcal (karbohidrat +$carbs g) → $kcal.';
  }

  @override
  String adjustDown(Object delta, Object carbs, Object kcal) {
    return 'Berat naik lebih cepat dari rentang yang diharapkan selama 2 minggu, dengan makan tercatat konsisten. Usulan: turunkan target $delta kcal (karbohidrat −$carbs g) → $kcal.';
  }

  @override
  String get adjustNote =>
      'Perubahan kecil, dihitung aplikasi (bukan AI). Tidak berlaku sebelum kamu menyetujuinya.';

  @override
  String get adjustAccept => 'Terapkan';

  @override
  String get adjustDecline => 'Tidak sekarang';

  @override
  String get adjustAccepted => 'Target baru aktif.';

  @override
  String get adjustDeclined => 'Usulan tidak diterapkan.';

  @override
  String get adjustAcceptedLabel => 'Diterapkan';

  @override
  String get adjustDeclinedLabel => 'Tidak diterapkan';

  @override
  String get adjustBlockedIntake =>
      'Tren berat di luar rentang, tetapi makan belum tercatat konsisten (≥ 4 hari/minggu, dekat target). Perbaiki pencatatan dulu sebelum target diubah.';

  @override
  String get adjustBlockedSafety =>
      'Karena ada riwayat gangguan makan, perubahan target kalori sebaiknya didiskusikan dengan tenaga kesehatan.';

  @override
  String get weeklyAiTitle => 'Ringkasan AI';

  @override
  String get weeklyAiGenerate => 'Buat ringkasan dengan AI';

  @override
  String get weeklyAiRegenerate => 'Buat ulang';

  @override
  String get weeklyAiGenerating => 'Menyusun ringkasan…';

  @override
  String get weeklyAiWentWell => 'Yang berjalan baik';

  @override
  String get weeklyAiObstacles => 'Hambatan';

  @override
  String get weeklyAiSuggestions => 'Saran minggu depan';

  @override
  String get weeklyAiNote =>
      'Ditulis AI dari statistik di atas (tanpa nama, umur, atau catatan pribadi). Tidak mengubah target.';

  @override
  String get weeklyAiError => 'Ringkasan AI belum bisa dibuat.';

  @override
  String get weeklyHistory => 'Ringkasan tersimpan';

  @override
  String get mealPlanWarnPortions =>
      'Porsi (gram) dari AI disesuaikan aplikasi agar total mendekati targetmu. Pilihan bahan tetap dari AI.';

  @override
  String get measureGuideOpen => 'Cara mengukur';

  @override
  String get measureGuideTitle => 'Cara mengukur lingkar badan';

  @override
  String get measureGuideIntro => 'Pakai pita ukur kain. Garis volt menunjukkan letak pita.';

  @override
  String get measureStepsChest =>
      'Berdiri tegak, lengan rileks di samping badan.\nLingkarkan pita di bagian dada paling lebar (sejajar puting), lewat bawah ketiak dan tulang belikat.\nBaca angkanya setelah membuang napas normal.';

  @override
  String get measureStepsWaist =>
      'Berdiri tegak, perut rileks — jangan dikempiskan.\nLingkarkan pita sejajar pusar, di atas tulang pinggul.\nBaca angkanya di akhir hembusan napas normal.';

  @override
  String get measureStepsArm =>
      'Biarkan lengan menggantung rileks di samping badan.\nCari titik tengah antara ujung bahu dan siku.\nLingkarkan pita di titik itu; pakai lengan yang sama setiap kali.';

  @override
  String get measureStepsThigh =>
      'Berdiri dengan kaki selebar pinggul, berat badan seimbang.\nLingkarkan pita di bagian paha paling besar, ±2–3 jari di bawah selangkangan.\nPakai paha yang sama setiap kali (mis. kanan).';

  @override
  String get measureStepsHip =>
      'Berdiri tegak dengan kaki rapat.\nLingkarkan pita di bagian bokong paling menonjol.\nPastikan pita datar sejajar lantai — cek di cermin.';

  @override
  String get measureTipsTitle => 'Agar hasilnya konsisten';

  @override
  String get measureTips =>
      'Ukur di waktu yang sama, idealnya pagi hari setelah ke toilet dan sebelum makan.\nPita menempel di kulit tanpa menekan, dan sejajar lantai.\nUkur dua kali lalu catat rata-ratanya.\nCukup ulangi setiap 1–2 minggu; perubahan harian wajar naik-turun.';

  @override
  String get photoGuideOpen => 'Contoh foto & tips';

  @override
  String get photoGuideTitle => 'Contoh foto progres';

  @override
  String get photoGuideIntro =>
      'Ambil tiga pose yang sama setiap kali agar perubahannya mudah dibandingkan.';

  @override
  String get photoPoseHintFront =>
      'Menghadap kamera, kaki selebar pinggul, lengan sedikit menjauh dari badan.';

  @override
  String get photoPoseHintSide =>
      'Putar 90°, berdiri tegak, lengan di samping atau sedikit ke depan agar pinggang terlihat.';

  @override
  String get photoPoseHintBack =>
      'Membelakangi kamera dengan posisi kaki dan lengan sama seperti foto depan.';

  @override
  String get photoTipsTitle => 'Tips agar foto bisa dibandingkan';

  @override
  String get photoTips =>
      'Cahaya sama setiap kali, dari depan atau atas; hindari cahaya dari belakang.\nLatar polos, jarak (±2–3 m) dan tinggi kamera sama — setinggi pusar.\nSeluruh badan dari kepala sampai kaki masuk bingkai; pakai timer atau minta bantuan.\nPakaian sama yang memperlihatkan bentuk badan.\nAmbil di waktu yang sama, mis. pagi hari sebelum makan.';

  @override
  String photoExampleLabel(Object pose) {
    return 'Contoh pose $pose';
  }

  @override
  String bodyGuideFigureLabel(Object site) {
    return 'Ilustrasi letak pita ukur di $site';
  }
}
