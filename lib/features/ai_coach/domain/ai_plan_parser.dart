import 'dart:convert';

import '../../assessment/domain/entities/assessment_data.dart';
import '../../exercise_library/domain/exercise.dart';
import '../../workout/domain/entities/workout.dart';
import '../../workout/domain/plan_validator.dart';
import '../../workout/domain/template_planner.dart';

/// Hasil parsing output AI: program yang lolos validasi atau daftar masalah
/// (dipakai sebagai umpan balik retry).
class AiPlanResult {
  const AiPlanResult.ok(this.draft, this.rationale) : problems = const [];
  const AiPlanResult.invalid(this.problems) : draft = null, rationale = null;

  final PlanDraft? draft;
  final String? rationale;
  final List<String> problems;

  bool get isValid => draft != null;
}

/// Parse & validasi output AI terhadap katalog, assessment, dan aturan
/// keselamatan. Output yang tidak lolos TIDAK pernah disimpan.
abstract final class AiPlanParser {
  static const supportedSchemaVersion = 1;
  static const _maxRationale = 400;

  /// Toleransi durasi sesi terhadap pilihan pengguna.
  static const durationTolerance = 1.15;

  static String _clip(String? s) {
    final t = (s ?? '').trim();
    return t.length <= _maxRationale ? t : '${t.substring(0, _maxRationale - 1)}…';
  }

  static AiPlanResult parse(
    String raw, {
    required AssessmentData assessment,
    required Map<String, Exercise> catalog,
  }) {
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return const AiPlanResult.invalid(['invalid_json: keluaran bukan JSON objek yang valid']);
    }

    final problems = <String>[];
    if (json['schemaVersion'] != supportedSchemaVersion) {
      problems.add('schema_version: schemaVersion harus $supportedSchemaVersion');
    }
    final split = json['split'];
    if (split != 'full_body' && split != 'upper_lower') {
      problems.add('split: harus full_body atau upper_lower');
    }
    final rawDays = json['days'];
    if (rawDays is! List || rawDays.isEmpty) {
      return AiPlanResult.invalid([...problems, 'days: minimal satu hari latihan']);
    }

    final level = assessment.experience.level!.name;
    final available = assessment.availability.trainingDays.toSet();
    final minutes = assessment.availability.sessionMinutes!;
    final warmup = TemplatePlanner.warmupFor(minutes);
    final priority = TemplatePlanner.priorityMusclesOf(assessment);
    final days = <PlanDay>[];

    for (final (i, d) in rawDays.indexed) {
      if (d is! Map<String, dynamic>) {
        problems.add('days[$i]: format hari tidak valid');
        continue;
      }
      final weekday = d['weekday'];
      final focus = d['focus'];
      final rawExercises = d['exercises'];
      if (weekday is! int || !available.contains(weekday)) {
        problems.add(
          'days[$i].weekday: $weekday bukan hari yang tersedia ${available.toList()..sort()}',
        );
      }
      if (focus is! String) {
        problems.add('days[$i].focus: wajib diisi');
      }
      if (rawExercises is! List) {
        problems.add('days[$i].exercises: wajib berupa daftar');
        continue;
      }
      final exercises = <PlannedExercise>[];
      for (final (j, e) in rawExercises.indexed) {
        if (e is! Map<String, dynamic>) continue;
        final id = e['exerciseId'];
        final ex = id is String ? catalog[id] : null;
        int? n(String k) => (e[k] as num?)?.toInt();
        if (ex == null) {
          problems.add('days[$i].exercises[$j]: exerciseId "$id" tidak ada di katalog');
          continue;
        }
        final values = [
          n('sets'),
          n('repMin'),
          n('repMax'),
          n('restSec'),
          n('rirMin'),
          n('rirMax'),
        ];
        if (values.contains(null)) {
          problems.add('days[$i].exercises[$j]: angka wajib lengkap');
          continue;
        }
        exercises.add(
          PlannedExercise(
            exerciseId: ex.id,
            name: ex.name,
            sets: values[0]!,
            repMin: values[1]!,
            repMax: values[2]!,
            repUnit: ex.repUnit,
            loadType: ex.loadType,
            restSec: values[3]!,
            rirMin: values[4]!,
            rirMax: values[5]!,
            priority: ex.primaryMuscles.any(priority.contains),
            rationale: _clip(e['rationale'] as String?).isEmpty
                ? null
                : _clip(e['rationale'] as String?),
          ),
        );
      }
      final estimate = PlanValidator.estimateMinutes(warmup, exercises);
      if (estimate > minutes * durationTolerance) {
        problems.add('days[$i]: perkiraan $estimate menit melebihi durasi sesi $minutes menit');
      }
      if (exercises.length < 3) problems.add('days[$i]: minimal 3 gerakan per sesi');
      if (level == 'beginner' && exercises.any((p) => p.rirMin < 2)) {
        problems.add('days[$i]: pemula wajib rirMin ≥ 2 (tidak sampai gagal)');
      }
      days.add(
        PlanDay(
          id: 'd${days.length + 1}',
          order: days.length,
          weekday: weekday is int ? weekday : 0,
          focus: focus is String ? focus : 'full_body_a',
          warmupMinutes: warmup,
          estimatedMinutes: estimate,
          exercises: exercises,
        ),
      );
    }

    final maxDays = TemplatePlanner.maxDaysFor(level);
    if (days.length > maxDays) {
      problems.add('days: maksimal $maxDays hari latihan untuk level $level');
    }

    days.sort((a, b) => a.weekday.compareTo(b.weekday));
    final ordered = [for (final (i, d) in days.indexed) d.copyWith(id: 'd${i + 1}', order: i)];
    final equipment = TemplatePlanner.equipmentOf(assessment);
    final validation = PlanValidator.validate(
      ordered,
      catalog: catalog,
      equipment: equipment,
      level: level,
    );
    problems.addAll(
      validation.errors.map(
        (e) =>
            '${e.code}${e.day == null ? '' : ' @${e.day}'}${e.exerciseId == null ? '' : ' (${e.exerciseId})'}',
      ),
    );
    if (problems.isNotEmpty) return AiPlanResult.invalid(problems);

    final warnings = <String>{
      if (TemplatePlanner.needsInjuryReview(assessment)) 'review_injuries',
      ...validation.warnings,
    };
    return AiPlanResult.ok(
      PlanDraft(
        split: split! as String,
        level: level,
        daysPerWeek: ordered.length,
        sessionMinutes: minutes,
        days: ordered,
        warnings: warnings.toList(),
      ),
      _clip(json['rationale'] as String?),
    );
  }

  /// Latihan yang boleh dipilih AI: sesuai alat & level pengguna.
  static List<Exercise> allowedExercises(AssessmentData a, Map<String, Exercise> catalog) {
    final equipment = TemplatePlanner.equipmentOf(a);
    final level = a.experience.level!.name;
    return catalog.values
        .where(
          (e) =>
              PlanValidator.hasEquipment(equipment, e) && PlanValidator.levelAllows(level, e.level),
        )
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }
}
