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
    return 'Target ini menuntut kenaikan $rate kg/minggu, melebihi batas $max kg/minggu ($maxPct% berat badan) untuk level Anda. Kenaikan terlalu cepat cenderung menambah lebih banyak lemak.';
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
  String get homeNoPlan => 'Belum ada program latihan. Buat program awal di tab Latihan.';

  @override
  String get openWorkout => 'Buka';

  @override
  String get dataPrivacySection => 'Data & privasi';

  @override
  String get dataLocalOnly =>
      'Semua data tersimpan hanya di perangkat ini, tanpa akun dan tanpa server. Bila aplikasi dihapus atau HP hilang, data ikut hilang — fitur backup menyusul.';

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
      'Saat menyusun program, aplikasi mengirim ke Google Gemini: tujuan, level & pengalaman latihan, hari & durasi latihan, alat dan beban maksimal, otot prioritas, preferensi latihan, catatan cedera/gerakan yang dihindari, dan daftar gerakan katalog. Tidak dikirim: nama, umur, tanggal lahir, tinggi/berat badan, jenis kondisi medis, atau data makan.';

  @override
  String get aiFreeTierNote =>
      'Di tier gratis Google AI Studio, Google dapat memakai isi permintaan untuk meningkatkan produknya. Gunakan tier berbayar bila Anda tidak menginginkannya.';

  @override
  String get aiConsentCheckbox =>
      'Saya setuju data di atas dikirim ke Google Gemini untuk menyusun program.';

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
}
