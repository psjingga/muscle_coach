import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../assessment/domain/entities/assessment_data.dart';
import '../../goals/domain/entities/goal.dart';
import '../../profile/data/local_profile_repository.dart';
import '../domain/food.dart';
import '../domain/food_log.dart';
import '../domain/meal_plan.dart';
import 'tkpi_food_data_source.dart';

/// Data yang dibutuhkan untuk menyusun menu.
typedef MealPlanningContext = ({
  NutritionSection prefs,
  Nutrients target,
  bool eatingDisorderHistory,
});

abstract interface class NutritionRepository {
  /// Katalog lengkap: TKPI + makanan sendiri. Kunci = `Food.id`.
  Future<Map<String, Food>> catalog();
  Future<FoodSourceInfo> sourceInfo();

  Stream<List<Food>> watchCustomFoods();
  Future<String> addCustomFood({
    required String name,
    required Nutrients per100g,
    double? servingGrams,
  });
  Future<void> deleteCustomFood(String id);

  Stream<List<FoodLogEntry>> watchDay(String date);

  /// Catat makanan katalog (gizi dihitung dari gram).
  Future<String> logFood({
    required String date,
    required MealSlot meal,
    required Food food,
    required double grams,
  });

  /// Catat kalori/makro langsung (tanpa katalog).
  Future<String> logManual({
    required String date,
    required MealSlot meal,
    required String name,
    required Nutrients nutrients,

    /// `manual` (default) atau `aiEstimate` (hasil scan foto).
    NutritionQuality quality = NutritionQuality.manual,
  });

  /// Ubah porsi / waktu makan. Gizi dihitung ulang dari katalog bila ada.
  Future<void> updateEntry(String id, {required MealSlot meal, double? grams, Nutrients? manual});
  Future<void> deleteEntry(String id);

  /// Makanan yang terakhir dicatat (unik, terbaru dulu) + gram terakhir.
  Future<List<({String foodId, double? grams})>> recentFoods({int limit = 15});

  Future<MealPlanningContext> mealPlanningContext();
  Future<String> saveDraftMealPlan(MealPlan plan, {required String model});
  Stream<MealPlan?> watchMealPlan(String id);
  Stream<MealPlan?> watchActiveMealPlan();

  /// Aktifkan draft; menu aktif sebelumnya diarsipkan.
  Future<void> activateMealPlan(String id);
  Future<void> deleteMealPlan(String id);

  /// Tandai satu waktu makan dari menu sebagai dimakan (idempoten).
  Future<void> logPlannedMeal({required String date, required MealPlan plan, required int index});
  Future<void> unlogPlannedMeal({required String date, required String planRef});
}

class LocalNutritionRepository implements NutritionRepository {
  LocalNutritionRepository(this._db, this._clock, this._source);

  final AppDatabase _db;
  final DateTime Function() _clock;
  final FoodDataSource _source;

  static String planRef(String planId, int index) => '$planId:$index';

  static Food _custom(CustomFoodRow r) => Food(
    id: Food.customId(r.id),
    name: r.name,
    origin: FoodOrigin.custom,
    quality: NutritionQuality.userLabel,
    defaultGrams: r.servingGrams,
    per100g: Nutrients(kcal: r.kcal, protein: r.protein, carbs: r.carbs, fat: r.fat),
  );

  static const _qualityCodes = {
    NutritionQuality.source: 'source',
    NutritionQuality.inconsistent: 'inconsistent',
    NutritionQuality.userLabel: 'user_label',
    NutritionQuality.manual: 'manual',
    NutritionQuality.aiEstimate: 'ai_estimate',
  };
  static final _qualityByCode = {for (final e in _qualityCodes.entries) e.value: e.key};

  static FoodLogEntry _entry(FoodLogRow r) => FoodLogEntry(
    id: r.id,
    date: r.date,
    meal: MealSlot.values.byName(r.meal),
    name: r.name,
    foodId: r.foodId,
    grams: r.grams,
    planRef: r.planRef,
    quality: _qualityByCode[r.quality] ?? NutritionQuality.manual,
    nutrients: Nutrients(kcal: r.kcal, protein: r.protein, carbs: r.carbs, fat: r.fat),
  );

  @override
  Future<FoodSourceInfo> sourceInfo() => _source.info();

  @override
  Future<Map<String, Food>> catalog() async {
    final custom = await _db.select(_db.customFoods).get();
    return {...await _source.foods(), for (final r in custom) Food.customId(r.id): _custom(r)};
  }

  Future<Food> _food(String foodId) async {
    final food = (await catalog())[foodId];
    if (food == null) throw const AppFailure(FailureKind.notFound, debugMessage: 'food-missing');
    return food;
  }

  @override
  Stream<List<Food>> watchCustomFoods() =>
      (_db.select(_db.customFoods)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch().map(
        (rows) => [for (final r in rows) _custom(r)],
      );

  @override
  Future<String> addCustomFood({
    required String name,
    required Nutrients per100g,
    double? servingGrams,
  }) async {
    final id = newId();
    final now = _clock();
    final n = per100g.rounded();
    await _db
        .into(_db.customFoods)
        .insert(
          CustomFoodsCompanion.insert(
            id: id,
            name: name.trim(),
            kcal: n.kcal,
            protein: n.protein,
            carbs: n.carbs,
            fat: n.fat,
            servingGrams: Value(servingGrams),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return Food.customId(id);
  }

  @override
  Future<void> deleteCustomFood(String id) async {
    final raw = id.startsWith('custom:') ? id.substring(7) : id;
    await (_db.delete(_db.customFoods)..where((t) => t.id.equals(raw))).go();
  }

  @override
  Stream<List<FoodLogEntry>> watchDay(String date) =>
      (_db.select(_db.foodLogs)
            ..where((t) => t.date.equals(date))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch()
          .map((rows) => [for (final r in rows) _entry(r)]);

  Future<String> _insert({
    required String date,
    required MealSlot meal,
    required String name,
    required Nutrients nutrients,
    required NutritionQuality quality,
    String? foodId,
    double? grams,
    String? planRef,
  }) async {
    final id = newId();
    final now = _clock();
    final n = nutrients.rounded();
    await _db
        .into(_db.foodLogs)
        .insert(
          FoodLogsCompanion.insert(
            id: id,
            date: date,
            meal: meal.name,
            foodId: Value(foodId),
            name: name,
            grams: Value(grams),
            kcal: n.kcal,
            protein: n.protein,
            carbs: n.carbs,
            fat: n.fat,
            quality: _qualityCodes[quality]!,
            planRef: Value(planRef),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return id;
  }

  static void _checkGrams(double grams) {
    if (!(grams > 0 && grams <= 5000)) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'grams-out-of-range');
    }
  }

  @override
  Future<String> logFood({
    required String date,
    required MealSlot meal,
    required Food food,
    required double grams,
  }) async {
    _checkGrams(grams);
    return _insert(
      date: date,
      meal: meal,
      name: food.name,
      foodId: food.id,
      grams: grams,
      nutrients: food.per100g.forGrams(grams),
      quality: food.quality,
    );
  }

  @override
  Future<String> logManual({
    required String date,
    required MealSlot meal,
    required String name,
    required Nutrients nutrients,
    NutritionQuality quality = NutritionQuality.manual,
  }) async {
    _checkManual(nutrients);
    return _insert(
      date: date,
      meal: meal,
      name: name.trim(),
      nutrients: nutrients,
      quality: quality,
    );
  }

  static void _checkManual(Nutrients n) {
    final ok = [n.kcal, n.protein, n.carbs, n.fat].every((v) => v >= 0 && v <= 10000);
    if (!ok) throw const AppFailure(FailureKind.invalidInput, debugMessage: 'nutrients-range');
  }

  @override
  Future<void> updateEntry(
    String id, {
    required MealSlot meal,
    double? grams,
    Nutrients? manual,
  }) async {
    final row = await (_db.select(_db.foodLogs)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) throw const AppFailure(FailureKind.notFound);
    Nutrients? n;
    if (row.foodId != null && grams != null) {
      _checkGrams(grams);
      n = (await _food(row.foodId!)).per100g.forGrams(grams).rounded();
    } else if (row.foodId == null && manual != null) {
      _checkManual(manual);
      n = manual.rounded();
    }
    await (_db.update(_db.foodLogs)..where((t) => t.id.equals(id))).write(
      FoodLogsCompanion(
        meal: Value(meal.name),
        grams: row.foodId != null && grams != null ? Value(grams) : const Value.absent(),
        kcal: n == null ? const Value.absent() : Value(n.kcal),
        protein: n == null ? const Value.absent() : Value(n.protein),
        carbs: n == null ? const Value.absent() : Value(n.carbs),
        fat: n == null ? const Value.absent() : Value(n.fat),
        updatedAt: Value(_clock()),
      ),
    );
  }

  @override
  Future<void> deleteEntry(String id) =>
      (_db.delete(_db.foodLogs)..where((t) => t.id.equals(id))).go();

  @override
  Future<List<({String foodId, double? grams})>> recentFoods({int limit = 15}) async {
    final rows =
        await (_db.select(_db.foodLogs)
              ..where((t) => t.foodId.isNotNull())
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
              ..limit(200))
            .get();
    final seen = <String>{};
    return [
      for (final r in rows)
        if (seen.add(r.foodId!)) (foodId: r.foodId!, grams: r.grams),
    ].take(limit).toList();
  }

  @override
  Future<MealPlanningContext> mealPlanningContext() async {
    final profile = await readProfile(_db);
    final targetId = profile?.activeNutritionTargetId;
    final targetRow = targetId == null
        ? null
        : await (_db.select(
            _db.nutritionTargets,
          )..where((t) => t.id.equals(targetId))).getSingleOrNull();
    if (targetRow == null) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'no-nutrition-target');
    }
    final plan = NutritionPlan.fromJson(jsonDecode(targetRow.data) as Map<String, dynamic>);
    final assessmentId = profile!.latestAssessmentId;
    final aRow = assessmentId == null
        ? null
        : await (_db.select(
            _db.assessments,
          )..where((t) => t.id.equals(assessmentId))).getSingleOrNull();
    final assessment = aRow == null
        ? const AssessmentData()
        : AssessmentData.fromJson(jsonDecode(aRow.data) as Map<String, dynamic>);
    return (
      prefs: assessment.nutrition,
      target: targetOf(plan),
      eatingDisorderHistory: assessment.safety.medicalFlags.contains(
        MedicalFlag.eatingDisorderHistory,
      ),
    );
  }

  static Nutrients targetOf(NutritionPlan p) => Nutrients(
    kcal: p.targetKcal.toDouble(),
    protein: p.proteinG.toDouble(),
    carbs: p.carbsG.toDouble(),
    fat: p.fatG.toDouble(),
  );

  static MealPlan _plan(MealPlanRow r) =>
      MealPlan.fromJson(jsonDecode(r.data) as Map<String, dynamic>)._withMeta(r);

  @override
  Future<String> saveDraftMealPlan(MealPlan plan, {required String model}) async {
    final id = newId();
    await _db.transaction(() async {
      await (_db.delete(_db.mealPlans)..where((t) => t.status.equals('draft'))).go();
      await _db
          .into(_db.mealPlans)
          .insert(
            MealPlansCompanion.insert(
              id: id,
              status: 'draft',
              source: 'ai_generated',
              data: jsonEncode(plan.toJson()),
              model: Value(model),
              promptVersion: plan.promptVersion ?? '',
              catalogVersion: plan.catalogVersion ?? '',
              createdAt: _clock(),
            ),
          );
    });
    return id;
  }

  @override
  Stream<MealPlan?> watchMealPlan(String id) => (_db.select(
    _db.mealPlans,
  )..where((t) => t.id.equals(id))).watchSingleOrNull().map((r) => r == null ? null : _plan(r));

  @override
  Stream<MealPlan?> watchActiveMealPlan() =>
      (_db.select(_db.mealPlans)
            ..where((t) => t.status.equals('active'))
            ..orderBy([(t) => OrderingTerm.desc(t.activatedAt)])
            ..limit(1))
          .watchSingleOrNull()
          .map((r) => r == null ? null : _plan(r));

  @override
  Future<void> activateMealPlan(String id) async {
    final now = _clock();
    await _db.transaction(() async {
      final row = await (_db.select(
        _db.mealPlans,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (row == null) throw const AppFailure(FailureKind.notFound);
      if (row.status != 'draft') {
        throw const AppFailure(FailureKind.invalidInput, debugMessage: 'meal-plan-not-draft');
      }
      await (_db.update(_db.mealPlans)..where((t) => t.status.equals('active'))).write(
        MealPlansCompanion(status: const Value('archived'), archivedAt: Value(now)),
      );
      await (_db.update(_db.mealPlans)..where((t) => t.id.equals(id))).write(
        MealPlansCompanion(status: const Value('active'), activatedAt: Value(now)),
      );
    });
  }

  @override
  Future<void> deleteMealPlan(String id) =>
      (_db.delete(_db.mealPlans)..where((t) => t.id.equals(id))).go();

  @override
  Future<void> logPlannedMeal({
    required String date,
    required MealPlan plan,
    required int index,
  }) async {
    if (index < 0 || index >= plan.meals.length) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'meal-index');
    }
    final ref = planRef(plan.id, index);
    await _db.transaction(() async {
      final existing =
          await (_db.select(_db.foodLogs)
                ..where((t) => t.date.equals(date) & t.planRef.equals(ref))
                ..limit(1))
              .getSingleOrNull();
      if (existing != null) return;
      final meal = plan.meals[index];
      final foods = await catalog();
      for (final item in meal.items) {
        // Hitung ulang dari katalog terkini; bila bahan hilang, pakai salinan menu.
        final food = foods[item.foodId];
        await _insert(
          date: date,
          meal: meal.slot,
          name: item.name,
          foodId: item.foodId,
          grams: item.grams,
          nutrients: food?.per100g.forGrams(item.grams) ?? item.nutrients,
          quality: food?.quality ?? item.quality,
          planRef: ref,
        );
      }
    });
  }

  @override
  Future<void> unlogPlannedMeal({required String date, required String planRef}) => (_db.delete(
    _db.foodLogs,
  )..where((t) => t.date.equals(date) & t.planRef.equals(planRef))).go();
}

extension on MealPlan {
  MealPlan _withMeta(MealPlanRow r) => MealPlan(
    id: r.id,
    status: MealPlanStatus.values.byName(r.status),
    meals: meals,
    target: target,
    rationale: rationale,
    warnings: warnings,
    model: r.model,
    promptVersion: r.promptVersion,
    catalogVersion: r.catalogVersion,
  );
}
