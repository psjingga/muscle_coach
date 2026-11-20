import 'dart:async';

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
import 'package:musclecoach/features/nutrition/data/nutrition_repository.dart';
import 'package:musclecoach/features/nutrition/domain/food.dart';
import 'package:musclecoach/features/nutrition/domain/food_log.dart';
import 'package:musclecoach/features/nutrition/domain/meal_plan.dart';
import 'package:musclecoach/features/nutrition/presentation/providers/nutrition_providers.dart';
import 'package:musclecoach/features/nutrition/presentation/screens/add_food_screen.dart';
import 'package:musclecoach/features/nutrition/presentation/screens/meal_plan_screen.dart';
import 'package:musclecoach/features/nutrition/presentation/screens/nutrition_screen.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import 'nutrition_repository_test.dart' show foodSource;

const target = Nutrients(kcal: 2500, protein: 130, carbs: 330, fat: 70);
final now = DateTime(2026, 11, 19, 10);
const today = '2026-11-19';

/// testWidgets + bongkar pohon widget di akhir agar timer penutupan stream
/// drift (durasi 0) selesai sebelum pemeriksaan timer tertunda.
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
  late LocalNutritionRepository repo;
  late GoRouter router;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalNutritionRepository(db, () => now, foodSource);
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester, {Nutrients? goal = target, String initial = '/n'}) async {
    tester.view.physicalSize = const Size(900, 3400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/n', builder: (_, _) => const NutritionScreen()),
        GoRoute(
          path: Routes.addFood,
          builder: (_, s) => AddFoodScreen(
            date: s.uri.queryParameters['date']!,
            meal: MealSlot.values.byName(s.uri.queryParameters['meal']!),
          ),
        ),
        GoRoute(
          path: '${Routes.mealPlan}/:id',
          builder: (_, s) => MealPlanScreen(planId: s.pathParameters['id']!),
        ),
        GoRoute(path: Routes.aiSettings, builder: (_, _) => const Text('ai settings')),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => now),
          foodDataSourceProvider.overrideWithValue(foodSource),
          nutritionRepositoryProvider.overrideWithValue(repo),
          nutritionTargetNutrientsProvider.overrideWithValue(goal),
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
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }

  widgetTest('tanpa target nutrisi → keadaan kosong', (tester) async {
    await pump(tester, goal: null);
    expect(find.text('Belum ada target nutrisi'), findsOneWidget);
  });

  widgetTest('ringkasan hari: total, sisa, per waktu makan, air, atribusi', (tester) async {
    final nasi = (await tester.runAsync(() => repo.catalog()))![Food.tkpiId('AP001')]!;
    await tester.runAsync(
      () => repo.logFood(date: today, meal: MealSlot.lunch, food: nasi, grams: 250),
    );
    await pump(tester);
    expect(find.text('Hari ini'), findsOneWidget);
    expect(find.byKey(const Key('day-kcal')), findsOneWidget);
    expect(find.text('450 kcal'), findsWidgets);
    expect(find.text('Sisa 2.050 kcal'), findsOneWidget);
    expect(find.text('Makan siang · 450 kcal'), findsOneWidget);
    expect(find.text('Nasi'), findsOneWidget);
    expect(find.text('8 / 130 g'), findsOneWidget); // protein 7,5 g dibulatkan
    expect(find.text('Minum air'), findsOneWidget);
    expect(find.textContaining('Kementerian Kesehatan Republik Indonesia'), findsOneWidget);

    // Hari sebelumnya kosong; tidak bisa maju melewati hari ini.
    await tester.tap(find.byTooltip('Hari sebelumnya'));
    await settle(tester);
    expect(find.text('18 November 2026'), findsOneWidget);
    expect(find.text('Sisa 2.500 kcal'), findsOneWidget);
    await tester.tap(find.byTooltip('Hari berikutnya'));
    await settle(tester);
    expect(find.text('Hari ini'), findsOneWidget);
  });

  widgetTest('tambah makanan: cari TKPI → porsi → tersimpan & total berubah', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('add-breakfast')));
    await settle(tester);
    expect(find.text('Tambah ke Sarapan'), findsOneWidget);
    expect(find.textContaining('Ketik nama makanan'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('food-search')), 'telur ayam ras, segar');
    await tester.pump(const Duration(milliseconds: 300));
    await settle(tester);
    await tester.tap(find.byKey(const Key('food-tkpi:HR002')));
    await tester.pumpAndSettle();

    // Lembar porsi: bawaan 100 g, BDD 89 % dijelaskan.
    expect(find.text('154 kcal'), findsOneWidget);
    expect(find.textContaining('dapat dimakan (89%)'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('portion-grams')), '120');
    await tester.pump();
    expect(find.text('185 kcal'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('portion-grams')), '0');
    await tester.pump();
    expect(find.text('Isi 1–5000 g'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('portion-grams')), '120');
    await tester.pump();
    await tester.tap(find.byKey(const Key('portion-save')));
    await settle(tester);

    expect(find.text('Sarapan · 185 kcal'), findsOneWidget);
    final day = (await tester.runAsync(() => repo.watchDay(today).first))!;
    expect(day.single.grams, 120);
    expect(day.single.meal, MealSlot.breakfast);

    // Ubah porsi lewat ketukan catatan, lalu hapus.
    await tester.tap(find.byKey(Key('entry-${day.single.id}')));
    await settle(tester);
    expect(
      tester.widget<TextField>(find.byKey(const Key('portion-grams'))).controller!.text,
      '120',
    );
    await tester.enterText(find.byKey(const Key('portion-grams')), '60');
    await tester.pump();
    await tester.tap(find.byKey(const Key('portion-save')));
    await settle(tester);
    expect(find.text('Sarapan · 92 kcal'), findsOneWidget);
    await tester.tap(find.byKey(Key('entry-${day.single.id}')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('portion-delete')));
    await settle(tester);
    expect(find.text('Sarapan'), findsOneWidget);
  });

  widgetTest('catat kalori/makro manual dengan validasi', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('add-snack')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('food-add-manual')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('manual-save')));
    await tester.pumpAndSettle();
    expect(find.text('Wajib diisi'), findsNWidgets(2));
    await tester.enterText(find.byKey(const Key('manual-name')), 'Martabak (perkiraan)');
    await tester.enterText(find.byKey(const Key('nutrient-kcal')), '600');
    await tester.enterText(find.byKey(const Key('nutrient-protein')), '10');
    await tester.enterText(find.byKey(const Key('nutrient-carbs')), '20');
    await tester.enterText(find.byKey(const Key('nutrient-fat')), '5');
    await tester.pump();
    // 4×10 + 4×20 + 9×5 = 165 kcal ≠ 600 → peringatan (tidak memblokir).
    expect(find.textContaining('≈165 kcal'), findsOneWidget);
    await tester.tap(find.byKey(const Key('manual-save')));
    await settle(tester);
    final e = (await tester.runAsync(() => repo.watchDay(today).first))!.single;
    expect(e.name, 'Martabak (perkiraan)');
    expect(e.nutrients.kcal, 600);
    expect(e.quality, NutritionQuality.manual);
  });

  widgetTest('makanan dari label: per sajian 30 g → disimpan per 100 g lalu dicatat', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('add-breakfast')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('food-add-custom')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('custom-name')), 'Granola Merek X');
    await tester.enterText(find.byKey(const Key('custom-basis')), '30');
    await tester.enterText(find.byKey(const Key('nutrient-kcal')), '135');
    await tester.enterText(find.byKey(const Key('nutrient-protein')), '3');
    await tester.enterText(find.byKey(const Key('nutrient-carbs')), '18');
    await tester.enterText(find.byKey(const Key('nutrient-fat')), '5,4');
    await tester.tap(find.byKey(const Key('custom-save')));
    await settle(tester);
    // Lembar porsi terbuka dengan porsi label 30 g.
    expect(tester.widget<TextField>(find.byKey(const Key('portion-grams'))).controller!.text, '30');
    expect(find.text('135 kcal'), findsOneWidget);
    await tester.tap(find.byKey(const Key('portion-save')));
    await settle(tester);
    final foods = (await tester.runAsync(() => repo.watchCustomFoods().first))!;
    expect(foods.single.per100g.kcal, 450);
    expect(foods.single.per100g.fat, 18);
    final e = (await tester.runAsync(() => repo.watchDay(today).first))!.single;
    expect(e.quality, NutritionQuality.userLabel);
    expect(e.nutrients.kcal, 135);
  });

  widgetTest('menu aktif: tandai dimakan → tercatat; batalkan; pratinjau draft', (tester) async {
    final foods = (await tester.runAsync(() => repo.catalog()))!;
    PlannedFood item(String code, double g) {
      final f = foods[Food.tkpiId(code)]!;
      return PlannedFood(
        foodId: f.id,
        name: f.name,
        grams: g,
        nutrients: f.per100g.forGrams(g),
        quality: f.quality,
      );
    }

    final plan = MealPlan(
      meals: [
        PlannedMeal(
          slot: MealSlot.breakfast,
          title: 'Nasi telur dadar',
          items: [item('AP001', 200), item('HP001', 60)],
        ),
        PlannedMeal(slot: MealSlot.lunch, title: 'Nasi tempe', items: [item('CP076', 100)]),
      ],
      target: target,
      rationale: 'Menu contoh yang mudah dibuat.',
      warnings: const [MealPlanWarning.allergyCheck],
      promptVersion: 'meal_plan.v1',
      catalogVersion: 'tkpi',
    );
    final id = (await tester.runAsync(() => repo.saveDraftMealPlan(plan, model: 'gemini-x')))!;

    // Pratinjau draft: total dihitung aplikasi + peringatan + setujui.
    await pump(tester);
    unawaited(router.push(Routes.mealPlanPath(id)));
    await settle(tester);
    expect(find.text('Menu contoh yang mudah dibuat.'), findsOneWidget);
    expect(find.textContaining('memeriksa alergen dari nama bahan'), findsOneWidget);
    expect(find.textContaining('Total menu: 861 kcal'), findsOneWidget);
    expect(find.textContaining('dihitung aplikasi dari data TKPI'), findsOneWidget);
    await tester.tap(find.byKey(const Key('meal-plan-use')));
    await settle(tester);
    expect(
      (await tester.runAsync(() => repo.watchActiveMealPlan().first))!.id,
      id,
      reason: 'menu aktif setelah disetujui',
    );

    expect(find.text('Sarapan · Nasi telur dadar'), findsOneWidget);
    await tester.tap(find.byKey(const Key('plan-log-0')));
    await settle(tester);
    expect(find.text('Sarapan dicatat ke hari ini'), findsOneWidget);
    expect(find.byKey(const Key('plan-unlog-0')), findsOneWidget);
    expect(find.text('Sarapan · 511 kcal'), findsOneWidget);
    await tester.tap(find.byKey(const Key('plan-unlog-0')));
    await settle(tester);
    expect(find.byKey(const Key('plan-log-0')), findsOneWidget);
    expect((await tester.runAsync(() => repo.watchDay(today).first))!, isEmpty);
  });
}
