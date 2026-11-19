import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';
import 'package:musclecoach/features/goals/domain/goal_planner.dart';
import 'package:musclecoach/features/goals/domain/nutrition_config.dart';

import '../../fixtures/sample_assessment.dart';

typedef G = GoalPlanner;

NutritionPlan calc({
  Sex sex = Sex.male,
  double weightKg = 70,
  double heightCm = 175,
  PrimaryGoal goal = PrimaryGoal.muscleGain,
  bool conservative = false,
}) => G.calculateNutrition(
  sex: sex,
  weightKg: weightKg,
  heightCm: heightCm,
  age: 30,
  activity: ActivityLevel.light,
  goal: goal,
  level: ExperienceLevel.beginner,
  conservative: conservative,
);

void main() {
  group('kalkulasi nutrisi', () {
    test('Mifflin–St Jeor & BMI', () {
      expect(
        G.mifflinStJeor(male: true, weightKg: 70, heightCm: 175, age: 30),
        closeTo(1648.75, 1e-9),
      );
      expect(
        G.mifflinStJeor(male: false, weightKg: 70, heightCm: 175, age: 30),
        closeTo(1482.75, 1e-9),
      );
      expect(G.bmi(70, 175), closeTo(22.857, 0.001));
    });

    test('BMR, TDEE, surplus dan makro untuk pria pemula', () {
      final r = calc();
      expect(r.sexBasis, SexBasis.male);
      expect(r.bmrKcal, const NumRange(min: 1649, max: 1649));
      expect(r.activityFactor, 1.375);
      expect(r.tdeeKcal, const NumRange(min: 2267, max: 2267));
      expect(r.surplusPct, 10);
      expect(r.proteinG, 125); // 1,8 × 70 = 126 → 125
      expect(r.fatG, 55); // 0,8 × 70 = 56 → 55
      expect(r.carbsG % 5, 0);
    });

    test('total kcal selalu konsisten dengan makro 4/4/9', () {
      for (final w in [45.0, 60.0, 82.5, 110.0, 150.0]) {
        for (final sex in Sex.values) {
          final r = calc(weightKg: w, sex: sex);
          expect(r.targetKcal, r.proteinG * 4 + r.carbsG * 4 + r.fatG * 9);
          expect(r.proteinG % 5, 0);
          expect(r.fatG % 5, 0);
          expect(r.carbsG, greaterThanOrEqualTo(0));
        }
      }
    });

    test('energi target dekat TDEE × (1 + surplus)', () {
      final r = calc();
      expect((r.targetKcal - r.tdeeKcal.min * 1.1).abs(), lessThan(40));
      expect(r.targetKcalRange.isSingle, isTrue);
    });

    test('jenis kelamin tidak diisi → rentang', () {
      final r = calc(sex: Sex.undisclosed);
      expect(r.sexBasis, SexBasis.range);
      expect(r.bmrKcal, const NumRange(min: 1483, max: 1649));
      expect(r.targetKcalRange.min, lessThan(r.targetKcalRange.max));
      expect(
        r.targetKcal,
        inInclusiveRange(r.targetKcalRange.min - 30, r.targetKcalRange.max + 30),
      );
    });

    test('lemak 20–35 % energi dan ≥ 0,6 g/kg', () {
      for (final w in [40.0, 70.0, 140.0]) {
        final r = calc(weightKg: w, heightCm: 180);
        final pct = r.fatG * 9 / r.targetKcal;
        expect(pct, inInclusiveRange(0.18, 0.37));
        expect(r.fatG, greaterThanOrEqualTo((0.6 * w / 5).floor() * 5));
      }
    });

    test('BMI tinggi → protein memakai berat acuan BMI 25', () {
      final r = calc(weightKg: 120);
      expect(r.proteinBasisKg, closeTo(76.6, 0.05));
      expect(r.proteinG, 140);
    });

    test('recomposition: tanpa surplus, protein 2,0 g/kg; mode konservatif membatasi surplus', () {
      final recomp = calc(goal: PrimaryGoal.recomposition);
      expect(recomp.surplusPct, 0);
      expect(recomp.proteinG, 140);
      expect(calc(conservative: true).surplusPct, NutritionConfig.conservativeSurplusPct);
      expect(
        G.surplusFor(PrimaryGoal.muscleGain, ExperienceLevel.advanced, conservative: false),
        5,
      );
    });

    test('persentase energi berjumlah ±100', () {
      final s = calc().energySplitPct;
      expect(s.protein + s.fat + s.carbs, inInclusiveRange(99, 101));
    });
  });

  group('evaluasi target', () {
    GoalEvaluation eval({
      PrimaryGoal primary = PrimaryGoal.muscleGain,
      double? target = 74,
      int weeks = 24,
      bool conservative = false,
    }) => G.evaluateGoal(
      primary: primary,
      level: ExperienceLevel.beginner,
      startKg: 70,
      targetKg: target,
      weeks: weeks,
      conservative: conservative,
    );

    test('dalam batas laju → realistis', () {
      final e = eval();
      expect(e.verdict, GoalVerdict.realistic);
      expect(e.deltaKg, 4);
      expect(e.weeklyChangePct, closeTo(0.24, 0.001));
      expect(e.expectedWeeklyGainKg, const NumRange(min: 0.18, max: 0.35));
    });

    test('laju terlalu cepat → saran waktu & target yang lolos', () {
      final e = eval(target: 80, weeks: 8);
      expect(e.verdict, GoalVerdict.needsAdjustment);
      expect(e.reasons, [GoalReason.rateTooFast]);
      expect(e.suggestedWeeks, 29);
      expect(e.suggestedTargetWeightKg, 72.8);
      expect(eval(target: 80, weeks: 29).verdict, GoalVerdict.realistic);
      expect(eval(target: 72.8, weeks: 8).verdict, GoalVerdict.realistic);
    });

    test('tepat di batas masih realistis; konservatif menurunkan batas', () {
      expect(eval(target: 77, weeks: 20).verdict, GoalVerdict.realistic);
      expect(eval(target: 77, weeks: 20, conservative: true).verdict, GoalVerdict.needsAdjustment);
      expect(G.maxWeeklyGainPct(ExperienceLevel.advanced, conservative: false), 0.25);
    });

    test('muscle gain dengan target di bawah berat sekarang', () {
      expect(eval(target: 65).reasons, [GoalReason.targetBelowCurrent]);
    });

    test('recomposition: stabil OK, perubahan besar perlu disesuaikan', () {
      expect(eval(primary: PrimaryGoal.recomposition, target: 71).verdict, GoalVerdict.realistic);
      final e = eval(primary: PrimaryGoal.recomposition, target: 76);
      expect(e.reasons, [GoalReason.recompositionWeightChange]);
      expect(e.suggestedTargetWeightKg, 70);
    });

    test('tanpa berat target → realistis', () {
      expect(eval(target: null).deltaKg, isNull);
    });
  });

  group('keselamatan & usulan goal', () {
    test('flag keselamatan', () {
      final ok = G.assessSafety(age: 30, bmi: 22, medicalFlags: const [], redFlags: const []);
      expect(ok, const SafetyAssessment(stop: false, conservative: false, warnings: []));
      final stop = G.assessSafety(
        age: 30,
        bmi: 22,
        medicalFlags: const [],
        redFlags: const [RedFlag.chestPain],
      );
      expect(stop.stop, isTrue);
      expect(stop.warnings, [SafetyWarning.redFlagSymptoms]);
      expect(
        G.assessSafety(
          age: 30,
          bmi: 22,
          medicalFlags: const [MedicalFlag.pregnant],
          redFlags: const [],
        ),
        const SafetyAssessment(stop: false, conservative: true, warnings: [SafetyWarning.pregnant]),
      );
      expect(
        G.assessSafety(age: 17, bmi: 22, medicalFlags: const [], redFlags: const []).warnings,
        [SafetyWarning.minorAge],
      );
      final high = G.assessSafety(age: 30, bmi: 36, medicalFlags: const [], redFlags: const []);
      expect(high.warnings, [SafetyWarning.highBmi]);
      expect(high.conservative, isFalse);
    });

    test('buildProposal menggabungkan usia, evaluasi, nutrisi, dan tanggal target', () {
      final g = G.buildProposal(sample, now);
      expect(g.status, GoalStatus.proposed);
      expect(g.age, 30);
      expect(g.bmi, 22.9);
      expect(g.targetDate, '2027-05-06');
      expect(g.evaluation.verdict, GoalVerdict.realistic);
      expect(g.nutrition.surplusPct, 10);
      expect(g.configVersion, NutritionConfig.version);
      expect(g.canConfirm, isTrue);
    });

    test('flag medis → konservatif; gejala bahaya → tidak bisa dikonfirmasi', () {
      final med = G.buildProposal(
        sample.copyWith(safety: const SafetySection(medicalFlags: [MedicalFlag.medication])),
        now,
      );
      expect(med.nutrition.surplusPct, 5);
      expect(med.evaluation.maxWeeklyGainPct, 0.25);
      final danger = G.buildProposal(
        sample.copyWith(safety: const SafetySection(redFlags: [RedFlag.fainting])),
        now,
      );
      expect(danger.canConfirm, isFalse);
    });

    test('round-trip JSON goal (disimpan sebagai JSON di database)', () {
      final g = G.buildProposal(sample, now);
      expect(Goal.fromJson(g.toJson()), g);
    });
  });
}
