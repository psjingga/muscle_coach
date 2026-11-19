import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/formatters.dart';
import '../../../exercise_library/presentation/providers/exercise_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/workout_repository.dart';
import '../../domain/entities/workout.dart';
import '../../domain/workout_math.dart';

part 'workout_providers.g.dart';

/// keepAlive: repository memegang closure pembaca katalog yang dipakai
/// setelah operasi async — `ref` milik provider autoDispose bisa sudah mati.
@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(Ref ref) => LocalWorkoutRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(clockProvider),
  () => ref.read(exerciseCatalogProvider.future),
);

@riverpod
Stream<WorkoutPlan?> workoutPlan(Ref ref, String planId) =>
    ref.watch(workoutRepositoryProvider).watchPlan(planId);

@riverpod
Stream<List<PlanDay>> planDays(Ref ref, String planId) =>
    ref.watch(workoutRepositoryProvider).watchDays(planId);

/// ID program aktif dari profil.
@riverpod
String? activePlanId(Ref ref) =>
    ref.watch(userProfileProvider.select((p) => p.value?.activeWorkoutPlanId));

@riverpod
Stream<WorkoutSession?> workoutSession(Ref ref, String sessionId) =>
    ref.watch(workoutRepositoryProvider).watchSession(sessionId);

@riverpod
Stream<List<SetLog>> sessionSets(Ref ref, String sessionId) =>
    ref.watch(workoutRepositoryProvider).watchSets(sessionId);

@riverpod
Stream<List<WorkoutSession>> workoutHistory(Ref ref) =>
    ref.watch(workoutRepositoryProvider).watchHistory();

/// Hasil sesi selesai terakhir untuk hari program yang sama ("Terakhir: …").
@riverpod
Future<({WorkoutSession session, List<SetLog> sets})?> lastPerformance(
  Ref ref,
  String planId,
  String dayId,
) => ref.watch(workoutRepositoryProvider).lastCompleted(planId: planId, dayId: dayId);

/// Tanggal lokal hari ini `YYYY-MM-DD` & hari ISO (dapat dioverride di test).
({String date, int weekday}) today(DateTime now) =>
    (date: Fmt.toIsoDate(now), weekday: now.weekday);

/// Aksi program & sesi. `state` = status aksi terakhir (untuk tombol/snackbar).
@riverpod
class WorkoutActions extends _$WorkoutActions {
  @override
  FutureOr<void> build() {}

  WorkoutRepository get _repo => ref.read(workoutRepositoryProvider);

  Future<T?> _run<T>(Future<T> Function() action) async {
    state = const AsyncLoading();
    try {
      final value = await action();
      if (ref.mounted) state = const AsyncData(null);
      return value;
    } catch (e, st) {
      final failure = FailureMapper.from(e);
      appLogger.w('Aksi latihan gagal: $failure', error: e, stackTrace: st);
      if (ref.mounted) state = AsyncError(failure, st);
      return null;
    }
  }

  Future<String?> createStarterPlan() => _run(_repo.createStarterPlan);

  Future<bool> activatePlan(String planId) async =>
      await _run(() async {
        await _repo.activatePlan(planId);
        return true;
      }) ??
      false;

  /// Lanjutkan sesi hari ini yang belum selesai, atau mulai sesi baru.
  Future<String?> startOrResume(String planId, PlanDay day) => _run(() async {
    final now = ref.read(clockProvider)();
    final t = today(now);
    final existing = await _repo.findInProgress(planId: planId, dayId: day.id, date: t.date);
    return existing?.id ?? await _repo.startSession(planId: planId, day: day, date: t.date);
  });

  Future<bool> completeSession(
    String sessionId, {
    String? notes,
    int? energy,
    String? discomfort,
  }) async =>
      await _run(() async {
        String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
        await _repo.completeSession(
          sessionId,
          notes: clean(notes),
          energy: energy,
          discomfort: clean(discomfort),
        );
        return true;
      }) ??
      false;

  Future<bool> deleteSession(String sessionId) async =>
      await _run(() async {
        await _repo.deleteSession(sessionId);
        return true;
      }) ??
      false;
}

/// Pencatatan set dalam satu sesi + timer istirahat.
@riverpod
class SessionLogger extends _$SessionLogger {
  @override
  RestTimer? build(String sessionId) => null;

  DateTime get _now => ref.read(clockProvider)();

  /// Catat set; mulai timer istirahat sesuai target. Mengembalikan error input bila ada.
  Future<SetInputError?> logSet({
    required int exerciseIndex,
    required PlannedExercise planned,
    required int setNumber,
    required double? weightKg,
    required int? reps,
    int? rir,
  }) async {
    final error = WorkoutMath.validateSet(weightKg: weightKg, reps: reps);
    if (error != null) return error;
    final repo = ref.read(workoutRepositoryProvider);
    unawaited(
      repo
          .logSet(
            sessionId,
            SetLog(
              exerciseId: planned.exerciseId,
              exerciseIndex: exerciseIndex,
              setNumber: setNumber,
              weightKg: weightKg,
              reps: reps!,
              rir: rir,
              status: SetStatus.done,
            ),
          )
          .catchError((Object _) {}),
    );
    state = RestTimer.start(_now, planned.restSec);
    return null;
  }

  Future<void> skipSet({
    required int exerciseIndex,
    required PlannedExercise planned,
    required int setNumber,
  }) async {
    await ref
        .read(workoutRepositoryProvider)
        .logSet(
          sessionId,
          SetLog(
            exerciseId: planned.exerciseId,
            exerciseIndex: exerciseIndex,
            setNumber: setNumber,
            reps: 0,
            status: SetStatus.skipped,
          ),
        );
  }

  Future<void> deleteSet(String setId) =>
      ref.read(workoutRepositoryProvider).deleteSet(sessionId, setId);

  void adjustRest(int deltaSeconds) {
    final t = state;
    if (t != null) state = t.adjust(_now, deltaSeconds);
  }

  void stopRest() => state = null;
}
