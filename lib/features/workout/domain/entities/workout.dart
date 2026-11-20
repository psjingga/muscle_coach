import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

// Program dibuat server (`functions/src/workout/*`); sesi & set ditulis aplikasi.

@JsonEnum(fieldRename: FieldRename.snake)
enum PlanStatus { draft, active, archived }

@JsonEnum(fieldRename: FieldRename.snake)
enum SessionStatus { inProgress, completed, skipped }

@JsonEnum(fieldRename: FieldRename.snake)
enum SetStatus { done, skipped }

@freezed
abstract class PlannedExercise with _$PlannedExercise {
  const factory PlannedExercise({
    required String exerciseId,
    required String name,
    required int sets,
    required int repMin,
    required int repMax,
    @Default('reps') String repUnit,
    @Default('total') String loadType,
    required int restSec,
    required int rirMin,
    required int rirMax,
    @Default(false) bool priority,

    /// Alasan singkat dari AI (null untuk program template).
    String? rationale,
  }) = _PlannedExercise;

  const PlannedExercise._();

  bool get isTimed => repUnit == 'seconds';

  factory PlannedExercise.fromJson(Map<String, dynamic> json) => _$PlannedExerciseFromJson(json);
}

@freezed
abstract class PlanDay with _$PlanDay {
  const factory PlanDay({
    required String id,
    required int order,

    /// ISO 1 = Senin … 7 = Minggu.
    required int weekday,
    required String focus,
    required int warmupMinutes,
    required int estimatedMinutes,
    required List<PlannedExercise> exercises,
  }) = _PlanDay;

  factory PlanDay.fromJson(Map<String, dynamic> json) => _$PlanDayFromJson(json);
}

@freezed
abstract class WorkoutPlan with _$WorkoutPlan {
  const factory WorkoutPlan({
    @JsonKey(includeFromJson: false, includeToJson: false) @Default('') String id,
    required PlanStatus status,
    @Default('template') String source,
    required String split,
    required String level,
    required int daysPerWeek,
    required int sessionMinutes,
    @Default(<String>[]) List<String> warnings,

    /// Ringkasan alasan dari AI & model penyusun (null untuk template).
    String? rationale,
    String? model,
  }) = _WorkoutPlan;

  const WorkoutPlan._();

  bool get isAiGenerated => source == 'ai_generated';

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => _$WorkoutPlanFromJson(json);
}

@freezed
abstract class WorkoutSession with _$WorkoutSession {
  const factory WorkoutSession({
    @JsonKey(includeFromJson: false, includeToJson: false) @Default('') String id,
    required String planId,
    required String dayId,

    /// Tanggal lokal pengguna `YYYY-MM-DD`.
    required String date,
    required int weekday,
    required String focus,
    required SessionStatus status,
    required List<PlannedExercise> planned,
    String? notes,
    int? energy,
    String? discomfort,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => _$WorkoutSessionFromJson(json);
}

/// Satu set aktual. `reps` berisi detik untuk latihan berbasis waktu.
@freezed
abstract class SetLog with _$SetLog {
  const factory SetLog({
    @JsonKey(includeFromJson: false, includeToJson: false) @Default('') String id,
    required String exerciseId,
    required int exerciseIndex,
    required int setNumber,
    double? weightKg,
    required int reps,
    int? rir,
    required SetStatus status,
  }) = _SetLog;

  factory SetLog.fromJson(Map<String, dynamic> json) => _$SetLogFromJson(json);
}
