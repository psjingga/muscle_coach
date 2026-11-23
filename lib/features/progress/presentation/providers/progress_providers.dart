import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/utils/formatters.dart';
import '../../../ai_coach/application/ai_plan_service.dart';
import '../../../ai_coach/domain/ai_config.dart';
import '../../../ai_coach/presentation/providers/ai_providers.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../../core/storage/photo_store.dart';
import '../../application/weekly_review_service.dart';
import '../../data/body_repository.dart';
import '../../data/photo_picker.dart';
import '../../data/progress_repository.dart';
import '../../domain/progress_math.dart';
import '../../domain/progress_models.dart';

part 'progress_providers.g.dart';

@Riverpod(keepAlive: true)
ProgressRepository progressRepository(Ref ref) =>
    LocalProgressRepository(ref.watch(appDatabaseProvider), ref.watch(clockProvider));

@riverpod
Stream<List<WeightEntry>> weights(Ref ref) => ref.watch(progressRepositoryProvider).watchWeights();

@riverpod
Stream<List<DailyCheckIn>> checkIns(Ref ref) =>
    ref.watch(progressRepositoryProvider).watchCheckIns();

@Riverpod(keepAlive: true)
PhotoStore photoStore(Ref ref) => LocalPhotoStore();

@Riverpod(keepAlive: true)
PhotoPicker photoPicker(Ref ref) => ImagePickerPhotoPicker();

/// Folder foto progres (untuk menampilkan berkas).
@Riverpod(keepAlive: true)
Future<Directory> photoDirectory(Ref ref) => ref.watch(photoStoreProvider).directory();

@Riverpod(keepAlive: true)
BodyRepository bodyRepository(Ref ref) => LocalBodyRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(photoStoreProvider),
  ref.watch(clockProvider),
);

@riverpod
Stream<List<BodyMeasurement>> measurements(Ref ref) =>
    ref.watch(bodyRepositoryProvider).watchMeasurements();

@riverpod
Stream<List<ProgressPhoto>> progressPhotos(Ref ref) =>
    ref.watch(bodyRepositoryProvider).watchPhotos();

@riverpod
Stream<List<DayIntake>> intakeByDay(Ref ref) => ref.watch(progressRepositoryProvider).watchIntake();

@riverpod
Stream<List<TrainingDay>> trainingDays(Ref ref) =>
    ref.watch(progressRepositoryProvider).watchTraining();

/// Hari latihan per minggu pada program aktif (berubah saat program diganti).
@riverpod
Future<int?> plannedSessionsPerWeek(Ref ref) {
  ref.watch(userProfileProvider.select((p) => p.value?.activeWorkoutPlanId));
  return ref.watch(progressRepositoryProvider).plannedSessionsPerWeek();
}

@riverpod
String progressToday(Ref ref) => Fmt.toIsoDate(ref.watch(clockProvider)());

/// Status target dari tren berat.
@riverpod
GoalProgress? goalProgress(Ref ref) {
  final goal = ref.watch(activeGoalProvider).value;
  final weights = ref.watch(weightsProvider).value;
  if (goal == null || weights == null) return null;
  return ProgressMath.goalProgress(goal, weights, today: ref.watch(progressTodayProvider));
}

/// Ringkasan minggu [weekStart] (dihitung langsung dari data).
@riverpod
WeekSummary? weekSummary(Ref ref, String weekStart) {
  final weights = ref.watch(weightsProvider).value;
  final training = ref.watch(trainingDaysProvider).value;
  final intake = ref.watch(intakeByDayProvider).value;
  final checkIns = ref.watch(checkInsProvider).value;
  if (weights == null || training == null || intake == null || checkIns == null) return null;
  final target = ref.watch(activeNutritionTargetProvider).value;
  return ProgressMath.weekSummary(
    weekStart: weekStart,
    weights: weights,
    training: training,
    intake: intake,
    checkIns: checkIns,
    plannedSessionsPerWeek: ref.watch(plannedSessionsPerWeekProvider).value,
    targetKcal: target?.targetKcal.toDouble(),
    targetProtein: target?.proteinG.toDouble(),
  );
}

/// Usulan penyesuaian berdasarkan 2 minggu lengkap terakhir sebelum [weekStart]+7.
@riverpod
({NutritionAdjustment? adjustment, AdjustmentBlock? block})? adjustmentFor(
  Ref ref,
  String weekStart,
) {
  final goal = ref.watch(activeGoalProvider).value;
  final target = ref.watch(activeNutritionTargetProvider).value;
  final progress = ref.watch(goalProgressProvider);
  final w1 = ref.watch(weekSummaryProvider(ProgressMath.addDays(weekStart, -7)));
  final w2 = ref.watch(weekSummaryProvider(weekStart));
  if (goal == null || target == null || progress == null || w1 == null || w2 == null) return null;
  return ProgressMath.proposeAdjustment(
    goal: goal,
    progress: progress,
    target: target,
    lastTwoWeeks: [w1, w2],
  );
}

@riverpod
Stream<StoredWeeklyReview?> storedReview(Ref ref, String weekStart) =>
    ref.watch(progressRepositoryProvider).watchReview(weekStart);

@riverpod
Stream<List<StoredWeeklyReview>> storedReviews(Ref ref) =>
    ref.watch(progressRepositoryProvider).watchReviews();

@Riverpod(keepAlive: true)
WeeklyReviewService weeklyReviewService(Ref ref) {
  final keys = ref.watch(aiKeyStoreProvider);
  return WeeklyReviewService(
    progress: ref.watch(progressRepositoryProvider),
    ai: ref.watch(aiRepositoryProvider),
    client: ref.watch(aiClientProvider),
    keys: keys,
    clock: ref.watch(clockProvider),
    model: () async => await keys.readModel() ?? AiConfig.defaultModel,
  );
}

/// Aksi progres (berat, check-in, keputusan penyesuaian, ringkasan AI).
/// keepAlive: dipanggil dari callback yang tidak mendengarkan provider ini.
@Riverpod(keepAlive: true)
class ProgressActions extends _$ProgressActions {
  @override
  FutureOr<void> build() {}

  ProgressRepository get _repo => ref.read(progressRepositoryProvider);

  Future<bool> _ok(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } on AiPlanException catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
      return false;
    } catch (e, st) {
      final failure = FailureMapper.from(e);
      // Tanpa isi data kesehatan di log.
      appLogger.w('Aksi progres gagal: ${failure.kind.name}');
      if (ref.mounted) state = AsyncError(failure, st);
      return false;
    }
  }

  Future<bool> saveWeight(String date, double kg) => _ok(() => _repo.saveWeight(date, kg));
  Future<bool> deleteWeight(String date) => _ok(() => _repo.deleteWeight(date));
  Future<bool> saveCheckIn(DailyCheckIn c) => _ok(() => _repo.saveCheckIn(c));

  BodyRepository get _body => ref.read(bodyRepositoryProvider);
  Future<bool> saveMeasurement(BodyMeasurement m) => _ok(() => _body.saveMeasurement(m));
  Future<bool> deleteMeasurement(String date) => _ok(() => _body.deleteMeasurement(date));
  Future<bool> deletePhoto(String id) => _ok(() => _body.deletePhoto(id));

  /// Ambil foto dari kamera/galeri lalu simpan. `null` bila dibatalkan.
  Future<bool?> addPhoto({
    required String date,
    required PhotoPose pose,
    required PhotoSource source,
  }) async {
    final String? path;
    try {
      path = await ref.read(photoPickerProvider).pick(source);
    } catch (e) {
      appLogger.w('Gagal mengambil foto: ${e.runtimeType}');
      return false;
    }
    if (path == null) return null;
    return _ok(() => _body.addPhoto(date: date, pose: pose, sourcePath: path!));
  }

  /// Simpan statistik minggu + status + usulan saat ini.
  Future<bool> saveReview(
    WeekSummary stats, {
    required GoalProgressStatus status,
    NutritionAdjustment? proposal,
  }) => _ok(() => _repo.saveReviewStats(stats, goalStatus: status, proposal: proposal));

  Future<bool> decide(String weekStart, {required bool accept}) =>
      _ok(() => _repo.decideAdjustment(weekStart, accept: accept));

  Future<bool> generateAiSummary(String weekStart) => _ok(() async {
    final goal = await ref.read(activeGoalProvider.future);
    if (goal == null) throw StateError('no-goal');
    await ref.read(weeklyReviewServiceProvider).generate(weekStart, goal: goal);
  });
}
