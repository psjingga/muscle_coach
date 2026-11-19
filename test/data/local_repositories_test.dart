import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/features/assessment/data/local_assessment_repository.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';
import 'package:musclecoach/features/goals/data/local_goal_repository.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';
import 'package:musclecoach/features/profile/data/local_profile_repository.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';

import '../fixtures/sample_assessment.dart';

final _catalog = {
  for (final e in AssetExerciseRepository.parse(
    File(AssetExerciseRepository.path).readAsStringSync(),
  ).exercises)
    e.id: e,
};

Matcher failure(FailureKind kind, [String? reason]) => isA<AppFailure>()
    .having((f) => f.kind, 'kind', kind)
    .having((f) => f.debugMessage, 'reason', reason ?? anything);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late LocalAssessmentRepository assessments;
  late LocalGoalRepository goals;
  late LocalProfileRepository profile;
  late LocalWorkoutRepository workouts;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    DateTime clock() => now;
    assessments = LocalAssessmentRepository(db, clock);
    goals = LocalGoalRepository(db, clock);
    profile = LocalProfileRepository(db);
    workouts = LocalWorkoutRepository(db, clock, () async => _catalog);
  });

  tearDown(() => db.close());

  Future<Goal> goal(String id) async => (await goals.watchGoal(id).first)!;

  Future<String> onboard([AssessmentData a = sample]) async {
    final goalId = await assessments.submit(a);
    await goals.confirm(goalId, acknowledgedWarnings: true);
    return goalId;
  }

  group('assessment', () {
    test('draft disimpan & dimuat beserta langkah', () async {
      expect(await assessments.loadDraft(), isNull);
      await assessments.saveDraft(sample, 3);
      final draft = await assessments.loadDraft();
      expect(draft?.step, 3);
      expect(draft?.data, sample);
    });

    test('submit: assessment final, usulan goal, profil; draft dihapus', () async {
      await assessments.saveDraft(sample, 6);
      final goalId = await assessments.submit(
        sample.copyWith(profile: sample.profile.copyWith(nickname: '  Budi ')),
      );
      expect(await assessments.loadDraft(), isNull);
      final g = await goal(goalId);
      expect(g.status, GoalStatus.proposed);
      expect(g.nutrition.targetKcal, greaterThan(0));
      final p = await profile.watch().first;
      expect(p?.displayName, 'Budi');
      expect(p?.onboardingCompleted, isFalse);
      expect(await assessments.loadAssessment(p!.latestAssessmentId!), isNotNull);
    });

    test('usulan lama yang belum dikonfirmasi diganti', () async {
      final first = await assessments.submit(sample);
      final second = await assessments.submit(sample);
      expect(await goals.watchGoal(first).first, isNull);
      expect((await goal(second)).status, GoalStatus.proposed);
    });

    test('menolak assessment tidak lengkap atau usia di luar rentang', () async {
      await expectLater(
        assessments.submit(const AssessmentData()),
        throwsA(failure(FailureKind.invalidInput)),
      );
      final child = sample.copyWith(profile: sample.profile.copyWith(birthDate: '2015-01-01'));
      await expectLater(assessments.submit(child), throwsA(failure(FailureKind.invalidInput)));
    });
  });

  group('konfirmasi goal', () {
    test('mengaktifkan goal, membuat target nutrisi, onboarding selesai', () async {
      final goalId = await onboard();
      expect((await goal(goalId)).status, GoalStatus.active);
      final p = (await profile.watch().first)!;
      expect(p.onboardingCompleted, isTrue);
      expect(p.activeGoalId, goalId);
      final target = await goals.watchNutritionTarget(p.activeNutritionTargetId!).first;
      expect(target?.proteinG, (await goal(goalId)).nutrition.proteinG);
    });

    test('goal baru mengarsipkan goal & target lama', () async {
      final first = await onboard();
      final oldTarget = (await profile.watch().first)!.activeNutritionTargetId!;
      final second = await onboard();
      expect((await goal(first)).status, GoalStatus.archived);
      expect((await goal(second)).status, GoalStatus.active);
      final rows = await db.select(db.nutritionTargets).get();
      expect(rows.where((r) => r.status == 'active').length, 1);
      expect(rows.firstWhere((r) => r.id == oldTarget).status, 'archived');
    });

    test(
      'menolak target perlu disesuaikan, gejala bahaya, konfirmasi ganda, tanpa acknowledgement',
      () async {
        final tooFast = await assessments.submit(
          sample.copyWith(goal: sample.goal.copyWith(targetWeightKg: 85, targetWeeks: 8)),
        );
        await expectLater(
          goals.confirm(tooFast, acknowledgedWarnings: true),
          throwsA(failure(FailureKind.invalidInput, 'goal-needs-adjustment')),
        );
        final danger = await assessments.submit(
          sample.copyWith(safety: const SafetySection(redFlags: [RedFlag.chestPain])),
        );
        await expectLater(
          goals.confirm(danger, acknowledgedWarnings: true),
          throwsA(failure(FailureKind.invalidInput, 'safety-stop')),
        );
        final flagged = await assessments.submit(
          sample.copyWith(safety: const SafetySection(medicalFlags: [MedicalFlag.medication])),
        );
        await expectLater(
          goals.confirm(flagged, acknowledgedWarnings: false),
          throwsA(failure(FailureKind.invalidInput, 'acknowledgement-required')),
        );
        await goals.confirm(flagged, acknowledgedWarnings: true);
        await expectLater(
          goals.confirm(flagged, acknowledgedWarnings: true),
          throwsA(failure(FailureKind.invalidInput, 'goal-not-proposed')),
        );
        await expectLater(
          goals.confirm('tidak-ada', acknowledgedWarnings: true),
          throwsA(failure(FailureKind.notFound)),
        );
      },
    );
  });

  group('program latihan', () {
    test('menolak sebelum onboarding selesai', () async {
      await assessments.submit(sample);
      await expectLater(
        workouts.createStarterPlan(),
        throwsA(failure(FailureKind.invalidInput, 'onboarding-required')),
      );
    });

    test('draft program + hari dari assessment terakhir; draft lama diganti', () async {
      await onboard();
      final first = await workouts.createStarterPlan();
      final planId = await workouts.createStarterPlan();
      final plan = (await workouts.watchPlan(planId).first)!;
      expect(plan.status, PlanStatus.draft);
      expect(plan.split, 'full_body');
      expect(plan.daysPerWeek, 3);
      final days = await workouts.watchDays(planId).first;
      expect(days.map((d) => d.weekday), [1, 3, 5]);
      expect(days.first.exercises.length, greaterThanOrEqualTo(3));
      expect(await workouts.watchPlan(first).first, isNull);
      expect(await workouts.watchDays(first).first, isEmpty); // cascade
    });

    test('aktivasi mengarsipkan program lama & mencatat di profil', () async {
      await onboard();
      final a = await workouts.createStarterPlan();
      await workouts.activatePlan(a);
      final b = await workouts.createStarterPlan();
      await workouts.activatePlan(b);
      expect((await workouts.watchPlan(a).first)!.status, PlanStatus.archived);
      expect((await workouts.watchPlan(b).first)!.status, PlanStatus.active);
      expect((await profile.watch().first)!.activeWorkoutPlanId, b);
      await expectLater(
        workouts.activatePlan(b),
        throwsA(failure(FailureKind.invalidInput, 'plan-not-draft')),
      );
      await expectLater(workouts.activatePlan('x'), throwsA(failure(FailureKind.notFound)));
    });
  });

  group('sesi latihan', () {
    late String planId;
    late PlanDay day;

    setUp(() async {
      await onboard();
      planId = await workouts.createStarterPlan();
      await workouts.activatePlan(planId);
      day = (await workouts.watchDays(planId).first).first;
    });

    SetLog set(int n, {double kg = 16, int reps = 10}) => SetLog(
      exerciseId: day.exercises.first.exerciseId,
      exerciseIndex: 0,
      setNumber: n,
      weightKg: kg,
      reps: reps,
      rir: 2,
      status: SetStatus.done,
    );

    test('mulai, catat set, selesaikan, riwayat & performa terakhir', () async {
      final id = await workouts.startSession(planId: planId, day: day, date: '2026-11-16');
      final inProgress = await workouts.findInProgress(
        planId: planId,
        dayId: day.id,
        date: '2026-11-16',
      );
      expect(inProgress?.id, id);
      expect(inProgress?.planned, day.exercises);

      await workouts.logSet(id, set(1));
      await workouts.logSet(id, set(2, kg: 17.5));
      final sets = await workouts.watchSets(id).first;
      expect(sets.map((s) => s.weightKg), containsAll([16.0, 17.5]));
      await workouts.deleteSet(id, sets.first.id);
      expect(await workouts.watchSets(id).first, hasLength(1));

      await workouts.completeSession(id, notes: 'Lancar', energy: 4);
      final done = (await workouts.watchSession(id).first)!;
      expect(done.status, SessionStatus.completed);
      expect(done.energy, 4);
      expect(
        await workouts.findInProgress(planId: planId, dayId: day.id, date: '2026-11-16'),
        isNull,
      );
      expect((await workouts.watchHistory().first).map((s) => s.id), [id]);

      final last = await workouts.lastCompleted(planId: planId, dayId: day.id);
      expect(last?.session.id, id);
      expect(last?.sets, hasLength(1));
    });

    test('hapus sesi ikut menghapus set-nya', () async {
      final id = await workouts.startSession(planId: planId, day: day, date: '2026-11-16');
      await workouts.logSet(id, set(1));
      await workouts.deleteSession(id);
      expect(await workouts.watchSession(id).first, isNull);
      expect(await db.select(db.setLogs).get(), isEmpty);
    });

    test('hapus semua data → profil kosong (kembali ke onboarding)', () async {
      final id = await workouts.startSession(planId: planId, day: day, date: '2026-11-16');
      await workouts.logSet(id, set(1));
      await profile.wipeAllData();
      expect(await profile.watch().first, isNull);
      expect(await db.select(db.setLogs).get(), isEmpty);
      expect(await db.select(db.goals).get(), isEmpty);
      expect(await db.select(db.workoutPlans).get(), isEmpty);
    });
  });
}
