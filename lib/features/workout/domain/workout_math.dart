import 'entities/workout.dart';

/// Perhitungan latihan murni (tanpa Flutter/Firebase).
abstract final class WorkoutMath {
  /// Batas input set (sama dengan Security Rules).
  static const maxWeightKg = 1000.0;
  static const maxReps = 300;
  static const maxSetsPerExercise = 10;

  /// Volume = Σ beban × repetisi untuk set selesai yang berbeban (kg).
  /// Untuk dumbbell per tangan, beban dihitung dua kali (dua dumbbell).
  static double volumeKg(Iterable<SetLog> sets, List<PlannedExercise> planned) {
    var total = 0.0;
    for (final s in sets) {
      if (s.status != SetStatus.done || s.weightKg == null) continue;
      final p = s.exerciseIndex < planned.length ? planned[s.exerciseIndex] : null;
      if (p?.isTimed ?? false) continue;
      final factor = p?.loadType == 'per_hand' ? 2 : 1;
      total += s.weightKg! * s.reps * factor;
    }
    return total;
  }

  static int doneSets(Iterable<SetLog> sets) =>
      sets.where((s) => s.status == SetStatus.done).length;

  static int plannedSets(List<PlannedExercise> planned) =>
      planned.fold(0, (sum, p) => sum + p.sets);

  /// Set milik latihan ke-[index], urut nomor set.
  static List<SetLog> setsFor(Iterable<SetLog> sets, int index) =>
      sets.where((s) => s.exerciseIndex == index).toList()
        ..sort((a, b) => a.setNumber.compareTo(b.setNumber));

  static int nextSetNumber(Iterable<SetLog> sets, int index) {
    final own = setsFor(sets, index);
    return own.isEmpty ? 1 : own.last.setNumber + 1;
  }

  /// Progresi ganda: naikkan beban bila SEMUA set target selesai di batas
  /// atas repetisi tanpa melewati RIR minimum (tidak sampai gagal).
  static bool shouldIncreaseLoad(PlannedExercise p, List<SetLog> previous) {
    final done = previous.where((s) => s.status == SetStatus.done).toList();
    if (done.length < p.sets) return false;
    return done.every((s) => s.reps >= p.repMax && (s.rir == null || s.rir! >= p.rirMin));
  }

  /// Validasi input satu set; `null` bila valid.
  static SetInputError? validateSet({required double? weightKg, required int? reps}) {
    if (reps == null) return SetInputError.repsRequired;
    if (reps < 1 || reps > maxReps) return SetInputError.repsOutOfRange;
    if (weightKg != null && (weightKg < 0 || weightKg > maxWeightKg)) {
      return SetInputError.weightOutOfRange;
    }
    return null;
  }

  /// Hari latihan berikutnya mulai hari ini (ISO weekday), termasuk hari ini.
  static PlanDay? nextDay(List<PlanDay> days, int todayWeekday) {
    if (days.isEmpty) return null;
    PlanDay? best;
    var bestDistance = 8;
    for (final d in days) {
      final distance = (d.weekday - todayWeekday + 7) % 7;
      if (distance < bestDistance) {
        best = d;
        bestDistance = distance;
      }
    }
    return best;
  }
}

enum SetInputError { repsRequired, repsOutOfRange, weightOutOfRange }

/// Timer istirahat berbasis waktu akhir (tahan terhadap jeda frame/app di background).
class RestTimer {
  const RestTimer({required this.endsAt, required this.totalSeconds});

  final DateTime endsAt;
  final int totalSeconds;

  factory RestTimer.start(DateTime now, int seconds) => RestTimer(
    endsAt: now.add(Duration(seconds: seconds)),
    totalSeconds: seconds,
  );

  int remainingSeconds(DateTime now) {
    final ms = endsAt.difference(now).inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  bool isDone(DateTime now) => remainingSeconds(now) == 0;

  /// Tambah/kurangi waktu (min. sisa 0).
  RestTimer adjust(DateTime now, int deltaSeconds) {
    final remaining = remainingSeconds(now) + deltaSeconds;
    final clamped = remaining < 0 ? 0 : remaining;
    return RestTimer(
      endsAt: now.add(Duration(seconds: clamped)),
      totalSeconds: totalSeconds + deltaSeconds < 1 ? 1 : totalSeconds + deltaSeconds,
    );
  }

  double progress(DateTime now) => totalSeconds == 0 ? 1 : 1 - remainingSeconds(now) / totalSeconds;
}
