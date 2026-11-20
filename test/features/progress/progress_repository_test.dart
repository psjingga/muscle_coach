import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/features/ai_coach/application/ai_plan_service.dart';
import 'package:musclecoach/features/ai_coach/data/ai_repository.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_config.dart';
import 'package:musclecoach/features/assessment/data/local_assessment_repository.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';
import 'package:musclecoach/features/goals/data/local_goal_repository.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';
import 'package:musclecoach/features/nutrition/data/nutrition_repository.dart';
import 'package:musclecoach/features/nutrition/domain/food.dart';
import 'package:musclecoach/features/nutrition/domain/food_log.dart';
import 'package:musclecoach/features/profile/data/local_profile_repository.dart';
import 'package:musclecoach/features/progress/application/weekly_review_service.dart';
import 'package:musclecoach/features/progress/data/progress_repository.dart';
import 'package:musclecoach/features/progress/domain/progress_math.dart';
import 'package:musclecoach/features/progress/domain/progress_models.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';

import '../../fixtures/sample_assessment.dart';
import '../ai_coach/ai_coach_test.dart' show FakeAiClient, MemoryKeyStore;
import '../../data/local_repositories_test.dart' show failure;
import '../nutrition/nutrition_repository_test.dart' show foodSource;
import 'progress_math_test.dart' show goal;

const stats = WeekSummary(
  weekStart: '2026-11-09',
  weighIns: 3,
  avgWeightKg: 70.3,
  prevAvgWeightKg: 70.0,
  sessionsCompleted: 3,
  sessionsPlanned: 3,
  volumeKg: 5000,
  prevVolumeKg: 4500,
  setsDone: 30,
  loggedDays: 5,
  avgKcal: 2500,
  targetKcal: 2550,
  checkIns: 4,
  avgSleepHours: 7,
  avgEnergy: 3.5,
  discomfortDays: 0,
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late LocalProgressRepository repo;
  DateTime clock() => now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalProgressRepository(db, clock);
  });

  tearDown(() => db.close());

  group('Berat & check-in', () {
    test('berat: satu per tanggal (diperbarui), dibulatkan 0,1, batas wajar', () async {
      await repo.saveWeight('2026-11-18', 70.04);
      await repo.saveWeight('2026-11-18', 70.36);
      await repo.saveWeight('2026-11-17', 70.0);
      final w = await repo.watchWeights().first;
      expect(w.map((e) => (e.date, e.kg)), [('2026-11-17', 70.0), ('2026-11-18', 70.4)]);
      for (final kg in [10.0, 500.0]) {
        expect(repo.saveWeight('2026-11-18', kg), throwsA(failure(FailureKind.invalidInput)));
      }
      expect(repo.saveWeight('18-11-2026', 70), throwsA(failure(FailureKind.invalidInput, 'date')));
      await repo.deleteWeight('2026-11-17');
      expect(await repo.watchWeights().first, hasLength(1));
    });

    test('check-in: upsert per tanggal, teks dirapikan, validasi skala', () async {
      await repo.saveCheckIn(
        const DailyCheckIn(date: '2026-11-19', sleepHours: 7, energy: 4, notes: '  sibuk  '),
      );
      await repo.saveCheckIn(
        const DailyCheckIn(date: '2026-11-19', sleepHours: 6.5, energy: 3, discomfort: ' '),
      );
      final c = (await repo.watchCheckIns().first).single;
      expect(c.sleepHours, 6.5);
      expect(c.energy, 3);
      expect(c.notes, isNull);
      expect(c.discomfort, isNull);
      for (final bad in [
        const DailyCheckIn(date: '2026-11-19', sleepHours: 25),
        const DailyCheckIn(date: '2026-11-19', energy: 6),
        const DailyCheckIn(date: '2026-11-19', mood: 0),
      ]) {
        expect(repo.saveCheckIn(bad), throwsA(failure(FailureKind.invalidInput)));
      }
    });
  });

  group('Data agregat', () {
    test('asupan per tanggal dari catatan makanan', () async {
      final nutrition = LocalNutritionRepository(db, clock, foodSource);
      final nasi = (await nutrition.catalog())[Food.tkpiId('AP001')]!;
      await nutrition.logFood(date: '2026-11-18', meal: MealSlot.lunch, food: nasi, grams: 100);
      await nutrition.logFood(date: '2026-11-18', meal: MealSlot.dinner, food: nasi, grams: 200);
      await nutrition.logManual(
        date: '2026-11-19',
        meal: MealSlot.snack,
        name: 'x',
        nutrients: const Nutrients(kcal: 100, protein: 5, carbs: 0, fat: 0),
      );
      final i = await repo.watchIntake().first;
      expect(i.map((d) => (d.date, d.kcal)), [('2026-11-18', 540.0), ('2026-11-19', 100.0)]);
      expect(i.first.protein, closeTo(9, 1e-9));
    });

    test('sesi selesai + set dikerjakan; set waktu ditandai; rencana per minggu', () async {
      final goalId = await LocalAssessmentRepository(db, clock).submit(sample);
      await LocalGoalRepository(db, clock).confirm(goalId, acknowledgedWarnings: true);
      final catalog = {
        for (final e in AssetExerciseRepository.parse(
          File(AssetExerciseRepository.path).readAsStringSync(),
        ).exercises)
          e.id: e,
      };
      final workouts = LocalWorkoutRepository(db, clock, () async => catalog);
      final planId = await workouts.createStarterPlan();
      await workouts.activatePlan(planId);
      expect(await repo.plannedSessionsPerWeek(), 3);

      final day = (await workouts.watchDays(planId).first).first;
      final sid = await workouts.startSession(planId: planId, day: day, date: '2026-11-18');
      await workouts.logSet(
        sid,
        const SetLog(
          exerciseId: 'x',
          exerciseIndex: 0,
          setNumber: 1,
          weightKg: 20,
          reps: 10,
          status: SetStatus.done,
        ),
      );
      await workouts.logSet(
        sid,
        const SetLog(
          exerciseId: 'x',
          exerciseIndex: 0,
          setNumber: 2,
          reps: 0,
          status: SetStatus.skipped,
        ),
      );
      expect(await repo.watchTraining().first, isEmpty, reason: 'sesi belum selesai');
      await workouts.completeSession(sid, discomfort: 'bahu');
      final t = (await repo.watchTraining().first).single;
      expect(t.date, '2026-11-18');
      expect(t.sets.single.volumeKg, 200);
      expect(t.discomfort, isTrue);
    });
  });

  group('Ringkasan mingguan & penyesuaian', () {
    late String oldTargetId;

    setUp(() async {
      final goalId = await LocalAssessmentRepository(db, clock).submit(sample);
      await LocalGoalRepository(db, clock).confirm(goalId, acknowledgedWarnings: true);
      oldTargetId = (await readProfile(db))!.activeNutritionTargetId!;
    });

    Future<NutritionPlan> activeTarget() async {
      final id = (await readProfile(db))!.activeNutritionTargetId!;
      final row = await (db.select(db.nutritionTargets)..where((t) => t.id.equals(id))).getSingle();
      expect(row.status, 'active');
      return NutritionPlan.fromJson(jsonDecode(row.data) as Map<String, dynamic>);
    }

    NutritionAdjustment up(NutritionPlan p) => NutritionAdjustment(
      deltaKcal: 100,
      deltaCarbsG: 25,
      direction: RateDirection.below,
      newKcal: p.proteinG * 4 + (p.carbsG + 25) * 4 + p.fatG * 9,
      newCarbsG: p.carbsG + 25,
    );

    test('simpan statistik; terima usulan → target baru aktif, lama diarsipkan', () async {
      final before = await activeTarget();
      await repo.saveReviewStats(
        stats,
        goalStatus: GoalProgressStatus.adjustTarget,
        proposal: up(before),
      );
      await repo.decideAdjustment('2026-11-09', accept: true);
      final after = await activeTarget();
      expect(after.carbsG, before.carbsG + 25);
      expect(after.targetKcal, up(before).newKcal);
      expect(after.proteinG, before.proteinG);
      expect(after.energySplitPct.carbs, greaterThan(before.energySplitPct.carbs));
      final old = await (db.select(
        db.nutritionTargets,
      )..where((t) => t.id.equals(oldTargetId))).getSingle();
      expect(old.status, 'archived');
      final r = (await repo.watchReview('2026-11-09').first)!;
      expect(r.decision, 'accepted');
      expect(
        repo.decideAdjustment('2026-11-09', accept: false),
        throwsA(failure(FailureKind.invalidInput, 'already-decided')),
      );

      // Statistik diperbarui → keputusan & usulan lama dipertahankan.
      await repo.saveReviewStats(stats, goalStatus: GoalProgressStatus.onTrack);
      final r2 = (await repo.watchReview('2026-11-09').first)!;
      expect(r2.decision, 'accepted');
      expect(r2.proposal, isNotNull);
      expect(r2.goalStatus, GoalProgressStatus.onTrack);
    });

    test('tolak usulan → target tidak berubah', () async {
      final before = await activeTarget();
      await repo.saveReviewStats(
        stats,
        goalStatus: GoalProgressStatus.adjustTarget,
        proposal: up(before),
      );
      await repo.decideAdjustment('2026-11-09', accept: false);
      expect((await activeTarget()).targetKcal, before.targetKcal);
      expect((await readProfile(db))!.activeNutritionTargetId, oldTargetId);
      expect((await repo.watchReview('2026-11-09').first)!.decision, 'declined');
    });

    test('tanpa usulan → tidak bisa diputuskan', () async {
      await repo.saveReviewStats(stats, goalStatus: GoalProgressStatus.onTrack);
      expect(
        repo.decideAdjustment('2026-11-09', accept: true),
        throwsA(failure(FailureKind.notFound, 'proposal-missing')),
      );
    });

    group('WeeklyReviewService', () {
      late AiRepository aiRepo;
      late MemoryKeyStore keys;

      setUp(() async {
        aiRepo = AiRepository(db);
        keys = MemoryKeyStore('kunci-uji');
        await aiRepo.setConsent(accepted: true, now: now);
        await repo.saveReviewStats(stats, goalStatus: GoalProgressStatus.onTrack);
      });

      WeeklyReviewService service(FakeAiClient c) => WeeklyReviewService(
        progress: repo,
        ai: aiRepo,
        client: c,
        keys: keys,
        clock: clock,
        model: () async => AiConfig.defaultModel,
      );

      String json({List<String>? suggestions}) => jsonEncode({
        'schemaVersion': 1,
        'summary': 'Minggu yang konsisten.',
        'wentWell': ['Semua sesi selesai'],
        'obstacles': <String>[],
        'suggestions': suggestions ?? ['Pertahankan jam tidur'],
      });

      test('berhasil: ringkasan tersimpan, prompt tanpa berat absolut, log', () async {
        final client = FakeAiClient([json()]);
        await service(client).generate('2026-11-09', goal: goal);
        final r = (await repo.watchReview('2026-11-09').first)!;
        expect(r.aiSummary!.summary, 'Minggu yang konsisten.');
        expect(r.model, 'gemini-test');
        expect(r.promptVersion, 'weekly_review.v1');
        expect(client.requests.single, isNot(contains('70.3')));
        final log = await db.select(db.aiGenerationLogs).getSingle();
        expect((log.kind, log.status), ('weekly_review', 'success'));
      });

      test('menyebut angka kalori → retry; tetap salah → gagal tanpa simpan', () async {
        final client = FakeAiClient([
          json(suggestions: ['Tambah 300 kcal']),
          json(),
        ]);
        await service(client).generate('2026-11-09', goal: goal);
        expect(client.requests.last, contains('angka_target'));

        await repo.saveReviewStats(
          stats.copyWithWeek('2026-11-02'),
          goalStatus: GoalProgressStatus.onTrack,
        );
        final bad = FakeAiClient([
          json(suggestions: ['Tambah 300 kcal']),
          'bukan json',
        ]);
        await expectLater(
          service(bad).generate('2026-11-02', goal: goal),
          throwsA(isA<AiPlanException>().having((e) => e.error, 'e', AiPlanError.invalidOutput)),
        );
        expect((await repo.watchReview('2026-11-02').first)!.aiSummary, isNull);
      });

      test('ringkasan belum tersimpan → notFound', () async {
        await expectLater(
          service(FakeAiClient([])).generate('2020-01-06', goal: goal),
          throwsA(failure(FailureKind.notFound, 'review-missing')),
        );
      });
    });
  });
}

extension on WeekSummary {
  WeekSummary copyWithWeek(String ws) => WeekSummary(
    weekStart: ws,
    weighIns: weighIns,
    sessionsCompleted: sessionsCompleted,
    volumeKg: volumeKg,
    setsDone: setsDone,
    loggedDays: loggedDays,
    checkIns: checkIns,
    discomfortDays: discomfortDays,
  );
}
