import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';
import 'package:musclecoach/features/goals/presentation/providers/goal_providers.dart';
import 'package:musclecoach/features/goals/presentation/screens/goal_review_screen.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../../fixtures/assessment_fixtures.dart';
import '../../helpers/fakes.dart';

void main() {
  late MockGoalRepository repo;

  Future<void> pump(WidgetTester tester, Goal goal) async {
    // Layar tinggi agar seluruh kartu dirender oleh ListView.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    repo = MockGoalRepository();
    when(() => repo.watchGoal(any())).thenAnswer((_) => Stream.value(goal));
    when(() => repo.confirm(any(), acknowledgedWarnings: any(named: 'acknowledgedWarnings')))
        .thenAnswer((_) async {});
    final router = GoRouter(
      initialLocation: '/goal/g1',
      routes: [
        GoRoute(
          path: '/goal/:id',
          builder: (_, s) => GoalReviewScreen(goalId: s.pathParameters['id']!),
        ),
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('home')),
        ),
        GoRoute(path: '/assessment', builder: (_, s) => Text('assessment ${s.uri.query}')),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goalRepositoryProvider.overrideWithValue(repo),
          userProfileProvider.overrideWith(
            (ref) => Stream<UserProfile?>.value(const UserProfile(onboardingCompleted: true)),
          ),
        ],
        child: MaterialApp.router(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder confirmButton() => find.widgetWithText(FilledButton, 'Konfirmasi target');

  testWidgets('target realistis: angka, asumsi, lalu konfirmasi', (tester) async {
    await pump(tester, testGoal());
    expect(find.text('Target realistis'), findsOneWidget);
    expect(find.text('2.495 kcal'), findsOneWidget);
    expect(find.text('125 g'), findsOneWidget);
    expect(find.text('+4 kg'), findsOneWidget);
    expect(find.textContaining('sekitar 0,18–0,35 kg/minggu'), findsOneWidget);
    expect(find.text('Estimasi'), findsOneWidget);

    await tester.tap(find.text('Asumsi & cara hitung'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mifflin–St Jeor'), findsOneWidget);
    expect(find.textContaining('surplus konservatif 10%'), findsOneWidget);

    await tester.tap(confirmButton());
    await tester.pumpAndSettle();
    verify(() => repo.confirm('g1', acknowledgedWarnings: false)).called(1);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('target perlu disesuaikan: alasan & saran, tanpa tombol konfirmasi', (tester) async {
    await pump(tester, testGoal(verdict: 'needs_adjustment', reasons: ['rate_too_fast']));
    expect(find.text('Target perlu disesuaikan'), findsOneWidget);
    expect(
      find.textContaining(
        'Target ini menuntut kenaikan 0,17 kg/minggu, melebihi batas 0,35 kg/minggu (0,5% berat badan)',
      ),
      findsOneWidget,
    );
    expect(find.text('Saran waktu: minimal 29 minggu untuk target ini.'), findsOneWidget);
    expect(confirmButton(), findsNothing);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Sesuaikan target'));
    await tester.pumpAndSettle();
    expect(find.text('assessment step=1'), findsOneWidget);
  });

  testWidgets('peringatan keselamatan wajib dicentang sebelum konfirmasi', (tester) async {
    await pump(tester, testGoal(warnings: ['medication']));
    expect(find.text('Perlu diperhatikan'), findsOneWidget);
    expect(tester.widget<FilledButton>(confirmButton()).onPressed, isNull);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(tester.widget<FilledButton>(confirmButton()).onPressed, isNotNull);
    await tester.tap(confirmButton());
    await tester.pumpAndSettle();
    verify(() => repo.confirm('g1', acknowledgedWarnings: true)).called(1);
  });

  testWidgets('gejala berbahaya: arahkan ke tenaga medis, tanpa target nutrisi', (tester) async {
    await pump(tester, testGoal(stop: true, warnings: ['red_flag_symptoms']));
    expect(find.text('Tunda dulu rencana latihan'), findsOneWidget);
    expect(find.textContaining('119 atau 112'), findsOneWidget);
    expect(find.text('Target nutrisi harian'), findsNothing);
    expect(confirmButton(), findsNothing);
  });

  testWidgets('goal aktif hanya ditampilkan, tanpa aksi', (tester) async {
    await pump(tester, testGoal(status: 'active'));
    expect(find.text('Target aktif'), findsOneWidget);
    expect(confirmButton(), findsNothing);
    expect(find.widgetWithText(OutlinedButton, 'Ubah jawaban'), findsNothing);
  });
}
