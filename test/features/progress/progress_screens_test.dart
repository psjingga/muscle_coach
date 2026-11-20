import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:musclecoach/app/router/routes.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/assessment/data/local_assessment_repository.dart';
import 'package:musclecoach/features/goals/data/local_goal_repository.dart';
import 'package:musclecoach/features/goals/domain/entities/goal.dart';
import 'package:musclecoach/features/nutrition/data/nutrition_repository.dart';
import 'package:musclecoach/features/nutrition/domain/food.dart';
import 'package:musclecoach/features/nutrition/domain/food_log.dart';
import 'package:musclecoach/features/nutrition/presentation/providers/nutrition_providers.dart';
import 'package:musclecoach/features/profile/data/local_profile_repository.dart';
import 'package:musclecoach/features/progress/data/progress_repository.dart';
import 'package:musclecoach/features/progress/presentation/screens/check_in_screen.dart';
import 'package:musclecoach/features/progress/presentation/screens/progress_screen.dart';
import 'package:musclecoach/features/progress/presentation/screens/weekly_review_screen.dart';
import 'package:musclecoach/features/progress/presentation/widgets/progress_charts.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../../fixtures/sample_assessment.dart';
import '../nutrition/nutrition_repository_test.dart' show foodSource;
import 'progress_math_test.dart' show weeksOf;

void widgetTest(String name, Future<void> Function(WidgetTester) body) =>
    testWidgets(name, (tester) async {
      await body(tester);
      await tester.pumpWidget(const SizedBox());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 10));
      }
    });

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late LocalProgressRepository progress;
  late GoRouter router;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    progress = LocalProgressRepository(db, () => now);
  });

  tearDown(() => db.close());

  /// Assessment contoh + target aktif.
  Future<void> seedGoal(WidgetTester tester) => tester.runAsync(() async {
    DateTime clock() => now;
    final goalId = await LocalAssessmentRepository(db, clock).submit(sample);
    await LocalGoalRepository(db, clock).confirm(goalId, acknowledgedWarnings: true);
  });

  Future<NutritionPlan> activeTarget(WidgetTester tester) async => (await tester.runAsync(() async {
    final id = (await readProfile(db))!.activeNutritionTargetId!;
    final row = await (db.select(db.nutritionTargets)..where((t) => t.id.equals(id))).getSingle();
    return NutritionPlan.fromJson(jsonDecode(row.data) as Map<String, dynamic>);
  }))!;

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }

  Future<void> pump(WidgetTester tester, {String initial = '/p'}) async {
    tester.view.physicalSize = const Size(900, 3600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/p', builder: (_, _) => const ProgressScreen()),
        GoRoute(
          path: '${Routes.checkIn}/:date',
          builder: (_, s) => CheckInScreen(date: s.pathParameters['date']!),
        ),
        GoRoute(
          path: '${Routes.weeklyReview}/:week',
          builder: (_, s) => WeeklyReviewScreen(weekStart: s.pathParameters['week']!),
        ),
        GoRoute(path: Routes.aiSettings, builder: (_, _) => const Text('ai')),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => now),
          foodDataSourceProvider.overrideWithValue(foodSource),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await settle(tester);
  }

  widgetTest('tanpa data: ajakan check-in & timbang; catat berat lewat lembar', (tester) async {
    await seedGoal(tester);
    await pump(tester);
    expect(find.text('Check-in hari ini'), findsOneWidget);
    expect(find.textContaining('Belum ada penimbangan'), findsOneWidget);
    expect(find.byKey(const Key('goal-status-insufficientData')), findsOneWidget);
    expect(find.text('Belum ada sesi selesai.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('weight-log')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('weight-kg')), '20');
    await tester.pump();
    expect(find.text('Isi 25–400 kg'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('weight-kg')), '70,5');
    await tester.pump();
    await tester.tap(find.byKey(const Key('weight-save')));
    await settle(tester);
    expect(find.text('Terakhir 70,5 kg · 19 November 2026'), findsOneWidget);
    expect(find.text('Berat bukan massa otot'), findsNothing);
    expect(find.textContaining('Berat badan bukan massa otot'), findsOneWidget);
  });

  widgetTest('grafik tampil dengan data; status on track', (tester) async {
    await seedGoal(tester);
    await tester.runAsync(() async {
      for (final w in weeksOf([70, 70.3, 70.6])) {
        await progress.saveWeight(w.date, w.kg);
      }
      final nutrition = LocalNutritionRepository(db, () => now, foodSource);
      await nutrition.logManual(
        date: '2026-11-18',
        meal: MealSlot.lunch,
        name: 'x',
        nutrients: const Nutrients(kcal: 800, protein: 40, carbs: 90, fat: 20),
      );
    });
    await pump(tester);
    expect(find.byType(WeightChart), findsOneWidget);
    expect(find.byType(IntakeChart), findsOneWidget);
    expect(find.byKey(const Key('goal-status-onTrack')), findsOneWidget);
    expect(find.textContaining('+0,3 kg'), findsOneWidget);
  });

  widgetTest('check-in: isi, peringatan nyeri, simpan (berat ikut tercatat)', (tester) async {
    await seedGoal(tester);
    await pump(tester);
    unawaited(router.push(Routes.checkInPath('2026-11-19')));
    await settle(tester);
    expect(find.text('Latihan hari ini: belum ada sesi selesai'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('checkin-sleep')), '30');
    await tester.tap(find.byKey(const Key('checkin-save')));
    await tester.pumpAndSettle();
    expect(find.text('Isi 0–24 jam'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('checkin-sleep')), '6,5');
    await tester.enterText(find.byKey(const Key('checkin-weight')), '70,2');
    await tester.tap(find.byKey(const Key('energy-4')));
    await tester.enterText(find.byKey(const Key('checkin-discomfort')), 'lutut kiri saat squat');
    await tester.pump();
    expect(find.textContaining('konsultasikan ke tenaga kesehatan'), findsOneWidget);
    await tester.tap(find.byKey(const Key('checkin-save')));
    await settle(tester);
    expect(find.text('Check-in hari ini sudah diisi'), findsOneWidget);
    final c = (await tester.runAsync(() => progress.watchCheckIns().first))!.single;
    expect((c.sleepHours, c.energy, c.discomfort), (6.5, 4, 'lutut kiri saat squat'));
    final w = (await tester.runAsync(() => progress.watchWeights().first))!.single;
    expect(w.kg, 70.2);
  });

  widgetTest('ringkasan mingguan: berat stagnan 2 minggu + makan konsisten → usulan → terapkan', (
    tester,
  ) async {
    await seedGoal(tester);
    final before = await activeTarget(tester);
    await tester.runAsync(() async {
      for (final w in weeksOf([70, 70, 70])) {
        await progress.saveWeight(w.date, w.kg);
      }
      // Makan tercatat 5 hari/minggu pada target selama 2 minggu terakhir.
      final nutrition = LocalNutritionRepository(db, () => now, foodSource);
      for (final ws in ['2026-11-02', '2026-11-09']) {
        for (var d = 0; d < 5; d++) {
          final date = DateTime.parse(ws).add(Duration(days: d));
          await nutrition.logManual(
            date: date.toIso8601String().substring(0, 10),
            meal: MealSlot.lunch,
            name: 'menu',
            nutrients: Nutrients(
              kcal: before.targetKcal.toDouble(),
              protein: before.proteinG.toDouble(),
              carbs: before.carbsG.toDouble(),
              fat: before.fatG.toDouble(),
            ),
          );
        }
      }
    });
    await pump(tester);
    expect(find.byKey(const Key('goal-status-adjustTarget')), findsOneWidget);
    await tester.tap(find.byKey(const Key('weekly-open')));
    await settle(tester);
    expect(find.text('9 November 2026 – 15 November 2026'), findsOneWidget);
    expect(find.textContaining('70 kg (3× timbang)'), findsOneWidget);
    expect(find.textContaining('5 hari tercatat'), findsOneWidget);
    expect(find.byKey(const Key('adjust-body')), findsOneWidget);
    expect(find.textContaining('naikkan target 100 kcal'), findsOneWidget);
    // Belum ada perubahan sebelum disetujui.
    expect((await activeTarget(tester)).targetKcal, before.targetKcal);

    await tester.tap(find.byKey(const Key('adjust-accept')));
    await settle(tester);
    expect(find.text('Target baru aktif.'), findsOneWidget);
    expect(find.text('Diterapkan'), findsOneWidget);
    final after = await activeTarget(tester);
    expect(after.carbsG, before.carbsG + 25);
    // Ringkasan AI tersedia (butuh key — tombol ada).
    expect(find.byKey(const Key('weekly-ai-generate')), findsOneWidget);
  });

  widgetTest('makan belum konsisten → tidak ada usulan, minta perbaiki pencatatan', (tester) async {
    await seedGoal(tester);
    await tester.runAsync(() async {
      for (final w in weeksOf([70, 70, 70])) {
        await progress.saveWeight(w.date, w.kg);
      }
    });
    await pump(tester, initial: Routes.weeklyReviewPath('2026-11-09'));
    expect(find.textContaining('makan belum tercatat konsisten'), findsOneWidget);
    expect(find.byKey(const Key('adjust-accept')), findsNothing);
  });
}
