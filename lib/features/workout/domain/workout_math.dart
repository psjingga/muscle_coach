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

  /// Status latihan hari ini untuk Beranda. [sessions] = sesi pada tanggal
  /// hari ini (terbaru dulu). `null` bila program tidak punya hari latihan.
  static TodayWorkout? todayWorkout({
    required List<PlanDay> days,
    required int weekday,
    required List<WorkoutSession> sessions,
  }) {
    if (days.isEmpty) return null;
    PlanDay? dayOf(String id) => days.where((d) => d.id == id).firstOrNull;
    // Sesi berjalan (juga sesi hari lain yang dimulai lebih awal).
    for (final s in sessions.where((s) => s.status == SessionStatus.inProgress)) {
      if (dayOf(s.dayId) case final day?) return TodayTraining(day, inProgress: s);
    }
    final next = nextDay(days, weekday % 7 + 1)!;
    final done = sessions.where((s) => s.status == SessionStatus.completed).firstOrNull;
    if (done != null) return TodayDone(done, next: next);
    final today = days.where((d) => d.weekday == weekday).firstOrNull;
    return today != null ? TodayTraining(today) : TodayRest(next);
  }

  /// Durasi sesi selesai (menit), `null` bila waktu tidak lengkap/tidak wajar.
  static int? durationMinutes(WorkoutSession s) {
    final start = s.startedAt;
    final end = s.completedAt;
    if (start == null || end == null || !end.isAfter(start)) return null;
    final minutes = end.difference(start).inMinutes;
    return minutes > 0 && minutes <= 24 * 60 ? minutes : null;
  }
}

/// Status kartu latihan di Beranda.
sealed class TodayWorkout {
  const TodayWorkout();
}

/// Hari latihan (belum selesai); [inProgress] = sesi yang bisa dilanjutkan.
final class TodayTraining extends TodayWorkout {
  const TodayTraining(this.day, {this.inProgress});

  final PlanDay day;
  final WorkoutSession? inProgress;
}

/// Latihan hari ini sudah selesai.
final class TodayDone extends TodayWorkout {
  const TodayDone(this.session, {required this.next});

  final WorkoutSession session;
  final PlanDay next;
}

/// Tidak ada sesi terjadwal hari ini.
final class TodayRest extends TodayWorkout {
  const TodayRest(this.next);

  final PlanDay next;
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
