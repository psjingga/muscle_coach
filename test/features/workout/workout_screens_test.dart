import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/features/workout/presentation/providers/workout_providers.dart';
import 'package:musclecoach/features/workout/presentation/screens/plan_screen.dart';
import 'package:musclecoach/features/workout/presentation/screens/session_screen.dart';
import 'package:musclecoach/features/workout/presentation/screens/workout_screen.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../../fixtures/workout_fixtures.dart';
import '../../helpers/fakes.dart';

void main() {
  late MockWorkoutRepository repo;
  final now = DateTime(2026, 11, 19, 10); // Kamis

  setUpAll(() {
    registerFallbackValue(
      const SetLog(
        exerciseId: 'x',
        exerciseIndex: 0,
        setNumber: 1,
        reps: 1,
        status: SetStatus.done,
      ),
    );
  });

  Future<void> pump(
    WidgetTester tester, {
    required String initial,
    UserProfile profile = const UserProfile(onboardingCompleted: true),
  }) async {
    tester.view.physicalSize = const Size(900, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/workout', builder: (_, _) => const WorkoutScreen()),
        GoRoute(
          path: '/plan/:id',
          builder: (_, s) => PlanScreen(planId: s.pathParameters['id']!),
        ),
        GoRoute(
          path: '/session/:id',
          builder: (_, s) => SessionScreen(sessionId: s.pathParameters['id']!),
        ),
        GoRoute(path: '/day/:p/:d', builder: (_, s) => Text('day ${s.pathParameters['d']}')),
        GoRoute(path: '/history', builder: (_, _) => const Text('history')),
        GoRoute(path: '/exercises', builder: (_, _) => const Text('exercises')),
        GoRoute(
          path: '/exercise/:id',
          builder: (_, s) => Text('exercise ${s.pathParameters['id']}'),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(repo),
          userProfileProvider.overrideWith((ref) => Stream<UserProfile?>.value(profile)),
          clockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp.router(
          // Tema aplikasi: menangkap error layout tombol (lebar min. tak terbatas).
          theme: AppTheme.light(),
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => repo = MockWorkoutRepository());

  group('Tab Latihan', () {
    testWidgets('tanpa program: buat program awal lalu buka pratinjau', (tester) async {
      when(() => repo.createStarterPlan()).thenAnswer((_) async => 'p9');
      when(() => repo.watchPlan('p9'))
          .thenAnswer((_) => Stream.value(activePlan.copyWith(id: 'p9', status: PlanStatus.draft)));
      when(() => repo.watchDays('p9')).thenAnswer((_) => Stream.value([dayA, dayB]));
      await pump(tester, initial: '/workout');
      expect(find.text('Belum ada program latihan'), findsOneWidget);

      await tester.tap(find.text('Buat program awal'));
      await tester.pumpAndSettle();
      expect(find.text('Draft program'), findsOneWidget);
      expect(find.text('Aktifkan program'), findsOneWidget);
      expect(find.textContaining('Periksa setiap gerakan'), findsOneWidget);
      expect(find.text('3 set × 8–12 repetisi\nIstirahat 2 mnt · RIR 2–3'), findsNWidgets(3));
      expect(find.text('2 set × 20–40 detik\nIstirahat 1 mnt · RIR 2–3'), findsOneWidget);
      expect(find.text('Prioritas'), findsOneWidget);
    });

    testWidgets('program aktif: jadwal mingguan dengan penanda hari ini', (tester) async {
      when(() => repo.watchPlan('p1')).thenAnswer((_) => Stream.value(activePlan));
      when(() => repo.watchDays('p1')).thenAnswer((_) => Stream.value([dayA, dayB]));
      when(() => repo.watchHistory()).thenAnswer((_) => Stream.value(const []));
      await pump(
        tester,
        initial: '/workout',
        profile: const UserProfile(activeWorkoutPlanId: 'p1'),
      );
      expect(find.text('Seluruh tubuh A'), findsOneWidget);
      expect(find.text('Seluruh tubuh B'), findsOneWidget);
      expect(find.text('Sabtu'), findsOneWidget);
      expect(find.text('Hari ini'), findsOneWidget);
      expect(find.text('0/2 sesi'), findsOneWidget);
      expect(find.byKey(const Key('workout-start-today')), findsOneWidget);
      await tester.tap(find.text('Seluruh tubuh A'));
      await tester.pumpAndSettle();
      expect(find.text('day d1'), findsOneWidget);
    });
  });

  group('Tab Latihan — minggu ini', () {
    testWidgets('sesi selesai hari ini: centang, progres minggu, riwayat terakhir', (tester) async {
      when(() => repo.watchPlan('p1')).thenAnswer((_) => Stream.value(activePlan));
      when(() => repo.watchDays('p1')).thenAnswer((_) => Stream.value([dayA, dayB]));
      final done = session.copyWith(status: SessionStatus.completed, energy: 4);
      when(() => repo.watchHistory()).thenAnswer((_) => Stream.value([done]));
      when(() => repo.watchSets('s1'))
          .thenAnswer((_) => Stream.value([doneSet(0, 1, kg: 16), doneSet(0, 2, kg: 16)]));
      await pump(
        tester,
        initial: '/workout',
        profile: const UserProfile(activeWorkoutPlanId: 'p1'),
      );
      expect(find.text('Kamis · Selesai'), findsOneWidget);
      expect(find.text('1/2 sesi'), findsOneWidget);
      expect(find.byKey(const Key('workout-start-today')), findsNothing);
      expect(find.text('Riwayat terakhir'), findsOneWidget);
      expect(find.textContaining('2 set · 320 kg'), findsOneWidget);
      expect(find.text('Energi 4/5'), findsOneWidget);
    });
  });

  group('Pratinjau program', () {
    testWidgets('program AI: badge estimasi, alasan program & per gerakan', (tester) async {
      when(() => repo.watchPlan('p8')).thenAnswer(
        (_) => Stream.value(
          activePlan.copyWith(
            id: 'p8',
            status: PlanStatus.draft,
            source: 'ai_generated',
            model: 'gemini-3.6-flash',
            rationale: 'Full body 2x seminggu untuk pemula.',
          ),
        ),
      );
      when(() => repo.watchDays('p8')).thenAnswer(
        (_) => Stream.value([
          dayA.copyWith(exercises: [gobletSquat.copyWith(rationale: 'Pola squat dasar.')]),
        ]),
      );
      await pump(tester, initial: '/plan/p8');
      expect(find.text('Estimasi AI · gemini-3.6-flash'), findsOneWidget);
      expect(find.text('Full body 2x seminggu untuk pemula.'), findsOneWidget);
      expect(find.textContaining('Pola squat dasar.'), findsOneWidget);
      expect(find.textContaining('Diperiksa aplikasi'), findsOneWidget);
      expect(find.textContaining('bukan AI'), findsNothing);
    });

    testWidgets('mengganti program aktif meminta konfirmasi', (tester) async {
      when(() => repo.watchPlan('p9'))
          .thenAnswer((_) => Stream.value(activePlan.copyWith(id: 'p9', status: PlanStatus.draft)));
      when(() => repo.watchDays('p9')).thenAnswer((_) => Stream.value([dayA]));
      when(() => repo.watchPlan('p1')).thenAnswer((_) => Stream.value(activePlan));
      when(() => repo.watchDays('p1')).thenAnswer((_) => Stream.value([dayA]));
      when(() => repo.activatePlan('p9')).thenAnswer((_) async {});
      await pump(
        tester,
        initial: '/plan/p9',
        profile: const UserProfile(activeWorkoutPlanId: 'p1'),
      );

      await tester.tap(find.text('Aktifkan program'));
      await tester.pumpAndSettle();
      expect(find.text('Ganti program aktif?'), findsOneWidget);
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      verifyNever(() => repo.activatePlan(any()));

      await tester.tap(find.text('Aktifkan program'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ganti'));
      await tester.pumpAndSettle();
      verify(() => repo.activatePlan('p9')).called(1);
      expect(find.text('Program aktif! Selamat berlatih.'), findsOneWidget);
    });
  });

  group('Sesi latihan', () {
    late StreamController<List<SetLog>> sets;

    setUp(() {
      sets = StreamController<List<SetLog>>.broadcast();
      final logged = <SetLog>[];
      when(() => repo.watchSession('s1')).thenAnswer((_) => Stream.value(session));
      when(() => repo.watchSets('s1')).thenAnswer((_) async* {
        yield logged;
        yield* sets.stream;
      });
      when(() => repo.lastCompleted(planId: 'p1', dayId: 'd1')).thenAnswer(
        (_) async => (
          session: session.copyWith(id: 's0', status: SessionStatus.completed),
          sets: [for (var i = 1; i <= 3; i++) doneSet(0, i, kg: 16, reps: 12, rir: 2)],
        ),
      );
      when(() => repo.logSet('s1', any())).thenAnswer((inv) async {
        final s = inv.positionalArguments[1] as SetLog;
        logged.add(s.copyWith(id: 'n${logged.length}'));
        sets.add(List.of(logged));
      });
      when(
        () => repo.completeSession(
          's1',
          notes: any(named: 'notes'),
          energy: any(named: 'energy'),
          discomfort: any(named: 'discomfort'),
        ),
      ).thenAnswer((_) async {});
    });

    tearDown(() => sets.close());

    testWidgets('target, riwayat sesi lalu, saran naik beban, dan prefill', (tester) async {
      await pump(tester, initial: '/session/s1');
      expect(find.text('1. Goblet Squat'), findsOneWidget);
      // Kolom "Sebelumnya": set aktif + 2 set rencana berikutnya.
      expect(find.text('16 × 12'), findsNWidgets(3));
      expect(find.textContaining('coba naikkan beban'), findsOneWidget);
      expect(find.text('0/8 set'), findsOneWidget);
      // Hanya gerakan aktif yang terbuka; gerakan lain ringkas.
      expect(find.byKey(const ValueKey('ex-collapsed-1')), findsOneWidget);
      final weight = tester.widget<TextField>(find.byKey(const ValueKey('weight-0')));
      expect(weight.controller!.text, '16');
    });

    testWidgets('catat set → set tampil, timer istirahat berjalan', (tester) async {
      await pump(tester, initial: '/session/s1');
      await tester.enterText(find.byKey(const ValueKey('weight-0')), '17,5');
      await tester.enterText(find.byKey(const ValueKey('reps-0')), '10');
      await tester.tap(find.byKey(const ValueKey('log-0')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final saved = verify(() => repo.logSet('s1', captureAny())).captured.single as SetLog;
      expect(saved.weightKg, 17.5);
      expect(saved.reps, 10);
      final row = find.byKey(const ValueKey('set-0-1'));
      expect(row, findsOneWidget);
      expect(find.descendant(of: row, matching: find.text('17,5')), findsOneWidget);
      expect(find.descendant(of: row, matching: find.text('10')), findsOneWidget);
      expect(find.text('1/8 set'), findsOneWidget);
      final rest = find.byKey(const Key('rest-remaining'));
      expect(tester.widget<Text>(rest).data, '2:00');

      await tester.tap(find.text('+15 dtk'));
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.widget<Text>(rest).data, '2:15');
      await tester.tap(find.text('Selesai'));
      await tester.pump(const Duration(milliseconds: 600));
      expect(rest, findsNothing);
    });

    testWidgets('repetisi kosong → pesan error, tidak tersimpan', (tester) async {
      await pump(tester, initial: '/session/s1');
      await tester.tap(find.byKey(const ValueKey('ex-collapsed-1')));
      await tester.pump();
      await tester.enterText(find.byKey(const ValueKey('reps-1')), '');
      await tester.tap(find.byKey(const ValueKey('log-1')));
      await tester.pump();
      expect(find.text('Isi repetisi.'), findsOneWidget);
      verifyNever(() => repo.logSet(any(), any()));
    });

    testWidgets('lewati gerakan → semua set tersisa dilewati, gerakan berikutnya terbuka', (
      tester,
    ) async {
      await pump(tester, initial: '/session/s1');
      await tester.tap(find.byKey(const ValueKey('skip-0')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      final saved = verify(() => repo.logSet('s1', captureAny())).captured.cast<SetLog>();
      expect(saved.map((s) => (s.exerciseIndex, s.setNumber, s.status)), [
        (0, 1, SetStatus.skipped),
        (0, 2, SetStatus.skipped),
        (0, 3, SetStatus.skipped),
      ]);
      expect(find.byKey(const ValueKey('ex-collapsed-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('weight-1')), findsOneWidget);
    });

    testWidgets('selesaikan sesi dengan energi & catatan', (tester) async {
      await pump(tester, initial: '/session/s1');
      await tester.tap(find.text('Selesaikan sesi'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, '4'));
      await tester.enterText(find.widgetWithText(TextField, 'Catatan (opsional)'), 'Lancar');
      await tester.tap(find.text('Simpan & selesai'));
      await tester.pumpAndSettle();
      verify(() => repo.completeSession('s1', notes: 'Lancar', energy: 4, discomfort: null))
          .called(1);
    });
  });
}
