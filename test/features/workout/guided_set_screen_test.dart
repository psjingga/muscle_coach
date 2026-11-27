import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/assessment/data/local_assessment_repository.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';
import 'package:musclecoach/features/goals/data/local_goal_repository.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/features/workout/domain/guided_set.dart';
import 'package:musclecoach/features/workout/presentation/guided/guided_cues.dart';
import 'package:musclecoach/features/workout/presentation/guided/guided_set_screen.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../../fixtures/sample_assessment.dart';

class _RecordingCues implements GuidedCuePlayer {
  final played = <GuidedCue>[];
  @override
  Future<void> play(GuidedCue cue) async => played.add(cue);
  final awake = <bool>[];
  @override
  Future<void> keepAwake(bool on) async => awake.add(on);
  @override
  Future<void> dispose() async {}
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  var now = DateTime(2026, 11, 27, 10);
  DateTime clock() => now;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  testWidgets('set terpandu: aba-aba → rep → Lanjut → akhiri → simpan set', (tester) async {
    late LocalWorkoutRepository workouts;
    late String sessionId;
    const planned = PlannedExercise(
      exerciseId: 'barbell_back_squat',
      name: 'Barbell Back Squat',
      sets: 3,
      repMin: 2,
      repMax: 3,
      restSec: 90,
      rirMin: 1,
      rirMax: 2,
    );
    await tester.runAsync(() async {
      final goalId = await LocalAssessmentRepository(db, clock).submit(sample);
      await LocalGoalRepository(db, clock).confirm(goalId, acknowledgedWarnings: true);
      final catalog = {
        for (final e in AssetExerciseRepository.parse(
          File(AssetExerciseRepository.path).readAsStringSync(),
        ).exercises)
          e.id: e,
      };
      workouts = LocalWorkoutRepository(db, clock, () async => catalog);
      final planId = await workouts.createStarterPlan();
      await workouts.activatePlan(planId);
      final day = (await workouts.watchDays(planId).first).first;
      sessionId = await workouts.startSession(planId: planId, day: day, date: '2026-11-27');
    });

    final cues = _RecordingCues();
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(clock),
          guidedCuePlayerFactoryProvider.overrideWithValue(({required bool sound}) => cues),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GuidedSetScreen(
            sessionId: sessionId,
            exerciseIndex: 0,
            planned: planned,
            setNumber: 1,
            exercise: null,
            initialWeight: 40,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Target 2–3 rep'), findsOneWidget);
    expect(find.text('Tempo 2-1-1'), findsOneWidget);

    Future<void> advance(double seconds) async {
      now = now.add(Duration(milliseconds: (seconds * 1000).round()));
      await tester.pump(const Duration(milliseconds: 16));
    }

    await tester.tap(find.byKey(const Key('guided-start')));
    await tester.pump();
    expect(find.text('BERSIAP'), findsOneWidget);
    expect(find.text('3'), findsWidgets);

    await advance(3); // aba-aba selesai → TURUN
    expect(find.text('TURUN'), findsWidgets);
    expect(find.text('2'), findsWidgets);

    await advance(4); // turun 2 + tahan 1 + naik 1 → rep 1 selesai
    await advance(.1);
    expect(find.text('Rep 1 selesai'), findsOneWidget);
    expect(find.byKey(const Key('guided-next')), findsOneWidget);

    // Tidak lanjut sendiri: tetap menunggu ketukan.
    await advance(30);
    expect(find.text('Rep 1 selesai'), findsOneWidget);

    await tester.tap(find.byKey(const Key('guided-next')));
    await tester.pump();
    await advance(4.1);
    expect(find.text('Rep 2 selesai'), findsOneWidget);

    await tester.tap(find.byKey(const Key('guided-finish-now')));
    await tester.pump();
    expect(find.text('Set 1 selesai'), findsOneWidget);
    expect(find.text('2'), findsWidgets); // repetisi terisi otomatis

    await tester.tap(find.byKey(const Key('guided-rir-1')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('guided-save')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    final sets = await tester.runAsync(() => workouts.watchSets(sessionId).first);
    expect(sets!.single.reps, 2);
    expect(sets.single.weightKg, 40);
    expect(sets.single.rir, 1);
    expect(
      cues.played,
      containsAllInOrder([
        GuidedCue.countdownTick,
        GuidedCue.go,
        GuidedCue.repComplete,
        GuidedCue.setComplete,
      ]),
    );

    expect(cues.awake.first, isTrue); // layar menyala selama set
    expect(cues.awake.last, isFalse); // dilepas setelah selesai

    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 10));
    }
  });

  testWidgets('atur tempo dari layar siap: label & fase ikut berubah', (tester) async {
    const planned = PlannedExercise(
      exerciseId: 'barbell_back_squat',
      name: 'Barbell Back Squat',
      sets: 3,
      repMin: 8,
      repMax: 12,
      restSec: 90,
      rirMin: 1,
      rirMax: 2,
    );
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(clock),
          guidedCuePlayerFactoryProvider.overrideWithValue(
            ({required bool sound}) => _RecordingCues(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const GuidedSetScreen(
            sessionId: 's',
            exerciseIndex: 0,
            planned: planned,
            setNumber: 1,
            exercise: null,
          ),
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    expect(find.text('Tempo 2-1-1'), findsOneWidget);

    await tester.tap(find.byKey(const Key('guided-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('guided-eccentric-plus')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('guided-eccentric-value')), findsOneWidget);
    expect(find.text('3 dtk'), findsWidgets);

    Navigator.of(tester.element(find.byKey(const Key('guided-sound')))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Tempo 3-1-1'), findsOneWidget);
    expect(find.textContaining('turun 3 dtk'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 10));
    }
  });
}
