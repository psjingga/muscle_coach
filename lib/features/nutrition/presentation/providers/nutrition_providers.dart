import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/utils/formatters.dart';
import '../../../ai_coach/application/ai_plan_service.dart';
import '../../../ai_coach/domain/ai_config.dart';
import '../../../ai_coach/presentation/providers/ai_providers.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../application/meal_plan_service.dart';
import '../../data/nutrition_repository.dart';
import '../../data/tkpi_food_data_source.dart';
import '../../domain/food.dart';
import '../../domain/food_log.dart';
import '../../domain/food_search.dart';
import '../../domain/meal_plan.dart';

part 'nutrition_providers.g.dart';

@Riverpod(keepAlive: true)
FoodDataSource foodDataSource(Ref ref) => TkpiAssetFoodDataSource(rootBundle);

@Riverpod(keepAlive: true)
NutritionRepository nutritionRepository(Ref ref) => LocalNutritionRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(clockProvider),
  ref.watch(foodDataSourceProvider),
);

@Riverpod(keepAlive: true)
Future<FoodSourceInfo> foodSourceInfo(Ref ref) => ref.watch(foodDataSourceProvider).info();

@Riverpod(keepAlive: true)
Stream<List<Food>> customFoods(Ref ref) =>
    ref.watch(nutritionRepositoryProvider).watchCustomFoods();

/// Katalog lengkap (TKPI + makanan sendiri), diperbarui saat makanan sendiri berubah.
@Riverpod(keepAlive: true)
Future<Map<String, Food>> foodCatalog(Ref ref) async {
  await ref.watch(customFoodsProvider.future);
  return ref.watch(nutritionRepositoryProvider).catalog();
}

/// Hasil pencarian; kueri kosong → makanan terakhir dicatat.
@riverpod
Future<List<Food>> foodSearch(Ref ref, String query) async {
  final catalog = await ref.watch(foodCatalogProvider.future);
  if (query.trim().isEmpty) {
    final recent = await ref.watch(nutritionRepositoryProvider).recentFoods();
    return [for (final r in recent) ?catalog[r.foodId]];
  }
  return FoodSearch.search(catalog.values, query);
}

/// Gram terakhir per makanan (untuk isian porsi bawaan).
@riverpod
Future<Map<String, double>> recentGrams(Ref ref) async {
  await ref.watch(foodCatalogProvider.future);
  final recent = await ref.watch(nutritionRepositoryProvider).recentFoods(limit: 200);
  return {
    for (final r in recent)
      if (r.grams != null) r.foodId: r.grams!,
  };
}

/// Target harian aktif sebagai [Nutrients].
@riverpod
Nutrients? nutritionTargetNutrients(Ref ref) {
  final plan = ref.watch(activeNutritionTargetProvider).value;
  return plan == null ? null : LocalNutritionRepository.targetOf(plan);
}

@riverpod
Stream<List<FoodLogEntry>> foodLogDay(Ref ref, String date) =>
    ref.watch(nutritionRepositoryProvider).watchDay(date);

/// Ringkasan satu hari terhadap target aktif.
@riverpod
AsyncValue<DayNutrition> dayNutrition(Ref ref, String date) => ref
    .watch(foodLogDayProvider(date))
    .whenData((e) => DayNutrition(e, target: ref.watch(nutritionTargetNutrientsProvider)));

/// Tanggal hari ini `YYYY-MM-DD`.
@riverpod
String todayDate(Ref ref) => Fmt.toIsoDate(ref.watch(clockProvider)());

@riverpod
Stream<MealPlan?> activeMealPlan(Ref ref) =>
    ref.watch(nutritionRepositoryProvider).watchActiveMealPlan();

@riverpod
Stream<MealPlan?> mealPlan(Ref ref, String id) =>
    ref.watch(nutritionRepositoryProvider).watchMealPlan(id);

@Riverpod(keepAlive: true)
MealPlanService mealPlanService(Ref ref) {
  final keys = ref.watch(aiKeyStoreProvider);
  return MealPlanService(
    nutrition: ref.watch(nutritionRepositoryProvider),
    ai: ref.watch(aiRepositoryProvider),
    client: ref.watch(aiClientProvider),
    keys: keys,
    clock: ref.watch(clockProvider),
    model: () async => await keys.readModel() ?? AiConfig.defaultModel,
  );
}

/// Aksi pencatatan makanan & menu. `state` = status aksi terakhir.
/// keepAlive: aksi dipanggil dari callback (lembar porsi, dialog) yang tidak
/// mendengarkan provider ini, jadi jangan sampai di-dispose di tengah aksi.
@Riverpod(keepAlive: true)
class NutritionActions extends _$NutritionActions {
  @override
  FutureOr<void> build() {}

  NutritionRepository get _repo => ref.read(nutritionRepositoryProvider);

  Future<T?> _run<T>(Future<T> Function() action) async {
    state = const AsyncLoading();
    try {
      final value = await action();
      if (ref.mounted) state = const AsyncData(null);
      return value;
    } catch (e, st) {
      final failure = FailureMapper.from(e);
      // Tanpa isi data makanan di log.
      appLogger.w('Aksi nutrisi gagal: ${failure.kind.name}');
      if (ref.mounted) state = AsyncError(failure, st);
      return null;
    }
  }

  Future<bool> _ok(Future<void> Function() action) async =>
      await _run(() async {
        await action();
        return true;
      }) ??
      false;

  Future<bool> logFood({
    required String date,
    required MealSlot meal,
    required Food food,
    required double grams,
  }) => _ok(() => _repo.logFood(date: date, meal: meal, food: food, grams: grams));

  Future<bool> logManual({
    required String date,
    required MealSlot meal,
    required String name,
    required Nutrients nutrients,
  }) => _ok(() => _repo.logManual(date: date, meal: meal, name: name, nutrients: nutrients));

  Future<bool> updateEntry(String id, {required MealSlot meal, double? grams, Nutrients? manual}) =>
      _ok(() => _repo.updateEntry(id, meal: meal, grams: grams, manual: manual));

  Future<bool> deleteEntry(String id) => _ok(() => _repo.deleteEntry(id));

  Future<String?> addCustomFood({
    required String name,
    required Nutrients per100g,
    double? servingGrams,
  }) => _run(() => _repo.addCustomFood(name: name, per100g: per100g, servingGrams: servingGrams));

  Future<bool> deleteCustomFood(String id) => _ok(() => _repo.deleteCustomFood(id));

  Future<bool> activateMealPlan(String id) => _ok(() => _repo.activateMealPlan(id));
  Future<bool> deleteMealPlan(String id) => _ok(() => _repo.deleteMealPlan(id));

  Future<bool> logPlannedMeal(String date, MealPlan plan, int index) =>
      _ok(() => _repo.logPlannedMeal(date: date, plan: plan, index: index));

  Future<bool> unlogPlannedMeal(String date, MealPlan plan, int index) => _ok(
    () => _repo.unlogPlannedMeal(
      date: date,
      planRef: LocalNutritionRepository.planRef(plan.id, index),
    ),
  );
}

/// Aksi "Susun menu dengan AI"; `state` = status aksi terakhir.
@Riverpod(keepAlive: true)
class MealPlanGenerator extends _$MealPlanGenerator {
  @override
  FutureOr<void> build() {}

  /// ID draft menu, atau `null` bila gagal (error di `state`).
  Future<String?> generate() async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(mealPlanServiceProvider).generate();
      if (ref.mounted) state = const AsyncData(null);
      return id;
    } on AiPlanException catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
      return null;
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(FailureMapper.from(e), st);
      return null;
    }
  }
}
