// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(foodDataSource)
final foodDataSourceProvider = FoodDataSourceProvider._();

final class FoodDataSourceProvider
    extends $FunctionalProvider<FoodDataSource, FoodDataSource, FoodDataSource>
    with $Provider<FoodDataSource> {
  FoodDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodDataSourceHash();

  @$internal
  @override
  $ProviderElement<FoodDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FoodDataSource create(Ref ref) {
    return foodDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodDataSource>(value),
    );
  }
}

String _$foodDataSourceHash() => r'9d952fb70d1b23f742ea0eecb2b0563af34dd3dd';

@ProviderFor(nutritionRepository)
final nutritionRepositoryProvider = NutritionRepositoryProvider._();

final class NutritionRepositoryProvider
    extends $FunctionalProvider<NutritionRepository, NutritionRepository, NutritionRepository>
    with $Provider<NutritionRepository> {
  NutritionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionRepositoryHash();

  @$internal
  @override
  $ProviderElement<NutritionRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NutritionRepository create(Ref ref) {
    return nutritionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NutritionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NutritionRepository>(value),
    );
  }
}

String _$nutritionRepositoryHash() => r'93e211421ea0636ff9a7e36f170c1e53fc0c0598';

@ProviderFor(foodSourceInfo)
final foodSourceInfoProvider = FoodSourceInfoProvider._();

final class FoodSourceInfoProvider
    extends
        $FunctionalProvider<AsyncValue<FoodSourceInfo>, FoodSourceInfo, FutureOr<FoodSourceInfo>>
    with $FutureModifier<FoodSourceInfo>, $FutureProvider<FoodSourceInfo> {
  FoodSourceInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodSourceInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodSourceInfoHash();

  @$internal
  @override
  $FutureProviderElement<FoodSourceInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<FoodSourceInfo> create(Ref ref) {
    return foodSourceInfo(ref);
  }
}

String _$foodSourceInfoHash() => r'5f636448829767765432729ffd88cca8994707a3';

@ProviderFor(customFoods)
final customFoodsProvider = CustomFoodsProvider._();

final class CustomFoodsProvider
    extends $FunctionalProvider<AsyncValue<List<Food>>, List<Food>, Stream<List<Food>>>
    with $FutureModifier<List<Food>>, $StreamProvider<List<Food>> {
  CustomFoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customFoodsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customFoodsHash();

  @$internal
  @override
  $StreamProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Food>> create(Ref ref) {
    return customFoods(ref);
  }
}

String _$customFoodsHash() => r'de7a9f7b90cb2b588b203675bd722c0340ed3cd7';

/// Katalog lengkap (TKPI + makanan sendiri), diperbarui saat makanan sendiri berubah.

@ProviderFor(foodCatalog)
final foodCatalogProvider = FoodCatalogProvider._();

/// Katalog lengkap (TKPI + makanan sendiri), diperbarui saat makanan sendiri berubah.

final class FoodCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Food>>,
          Map<String, Food>,
          FutureOr<Map<String, Food>>
        >
    with $FutureModifier<Map<String, Food>>, $FutureProvider<Map<String, Food>> {
  /// Katalog lengkap (TKPI + makanan sendiri), diperbarui saat makanan sendiri berubah.
  FoodCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodCatalogHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, Food>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, Food>> create(Ref ref) {
    return foodCatalog(ref);
  }
}

String _$foodCatalogHash() => r'782cf0e5007802ff88e213306b063929fe0e78e9';

/// Hasil pencarian; kueri kosong → makanan terakhir dicatat.

@ProviderFor(foodSearch)
final foodSearchProvider = FoodSearchFamily._();

/// Hasil pencarian; kueri kosong → makanan terakhir dicatat.

final class FoodSearchProvider
    extends $FunctionalProvider<AsyncValue<List<Food>>, List<Food>, FutureOr<List<Food>>>
    with $FutureModifier<List<Food>>, $FutureProvider<List<Food>> {
  /// Hasil pencarian; kueri kosong → makanan terakhir dicatat.
  FoodSearchProvider._({required FoodSearchFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'foodSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodSearchHash();

  @override
  String toString() {
    return r'foodSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Food>> create(Ref ref) {
    final argument = this.argument as String;
    return foodSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodSearchHash() => r'559ac56ce54151c2939ea8b8ddaea7738252f5e2';

/// Hasil pencarian; kueri kosong → makanan terakhir dicatat.

final class FoodSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Food>>, String> {
  FoodSearchFamily._()
    : super(
        retry: null,
        name: r'foodSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Hasil pencarian; kueri kosong → makanan terakhir dicatat.

  FoodSearchProvider call(String query) => FoodSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'foodSearchProvider';
}

/// Gram terakhir per makanan (untuk isian porsi bawaan).

@ProviderFor(recentGrams)
final recentGramsProvider = RecentGramsProvider._();

/// Gram terakhir per makanan (untuk isian porsi bawaan).

final class RecentGramsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          FutureOr<Map<String, double>>
        >
    with $FutureModifier<Map<String, double>>, $FutureProvider<Map<String, double>> {
  /// Gram terakhir per makanan (untuk isian porsi bawaan).
  RecentGramsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentGramsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentGramsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, double>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, double>> create(Ref ref) {
    return recentGrams(ref);
  }
}

String _$recentGramsHash() => r'6aa4195d20d8d36ed45624a8f3e91f31f2e96674';

/// Target harian aktif sebagai [Nutrients].

@ProviderFor(nutritionTargetNutrients)
final nutritionTargetNutrientsProvider = NutritionTargetNutrientsProvider._();

/// Target harian aktif sebagai [Nutrients].

final class NutritionTargetNutrientsProvider
    extends $FunctionalProvider<Nutrients?, Nutrients?, Nutrients?>
    with $Provider<Nutrients?> {
  /// Target harian aktif sebagai [Nutrients].
  NutritionTargetNutrientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionTargetNutrientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionTargetNutrientsHash();

  @$internal
  @override
  $ProviderElement<Nutrients?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Nutrients? create(Ref ref) {
    return nutritionTargetNutrients(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Nutrients? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Nutrients?>(value));
  }
}

String _$nutritionTargetNutrientsHash() => r'a806385f60c817f0bd695c5869ac4421a68ed474';

@ProviderFor(foodLogDay)
final foodLogDayProvider = FoodLogDayFamily._();

final class FoodLogDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FoodLogEntry>>,
          List<FoodLogEntry>,
          Stream<List<FoodLogEntry>>
        >
    with $FutureModifier<List<FoodLogEntry>>, $StreamProvider<List<FoodLogEntry>> {
  FoodLogDayProvider._({required FoodLogDayFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'foodLogDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodLogDayHash();

  @override
  String toString() {
    return r'foodLogDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<FoodLogEntry>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<FoodLogEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return foodLogDay(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodLogDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodLogDayHash() => r'6e5112a6674724c0eaed39fa81d4af4b4c437cfd';

final class FoodLogDayFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<FoodLogEntry>>, String> {
  FoodLogDayFamily._()
    : super(
        retry: null,
        name: r'foodLogDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FoodLogDayProvider call(String date) => FoodLogDayProvider._(argument: date, from: this);

  @override
  String toString() => r'foodLogDayProvider';
}

/// Ringkasan satu hari terhadap target aktif.

@ProviderFor(dayNutrition)
final dayNutritionProvider = DayNutritionFamily._();

/// Ringkasan satu hari terhadap target aktif.

final class DayNutritionProvider
    extends
        $FunctionalProvider<
          AsyncValue<DayNutrition>,
          AsyncValue<DayNutrition>,
          AsyncValue<DayNutrition>
        >
    with $Provider<AsyncValue<DayNutrition>> {
  /// Ringkasan satu hari terhadap target aktif.
  DayNutritionProvider._({required DayNutritionFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'dayNutritionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dayNutritionHash();

  @override
  String toString() {
    return r'dayNutritionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<DayNutrition>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<DayNutrition> create(Ref ref) {
    final argument = this.argument as String;
    return dayNutrition(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<DayNutrition> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<DayNutrition>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DayNutritionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dayNutritionHash() => r'9197bcd5fc6ec7539f80b19adfca082dea29c838';

/// Ringkasan satu hari terhadap target aktif.

final class DayNutritionFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<DayNutrition>, String> {
  DayNutritionFamily._()
    : super(
        retry: null,
        name: r'dayNutritionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Ringkasan satu hari terhadap target aktif.

  DayNutritionProvider call(String date) => DayNutritionProvider._(argument: date, from: this);

  @override
  String toString() => r'dayNutritionProvider';
}

/// Tanggal hari ini `YYYY-MM-DD`.

@ProviderFor(todayDate)
final todayDateProvider = TodayDateProvider._();

/// Tanggal hari ini `YYYY-MM-DD`.

final class TodayDateProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Tanggal hari ini `YYYY-MM-DD`.
  TodayDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayDateHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return todayDate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String>(value));
  }
}

String _$todayDateHash() => r'253486ebf9c80f501c26f65bea0be06e28fa6a44';

@ProviderFor(activeMealPlan)
final activeMealPlanProvider = ActiveMealPlanProvider._();

final class ActiveMealPlanProvider
    extends $FunctionalProvider<AsyncValue<MealPlan?>, MealPlan?, Stream<MealPlan?>>
    with $FutureModifier<MealPlan?>, $StreamProvider<MealPlan?> {
  ActiveMealPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMealPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMealPlanHash();

  @$internal
  @override
  $StreamProviderElement<MealPlan?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<MealPlan?> create(Ref ref) {
    return activeMealPlan(ref);
  }
}

String _$activeMealPlanHash() => r'1fb8ec0c246fc8d2108bfed02b5ae285f245683e';

@ProviderFor(mealPlan)
final mealPlanProvider = MealPlanFamily._();

final class MealPlanProvider
    extends $FunctionalProvider<AsyncValue<MealPlan?>, MealPlan?, Stream<MealPlan?>>
    with $FutureModifier<MealPlan?>, $StreamProvider<MealPlan?> {
  MealPlanProvider._({required MealPlanFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'mealPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanHash();

  @override
  String toString() {
    return r'mealPlanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<MealPlan?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<MealPlan?> create(Ref ref) {
    final argument = this.argument as String;
    return mealPlan(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MealPlanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mealPlanHash() => r'174fc40f5869b445eb15ec1e1f3050b10e5aaf90';

final class MealPlanFamily extends $Family
    with $FunctionalFamilyOverride<Stream<MealPlan?>, String> {
  MealPlanFamily._()
    : super(
        retry: null,
        name: r'mealPlanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MealPlanProvider call(String id) => MealPlanProvider._(argument: id, from: this);

  @override
  String toString() => r'mealPlanProvider';
}

@ProviderFor(mealPlanService)
final mealPlanServiceProvider = MealPlanServiceProvider._();

final class MealPlanServiceProvider
    extends $FunctionalProvider<MealPlanService, MealPlanService, MealPlanService>
    with $Provider<MealPlanService> {
  MealPlanServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanServiceHash();

  @$internal
  @override
  $ProviderElement<MealPlanService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MealPlanService create(Ref ref) {
    return mealPlanService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealPlanService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealPlanService>(value),
    );
  }
}

String _$mealPlanServiceHash() => r'0dd60cc5d3033147272d13eb6e670a107a695883';

/// Aksi pencatatan makanan & menu. `state` = status aksi terakhir.
/// keepAlive: aksi dipanggil dari callback (lembar porsi, dialog) yang tidak
/// mendengarkan provider ini, jadi jangan sampai di-dispose di tengah aksi.

@ProviderFor(NutritionActions)
final nutritionActionsProvider = NutritionActionsProvider._();

/// Aksi pencatatan makanan & menu. `state` = status aksi terakhir.
/// keepAlive: aksi dipanggil dari callback (lembar porsi, dialog) yang tidak
/// mendengarkan provider ini, jadi jangan sampai di-dispose di tengah aksi.
final class NutritionActionsProvider extends $AsyncNotifierProvider<NutritionActions, void> {
  /// Aksi pencatatan makanan & menu. `state` = status aksi terakhir.
  /// keepAlive: aksi dipanggil dari callback (lembar porsi, dialog) yang tidak
  /// mendengarkan provider ini, jadi jangan sampai di-dispose di tengah aksi.
  NutritionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionActionsHash();

  @$internal
  @override
  NutritionActions create() => NutritionActions();
}

String _$nutritionActionsHash() => r'c231283b1b04e8c601b3527f6acbcfdced1fb1bf';

/// Aksi pencatatan makanan & menu. `state` = status aksi terakhir.
/// keepAlive: aksi dipanggil dari callback (lembar porsi, dialog) yang tidak
/// mendengarkan provider ini, jadi jangan sampai di-dispose di tengah aksi.

abstract class _$NutritionActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Aksi "Susun menu dengan AI"; `state` = status aksi terakhir.

@ProviderFor(MealPlanGenerator)
final mealPlanGeneratorProvider = MealPlanGeneratorProvider._();

/// Aksi "Susun menu dengan AI"; `state` = status aksi terakhir.
final class MealPlanGeneratorProvider extends $AsyncNotifierProvider<MealPlanGenerator, void> {
  /// Aksi "Susun menu dengan AI"; `state` = status aksi terakhir.
  MealPlanGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanGeneratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanGeneratorHash();

  @$internal
  @override
  MealPlanGenerator create() => MealPlanGenerator();
}

String _$mealPlanGeneratorHash() => r'9e44b76fe45e34d5a13b7e79edb359dd79230d27';

/// Aksi "Susun menu dengan AI"; `state` = status aksi terakhir.

abstract class _$MealPlanGenerator extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
