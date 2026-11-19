import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../assessment/domain/entities/assessment_data.dart';
import '../../exercise_library/domain/exercise.dart';
import '../../profile/data/local_profile_repository.dart';
import '../domain/entities/workout.dart';
import '../domain/template_planner.dart';

abstract interface class WorkoutRepository {
  Stream<WorkoutPlan?> watchPlan(String planId);
  Stream<List<PlanDay>> watchDays(String planId);

  /// Buat draft program awal dari assessment terakhir → ID draft program.
  Future<String> createStarterPlan();

  /// Aktifkan draft; program aktif sebelumnya diarsipkan.
  Future<void> activatePlan(String planId);

  /// Buat sesi baru dengan salinan target hari tersebut → ID sesi.
  Future<String> startSession({required String planId, required PlanDay day, required String date});

  Stream<WorkoutSession?> watchSession(String sessionId);
  Stream<List<SetLog>> watchSets(String sessionId);

  /// Sesi yang sedang berjalan untuk hari program tertentu pada tanggal ini.
  Future<WorkoutSession?> findInProgress({
    required String planId,
    required String dayId,
    required String date,
  });

  Future<void> logSet(String sessionId, SetLog set);
  Future<void> deleteSet(String sessionId, String setId);

  Future<void> completeSession(String sessionId, {String? notes, int? energy, String? discomfort});

  /// Hapus sesi beserta seluruh set-nya.
  Future<void> deleteSession(String sessionId);

  /// Riwayat sesi selesai, terbaru dulu.
  Stream<List<WorkoutSession>> watchHistory({int limit = 30});

  /// Set dari sesi selesai terakhir untuk hari program yang sama.
  Future<({WorkoutSession session, List<SetLog> sets})?> lastCompleted({
    required String planId,
    required String dayId,
  });
}

class LocalWorkoutRepository implements WorkoutRepository {
  LocalWorkoutRepository(this._db, this._clock, this._catalog);

  final AppDatabase _db;
  final DateTime Function() _clock;
  final Future<Map<String, Exercise>> Function() _catalog;

  static List<PlannedExercise> _planned(String json) => [
    for (final e in jsonDecode(json) as List<dynamic>)
      PlannedExercise.fromJson(e as Map<String, dynamic>),
  ];

  static String _encodePlanned(List<PlannedExercise> list) =>
      jsonEncode([for (final p in list) p.toJson()]);

  static WorkoutPlan _plan(WorkoutPlanRow r) => WorkoutPlan(
    id: r.id,
    status: PlanStatus.values.byName(r.status),
    source: r.source,
    split: r.split,
    level: r.level,
    daysPerWeek: r.daysPerWeek,
    sessionMinutes: r.sessionMinutes,
    warnings: (jsonDecode(r.warnings) as List<dynamic>).cast<String>(),
  );

  static PlanDay _day(PlanDayRow r) => PlanDay(
    id: r.id,
    order: r.position,
    weekday: r.weekday,
    focus: r.focus,
    warmupMinutes: r.warmupMinutes,
    estimatedMinutes: r.estimatedMinutes,
    exercises: _planned(r.exercises),
  );

  static WorkoutSession _session(WorkoutSessionRow r) => WorkoutSession(
    id: r.id,
    planId: r.planId,
    dayId: r.dayId,
    date: r.date,
    weekday: r.weekday,
    focus: r.focus,
    status: SessionStatus.values.byName(r.status),
    planned: _planned(r.planned),
    notes: r.notes,
    energy: r.energy,
    discomfort: r.discomfort,
  );

  static SetLog _set(SetLogRow r) => SetLog(
    id: r.id,
    exerciseId: r.exerciseId,
    exerciseIndex: r.exerciseIndex,
    setNumber: r.setNumber,
    weightKg: r.weightKg,
    reps: r.reps,
    rir: r.rir,
    status: SetStatus.values.byName(r.status),
  );

  @override
  Stream<WorkoutPlan?> watchPlan(String planId) => (_db.select(
    _db.workoutPlans,
  )..where((t) => t.id.equals(planId))).watchSingleOrNull().map((r) => r == null ? null : _plan(r));

  @override
  Stream<List<PlanDay>> watchDays(String planId) =>
      (_db.select(_db.planDays)
            ..where((t) => t.planId.equals(planId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .watch()
          .map((rows) => rows.map(_day).toList());

  @override
  Future<String> createStarterPlan() async {
    final profile = await readProfile(_db);
    if (profile == null || !profile.onboardingCompleted) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'onboarding-required');
    }
    final assessmentId = profile.latestAssessmentId;
    final row = assessmentId == null
        ? null
        : await (_db.select(
            _db.assessments,
          )..where((t) => t.id.equals(assessmentId))).getSingleOrNull();
    if (row == null) {
      throw const AppFailure(FailureKind.notFound, debugMessage: 'assessment-missing');
    }
    final assessment = AssessmentData.fromJson(jsonDecode(row.data) as Map<String, dynamic>);
    if (assessment.safety.redFlags.isNotEmpty) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'safety-stop');
    }
    final catalog = await _catalog();
    final draft = TemplatePlanner.build(assessment, catalog);
    final now = _clock();
    final planId = newId();

    await _db.transaction(() async {
      // Draft lama yang belum diaktifkan diganti (hari ikut terhapus: cascade).
      await (_db.delete(_db.workoutPlans)..where((t) => t.status.equals('draft'))).go();
      await _db
          .into(_db.workoutPlans)
          .insert(
            WorkoutPlansCompanion.insert(
              id: planId,
              status: 'draft',
              source: 'template',
              generatorVersion: TemplatePlanner.generatorVersion,
              catalogVersion: catalogVersion,
              assessmentId: assessmentId!,
              split: draft.split,
              level: draft.level,
              daysPerWeek: draft.daysPerWeek,
              sessionMinutes: draft.sessionMinutes,
              warnings: jsonEncode(draft.warnings),
              createdAt: now,
            ),
          );
      for (final d in draft.days) {
        await _db
            .into(_db.planDays)
            .insert(
              PlanDaysCompanion.insert(
                planId: planId,
                id: d.id,
                position: d.order,
                weekday: d.weekday,
                focus: d.focus,
                warmupMinutes: d.warmupMinutes,
                estimatedMinutes: d.estimatedMinutes,
                exercises: _encodePlanned(d.exercises),
              ),
            );
      }
    });
    return planId;
  }

  @override
  Future<void> activatePlan(String planId) async {
    final now = _clock();
    await _db.transaction(() async {
      final plan = await (_db.select(
        _db.workoutPlans,
      )..where((t) => t.id.equals(planId))).getSingleOrNull();
      if (plan == null) throw const AppFailure(FailureKind.notFound);
      if (plan.status != 'draft') {
        throw const AppFailure(FailureKind.invalidInput, debugMessage: 'plan-not-draft');
      }
      await (_db.update(_db.workoutPlans)..where((t) => t.status.equals('active'))).write(
        WorkoutPlansCompanion(status: const Value('archived'), archivedAt: Value(now)),
      );
      await (_db.update(_db.workoutPlans)..where((t) => t.id.equals(planId))).write(
        WorkoutPlansCompanion(status: const Value('active'), activatedAt: Value(now)),
      );
      await updateProfile(_db, ProfileStateCompanion(activeWorkoutPlanId: Value(planId)), now);
    });
  }

  @override
  Future<String> startSession({
    required String planId,
    required PlanDay day,
    required String date,
  }) async {
    final id = newId();
    await _db
        .into(_db.workoutSessions)
        .insert(
          WorkoutSessionsCompanion.insert(
            id: id,
            planId: planId,
            dayId: day.id,
            date: date,
            weekday: day.weekday,
            focus: day.focus,
            status: SessionStatus.inProgress.name,
            planned: _encodePlanned(day.exercises),
            startedAt: _clock(),
          ),
        );
    return id;
  }

  @override
  Stream<WorkoutSession?> watchSession(String sessionId) =>
      (_db.select(_db.workoutSessions)..where((t) => t.id.equals(sessionId)))
          .watchSingleOrNull()
          .map((r) => r == null ? null : _session(r));

  @override
  Stream<List<SetLog>> watchSets(String sessionId) => (_db.select(
    _db.setLogs,
  )..where((t) => t.sessionId.equals(sessionId))).watch().map((rows) => rows.map(_set).toList());

  @override
  Future<WorkoutSession?> findInProgress({
    required String planId,
    required String dayId,
    required String date,
  }) async {
    final row =
        await (_db.select(_db.workoutSessions)
              ..where(
                (t) =>
                    t.planId.equals(planId) &
                    t.dayId.equals(dayId) &
                    t.date.equals(date) &
                    t.status.equals(SessionStatus.inProgress.name),
              )
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _session(row);
  }

  @override
  Future<void> logSet(String sessionId, SetLog set) async {
    await _db
        .into(_db.setLogs)
        .insertOnConflictUpdate(
          SetLogsCompanion.insert(
            id: set.id.isEmpty ? newId() : set.id,
            sessionId: sessionId,
            exerciseId: set.exerciseId,
            exerciseIndex: set.exerciseIndex,
            setNumber: set.setNumber,
            weightKg: Value(set.weightKg),
            reps: set.reps,
            rir: Value(set.rir),
            status: set.status.name,
            loggedAt: _clock(),
          ),
        );
  }

  @override
  Future<void> deleteSet(String sessionId, String setId) async {
    await (_db.delete(
      _db.setLogs,
    )..where((t) => t.id.equals(setId) & t.sessionId.equals(sessionId))).go();
  }

  @override
  Future<void> completeSession(
    String sessionId, {
    String? notes,
    int? energy,
    String? discomfort,
  }) async {
    await (_db.update(_db.workoutSessions)..where((t) => t.id.equals(sessionId))).write(
      WorkoutSessionsCompanion(
        status: Value(SessionStatus.completed.name),
        completedAt: Value(_clock()),
        notes: Value(notes),
        energy: Value(energy),
        discomfort: Value(discomfort),
      ),
    );
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    // Set ikut terhapus (foreign key cascade).
    await (_db.delete(_db.workoutSessions)..where((t) => t.id.equals(sessionId))).go();
  }

  @override
  Stream<List<WorkoutSession>> watchHistory({int limit = 30}) =>
      (_db.select(_db.workoutSessions)
            ..where((t) => t.status.equals(SessionStatus.completed.name))
            ..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.startedAt)])
            ..limit(limit))
          .watch()
          .map((rows) => rows.map(_session).toList());

  @override
  Future<({WorkoutSession session, List<SetLog> sets})?> lastCompleted({
    required String planId,
    required String dayId,
  }) async {
    final row =
        await (_db.select(_db.workoutSessions)
              ..where(
                (t) =>
                    t.planId.equals(planId) &
                    t.dayId.equals(dayId) &
                    t.status.equals(SessionStatus.completed.name),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    final sets = await (_db.select(_db.setLogs)..where((t) => t.sessionId.equals(row.id))).get();
    return (session: _session(row), sets: sets.map(_set).toList());
  }
}
