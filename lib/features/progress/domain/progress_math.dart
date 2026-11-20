import 'dart:math' as math;

import '../../../core/utils/formatters.dart';
import '../../assessment/domain/entities/assessment_data.dart';
import '../../goals/domain/entities/goal.dart';
import 'progress_models.dart';

/// Ambang evaluasi progres (dapat diubah tanpa menyentuh UI).
abstract final class ProgressConfig {
  static const version = 'progress-2026-11-v1';

  /// Minimal penimbangan per minggu agar rata-rata minggu itu dipakai.
  static const minWeighInsPerWeek = 2;

  /// Toleransi di luar rentang laju yang diharapkan (kg/minggu) — fluktuasi
  /// air/isi pencernaan membuat selisih kecil tidak bermakna.
  static const rateToleranceKg = 0.1;

  /// Recomposition: perubahan mingguan dianggap stabil bila ≤ 0,3 % BB.
  static const recompositionStablePct = 0.3;

  /// Penyesuaian target yang diusulkan (kecil): ±100 kcal lewat karbohidrat.
  static const adjustKcal = 100;
  static const adjustCarbsG = 25;

  /// Syarat kepatuhan asupan sebelum mengusulkan perubahan target:
  /// makan tercatat ≥ 4 hari/minggu dan rata-rata dalam ±15 % target.
  static const minLoggedDays = 4;
  static const intakeTolerance = 0.15;

  /// Rata-rata bergerak berat badan (hari).
  static const movingAverageDays = 7;
}

/// Status target (brief §6).
enum GoalProgressStatus { insufficientData, onTrack, needsReview, adjustTarget }

/// Arah penyimpangan laju berat terhadap rentang yang diharapkan.
enum RateDirection { below, within, above }

class GoalProgress {
  const GoalProgress({
    required this.status,
    required this.expectedKgPerWeek,
    this.weeklyChangesKg = const [],
    this.direction = RateDirection.within,
    this.latestAverageKg,
  });

  final GoalProgressStatus status;
  final NumRange expectedKgPerWeek;

  /// Selisih rata-rata berat antar minggu berurutan, terlama → terbaru.
  final List<double> weeklyChangesKg;
  final RateDirection direction;
  final double? latestAverageKg;

  double? get lastChangeKg => weeklyChangesKg.isEmpty ? null : weeklyChangesKg.last;
}

/// Ringkasan satu minggu (Senin–Minggu) dari data aktual.
class WeekSummary {
  const WeekSummary({
    required this.weekStart,
    required this.weighIns,
    this.avgWeightKg,
    this.prevAvgWeightKg,
    required this.sessionsCompleted,
    this.sessionsPlanned,
    required this.volumeKg,
    this.prevVolumeKg,
    required this.setsDone,
    required this.loggedDays,
    this.avgKcal,
    this.avgProtein,
    this.targetKcal,
    this.targetProtein,
    required this.checkIns,
    this.avgSleepHours,
    this.avgEnergy,
    required this.discomfortDays,
  });

  final String weekStart;
  final int weighIns;
  final double? avgWeightKg;
  final double? prevAvgWeightKg;
  final int sessionsCompleted;
  final int? sessionsPlanned;
  final double volumeKg;
  final double? prevVolumeKg;
  final int setsDone;
  final int loggedDays;
  final double? avgKcal;
  final double? avgProtein;
  final double? targetKcal;
  final double? targetProtein;
  final int checkIns;
  final double? avgSleepHours;
  final double? avgEnergy;
  final int discomfortDays;

  double? get weightChangeKg =>
      avgWeightKg != null && prevAvgWeightKg != null ? avgWeightKg! - prevAvgWeightKg! : null;

  /// Kepatuhan latihan (0–1), `null` bila tidak ada rencana.
  double? get trainingAdherence => sessionsPlanned == null || sessionsPlanned == 0
      ? null
      : math.min(1, sessionsCompleted / sessionsPlanned!);

  /// Rata-rata asupan dibanding target (mis. 0,95), `null` bila tidak ada data.
  double? get intakeRatio =>
      avgKcal == null || targetKcal == null || targetKcal == 0 ? null : avgKcal! / targetKcal!;

  bool get hasAnyData => weighIns > 0 || sessionsCompleted > 0 || loggedDays > 0 || checkIns > 0;

  Map<String, Object?> toJson() => {
    'weekStart': weekStart,
    'weighIns': weighIns,
    'avgWeightKg': avgWeightKg,
    'prevAvgWeightKg': prevAvgWeightKg,
    'sessionsCompleted': sessionsCompleted,
    'sessionsPlanned': sessionsPlanned,
    'volumeKg': volumeKg,
    'prevVolumeKg': prevVolumeKg,
    'setsDone': setsDone,
    'loggedDays': loggedDays,
    'avgKcal': avgKcal,
    'avgProtein': avgProtein,
    'targetKcal': targetKcal,
    'targetProtein': targetProtein,
    'checkIns': checkIns,
    'avgSleepHours': avgSleepHours,
    'avgEnergy': avgEnergy,
    'discomfortDays': discomfortDays,
  };

  factory WeekSummary.fromJson(Map<String, dynamic> j) {
    double? d(String k) => (j[k] as num?)?.toDouble();
    return WeekSummary(
      weekStart: j['weekStart'] as String,
      weighIns: j['weighIns'] as int,
      avgWeightKg: d('avgWeightKg'),
      prevAvgWeightKg: d('prevAvgWeightKg'),
      sessionsCompleted: j['sessionsCompleted'] as int,
      sessionsPlanned: j['sessionsPlanned'] as int?,
      volumeKg: d('volumeKg') ?? 0,
      prevVolumeKg: d('prevVolumeKg'),
      setsDone: j['setsDone'] as int,
      loggedDays: j['loggedDays'] as int,
      avgKcal: d('avgKcal'),
      avgProtein: d('avgProtein'),
      targetKcal: d('targetKcal'),
      targetProtein: d('targetProtein'),
      checkIns: j['checkIns'] as int,
      avgSleepHours: d('avgSleepHours'),
      avgEnergy: d('avgEnergy'),
      discomfortDays: j['discomfortDays'] as int,
    );
  }
}

/// Alasan tidak ada usulan penyesuaian target.
enum AdjustmentBlock {
  /// Target masih sesuai / data belum cukup.
  notNeeded,

  /// Makan tercatat terlalu sedikit atau jauh dari target — perbaiki kepatuhan dulu.
  intakeNotConsistent,

  /// Riwayat gangguan makan: penyesuaian kalori didiskusikan dengan tenaga kesehatan.
  safety,
}

/// Usulan perubahan kecil target energi (harus disetujui pengguna).
class NutritionAdjustment {
  const NutritionAdjustment({
    required this.deltaKcal,
    required this.deltaCarbsG,
    required this.direction,
    required this.newKcal,
    required this.newCarbsG,
  });

  final int deltaKcal;
  final int deltaCarbsG;
  final RateDirection direction;
  final int newKcal;
  final int newCarbsG;

  Map<String, Object?> toJson() => {
    'deltaKcal': deltaKcal,
    'deltaCarbsG': deltaCarbsG,
    'direction': direction.name,
    'newKcal': newKcal,
    'newCarbsG': newCarbsG,
  };

  factory NutritionAdjustment.fromJson(Map<String, dynamic> j) => NutritionAdjustment(
    deltaKcal: j['deltaKcal'] as int,
    deltaCarbsG: j['deltaCarbsG'] as int,
    direction: RateDirection.values.byName(j['direction'] as String),
    newKcal: j['newKcal'] as int,
    newCarbsG: j['newCarbsG'] as int,
  );
}

abstract final class ProgressMath {
  static DateTime _d(String iso) => DateTime.parse(iso);

  /// Senin dari minggu tanggal [iso] (`YYYY-MM-DD`).
  static String weekStartOf(String iso) {
    final d = _d(iso);
    return Fmt.toIsoDate(DateTime(d.year, d.month, d.day - (d.weekday - 1)));
  }

  static String addDays(String iso, int days) {
    final d = _d(iso);
    return Fmt.toIsoDate(DateTime(d.year, d.month, d.day + days));
  }

  static bool inWeek(String date, String weekStart) =>
      date.compareTo(weekStart) >= 0 && date.compareTo(addDays(weekStart, 7)) < 0;

  static double? _avg(Iterable<num> v) =>
      v.isEmpty ? null : v.fold<double>(0, (s, x) => s + x) / v.length;

  /// Rata-rata berat per minggu yang punya cukup penimbangan, urut waktu.
  static List<({String weekStart, double avgKg, int count})> weeklyWeights(
    List<WeightEntry> weights,
  ) {
    final byWeek = <String, List<double>>{};
    for (final w in weights) {
      byWeek.putIfAbsent(weekStartOf(w.date), () => []).add(w.kg);
    }
    final keys = byWeek.keys.toList()..sort();
    return [
      for (final k in keys)
        if (byWeek[k]!.length >= ProgressConfig.minWeighInsPerWeek)
          (weekStart: k, avgKg: _avg(byWeek[k]!)!, count: byWeek[k]!.length),
    ];
  }

  /// Rata-rata bergerak (jendela [ProgressConfig.movingAverageDays] hari
  /// kalender) untuk setiap penimbangan.
  static List<({String date, double kg})> movingAverage(List<WeightEntry> weights) {
    final sorted = [...weights]..sort((a, b) => a.date.compareTo(b.date));
    return [
      for (final w in sorted)
        (
          date: w.date,
          kg: _avg([
            for (final x in sorted)
              if (x.date.compareTo(w.date) <= 0 &&
                  x.date.compareTo(addDays(w.date, -(ProgressConfig.movingAverageDays - 1))) >= 0)
                x.kg,
          ])!,
        ),
    ];
  }

  /// Rentang laju (kg/minggu) yang diharapkan dari goal.
  static NumRange expectedRate(Goal goal) {
    if (goal.primaryGoal == PrimaryGoal.recomposition) {
      final tol = goal.startWeightKg * ProgressConfig.recompositionStablePct / 100;
      return NumRange(min: -tol, max: tol);
    }
    return goal.evaluation.expectedWeeklyGainKg;
  }

  /// Status target dari tren rata-rata mingguan (bukan satu penimbangan).
  /// Minggu berjalan tidak dihitung karena belum lengkap.
  static GoalProgress goalProgress(Goal goal, List<WeightEntry> weights, {required String today}) {
    final expected = expectedRate(goal);
    final currentWeek = weekStartOf(today);
    final weeks = [
      for (final w in weeklyWeights(weights))
        if (w.weekStart.compareTo(currentWeek) < 0) w,
    ];
    final changes = <double>[];
    for (var i = 1; i < weeks.length; i++) {
      // Hanya minggu yang berurutan; minggu tanpa data memutus rangkaian.
      if (weeks[i].weekStart != addDays(weeks[i - 1].weekStart, 7)) {
        changes.clear();
        continue;
      }
      changes.add(weeks[i].avgKg - weeks[i - 1].avgKg);
    }
    final recent = changes.length > 3 ? changes.sublist(changes.length - 3) : changes;
    final latestAvg = weeks.isEmpty ? null : weeks.last.avgKg;
    if (recent.isEmpty) {
      return GoalProgress(
        status: GoalProgressStatus.insufficientData,
        expectedKgPerWeek: expected,
        latestAverageKg: latestAvg,
      );
    }
    RateDirection dir(double c) => c < expected.min - ProgressConfig.rateToleranceKg
        ? RateDirection.below
        : c > expected.max + ProgressConfig.rateToleranceKg
        ? RateDirection.above
        : RateDirection.within;
    final last = dir(recent.last);
    final status = last == RateDirection.within
        ? GoalProgressStatus.onTrack
        : recent.length >= 2 && dir(recent[recent.length - 2]) == last
        ? GoalProgressStatus.adjustTarget
        : GoalProgressStatus.needsReview;
    return GoalProgress(
      status: status,
      expectedKgPerWeek: expected,
      weeklyChangesKg: recent,
      direction: last,
      latestAverageKg: latestAvg,
    );
  }

  /// Ringkasan minggu [weekStart] dari data aktual.
  static WeekSummary weekSummary({
    required String weekStart,
    required List<WeightEntry> weights,
    required List<TrainingDay> training,
    required List<DayIntake> intake,
    required List<DailyCheckIn> checkIns,
    int? plannedSessionsPerWeek,
    double? targetKcal,
    double? targetProtein,
  }) {
    final prevWeek = addDays(weekStart, -7);
    bool inW(String d) => inWeek(d, weekStart);
    bool inP(String d) => inWeek(d, prevWeek);
    final w = [
      for (final x in weights)
        if (inW(x.date)) x.kg,
    ];
    final pw = [
      for (final x in weights)
        if (inP(x.date)) x.kg,
    ];
    final t = [
      for (final x in training)
        if (inW(x.date)) x,
    ];
    final pt = [
      for (final x in training)
        if (inP(x.date)) x,
    ];
    final food = [
      for (final x in intake)
        if (inW(x.date) && x.kcal > 0) x,
    ];
    final ci = [
      for (final x in checkIns)
        if (inW(x.date)) x,
    ];
    final discomfortDates = {
      for (final x in ci)
        if (x.hasDiscomfort) x.date,
      for (final x in t)
        if (x.discomfort) x.date,
    };
    return WeekSummary(
      weekStart: weekStart,
      weighIns: w.length,
      avgWeightKg: w.length >= ProgressConfig.minWeighInsPerWeek ? _avg(w) : null,
      prevAvgWeightKg: pw.length >= ProgressConfig.minWeighInsPerWeek ? _avg(pw) : null,
      sessionsCompleted: t.length,
      sessionsPlanned: plannedSessionsPerWeek,
      volumeKg: t.fold(0, (s, x) => s + x.volumeKg),
      prevVolumeKg: pt.isEmpty ? null : pt.fold<double>(0, (s, x) => s + x.volumeKg),
      setsDone: t.fold(0, (s, x) => s + x.sets.length),
      loggedDays: food.length,
      avgKcal: _avg([for (final f in food) f.kcal]),
      avgProtein: _avg([for (final f in food) f.protein]),
      targetKcal: targetKcal,
      targetProtein: targetProtein,
      checkIns: ci.length,
      avgSleepHours: _avg([for (final x in ci) ?x.sleepHours]),
      avgEnergy: _avg([for (final x in ci) ?x.energy]),
      discomfortDays: discomfortDates.length,
    );
  }

  /// Usulan penyesuaian kecil target energi, atau alasan tidak ada usulan.
  /// Hanya bila laju berat menyimpang 2 minggu berturut-turut (status
  /// [GoalProgressStatus.adjustTarget]) DAN asupan tercatat konsisten di
  /// dekat target pada 2 minggu terakhir — bila asupan belum konsisten,
  /// target belum bisa dinilai.
  static ({NutritionAdjustment? adjustment, AdjustmentBlock? block}) proposeAdjustment({
    required Goal goal,
    required GoalProgress progress,
    required NutritionPlan target,
    required List<WeekSummary> lastTwoWeeks,
  }) {
    if (progress.status != GoalProgressStatus.adjustTarget) {
      return (adjustment: null, block: AdjustmentBlock.notNeeded);
    }
    if (goal.safety.warnings.contains(SafetyWarning.eatingDisorderHistory)) {
      return (adjustment: null, block: AdjustmentBlock.safety);
    }
    final consistent =
        lastTwoWeeks.length == 2 &&
        lastTwoWeeks.every(
          (w) =>
              w.loggedDays >= ProgressConfig.minLoggedDays &&
              w.intakeRatio != null &&
              (w.intakeRatio! - 1).abs() <= ProgressConfig.intakeTolerance,
        );
    if (!consistent) return (adjustment: null, block: AdjustmentBlock.intakeNotConsistent);

    final up = progress.direction == RateDirection.below;
    var deltaKcal = up ? ProgressConfig.adjustKcal : -ProgressConfig.adjustKcal;
    var deltaCarbs = up ? ProgressConfig.adjustCarbsG : -ProgressConfig.adjustCarbsG;
    // Tujuan menambah otot/kekuatan: jangan turun di bawah perkiraan TDEE
    // (menghindari defisit tanpa disadari). Karbohidrat tidak di bawah 0.
    if (!up && goal.primaryGoal != PrimaryGoal.recomposition) {
      final floor = target.tdeeKcal.min;
      if (target.targetKcal + deltaKcal < floor) {
        return (adjustment: null, block: AdjustmentBlock.notNeeded);
      }
    }
    if (target.carbsG + deltaCarbs < 0) {
      deltaCarbs = -target.carbsG;
      deltaKcal = deltaCarbs * 4;
    }
    final newCarbs = target.carbsG + deltaCarbs;
    final newKcal = target.proteinG * 4 + newCarbs * 4 + target.fatG * 9;
    return (
      adjustment: NutritionAdjustment(
        deltaKcal: newKcal - target.targetKcal,
        deltaCarbsG: deltaCarbs,
        direction: progress.direction,
        newKcal: newKcal,
        newCarbsG: newCarbs,
      ),
      block: null,
    );
  }

  /// Volume (kg × repetisi) per minggu untuk [weeks] minggu terakhir.
  static List<({String weekStart, double volumeKg, int sessions})> weeklyVolume(
    List<TrainingDay> training, {
    required String today,
    int weeks = 8,
  }) {
    final current = weekStartOf(today);
    return [
      for (var i = weeks - 1; i >= 0; i--)
        () {
          final ws = addDays(current, -7 * i);
          final t = [
            for (final x in training)
              if (inWeek(x.date, ws)) x,
          ];
          return (
            weekStart: ws,
            volumeKg: t.fold<double>(0, (s, x) => s + x.volumeKg),
            sessions: t.length,
          );
        }(),
    ];
  }

  /// Set terberat per sesi untuk satu gerakan (beban tertinggi, lalu repetisi).
  static List<({String date, double weightKg, int reps})> exerciseProgress(
    List<TrainingDay> training,
    String exerciseId,
  ) {
    final sorted = [...training]..sort((a, b) => a.date.compareTo(b.date));
    final out = <({String date, double weightKg, int reps})>[];
    for (final day in sorted) {
      SetEntry? best;
      for (final s in day.sets) {
        if (s.exerciseId != exerciseId || s.weightKg == null || s.timed) continue;
        if (best == null ||
            s.weightKg! > best.weightKg! ||
            (s.weightKg == best.weightKg && s.reps > best.reps)) {
          best = s;
        }
      }
      if (best != null) out.add((date: day.date, weightKg: best.weightKg!, reps: best.reps));
    }
    return out;
  }

  /// Minggu berturut-turut (sampai minggu lalu/berjalan) dengan ≥ 1 sesi.
  static int trainingStreakWeeks(List<TrainingDay> training, {required String today}) {
    final weeks = {for (final t in training) weekStartOf(t.date)};
    var ws = weekStartOf(today);
    if (!weeks.contains(ws)) ws = addDays(ws, -7);
    var n = 0;
    while (weeks.contains(ws)) {
      n++;
      ws = addDays(ws, -7);
    }
    return n;
  }
}
