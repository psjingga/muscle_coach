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
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/goals/data/local_goal_repository.dart';
import 'package:musclecoach/features/nutrition/application/meal_plan_service.dart';
import 'package:musclecoach/features/nutrition/data/nutrition_repository.dart';
import 'package:musclecoach/features/nutrition/data/tkpi_food_data_source.dart';
import 'package:musclecoach/features/nutrition/domain/food.dart';
import 'package:musclecoach/features/nutrition/domain/food_log.dart';
import 'package:musclecoach/features/nutrition/domain/meal_plan.dart';

import '../../fixtures/sample_assessment.dart';
import '../ai_coach/ai_coach_test.dart' show FakeAiClient, MemoryKeyStore;

class FileFoodSource implements FoodDataSource {
  final _parsed = TkpiAssetFoodDataSource.parse(
    File(TkpiAssetFoodDataSource.path).readAsStringSync(),
  );

  @override
  Future<Map<String, Food>> foods() async => _parsed.foods;

  @override
  Future<FoodSourceInfo> info() async => _parsed.info;
}

final foodSource = FileFoodSource();

/// Repository dengan konteks menu yang dapat diatur (target sederhana).
class ContextRepo extends LocalNutritionRepository {
  ContextRepo(super.db, super.clock, super.source, this.ctx);

  MealPlanningContext ctx;

  @override
  Future<MealPlanningContext> mealPlanningContext() async => ctx;
}

const date = '2026-11-19';
const smallTarget = Nutrients(kcal: 1500, protein: 75, carbs: 200, fat: 45);

/// Menu valid untuk [smallTarget] (lihat nutrition_domain_test).
String validMenu({String breakfast = 'HR002'}) => jsonEncode({
  'schemaVersion': 1,
  'rationale': 'Menu sederhana dari bahan umum.',
  'meals': [
    {
      'slot': 'breakfast',
      'title': 'Nasi telur',
      'items': [
        {'code': 'AP001', 'grams': 150},
        {'code': breakfast, 'grams': 120},
      ],
    },
    {
      'slot': 'lunch',
      'title': 'Nasi tempe bayam',
      'items': [
        {'code': 'AP001', 'grams': 150},
        {'code': 'CP076', 'grams': 100},
        {'code': 'DP002', 'grams': 150},
      ],
    },
    {
      'slot': 'dinner',
      'title': 'Nasi tahu + pisang',
      'items': [
        {'code': 'AP001', 'grams': 150},
        {'code': 'CP061', 'grams': 150},
        {'code': 'ER081', 'grams': 100},
      ],
    },
  ],
});

Matcher failure(FailureKind kind, [String? reason]) => isA<AppFailure>()
    .having((f) => f.kind, 'kind', kind)
    .having((f) => f.debugMessage, 'reason', reason ?? anything);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late LocalNutritionRepository repo;
  var clockNow = now;

  setUp(() {
    clockNow = now;
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalNutritionRepository(db, () => clockNow, foodSource);
  });

  tearDown(() => db.close());

  Future<Food> food(String code) async => (await repo.catalog())[Food.tkpiId(code)]!;

  group('Food log', () {
    test('catat dari katalog: gizi = per 100 g × gram, disalin ke catatan', () async {
      await repo.logFood(date: date, meal: MealSlot.lunch, food: await food('AP001'), grams: 150);
      final day = await repo.watchDay(date).first;
      expect(day.single.name, 'Nasi');
      expect(
        day.single.nutrients,
        const Nutrients(kcal: 270, protein: 4.5, carbs: 59.7, fat: 0.45),
      );
      expect(day.single.quality, NutritionQuality.source);
      expect(day.single.foodId, 'tkpi:AP001');
      expect(await repo.watchDay('2026-11-18').first, isEmpty);
    });

    test('ubah porsi → dihitung ulang; pindah waktu makan; hapus', () async {
      final id = await repo.logFood(
        date: date,
        meal: MealSlot.lunch,
        food: await food('AP001'),
        grams: 100,
      );
      await repo.updateEntry(id, meal: MealSlot.dinner, grams: 200);
      final e = (await repo.watchDay(date).first).single;
      expect(e.grams, 200);
      expect(e.nutrients.kcal, 360);
      expect(e.meal, MealSlot.dinner);
      await repo.deleteEntry(id);
      expect(await repo.watchDay(date).first, isEmpty);
    });

    test('gram tidak valid ditolak', () async {
      final nasi = await food('AP001');
      for (final g in [0.0, -5.0, 5001.0]) {
        expect(
          repo.logFood(date: date, meal: MealSlot.lunch, food: nasi, grams: g),
          throwsA(failure(FailureKind.invalidInput, 'grams-out-of-range')),
        );
      }
    });

    test('catatan manual: kualitas manual, bisa diubah angkanya', () async {
      final id = await repo.logManual(
        date: date,
        meal: MealSlot.snack,
        name: '  Kopi susu  ',
        nutrients: const Nutrients(kcal: 150, protein: 3, carbs: 20, fat: 6),
      );
      var e = (await repo.watchDay(date).first).single;
      expect(e.name, 'Kopi susu');
      expect(e.quality, NutritionQuality.manual);
      expect(e.isEstimate, isTrue);
      await repo.updateEntry(
        id,
        meal: MealSlot.snack,
        manual: const Nutrients(kcal: 200, protein: 3, carbs: 25, fat: 8),
      );
      e = (await repo.watchDay(date).first).single;
      expect(e.nutrients.kcal, 200);
      expect(
        repo.logManual(
          date: date,
          meal: MealSlot.snack,
          name: 'x',
          nutrients: const Nutrients(kcal: -1, protein: 0, carbs: 0, fat: 0),
        ),
        throwsA(failure(FailureKind.invalidInput)),
      );
    });

    test('makanan terakhir: unik, terbaru dulu, dengan gram terakhir', () async {
      await repo.logFood(date: date, meal: MealSlot.lunch, food: await food('AP001'), grams: 100);
      clockNow = now.add(const Duration(minutes: 1));
      await repo.logFood(date: date, meal: MealSlot.lunch, food: await food('CP076'), grams: 50);
      clockNow = now.add(const Duration(minutes: 2));
      await repo.logFood(date: date, meal: MealSlot.dinner, food: await food('AP001'), grams: 175);
      await repo.logManual(date: date, meal: MealSlot.snack, name: 'm', nutrients: Nutrients.zero);
      final r = await repo.recentFoods();
      expect(r.map((x) => x.foodId), ['tkpi:AP001', 'tkpi:CP076']);
      expect(r.first.grams, 175);
    });

    test('makanan dari label: per 100 g, masuk katalog, catatan tetap setelah dihapus', () async {
      final id = await repo.addCustomFood(
        name: ' Granola X ',
        per100g: const Nutrients(kcal: 450, protein: 10, carbs: 60, fat: 18),
        servingGrams: 30,
      );
      final f = (await repo.catalog())[id]!;
      expect(f.origin, FoodOrigin.custom);
      expect(f.quality, NutritionQuality.userLabel);
      expect(f.defaultGrams, 30);
      expect(f.name, 'Granola X');
      await repo.logFood(date: date, meal: MealSlot.breakfast, food: f, grams: 30);
      await repo.deleteCustomFood(id);
      expect((await repo.catalog())[id], isNull);
      final e = (await repo.watchDay(date).first).single;
      expect(e.nutrients.kcal, 135);
      expect(e.quality, NutritionQuality.userLabel);
    });

    test('hapus semua data juga menghapus catatan makanan & menu', () async {
      await repo.logFood(date: date, meal: MealSlot.lunch, food: await food('AP001'), grams: 100);
      await repo.addCustomFood(name: 'x', per100g: Nutrients.zero);
      await db.wipeAll();
      expect(await repo.watchDay(date).first, isEmpty);
      expect(await repo.watchCustomFoods().first, isEmpty);
    });
  });

  group('Menu', () {
    Future<MealPlan> draft() async {
      final ctx = await foodSource.foods();
      PlannedFood item(String code, double g) {
        final f = ctx[Food.tkpiId(code)]!;
        return PlannedFood(
          foodId: f.id,
          name: f.name,
          grams: g,
          nutrients: f.per100g.forGrams(g),
          quality: f.quality,
        );
      }

      return MealPlan(
        meals: [
          PlannedMeal(
            slot: MealSlot.breakfast,
            title: 'Nasi telur',
            items: [item('AP001', 150), item('HR002', 100)],
          ),
          PlannedMeal(slot: MealSlot.lunch, title: 'Nasi tempe', items: [item('CP076', 100)]),
        ],
        target: smallTarget,
        rationale: 'r',
        promptVersion: 'meal_plan.v1',
        catalogVersion: 'tkpi',
      );
    }

    test('draft → aktif; menu aktif lama diarsipkan; draft lama diganti', () async {
      final a = await repo.saveDraftMealPlan(await draft(), model: 'm');
      await repo.activateMealPlan(a);
      final b = await repo.saveDraftMealPlan(await draft(), model: 'm');
      final c = await repo.saveDraftMealPlan(await draft(), model: 'm');
      expect(await repo.watchMealPlan(b).first, isNull, reason: 'draft lama diganti');
      expect((await repo.watchActiveMealPlan().first)!.id, a);
      await repo.activateMealPlan(c);
      expect((await repo.watchActiveMealPlan().first)!.id, c);
      expect((await repo.watchMealPlan(a).first)!.status, MealPlanStatus.archived);
      expect(
        repo.activateMealPlan(c),
        throwsA(failure(FailureKind.invalidInput, 'meal-plan-not-draft')),
      );
      final p = (await repo.watchMealPlan(c).first)!;
      expect(p.model, 'm');
      expect(p.promptVersion, 'meal_plan.v1');
      expect(p.meals.first.items, hasLength(2));
    });

    test('tandai dimakan: idempoten, dihitung dari katalog, bisa dibatalkan', () async {
      final id = await repo.saveDraftMealPlan(await draft(), model: 'm');
      await repo.activateMealPlan(id);
      final plan = (await repo.watchActiveMealPlan().first)!;
      await repo.logPlannedMeal(date: date, plan: plan, index: 0);
      await repo.logPlannedMeal(date: date, plan: plan, index: 0);
      final day = await repo.watchDay(date).first;
      expect(day, hasLength(2));
      expect(day.every((e) => e.planRef == '$id:0' && e.meal == MealSlot.breakfast), isTrue);
      expect(DayNutrition(day).consumed.kcal, closeTo(270 + 154, 0.01));
      await repo.logPlannedMeal(date: '2026-11-20', plan: plan, index: 0);
      await repo.unlogPlannedMeal(date: date, planRef: '$id:0');
      expect(await repo.watchDay(date).first, isEmpty);
      expect(await repo.watchDay('2026-11-20').first, hasLength(2));
      expect(
        repo.logPlannedMeal(date: date, plan: plan, index: 5),
        throwsA(failure(FailureKind.invalidInput)),
      );
    });

    test('konteks menu: butuh target aktif; target & preferensi dari assessment', () async {
      expect(
        repo.mealPlanningContext(),
        throwsA(failure(FailureKind.invalidInput, 'no-nutrition-target')),
      );
      DateTime clock() => now;
      final a = sample.copyWith(
        nutrition: sample.nutrition.copyWith(allergies: 'udang'),
        safety: const SafetySection(medicalFlags: [MedicalFlag.eatingDisorderHistory]),
      );
      final goalId = await LocalAssessmentRepository(db, clock).submit(a);
      await LocalGoalRepository(db, clock).confirm(goalId, acknowledgedWarnings: true);
      final ctx = await repo.mealPlanningContext();
      expect(ctx.prefs.allergies, 'udang');
      expect(ctx.prefs.mealsPerDay, 3);
      expect(ctx.eatingDisorderHistory, isTrue);
      expect(ctx.target.kcal, greaterThan(1500));
      expect(ctx.target.protein, greaterThan(0));
    });
  });

  group('MealPlanService', () {
    late AiRepository aiRepo;
    late MemoryKeyStore keys;
    late ContextRepo ctxRepo;

    setUp(() async {
      aiRepo = AiRepository(db);
      keys = MemoryKeyStore('kunci-uji');
      ctxRepo = ContextRepo(db, () => now, foodSource, (
        prefs: const NutritionSection(diet: Diet.omnivore, mealsPerDay: 3),
        target: smallTarget,
        eatingDisorderHistory: false,
      ));
      await aiRepo.setConsent(accepted: true, now: now);
    });

    MealPlanService service(FakeAiClient client) => MealPlanService(
      nutrition: ctxRepo,
      ai: aiRepo,
      client: client,
      keys: keys,
      clock: () => now,
      model: () async => AiConfig.defaultModel,
    );

    Future<List<AiLogRow>> logs() => db.select(db.aiGenerationLogs).get();

    test('berhasil: draft tersimpan, total dihitung aplikasi, log tanpa data pribadi', () async {
      final client = FakeAiClient([validMenu()]);
      final id = await service(client).generate();
      final plan = (await ctxRepo.watchMealPlan(id).first)!;
      expect(plan.status, MealPlanStatus.draft);
      expect(plan.meals, hasLength(3));
      expect(plan.model, 'gemini-test');
      expect(plan.promptVersion, 'meal_plan.v1');
      expect(plan.catalogVersion, startsWith('tkpi-'));
      expect(plan.warnings, isEmpty);
      // Prompt hanya berisi target & preferensi + katalog — tanpa nama/umur/berat.
      final sent = jsonDecode(client.requests.single) as Map<String, dynamic>;
      expect(sent.keys, isNot(containsAll(['nama', 'umur', 'beratKg'])));
      expect((sent['target'] as Map)['kcal'], 1500);
      expect((sent['katalog'] as List).first, startsWith('AP001|Nasi|'));
      final log = (await logs()).single;
      expect(log.kind, 'meal_plan');
      expect(log.status, 'success');
      expect(log.promptVersion, 'meal_plan.v1');
    });

    test('output tidak valid → retry dengan umpan balik → berhasil', () async {
      final client = FakeAiClient([validMenu(breakfast: 'ZZ001'), validMenu()]);
      await service(client).generate();
      expect(client.requests, hasLength(2));
      expect(client.requests.last, contains('TIDAK VALID'));
      expect(client.requests.last, contains('"ZZ001" tidak ada'));
      expect((await logs()).single.attempts, 2);
    });

    test('tetap tidak valid → gagal, tidak ada draft', () async {
      final client = FakeAiClient(['{}', 'bukan json']);
      await expectLater(
        service(client).generate(),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'error', AiPlanError.invalidOutput)),
      );
      expect(await db.select(db.mealPlans).get(), isEmpty);
      expect((await logs()).single.status, 'invalid');
    });

    test('tanpa key / consent → error setup, AI tidak dipanggil', () async {
      final client = FakeAiClient([]);
      keys.key = null;
      await expectLater(
        service(client).generate(),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'error', AiPlanError.noKey)),
      );
      keys.key = 'k';
      await aiRepo.setConsent(accepted: false, now: now);
      await expectLater(
        service(client).generate(),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'error', AiPlanError.noConsent)),
      );
      expect(client.requests, isEmpty);
    });

    test('alergi & riwayat gangguan makan → peringatan pada menu; alergen ditolak', () async {
      ctxRepo.ctx = (
        prefs: const NutritionSection(diet: Diet.omnivore, mealsPerDay: 3, allergies: 'pisang'),
        target: smallTarget,
        eatingDisorderHistory: true,
      );
      // Menu acuan memakai pisang → ditolak; percobaan kedua tanpa pisang.
      final noBanana = validMenu().replaceAll('ER081', 'CP061');
      final client = FakeAiClient([validMenu(), noBanana]);
      final id = await service(client).generate();
      expect(client.requests.last, contains('pisang'));
      final plan = (await ctxRepo.watchMealPlan(id).first)!;
      expect(
        plan.warnings,
        containsAll([MealPlanWarning.eatingDisorder, MealPlanWarning.allergyCheck]),
      );
    });
  });
}
