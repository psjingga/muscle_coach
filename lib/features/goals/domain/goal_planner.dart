import 'dart:math' as math;

import '../../../core/utils/formatters.dart';
import '../../assessment/domain/entities/assessment_data.dart';
import '../../assessment/domain/validators/assessment_validator.dart';
import 'entities/goal.dart';
import 'nutrition_config.dart';

/// Kalkulasi baseline energi & makro serta evaluasi target — deterministik,
/// tanpa AI.
///
/// - BMR: Mifflin–St Jeor (1990). Estimasi populasi; kurang akurat untuk orang
///   sangat berotot/obesitas; tidak berlaku saat hamil.
/// - TDEE = BMR × faktor aktivitas; energi target = TDEE × (1 + surplus%).
/// - Protein & lemak dari berat badan; karbohidrat = sisa energi.
/// - Total kcal dihitung ulang dari makro yang dibulatkan (4/4/9).
/// - Jenis kelamin tidak diisi → rentang; makro memakai titik tengah.
abstract final class GoalPlanner {
  static double mifflinStJeor({
    required bool male,
    required double weightKg,
    required double heightCm,
    required int age,
  }) => 10 * weightKg + 6.25 * heightCm - 5 * age + (male ? 5 : -161);

  static double bmi(double weightKg, double heightCm) {
    final m = heightCm / 100;
    return weightKg / (m * m);
  }

  static int _roundTo(double value, int step) => (value / step).round() * step;
  static double _round1(double v) => (v * 10).round() / 10;
  static double _round2(double v) => (v * 100).round() / 100;

  static double surplusFor(PrimaryGoal goal, ExperienceLevel level, {required bool conservative}) {
    final base = NutritionConfig.surplusPct[goal]![level]!;
    return conservative ? math.min(base, NutritionConfig.conservativeSurplusPct) : base;
  }

  static NutritionPlan calculateNutrition({
    required Sex sex,
    required double weightKg,
    required double heightCm,
    required int age,
    required ActivityLevel activity,
    required PrimaryGoal goal,
    required ExperienceLevel level,
    required bool conservative,
  }) {
    final sexes = sex == Sex.undisclosed ? [false, true] : [sex == Sex.male];
    final bmrs = [
      for (final male in sexes)
        mifflinStJeor(male: male, weightKg: weightKg, heightCm: heightCm, age: age),
    ];
    final bmrMin = bmrs.reduce(math.min);
    final bmrMax = bmrs.reduce(math.max);

    final factor = NutritionConfig.activityFactors[activity]!;
    final tdeeMin = bmrMin * factor;
    final tdeeMax = bmrMax * factor;
    final surplus = surplusFor(goal, level, conservative: conservative);
    final energyFactor = 1 + surplus / 100;
    final energyMid = (tdeeMin + tdeeMax) / 2 * energyFactor;

    // Protein
    final currentBmi = bmi(weightKg, heightCm);
    final proteinBasisKg = currentBmi > NutritionConfig.proteinReferenceBmiAbove
        ? NutritionConfig.proteinReferenceBmi * math.pow(heightCm / 100, 2)
        : weightKg;
    final proteinPerKg = goal == PrimaryGoal.recomposition
        ? NutritionConfig.proteinRecompositionGPerKg
        : NutritionConfig.proteinDefaultGPerKg;
    final proteinG = _roundTo(proteinPerKg * proteinBasisKg, NutritionConfig.gramsStep);

    // Lemak: g/kg, dibatasi rentang % energi, minimum g/kg.
    const kp = NutritionConfig.kcalPerGramProtein;
    const kc = NutritionConfig.kcalPerGramCarbs;
    const kf = NutritionConfig.kcalPerGramFat;
    final fatMinByEnergy = energyMid * NutritionConfig.fatMinEnergyPct / 100 / kf;
    final fatMaxByEnergy = energyMid * NutritionConfig.fatMaxEnergyPct / 100 / kf;
    var fatRaw = math.min(
      math.max(NutritionConfig.fatGPerKg * weightKg, fatMinByEnergy),
      fatMaxByEnergy,
    );
    fatRaw = math.max(fatRaw, NutritionConfig.fatMinGPerKg * weightKg);
    final fatG = _roundTo(fatRaw, NutritionConfig.gramsStep);

    // Karbohidrat = sisa energi.
    final carbsG = math.max(
      0,
      _roundTo((energyMid - proteinG * kp - fatG * kf) / kc, NutritionConfig.gramsStep),
    );
    final targetKcal = proteinG * kp + carbsG * kc + fatG * kf;
    int pct(int kcal) => targetKcal == 0 ? 0 : (kcal / targetKcal * 100).round();

    return NutritionPlan(
      sexBasis: switch (sex) {
        Sex.male => SexBasis.male,
        Sex.female => SexBasis.female,
        Sex.undisclosed => SexBasis.range,
      },
      bmrKcal: NumRange(min: bmrMin.roundToDouble(), max: bmrMax.roundToDouble()),
      activityFactor: factor,
      tdeeKcal: NumRange(min: tdeeMin.roundToDouble(), max: tdeeMax.roundToDouble()),
      surplusPct: surplus,
      targetKcalRange: NumRange(
        min: _roundTo(tdeeMin * energyFactor, NutritionConfig.kcalStep).toDouble(),
        max: _roundTo(tdeeMax * energyFactor, NutritionConfig.kcalStep).toDouble(),
      ),
      targetKcal: targetKcal,
      proteinG: proteinG,
      fatG: fatG,
      carbsG: carbsG,
      proteinGPerKg: _round1(proteinG / weightKg),
      fatGPerKg: _round1(fatG / weightKg),
      proteinBasisKg: _round1(proteinBasisKg),
      energySplitPct: EnergySplit(
        protein: pct(proteinG * kp),
        fat: pct(fatG * kf),
        carbs: pct(carbsG * kc),
      ),
    );
  }

  static SafetyAssessment assessSafety({
    required int age,
    required double bmi,
    required List<MedicalFlag> medicalFlags,
    required List<RedFlag> redFlags,
  }) {
    final warnings = <SafetyWarning>[
      if (redFlags.isNotEmpty) SafetyWarning.redFlagSymptoms,
      if (age < NutritionConfig.adultAge) SafetyWarning.minorAge,
      if (bmi < NutritionConfig.bmiLow) SafetyWarning.lowBmi,
      if (bmi >= NutritionConfig.bmiHigh) SafetyWarning.highBmi,
      for (final f in medicalFlags)
        switch (f) {
          MedicalFlag.pregnant => SafetyWarning.pregnant,
          MedicalFlag.chronicCondition => SafetyWarning.chronicCondition,
          MedicalFlag.eatingDisorderHistory => SafetyWarning.eatingDisorderHistory,
          MedicalFlag.injuryRecovery => SafetyWarning.injuryRecovery,
          MedicalFlag.medication => SafetyWarning.medication,
        },
    ];
    return SafetyAssessment(
      stop: redFlags.isNotEmpty,
      conservative:
          age < NutritionConfig.adultAge || bmi < NutritionConfig.bmiLow || medicalFlags.isNotEmpty,
      warnings: warnings,
    );
  }

  static double maxWeeklyGainPct(ExperienceLevel level, {required bool conservative}) {
    final base = NutritionConfig.maxWeeklyGainPct[level]!;
    return conservative ? math.min(base, NutritionConfig.conservativeMaxWeeklyGainPct) : base;
  }

  static const _eps = 1e-9;

  static GoalEvaluation evaluateGoal({
    required PrimaryGoal primary,
    required ExperienceLevel level,
    required double startKg,
    required double? targetKg,
    required int weeks,
    required bool conservative,
  }) {
    final maxPct = maxWeeklyGainPct(level, conservative: conservative);
    final maxKgPerWeek = startKg * maxPct / 100;
    final expected = primary == PrimaryGoal.recomposition
        ? const NumRange(min: 0, max: 0)
        : NumRange(min: _round2(maxKgPerWeek / 2), max: _round2(maxKgPerWeek));
    final base = GoalEvaluation(
      verdict: GoalVerdict.realistic,
      reasons: const [],
      maxWeeklyGainPct: maxPct,
      expectedWeeklyGainKg: expected,
    );
    if (targetKg == null) return base;

    final deltaKg = _round1(targetKg - startKg);
    final result = base.copyWith(
      deltaKg: deltaKg,
      weeklyChangeKg: _round2(deltaKg / weeks),
      weeklyChangePct: _round2(deltaKg / weeks / startKg * 100),
    );

    if (primary == PrimaryGoal.recomposition) {
      final maxTotal = startKg * NutritionConfig.recompositionMaxTotalChangePct / 100;
      if (deltaKg.abs() > maxTotal + _eps) {
        return result.copyWith(
          verdict: GoalVerdict.needsAdjustment,
          reasons: [GoalReason.recompositionWeightChange],
          suggestedTargetWeightKg: _round1(startKg),
        );
      }
      return result;
    }
    if (deltaKg < -_eps) {
      return result.copyWith(
        verdict: GoalVerdict.needsAdjustment,
        reasons: [GoalReason.targetBelowCurrent],
        suggestedTargetWeightKg: _round1(startKg + maxKgPerWeek * weeks),
      );
    }
    if (result.weeklyChangePct! > maxPct + _eps) {
      return result.copyWith(
        verdict: GoalVerdict.needsAdjustment,
        reasons: [GoalReason.rateTooFast],
        // Saran waktu hanya bila masih dalam rentang yang bisa diisi di wizard.
        suggestedWeeks: switch ((deltaKg / maxKgPerWeek - _eps).ceil()) {
          final w when w <= AssessmentValidator.targetWeeksRange.max => w,
          _ => null,
        },
        // Dibulatkan ke bawah agar saran pasti di dalam batas.
        suggestedTargetWeightKg: ((startKg + maxKgPerWeek * weeks) * 10).floor() / 10,
      );
    }
    return result;
  }

  /// Evaluasi target dari jawaban wizard sebelum dikirim, agar pengguna
  /// tahu lebih awal bila target perlu disesuaikan. `null` bila data yang
  /// dibutuhkan (profil, tujuan, level) belum lengkap. Batas konservatif
  /// memakai data keselamatan yang sudah diisi; evaluasi final tetap di
  /// [buildProposal].
  static TargetPreview? previewTarget(AssessmentData a, DateTime now) {
    final p = a.profile;
    final birth = p.birthDate;
    final weight = p.weightKg;
    final height = p.heightCm;
    final primary = a.goal.primary;
    final weeks = a.goal.targetWeeks;
    final level = a.experience.level;
    if (birth == null || weight == null || height == null) return null;
    if (primary == null || weeks == null || weeks <= 0 || level == null) return null;
    final age = AssessmentValidator.ageOn(birth, now);
    if (age == null) return null;
    final safety = assessSafety(
      age: age,
      bmi: bmi(weight, height),
      medicalFlags: a.safety.medicalFlags,
      redFlags: a.safety.redFlags,
    );
    return TargetPreview(
      startKg: weight,
      weeks: weeks,
      safety: safety,
      evaluation: evaluateGoal(
        primary: primary,
        level: level,
        startKg: weight,
        targetKg: a.goal.targetWeightKg,
        weeks: weeks,
        conservative: safety.conservative,
      ),
    );
  }

  /// Gabungkan keselamatan, evaluasi target, dan kalkulasi nutrisi dari
  /// assessment yang sudah lolos validasi. Mengembalikan goal berstatus usulan.
  static Goal buildProposal(AssessmentData a, DateTime now) {
    final p = a.profile;
    final age = AssessmentValidator.ageOn(p.birthDate!, now)!;
    final currentBmi = bmi(p.weightKg!, p.heightCm!);
    final safety = assessSafety(
      age: age,
      bmi: currentBmi,
      medicalFlags: a.safety.medicalFlags,
      redFlags: a.safety.redFlags,
    );
    final weeks = a.goal.targetWeeks!;
    return Goal(
      status: GoalStatus.proposed,
      primaryGoal: a.goal.primary!,
      level: a.experience.level!,
      age: age,
      bmi: _round1(currentBmi),
      startWeightKg: p.weightKg!,
      targetWeightKg: a.goal.targetWeightKg,
      targetWeeks: weeks,
      // Aritmetika kalender (bukan Duration) agar aman terhadap DST.
      targetDate: Fmt.toIsoDate(DateTime(now.year, now.month, now.day + weeks * 7)),
      evaluation: evaluateGoal(
        primary: a.goal.primary!,
        level: a.experience.level!,
        startKg: p.weightKg!,
        targetKg: a.goal.targetWeightKg,
        weeks: weeks,
        conservative: safety.conservative,
      ),
      safety: safety,
      nutrition: calculateNutrition(
        sex: p.sex!,
        weightKg: p.weightKg!,
        heightCm: p.heightCm!,
        age: age,
        activity: a.activity.level!,
        goal: a.goal.primary!,
        level: a.experience.level!,
        conservative: safety.conservative,
      ),
      configVersion: NutritionConfig.version,
    );
  }
}

/// Hasil [GoalPlanner.previewTarget].
class TargetPreview {
  const TargetPreview({
    required this.startKg,
    required this.weeks,
    required this.safety,
    required this.evaluation,
  });

  final double startKg;
  final int weeks;
  final SafetyAssessment safety;
  final GoalEvaluation evaluation;

  bool get rejected => evaluation.verdict == GoalVerdict.needsAdjustment;
}
