import '../../exercise_library/domain/exercise.dart';
import 'entities/workout.dart';

/// Validator rencana latihan terhadap katalog, alat, level, dan batas angka.
/// Dipakai untuk program template dan (Fase 4) output Gemini sebelum disimpan.
abstract final class PlanValidator {
  static const setsRange = (min: 1, max: 6);
  static const repsRange = (min: 1, max: 30);
  static const secondsRange = (min: 5, max: 180);
  static const restRange = (min: 30, max: 300);
  static const rirRange = (min: 0, max: 5);
  static const exercisesPerDay = (min: 1, max: 10);

  static const _levelRank = {'beginner': 0, 'intermediate': 1, 'advanced': 2};

  static bool levelAllows(String userLevel, String exerciseLevel) =>
      (_levelRank[exerciseLevel] ?? 99) <= (_levelRank[userLevel] ?? -1);

  static bool hasEquipment(Set<String> equipment, Exercise ex) =>
      ex.equipment.every(equipment.contains);

  /// Hari kalender berurutan (termasuk Minggu → Senin).
  static bool consecutive(int a, int b) {
    final d = (a - b).abs();
    return d == 1 || d == 6;
  }

  static bool _in(num v, ({num min, num max}) r) => v >= r.min && v <= r.max;

  static PlanValidation validate(
    List<PlanDay> days, {
    required Map<String, Exercise> catalog,
    required Set<String> equipment,
    required String level,
  }) {
    final errors = <PlanIssue>[];
    final warnings = <String>{};
    if (days.isEmpty) errors.add(const PlanIssue('no_days'));

    final weekdays = <int>{};
    for (final day in days) {
      if (day.weekday < 1 || day.weekday > 7) {
        errors.add(PlanIssue('invalid_weekday', day: day.id));
      } else if (!weekdays.add(day.weekday)) {
        errors.add(PlanIssue('duplicate_weekday', day: day.id));
      }
      if (!_in(day.exercises.length, exercisesPerDay)) {
        errors.add(PlanIssue('exercise_count', day: day.id));
      }
      final seen = <String>{};
      for (final p in day.exercises) {
        PlanIssue issue(String code) => PlanIssue(code, day: day.id, exerciseId: p.exerciseId);
        final ex = catalog[p.exerciseId];
        if (ex == null) {
          errors.add(issue('unknown_exercise'));
          continue;
        }
        if (!seen.add(p.exerciseId)) errors.add(issue('duplicate_exercise'));
        if (!hasEquipment(equipment, ex)) errors.add(issue('equipment_missing'));
        if (!levelAllows(level, ex.level)) errors.add(issue('level_too_high'));
        if (ex.needsSpotter) warnings.add('spotter_or_safeties');
        if (!_in(p.sets, setsRange)) errors.add(issue('sets_out_of_range'));
        final range = p.repUnit == 'seconds' ? secondsRange : repsRange;
        if (p.repUnit != ex.repUnit ||
            !_in(p.repMin, range) ||
            !_in(p.repMax, range) ||
            p.repMin > p.repMax) {
          errors.add(issue('reps_out_of_range'));
        }
        if (!_in(p.restSec, restRange)) errors.add(issue('rest_out_of_range'));
        if (!_in(p.rirMin, rirRange) || !_in(p.rirMax, rirRange) || p.rirMin > p.rirMax) {
          errors.add(issue('rir_out_of_range'));
        }
      }
    }

    // Otot yang sama dilatih berat pada hari berurutan → peringatan.
    Set<String> heavy(PlanDay d) => {
      for (final p in d.exercises)
        if (catalog[p.exerciseId] case final ex? when ex.compound) ...ex.primaryMuscles,
    };
    for (var i = 0; i < days.length; i++) {
      for (var j = i + 1; j < days.length; j++) {
        if (!consecutive(days[i].weekday, days[j].weekday)) continue;
        if (heavy(days[i]).intersection(heavy(days[j])).isNotEmpty) {
          warnings.add('consecutive_muscle_overlap');
        }
      }
    }
    return PlanValidation(errors: errors, warnings: warnings.toList());
  }

  /// Perkiraan durasi sesi (menit): pemanasan + kerja + istirahat + transisi.
  static int estimateMinutes(int warmupMinutes, List<PlannedExercise> exercises) {
    var seconds = warmupMinutes * 60.0;
    for (final p in exercises) {
      final work = p.repUnit == 'seconds' ? (p.repMin + p.repMax) / 2 : 40;
      seconds += p.sets * work + (p.sets - 1) * p.restSec + 60;
    }
    return (seconds / 60).round();
  }
}

class PlanIssue {
  const PlanIssue(this.code, {this.day, this.exerciseId});

  final String code;
  final String? day;
  final String? exerciseId;

  @override
  String toString() => 'PlanIssue($code, $day, $exerciseId)';
}

class PlanValidation {
  const PlanValidation({required this.errors, required this.warnings});

  final List<PlanIssue> errors;
  final List<String> warnings;

  bool get isValid => errors.isEmpty;
}
