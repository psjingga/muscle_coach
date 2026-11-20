import 'dart:math' as math;

import '../../assessment/domain/entities/assessment_data.dart';
import '../../exercise_library/domain/exercise.dart';
import 'entities/workout.dart';
import 'plan_validator.dart';

/// Hasil planner: program + hari + peringatan.
class PlanDraft {
  const PlanDraft({
    required this.split,
    required this.level,
    required this.daysPerWeek,
    required this.sessionMinutes,
    required this.days,
    required this.warnings,
  });

  final String split;
  final String level;
  final int daysPerWeek;
  final int sessionMinutes;
  final List<PlanDay> days;
  final List<String> warnings;
}

/// Program awal berbasis aturan (tanpa AI): dipakai sebelum integrasi Gemini
/// dan sebagai fallback aman bila output AI tidak valid. Deterministik.
abstract final class TemplatePlanner {
  static const generatorVersion = 'template-2026-11-v1';

  /// Kandidat per slot, urut preferensi. Yang pertama memenuhi alat & level dipakai.
  static const _slots = <String, List<String>>{
    'squat': ['barbell_back_squat', 'goblet_squat', 'dumbbell_squat'],
    'squat_alt': ['barbell_front_squat', 'goblet_squat', 'dumbbell_squat'],
    'lunge': [
      'dumbbell_bulgarian_split_squat',
      'dumbbell_reverse_lunge',
      'dumbbell_step_up',
      'dumbbell_walking_lunge',
    ],
    'hinge': ['barbell_romanian_deadlift', 'dumbbell_romanian_deadlift', 'dumbbell_single_leg_rdl'],
    'hinge_heavy': ['barbell_deadlift', 'barbell_romanian_deadlift', 'dumbbell_romanian_deadlift'],
    'hip': ['barbell_hip_thrust', 'dumbbell_glute_bridge'],
    'h_push': ['barbell_bench_press', 'dumbbell_bench_press', 'dumbbell_floor_press', 'push_up'],
    'h_push_incline': [
      'dumbbell_incline_press',
      'dumbbell_bench_press',
      'dumbbell_floor_press',
      'push_up',
    ],
    'v_push': ['barbell_overhead_press', 'dumbbell_shoulder_press'],
    'v_push_db': ['dumbbell_shoulder_press', 'dumbbell_arnold_press'],
    'h_pull': ['barbell_bent_over_row', 'dumbbell_one_arm_row', 'dumbbell_bent_over_row'],
    'h_pull_db': ['dumbbell_chest_supported_row', 'dumbbell_one_arm_row', 'dumbbell_bent_over_row'],
    'v_pull': [
      'pull_up',
      'chin_up',
      'dumbbell_pullover',
      'dumbbell_one_arm_row',
      'dumbbell_bent_over_row',
    ],
    'lateral': ['dumbbell_lateral_raise'],
    'rear': ['dumbbell_rear_delt_fly'],
    'curl': ['dumbbell_biceps_curl', 'barbell_curl', 'dumbbell_hammer_curl'],
    'hammer': ['dumbbell_hammer_curl', 'dumbbell_biceps_curl', 'barbell_curl'],
    'triceps': [
      'dumbbell_overhead_triceps_extension',
      'dumbbell_skull_crusher',
      'barbell_close_grip_bench_press',
    ],
    'calf': ['dumbbell_standing_calf_raise'],
    'core': ['dead_bug', 'plank'],
    'core2': ['plank', 'dead_bug'],
  };

  static const _daySlots = <String, List<String>>{
    'full_body_a': ['squat', 'h_push', 'h_pull', 'hinge', 'lateral', 'curl', 'core'],
    'full_body_b': [
      'hinge_heavy',
      'v_push',
      'v_pull',
      'lunge',
      'h_push_incline',
      'triceps',
      'calf',
    ],
    'full_body_c': ['lunge', 'h_push_incline', 'h_pull_db', 'hip', 'v_push_db', 'hammer', 'core2'],
    'upper_a': ['h_push', 'h_pull', 'v_push', 'v_pull', 'lateral', 'curl', 'triceps'],
    'upper_b': ['v_push', 'h_pull_db', 'h_push_incline', 'v_pull', 'rear', 'triceps', 'hammer'],
    'lower_a': ['squat', 'hinge', 'lunge', 'calf', 'core', 'hip'],
    'lower_b': ['hinge_heavy', 'lunge', 'squat_alt', 'hip', 'calf', 'core2'],
  };

  static const _maxDays = {'beginner': 4, 'intermediate': 5, 'advanced': 6};

  /// Maksimal hari latihan per minggu untuk level ini (pemulihan).
  static int maxDaysFor(String level) => _maxDays[level] ?? 4;

  /// Pemanasan (menit) sesuai durasi sesi.
  static int warmupFor(int sessionMinutes) => sessionMinutes <= 30 ? 5 : 8;

  /// Kode otot katalog untuk otot prioritas assessment.
  static Set<String> priorityMusclesOf(AssessmentData a) => {
    for (final m in a.goal.priorityMuscles) ...?_priorityMuscles[m],
  };

  /// Peringatan berbasis assessment (cedera/gerakan dihindari).
  static bool needsInjuryReview(AssessmentData a) {
    final s = a.safety;
    return (s.injuries?.trim().isNotEmpty ?? false) ||
        (s.avoidedMovements?.trim().isNotEmpty ?? false) ||
        s.medicalFlags.contains(MedicalFlag.injuryRecovery);
  }

  static const _priorityMuscles = {
    MuscleGroup.chest: ['chest'],
    MuscleGroup.back: ['upper_back', 'lats'],
    MuscleGroup.shoulders: ['front_delts', 'side_delts', 'rear_delts'],
    MuscleGroup.arms: ['biceps', 'triceps'],
    MuscleGroup.legs: ['quads', 'hamstrings', 'calves'],
    MuscleGroup.glutes: ['glutes'],
    MuscleGroup.core: ['core'],
  };

  static Set<String> equipmentOf(AssessmentData a) {
    final e = a.availability.equipment;
    return {
      if (e.dumbbell) 'dumbbell',
      if (e.barbell) 'barbell',
      if (e.bench) 'bench',
      if (e.rack) 'rack',
      if (e.pullUpBar) 'pull_up_bar',
    };
  }

  /// Pilih hari latihan: maks. per level, utamakan hari yang tidak berurutan.
  static List<int> selectTrainingDays(List<int> available, String level) {
    final days = available.toSet().toList()..sort();
    final max = _maxDays[level]!;
    if (days.length <= max) return days;
    final chosen = <int>[];
    for (final d in days) {
      if (chosen.length < max && !chosen.any((c) => PlanValidator.consecutive(c, d))) {
        chosen.add(d);
      }
    }
    // Sisa slot: pilih hari dengan tetangga latihan paling sedikit.
    while (chosen.length < max) {
      int conflicts(int d) => chosen.where((c) => PlanValidator.consecutive(c, d)).length;
      final rest = days.where((d) => !chosen.contains(d));
      chosen.add(rest.reduce((a, b) => conflicts(b) < conflicts(a) ? b : a));
    }
    return chosen..sort();
  }

  static ({String split, List<String> focuses}) focusSequence(List<int> days) {
    bool hasConsecutive() {
      for (var i = 0; i < days.length; i++) {
        for (var j = i + 1; j < days.length; j++) {
          if (PlanValidator.consecutive(days[i], days[j])) return true;
        }
      }
      return false;
    }

    if (days.length >= 4 || (days.length >= 2 && hasConsecutive())) {
      const cycle = ['upper_a', 'lower_a', 'upper_b', 'lower_b'];
      return (split: 'upper_lower', focuses: [for (var i = 0; i < days.length; i++) cycle[i % 4]]);
    }
    const cycle = ['full_body_a', 'full_body_b', 'full_body_c'];
    return (split: 'full_body', focuses: [for (var i = 0; i < days.length; i++) cycle[i % 3]]);
  }

  static PlannedExercise _prescribe(Exercise ex, String level, {required bool priority}) {
    final lowerCompound =
        ex.compound && const ['squat', 'hinge', 'hip_extension'].contains(ex.pattern);
    final (int repMin, int repMax) = switch (ex) {
      _ when ex.repUnit == 'seconds' => level == 'beginner' ? (20, 40) : (30, 45),
      _ when !ex.compound => ex.pattern == 'core' ? (8, 12) : (10, 15),
      _ when ex.pattern == 'lunge' || level == 'beginner' => (8, 12),
      _ => (6, 10),
    };
    final baseSets = ex.compound ? (level == 'advanced' ? 4 : 3) : (level == 'beginner' ? 2 : 3);
    final restSec = ex.pattern == 'core' || ex.pattern == 'carry'
        ? 60
        : ex.compound
        ? (lowerCompound ? 150 : 120)
        : 75;
    final (int rirMin, int rirMax) = switch (level) {
      'beginner' => (2, 3),
      'intermediate' => (1, 3),
      _ => (1, 2),
    };
    return PlannedExercise(
      exerciseId: ex.id,
      name: ex.name,
      sets: math.min(baseSets + (priority ? 1 : 0), 5),
      repMin: repMin,
      repMax: repMax,
      repUnit: ex.repUnit,
      loadType: ex.loadType,
      restSec: restSec,
      rirMin: rirMin,
      rirMax: rirMax,
      priority: priority,
    );
  }

  static ({PlanDay day, int skipped}) _buildDay({
    required String focus,
    required int weekday,
    required int order,
    required int sessionMinutes,
    required Map<String, Exercise> catalog,
    required Set<String> equipment,
    required String level,
    required Set<String> priorityMuscles,
  }) {
    final warmup = warmupFor(sessionMinutes);
    final used = <String>{};
    final exercises = <PlannedExercise>[];
    var skipped = 0;
    for (final slot in _daySlots[focus]!) {
      Exercise? pick;
      for (final id in _slots[slot]!) {
        final ex = catalog[id];
        if (ex != null &&
            !used.contains(id) &&
            PlanValidator.hasEquipment(equipment, ex) &&
            PlanValidator.levelAllows(level, ex.level)) {
          pick = ex;
          break;
        }
      }
      if (pick == null) {
        skipped++;
        continue;
      }
      final candidate = _prescribe(
        pick,
        level,
        priority: pick.primaryMuscles.any(priorityMuscles.contains),
      );
      final fits =
          PlanValidator.estimateMinutes(warmup, [...exercises, candidate]) <= sessionMinutes;
      if (exercises.length >= 3 && !fits) break;
      exercises.add(candidate);
      used.add(pick.id);
    }
    // Sesi pendek: kurangi set (min. 2) sampai muat.
    while (PlanValidator.estimateMinutes(warmup, exercises) > sessionMinutes) {
      var target = -1;
      for (var i = 0; i < exercises.length; i++) {
        if (exercises[i].sets > 2 && (target < 0 || exercises[i].sets > exercises[target].sets)) {
          target = i;
        }
      }
      if (target < 0) break;
      exercises[target] = exercises[target].copyWith(sets: exercises[target].sets - 1);
    }
    return (
      day: PlanDay(
        id: 'd${order + 1}',
        order: order,
        weekday: weekday,
        focus: focus,
        warmupMinutes: warmup,
        estimatedMinutes: PlanValidator.estimateMinutes(warmup, exercises),
        exercises: exercises,
      ),
      skipped: skipped,
    );
  }

  /// Susun program awal dari assessment final.
  static PlanDraft build(AssessmentData a, Map<String, Exercise> catalog) {
    final level = a.experience.level!.name;
    final equipment = equipmentOf(a);
    final available = a.availability.trainingDays;
    final days = selectTrainingDays(available, level);
    final seq = focusSequence(days);
    final priority = {for (final m in a.goal.priorityMuscles) ...?_priorityMuscles[m]};
    final minutes = a.availability.sessionMinutes!;

    var skipped = 0;
    final planDays = <PlanDay>[];
    for (var i = 0; i < days.length; i++) {
      final r = _buildDay(
        focus: seq.focuses[i],
        weekday: days[i],
        order: i,
        sessionMinutes: minutes,
        catalog: catalog,
        equipment: equipment,
        level: level,
        priorityMuscles: priority,
      );
      skipped += r.skipped;
      planDays.add(r.day);
    }

    final warnings = <String>{
      if (needsInjuryReview(a)) 'review_injuries',
      if (days.length < available.toSet().length) 'days_reduced',
      if (skipped > 0) 'limited_equipment',
    };
    final validation = PlanValidator.validate(
      planDays,
      catalog: catalog,
      equipment: equipment,
      level: level,
    );
    if (!validation.isValid) {
      // Seharusnya tidak terjadi: planner hanya memilih dari katalog yang lolos filter.
      throw StateError('Template plan invalid: ${validation.errors}');
    }
    warnings.addAll(validation.warnings);
    return PlanDraft(
      split: seq.split,
      level: level,
      daysPerWeek: days.length,
      sessionMinutes: minutes,
      days: planDays,
      warnings: warnings.toList(),
    );
  }
}
