import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/ai_coach/domain/prompts/weekly_review_v1.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';
import 'package:musclecoach/features/goals/domain/goal_planner.dart';
import 'package:musclecoach/features/progress/data/progress_repository.dart';
import 'package:musclecoach/features/progress/domain/progress_math.dart';
import 'package:musclecoach/features/progress/domain/progress_models.dart';

import '../../fixtures/sample_assessment.dart';

/// Goal contoh: pria 70 kg pemula, muscle gain → laju 0,18–0,35 kg/minggu.
final goal = GoalPlanner.buildProposal(sample, now);

/// Kamis 19 Nov 2026 → minggu berjalan mulai Senin 16 Nov.
const today = '2026-11-19';

/// 3 penimbangan per minggu dengan rata-rata [avgs] (minggu terlama dulu),
/// minggu terakhir = minggu sebelum minggu berjalan.
List<WeightEntry> weeksOf(List<double> avgs) {
  final out = <WeightEntry>[];
  for (final (i, a) in avgs.indexed) {
    final ws = ProgressMath.addDays('2026-11-16', -7 * (avgs.length - i));
    out
      ..add(WeightEntry(date: ProgressMath.addDays(ws, 0), kg: a - 0.2))
      ..add(WeightEntry(date: ProgressMath.addDays(ws, 2), kg: a))
      ..add(WeightEntry(date: ProgressMath.addDays(ws, 4), kg: a + 0.2));
  }
  return out;
}

WeekSummary week({int logged = 6, double avgKcal = 2500, double target = 2500}) => WeekSummary(
  weekStart: '2026-11-09',
  weighIns: 3,
  sessionsCompleted: 3,
  volumeKg: 1000,
  setsDone: 30,
  loggedDays: logged,
  avgKcal: avgKcal,
  targetKcal: target,
  checkIns: 0,
  discomfortDays: 0,
);

void main() {
  test('expected rate dari goal (sanity)', () {
    expect(goal.evaluation.expectedWeeklyGainKg, const NumRange(min: 0.18, max: 0.35));
  });

  group('tanggal & rata-rata', () {
    test('awal minggu = Senin; tambah hari lintas bulan', () {
      expect(ProgressMath.weekStartOf('2026-11-19'), '2026-11-16');
      expect(ProgressMath.weekStartOf('2026-11-16'), '2026-11-16');
      expect(ProgressMath.weekStartOf('2026-11-22'), '2026-11-16'); // Minggu
      expect(ProgressMath.addDays('2026-11-30', 1), '2026-12-01');
      expect(ProgressMath.inWeek('2026-11-22', '2026-11-16'), isTrue);
      expect(ProgressMath.inWeek('2026-11-23', '2026-11-16'), isFalse);
    });

    test('rata-rata mingguan butuh ≥ 2 penimbangan', () {
      final w = ProgressMath.weeklyWeights(const [
        WeightEntry(date: '2026-11-02', kg: 70),
        WeightEntry(date: '2026-11-04', kg: 71),
        WeightEntry(date: '2026-11-10', kg: 72),
      ]);
      expect(w.single.weekStart, '2026-11-02');
      expect(w.single.avgKg, 70.5);
    });

    test('rata-rata bergerak 7 hari kalender', () {
      final ma = ProgressMath.movingAverage(const [
        WeightEntry(date: '2026-11-01', kg: 70),
        WeightEntry(date: '2026-11-05', kg: 72),
        WeightEntry(date: '2026-11-09', kg: 74), // 01 di luar jendela 03–09
      ]);
      expect(ma.map((e) => e.kg), [70, 71, 73]);
    });
  });

  group('status target', () {
    GoalProgress p(List<WeightEntry> w) => ProgressMath.goalProgress(goal, w, today: today);

    test('data kurang: < 2 minggu berurutan, minggu berjalan tidak dihitung', () {
      expect(p(const []).status, GoalProgressStatus.insufficientData);
      expect(p(weeksOf([70])).status, GoalProgressStatus.insufficientData);
      // Minggu berjalan (16 Nov) punya data tapi belum lengkap → diabaikan.
      final w = [
        ...weeksOf([70]),
        const WeightEntry(date: '2026-11-16', kg: 75),
        const WeightEntry(date: '2026-11-17', kg: 75),
      ];
      expect(p(w).status, GoalProgressStatus.insufficientData);
    });

    test('on track: +0,25 kg/minggu', () {
      final r = p(weeksOf([70, 70.25, 70.5]));
      expect(r.status, GoalProgressStatus.onTrack);
      expect(r.lastChangeKg, closeTo(0.25, 1e-9));
      expect(r.latestAverageKg, closeTo(70.5, 1e-9));
    });

    test('satu minggu menyimpang → perlu evaluasi (belum ubah target)', () {
      final r = p(weeksOf([70, 70.25, 70.25]));
      expect(r.status, GoalProgressStatus.needsReview);
      expect(r.direction, RateDirection.below);
    });

    test('dua minggu menyimpang searah → target perlu disesuaikan', () {
      expect(p(weeksOf([70, 70, 70])).status, GoalProgressStatus.adjustTarget);
      final fast = p(weeksOf([70, 70.8, 71.6]));
      expect(fast.status, GoalProgressStatus.adjustTarget);
      expect(fast.direction, RateDirection.above);
      // Berlawanan arah → hanya evaluasi.
      expect(p(weeksOf([70, 70.8, 70.8])).status, GoalProgressStatus.needsReview);
    });

    test('minggu tanpa data memutus rangkaian', () {
      final w = [
        ...weeksOf([70, 70, 70]).take(3), // minggu 26 Okt saja
        ...weeksOf([70]), // minggu 9 Nov
      ];
      expect(p(w).status, GoalProgressStatus.insufficientData);
    });

    test('recomposition: stabil ±0,3 % BB = on track', () {
      final recomp = GoalPlanner.buildProposal(
        sample.copyWith(
          goal: const GoalSection(primary: PrimaryGoal.recomposition, targetWeeks: 12),
        ),
        now,
      );
      final r = ProgressMath.goalProgress(recomp, weeksOf([70, 70.1, 70]), today: today);
      expect(r.status, GoalProgressStatus.onTrack);
      expect(r.expectedKgPerWeek.max, closeTo(0.21, 1e-9));
    });
  });

  group('usulan penyesuaian', () {
    final target = goal.nutrition;
    GoalProgress progress(List<double> avgs) =>
        ProgressMath.goalProgress(goal, weeksOf(avgs), today: today);

    test('naik terlalu lambat + makan konsisten → +100 kcal lewat karbohidrat', () {
      final r = ProgressMath.proposeAdjustment(
        goal: goal,
        progress: progress([70, 70, 70]),
        target: target,
        lastTwoWeeks: [
          week(target: target.targetKcal.toDouble(), avgKcal: target.targetKcal.toDouble()),
          week(target: target.targetKcal.toDouble(), avgKcal: target.targetKcal.toDouble()),
        ],
      );
      final a = r.adjustment!;
      expect(a.deltaCarbsG, 25);
      expect(a.newCarbsG, target.carbsG + 25);
      expect(a.newKcal, target.proteinG * 4 + (target.carbsG + 25) * 4 + target.fatG * 9);
      expect(a.direction, RateDirection.below);
    });

    test('naik terlalu cepat → −100 kcal', () {
      final r = ProgressMath.proposeAdjustment(
        goal: goal,
        progress: progress([70, 70.8, 71.6]),
        target: target,
        lastTwoWeeks: [
          week(target: target.targetKcal.toDouble(), avgKcal: target.targetKcal.toDouble()),
          week(target: target.targetKcal.toDouble(), avgKcal: target.targetKcal.toDouble()),
        ],
      );
      expect(r.adjustment!.deltaCarbsG, -25);
      expect(r.adjustment!.newKcal, lessThan(target.targetKcal));
    });

    test('makan belum tercatat konsisten → tidak ada usulan, minta perbaiki pencatatan', () {
      final t = target.targetKcal.toDouble();
      for (final weeks in [
        [week(logged: 2, target: t, avgKcal: t), week(target: t, avgKcal: t)],
        [week(target: t, avgKcal: t * 0.7), week(target: t, avgKcal: t)],
        [week(target: t, avgKcal: t)],
      ]) {
        final r = ProgressMath.proposeAdjustment(
          goal: goal,
          progress: progress([70, 70, 70]),
          target: target,
          lastTwoWeeks: weeks,
        );
        expect(r.adjustment, isNull);
        expect(r.block, AdjustmentBlock.intakeNotConsistent);
      }
    });

    test('on track / riwayat gangguan makan → tanpa usulan', () {
      final t = target.targetKcal.toDouble();
      final weeks = [week(target: t, avgKcal: t), week(target: t, avgKcal: t)];
      expect(
        ProgressMath.proposeAdjustment(
          goal: goal,
          progress: progress([70, 70.25, 70.5]),
          target: target,
          lastTwoWeeks: weeks,
        ).block,
        AdjustmentBlock.notNeeded,
      );
      final edGoal = goal.copyWith(
        safety: goal.safety.copyWith(warnings: [SafetyWarning.eatingDisorderHistory]),
      );
      expect(
        ProgressMath.proposeAdjustment(
          goal: edGoal,
          progress: progress([70, 70, 70]),
          target: target,
          lastTwoWeeks: weeks,
        ).block,
        AdjustmentBlock.safety,
      );
    });

    test('tidak menurunkan target di bawah perkiraan TDEE untuk muscle gain', () {
      final atTdee = target.copyWith(targetKcal: target.tdeeKcal.min.round() + 50);
      final r = ProgressMath.proposeAdjustment(
        goal: goal,
        progress: progress([70, 70.8, 71.6]),
        target: atTdee,
        lastTwoWeeks: [
          week(target: atTdee.targetKcal.toDouble(), avgKcal: atTdee.targetKcal.toDouble()),
          week(target: atTdee.targetKcal.toDouble(), avgKcal: atTdee.targetKcal.toDouble()),
        ],
      );
      expect(r.adjustment, isNull);
    });
  });

  group('ringkasan minggu & latihan', () {
    final training = [
      const TrainingDay(
        sessionId: 'a',
        date: '2026-11-03',
        sets: [SetEntry(exerciseId: 'squat', weightKg: 40, reps: 10)],
      ),
      const TrainingDay(
        sessionId: 'b',
        date: '2026-11-10',
        discomfort: true,
        sets: [
          SetEntry(exerciseId: 'squat', weightKg: 45, reps: 8),
          SetEntry(exerciseId: 'squat', weightKg: 45, reps: 10),
          SetEntry(exerciseId: 'plank', reps: 30, timed: true),
        ],
      ),
      const TrainingDay(
        sessionId: 'c',
        date: '2026-11-12',
        sets: [SetEntry(exerciseId: 'squat', weightKg: 42.5, reps: 12)],
      ),
    ];

    test('agregat minggu: berat, sesi, volume, makan, check-in, nyeri', () {
      final s = ProgressMath.weekSummary(
        weekStart: '2026-11-09',
        weights: weeksOf([70, 70.3]),
        training: training,
        intake: const [
          DayIntake(date: '2026-11-09', kcal: 2400, protein: 120),
          DayIntake(date: '2026-11-10', kcal: 2600, protein: 140),
          DayIntake(date: '2026-11-17', kcal: 3000, protein: 100),
        ],
        checkIns: const [
          DailyCheckIn(date: '2026-11-10', sleepHours: 7, energy: 4),
          DailyCheckIn(date: '2026-11-11', sleepHours: 6, energy: 2, discomfort: 'lutut'),
        ],
        plannedSessionsPerWeek: 3,
        targetKcal: 2500,
        targetProtein: 130,
      );
      expect(s.weighIns, 3);
      expect(s.avgWeightKg, closeTo(70.3, 1e-9));
      expect(s.weightChangeKg, closeTo(0.3, 1e-9));
      expect(s.sessionsCompleted, 2);
      expect(s.trainingAdherence, closeTo(2 / 3, 1e-9));
      expect(s.volumeKg, 45 * 8 + 45 * 10 + 42.5 * 12); // set waktu tidak dihitung
      expect(s.prevVolumeKg, 400);
      expect(s.setsDone, 4);
      expect(s.loggedDays, 2);
      expect(s.avgKcal, 2500);
      expect(s.intakeRatio, 1);
      expect(s.avgSleepHours, 6.5);
      expect(s.avgEnergy, 3);
      expect(s.discomfortDays, 2); // check-in 11 Nov + sesi 10 Nov
      final back = WeekSummary.fromJson(jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>);
      expect(back.volumeKg, s.volumeKg);
      expect(back.discomfortDays, 2);
    });

    test('volume mingguan, progres gerakan, minggu berturut-turut', () {
      final v = ProgressMath.weeklyVolume(training, today: today, weeks: 3);
      expect(v.map((w) => w.weekStart), ['2026-11-02', '2026-11-09', '2026-11-16']);
      expect(v.map((w) => w.sessions), [1, 2, 0]);
      final e = ProgressMath.exerciseProgress(training, 'squat');
      expect(e.map((x) => (x.weightKg, x.reps)), [(40, 10), (45, 10), (42.5, 12)]);
      expect(ProgressMath.exerciseProgress(training, 'plank'), isEmpty);
      // Minggu berjalan belum ada sesi → hitung dari minggu lalu.
      expect(ProgressMath.trainingStreakWeeks(training, today: today), 2);
    });
  });

  group('WeeklyReviewPromptV1', () {
    const valid = {
      'schemaVersion': 1,
      'summary': 'Minggu yang cukup konsisten.',
      'wentWell': ['3 sesi selesai'],
      'obstacles': ['Tidur kurang'],
      'suggestions': ['Tidur lebih awal 30 menit'],
    };

    test('valid', () {
      final r = WeeklyReviewPromptV1.parse(jsonEncode(valid));
      expect(r.problems, isEmpty);
      expect(r.summary!.suggestions.single, 'Tidur lebih awal 30 menit');
    });

    test('menolak angka kalori/gram, istilah medis, butir berlebih, kosong', () {
      List<String> probs(Map<String, Object?> j) =>
          WeeklyReviewPromptV1.parse(jsonEncode({...valid, ...j})).problems;
      expect(
        probs({
          'suggestions': ['Tambah 200 kcal per hari'],
        }),
        contains(startsWith('angka_target')),
      );
      expect(
        probs({
          'suggestions': ['Makan 30 g protein lagi'],
        }),
        contains(startsWith('angka_target')),
      );
      expect(probs({'summary': 'Ini diagnosis cedera lutut.'}), contains(startsWith('medis')));
      expect(
        probs({
          'wentWell': ['a', 'b', 'c', 'd'],
        }),
        contains(contains('maks. 3')),
      );
      expect(probs({'suggestions': <String>[]}), contains(contains('minimal 1')));
      expect(WeeklyReviewPromptV1.parse('x').problems.single, startsWith('invalid_json'));
    });

    test('isi prompt: agregat saja, tanpa berat absolut', () {
      final review = StoredWeeklyReview(
        weekStart: '2026-11-09',
        goalStatus: GoalProgressStatus.onTrack,
        stats: week().copyWithWeight(avg: 72.4, prev: 72.1),
      );
      final content = WeeklyReviewPromptV1.userContent(
        review,
        goal: PrimaryGoal.muscleGain,
        level: 'beginner',
        expectedKgPerWeek: const NumRange(min: 0.18, max: 0.35),
      );
      expect(content, isNot(contains('72.4')));
      expect(content, contains('"perubahanRataRataKgDariMingguLalu":0.3'));
      expect(content, isNot(contains('catatan')));
    });
  });
}

extension on WeekSummary {
  WeekSummary copyWithWeight({required double avg, required double prev}) => WeekSummary(
    weekStart: weekStart,
    weighIns: weighIns,
    avgWeightKg: avg,
    prevAvgWeightKg: prev,
    sessionsCompleted: sessionsCompleted,
    volumeKg: volumeKg,
    setsDone: setsDone,
    loggedDays: loggedDays,
    avgKcal: avgKcal,
    targetKcal: targetKcal,
    checkIns: checkIns,
    discomfortDays: discomfortDays,
  );
}
