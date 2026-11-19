import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';
import 'package:musclecoach/features/exercise_library/domain/exercise.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/features/workout/domain/plan_validator.dart';
import 'package:musclecoach/features/workout/domain/template_planner.dart';

import '../../fixtures/sample_assessment.dart';

final _parsed = AssetExerciseRepository.parse(
  File(AssetExerciseRepository.path).readAsStringSync(),
);
final catalog = {for (final e in _parsed.exercises) e.id: e};

void main() {
  group('katalog latihan (aset)', () {
    const muscles = {
      'chest', 'upper_back', 'lats', 'traps', 'front_delts', 'side_delts', 'rear_delts', //
      'biceps', 'triceps', 'forearms', 'quads', 'hamstrings', 'glutes', 'adductors',
      'calves', 'core',
    };
    const equipment = {'dumbbell', 'barbell', 'bench', 'rack', 'pull_up_bar'};

    test('versi cocok, ID unik, kode valid, alternatif ada', () {
      expect(_parsed.version, catalogVersion);
      expect(catalog.length, _parsed.exercises.length);
      expect(catalog.length, greaterThanOrEqualTo(40));
      for (final ex in catalog.values) {
        expect(ex.id, matches(RegExp(r'^[a-z0-9_]+$')));
        expect(
          {...ex.primaryMuscles, ...ex.secondaryMuscles}.difference(muscles),
          isEmpty,
          reason: ex.id,
        );
        expect(ex.equipment.toSet().difference(equipment), isEmpty, reason: ex.id);
        expect(ex.primaryMuscles, isNotEmpty);
        expect(ex.instructions, isNotEmpty);
        expect(ex.safety, isNotEmpty);
        expect(['beginner', 'intermediate', 'advanced'], contains(ex.level));
        for (final alt in ex.alternatives) {
          expect(catalog.containsKey(alt), isTrue, reason: '${ex.id} → $alt');
          expect(alt, isNot(ex.id));
        }
      }
      expect(catalog['barbell_bench_press']!.needsSpotter, isTrue);
      expect(catalog['barbell_back_squat']!.needsSpotter, isTrue);
    });
  });

  group('pemilihan hari & split', () {
    test('batas hari per level, utamakan tidak berurutan', () {
      expect(TemplatePlanner.selectTrainingDays([1, 2, 3, 4, 5, 6, 7], 'beginner'), [1, 3, 5, 6]);
      expect(
        TemplatePlanner.selectTrainingDays([1, 2, 3, 4, 5, 6, 7], 'intermediate'),
        hasLength(5),
      );
      expect(TemplatePlanner.selectTrainingDays([2, 4], 'beginner'), [2, 4]);
    });

    test('full body ≤ 3 hari tidak berurutan; upper/lower ≥ 4 atau berurutan', () {
      expect(TemplatePlanner.focusSequence([1, 3, 5]).split, 'full_body');
      expect(TemplatePlanner.focusSequence([1, 3, 5]).focuses, [
        'full_body_a',
        'full_body_b',
        'full_body_c',
      ]);
      expect(TemplatePlanner.focusSequence([1, 2]).split, 'upper_lower');
      expect(TemplatePlanner.focusSequence([1, 2, 4, 5]).focuses, [
        'upper_a',
        'lower_a',
        'upper_b',
        'lower_b',
      ]);
      expect(PlanValidator.consecutive(7, 1), isTrue);
      expect(PlanValidator.consecutive(1, 3), isFalse);
    });
  });

  group('TemplatePlanner.build', () {
    test('pemula dumbbell + bench: hanya gerakan yang alatnya ada & level pemula', () {
      final a = withEquipment(const EquipmentSelection(dumbbell: true, bench: true));
      final plan = TemplatePlanner.build(a, catalog);
      expect(plan.split, 'full_body');
      expect(plan.days.map((d) => d.weekday), [1, 3, 5]);
      final eq = TemplatePlanner.equipmentOf(a);
      expect(
        PlanValidator.validate(
          plan.days,
          catalog: catalog,
          equipment: eq,
          level: 'beginner',
        ).errors,
        isEmpty,
      );
      for (final d in plan.days) {
        expect(d.exercises.length, greaterThanOrEqualTo(3));
        expect(d.estimatedMinutes, lessThanOrEqualTo(60));
        for (final p in d.exercises) {
          final ex = catalog[p.exerciseId]!;
          expect(ex.equipment.every(eq.contains), isTrue);
          expect(ex.level, 'beginner');
          expect(p.rirMin, greaterThanOrEqualTo(2));
        }
      }
      expect(plan.days.first.exercises.first.exerciseId, 'goblet_squat');
    });

    test('tanpa rack/bench: back squat & bench press tidak dipilih', () {
      final a = withEquipment(
        const EquipmentSelection(dumbbell: true, barbell: true),
        level: ExperienceLevel.intermediate,
      );
      final ids = TemplatePlanner.build(
        a,
        catalog,
      ).days.expand((d) => d.exercises).map((e) => e.exerciseId);
      expect(ids, isNot(contains('barbell_back_squat')));
      expect(ids, isNot(contains('barbell_bench_press')));
      expect(ids, isNot(contains('dumbbell_bench_press')));
    });

    test('menengah dengan rack: barbell + peringatan spotter, tanpa tumpang tindih berurutan', () {
      final a = withEquipment(
        const EquipmentSelection(
          dumbbell: true,
          barbell: true,
          bench: true,
          rack: true,
          pullUpBar: true,
        ),
        level: ExperienceLevel.intermediate,
        days: [1, 2, 4, 5],
      );
      final plan = TemplatePlanner.build(a, catalog);
      expect(plan.split, 'upper_lower');
      final ids = plan.days.expand((d) => d.exercises).map((e) => e.exerciseId);
      expect(ids, contains('barbell_back_squat'));
      expect(ids, contains('pull_up'));
      expect(plan.warnings, contains('spotter_or_safeties'));
      expect(plan.warnings, isNot(contains('consecutive_muscle_overlap')));
    });

    test('durasi sesi menentukan jumlah latihan; 30 menit tetap ≤ 30', () {
      AssessmentData mins(int m) =>
          sample.copyWith(availability: sample.availability.copyWith(sessionMinutes: m));
      for (final d in TemplatePlanner.build(mins(30), catalog).days) {
        expect(d.exercises.length, greaterThanOrEqualTo(3));
        expect(d.estimatedMinutes, lessThanOrEqualTo(30));
      }
      expect(
        TemplatePlanner.build(mins(90), catalog).days.first.exercises.length,
        greaterThan(TemplatePlanner.build(mins(45), catalog).days.first.exercises.length),
      );
    });

    test('otot prioritas mendapat set tambahan', () {
      PlannedExercise press(List<MuscleGroup> p) => TemplatePlanner.build(
        sample.copyWith(goal: sample.goal.copyWith(priorityMuscles: p)),
        catalog,
      ).days.first.exercises.firstWhere((e) => e.exerciseId == 'dumbbell_bench_press');
      expect(press(const [MuscleGroup.chest]).sets, press(const []).sets + 1);
      expect(press(const [MuscleGroup.chest]).priority, isTrue);
    });

    test('peringatan cedera, hari dikurangi, alat terbatas', () {
      final a = sample.copyWith(
        safety: const SafetySection(injuries: 'Lutut kiri kadang nyeri'),
        availability: sample.availability.copyWith(
          trainingDays: [1, 2, 3, 4, 5, 6],
          equipment: const EquipmentSelection(barbell: true),
        ),
      );
      final plan = TemplatePlanner.build(a, catalog);
      expect(plan.warnings, containsAll(['review_injuries', 'days_reduced', 'limited_equipment']));
      expect(plan.daysPerWeek, 4);
    });
  });

  group('PlanValidator', () {
    const good = PlannedExercise(
      exerciseId: 'goblet_squat',
      name: 'Goblet Squat',
      sets: 3,
      repMin: 8,
      repMax: 12,
      restSec: 120,
      rirMin: 2,
      rirMax: 3,
    );
    PlanDay day(List<PlannedExercise> ex, [int weekday = 1]) => PlanDay(
      id: 'd$weekday',
      order: 0,
      weekday: weekday,
      focus: 'full_body_a',
      warmupMinutes: 8,
      estimatedMinutes: 30,
      exercises: ex,
    );
    List<String> codes(List<PlanDay> days, {Set<String> eq = const {'dumbbell'}}) =>
        PlanValidator.validate(
          days,
          catalog: catalog,
          equipment: eq,
          level: 'beginner',
        ).errors.map((e) => e.code).toList();

    test(
      'menerima rencana valid',
      () => expect(
        codes([
          day([good]),
        ]),
        isEmpty,
      ),
    );

    test('menolak latihan di luar katalog, alat tidak ada, level terlalu tinggi, duplikat', () {
      final c = codes([
        day([
          good.copyWith(exerciseId: 'kettlebell_swing'),
          good.copyWith(exerciseId: 'barbell_back_squat'),
          good.copyWith(exerciseId: 'dumbbell_arnold_press'),
          good,
          good,
        ]),
      ]);
      expect(
        c,
        containsAll([
          'unknown_exercise',
          'equipment_missing',
          'level_too_high',
          'duplicate_exercise',
        ]),
      );
    });

    test('menolak angka di luar batas', () {
      final c = codes(
        [
          day([
            good.copyWith(sets: 9),
            good.copyWith(exerciseId: 'dumbbell_squat', repMin: 12, repMax: 8),
            good.copyWith(exerciseId: 'dumbbell_reverse_lunge', restSec: 10),
            good.copyWith(exerciseId: 'dumbbell_step_up', rirMin: 0, rirMax: 9),
          ]),
        ],
        eq: {'dumbbell', 'bench'},
      );
      expect(
        c,
        containsAll([
          'sets_out_of_range',
          'reps_out_of_range',
          'rest_out_of_range',
          'rir_out_of_range',
        ]),
      );
    });

    test('menolak hari tidak valid/duplikat dan rencana kosong', () {
      expect(codes([]), ['no_days']);
      expect(
        codes([
          day([good], 8),
        ]),
        contains('invalid_weekday'),
      );
      expect(
        codes([
          day([good]),
          day([good]).copyWith(id: 'x'),
        ]),
        contains('duplicate_weekday'),
      );
    });

    test('peringatan otot sama di hari berurutan; estimasi durasi', () {
      final v = PlanValidator.validate(
        [
          day([good], 1),
          day([good], 2),
        ],
        catalog: catalog,
        equipment: {'dumbbell'},
        level: 'beginner',
      );
      expect(v.warnings, contains('consecutive_muscle_overlap'));
      expect(PlanValidator.estimateMinutes(8, [good]), 15);
    });
  });
}
