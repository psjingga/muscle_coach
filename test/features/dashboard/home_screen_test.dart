import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/assessment/data/local_assessment_repository.dart';
import 'package:musclecoach/features/dashboard/presentation/screens/home_screen.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';
import 'package:musclecoach/features/goals/data/local_goal_repository.dart';
import 'package:musclecoach/features/nutrition/presentation/providers/nutrition_providers.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../../fixtures/sample_assessment.dart';
import '../nutrition/nutrition_repository_test.dart' show foodSource;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late LocalWorkoutRepository workouts;
  late String planId;
  late List<PlanDay> days;
  // Jam bisa digeser per tes (mulai/selesai sesi untuk durasi).
  var now = DateTime(2026, 11, 16, 10);
  DateTime clock() => now;

  /// Tanggal pekan 16–22 Nov 2026 (Senin = 16) untuk hari ISO [weekday].
  DateTime dateOf(int weekday, {int hour = 10, int minute = 0}) =>
      DateTime(2026, 11, 15 + weekday, hour, minute);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> seed(WidgetTester tester) => tester.runAsync(() async {
    now = DateTime(2026, 11, 16, 8);
    final goalId = await LocalAssessmentRepository(db, clock).submit(sample);
    await LocalGoalRepository(db, clock).confirm(goalId, acknowledgedWarnings: true);
    final catalog = {
      for (final e in AssetExerciseRepository.parse(
        File(AssetExerciseRepository.path).readAsStringSync(),
      ).exercises)
        e.id: e,
    };
    workouts = LocalWorkoutRepository(db, clock, () async => catalog);
    planId = await workouts.createStarterPlan();
    await workouts.activatePlan(planId);
    days = await workouts.watchDays(planId).first;
  });

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        GoRoute(path: '/session/:id', builder: (_, s) => Text('sesi ${s.pathParameters['id']}')),
        GoRoute(path: '/day/:p/:d', builder: (_, s) => Text('hari ${s.pathParameters['d']}')),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(clock),
          foodDataSourceProvider.overrideWithValue(foodSource),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark(),
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 10));
    }
  }

  testWidgets('hari istirahat: kartu pemulihan + latihan berikutnya + mulai lebih awal', (
    tester,
  ) async {
    await seed(tester);
    final training = {for (final d in days) d.weekday};
    final rest = [for (var w = 1; w <= 7; w++) w].firstWhere((w) => !training.contains(w));
    now = dateOf(rest);
    await pump(tester);

    expect(find.byKey(const Key('home-rest')), findsOneWidget);
    expect(find.text('Hari istirahat'), findsOneWidget);
    expect(find.text('Waktunya pulih'), findsOneWidget);
    expect(find.byKey(const Key('week-rest-today')), findsOneWidget);
    expect(find.byKey(const Key('home-start-workout')), findsNothing);
    expect(find.textContaining('Berikutnya · '), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-start-early')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(find.textContaining('sesi '), findsOneWidget);
    await finish(tester);
  });

  testWidgets('hari latihan: mulai, lalu "Lanjutkan latihan" saat sesi berjalan', (tester) async {
    await seed(tester);
    final day = days.first;
    now = dateOf(day.weekday);
    await pump(tester);
    expect(find.text('Latihan hari ini'), findsOneWidget);
    expect(find.text('Mulai latihan'), findsOneWidget);

    await tester.runAsync(
      () => workouts.startSession(planId: planId, day: day, date: '2026-11-${15 + day.weekday}'),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(find.text('Lanjutkan latihan'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('latihan hari ini selesai: ringkasan durasi/set/volume', (tester) async {
    await seed(tester);
    final day = days.first;
    await tester.runAsync(() async {
      now = dateOf(day.weekday, hour: 7);
      final sid = await workouts.startSession(
        planId: planId,
        day: day,
        date: '2026-11-${15 + day.weekday}',
      );
      await workouts.logSet(
        sid,
        SetLog(
          exerciseId: day.exercises.first.exerciseId,
          exerciseIndex: 0,
          setNumber: 1,
          weightKg: 40,
          reps: 10,
          status: SetStatus.done,
        ),
      );
      now = dateOf(day.weekday, hour: 7, minute: 52);
      await workouts.completeSession(sid);
    });
    now = dateOf(day.weekday, hour: 18);
    await pump(tester);

    expect(find.byKey(const Key('home-done')), findsOneWidget);
    expect(find.text('Selesai hari ini'), findsOneWidget);
    expect(find.byKey(const Key('home-start-workout')), findsNothing);
    expect(find.textContaining('52'), findsWidgets);
    expect(find.byKey(const Key('home-session-summary')), findsOneWidget);
    expect(find.byKey(const Key('home-next-workout')), findsOneWidget);
    await finish(tester);
  });
}
