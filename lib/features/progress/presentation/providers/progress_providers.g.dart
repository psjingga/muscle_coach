// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(progressRepository)
final progressRepositoryProvider = ProgressRepositoryProvider._();

final class ProgressRepositoryProvider
    extends $FunctionalProvider<ProgressRepository, ProgressRepository, ProgressRepository>
    with $Provider<ProgressRepository> {
  ProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgressRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProgressRepository create(Ref ref) {
    return progressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressRepository>(value),
    );
  }
}

String _$progressRepositoryHash() => r'3106c2d2272b2bb9141af73b225d25d1c9d1ce3c';

@ProviderFor(weights)
final weightsProvider = WeightsProvider._();

final class WeightsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightEntry>>,
          List<WeightEntry>,
          Stream<List<WeightEntry>>
        >
    with $FutureModifier<List<WeightEntry>>, $StreamProvider<List<WeightEntry>> {
  WeightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightsHash();

  @$internal
  @override
  $StreamProviderElement<List<WeightEntry>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<WeightEntry>> create(Ref ref) {
    return weights(ref);
  }
}

String _$weightsHash() => r'39e3953005ca596fdc70d20ff2f8ccadf6723c6d';

@ProviderFor(checkIns)
final checkInsProvider = CheckInsProvider._();

final class CheckInsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DailyCheckIn>>,
          List<DailyCheckIn>,
          Stream<List<DailyCheckIn>>
        >
    with $FutureModifier<List<DailyCheckIn>>, $StreamProvider<List<DailyCheckIn>> {
  CheckInsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkInsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkInsHash();

  @$internal
  @override
  $StreamProviderElement<List<DailyCheckIn>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<DailyCheckIn>> create(Ref ref) {
    return checkIns(ref);
  }
}

String _$checkInsHash() => r'7e8cca4c91ee6c0aac5049890c667cc07ffb1d3f';

@ProviderFor(intakeByDay)
final intakeByDayProvider = IntakeByDayProvider._();

final class IntakeByDayProvider
    extends
        $FunctionalProvider<AsyncValue<List<DayIntake>>, List<DayIntake>, Stream<List<DayIntake>>>
    with $FutureModifier<List<DayIntake>>, $StreamProvider<List<DayIntake>> {
  IntakeByDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'intakeByDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$intakeByDayHash();

  @$internal
  @override
  $StreamProviderElement<List<DayIntake>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<DayIntake>> create(Ref ref) {
    return intakeByDay(ref);
  }
}

String _$intakeByDayHash() => r'8f08f064099dc9de80143f43b5df4ba15ecee350';

@ProviderFor(trainingDays)
final trainingDaysProvider = TrainingDaysProvider._();

final class TrainingDaysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TrainingDay>>,
          List<TrainingDay>,
          Stream<List<TrainingDay>>
        >
    with $FutureModifier<List<TrainingDay>>, $StreamProvider<List<TrainingDay>> {
  TrainingDaysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingDaysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingDaysHash();

  @$internal
  @override
  $StreamProviderElement<List<TrainingDay>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TrainingDay>> create(Ref ref) {
    return trainingDays(ref);
  }
}

String _$trainingDaysHash() => r'7c8f645b632fa673fa529115dd12ec88cc20dee4';

/// Hari latihan per minggu pada program aktif (berubah saat program diganti).

@ProviderFor(plannedSessionsPerWeek)
final plannedSessionsPerWeekProvider = PlannedSessionsPerWeekProvider._();

/// Hari latihan per minggu pada program aktif (berubah saat program diganti).

final class PlannedSessionsPerWeekProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Hari latihan per minggu pada program aktif (berubah saat program diganti).
  PlannedSessionsPerWeekProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannedSessionsPerWeekProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannedSessionsPerWeekHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return plannedSessionsPerWeek(ref);
  }
}

String _$plannedSessionsPerWeekHash() => r'172a63da0d9be3b38d79456b75f311763fa8f26a';

@ProviderFor(progressToday)
final progressTodayProvider = ProgressTodayProvider._();

final class ProgressTodayProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  ProgressTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressTodayHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return progressToday(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String>(value));
  }
}

String _$progressTodayHash() => r'2caaf327892706156d97288a278956695ce0c17f';

/// Status target dari tren berat.

@ProviderFor(goalProgress)
final goalProgressProvider = GoalProgressProvider._();

/// Status target dari tren berat.

final class GoalProgressProvider
    extends $FunctionalProvider<GoalProgress?, GoalProgress?, GoalProgress?>
    with $Provider<GoalProgress?> {
  /// Status target dari tren berat.
  GoalProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalProgressHash();

  @$internal
  @override
  $ProviderElement<GoalProgress?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoalProgress? create(Ref ref) {
    return goalProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalProgress? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalProgress?>(value),
    );
  }
}

String _$goalProgressHash() => r'921d2bdd987d5650d8ebd8982244fc5028be583a';

/// Ringkasan minggu [weekStart] (dihitung langsung dari data).

@ProviderFor(weekSummary)
final weekSummaryProvider = WeekSummaryFamily._();

/// Ringkasan minggu [weekStart] (dihitung langsung dari data).

final class WeekSummaryProvider
    extends $FunctionalProvider<WeekSummary?, WeekSummary?, WeekSummary?>
    with $Provider<WeekSummary?> {
  /// Ringkasan minggu [weekStart] (dihitung langsung dari data).
  WeekSummaryProvider._({required WeekSummaryFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'weekSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekSummaryHash();

  @override
  String toString() {
    return r'weekSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<WeekSummary?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeekSummary? create(Ref ref) {
    final argument = this.argument as String;
    return weekSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeekSummary? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeekSummary?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WeekSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weekSummaryHash() => r'4342bcf4dd6b6a82d99ff3a208bcfe6f7b68bdef';

/// Ringkasan minggu [weekStart] (dihitung langsung dari data).

final class WeekSummaryFamily extends $Family with $FunctionalFamilyOverride<WeekSummary?, String> {
  WeekSummaryFamily._()
    : super(
        retry: null,
        name: r'weekSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Ringkasan minggu [weekStart] (dihitung langsung dari data).

  WeekSummaryProvider call(String weekStart) =>
      WeekSummaryProvider._(argument: weekStart, from: this);

  @override
  String toString() => r'weekSummaryProvider';
}

/// Usulan penyesuaian berdasarkan 2 minggu lengkap terakhir sebelum [weekStart]+7.

@ProviderFor(adjustmentFor)
final adjustmentForProvider = AdjustmentForFamily._();

/// Usulan penyesuaian berdasarkan 2 minggu lengkap terakhir sebelum [weekStart]+7.

final class AdjustmentForProvider
    extends
        $FunctionalProvider<
          ({NutritionAdjustment? adjustment, AdjustmentBlock? block})?,
          ({NutritionAdjustment? adjustment, AdjustmentBlock? block})?,
          ({NutritionAdjustment? adjustment, AdjustmentBlock? block})?
        >
    with $Provider<({NutritionAdjustment? adjustment, AdjustmentBlock? block})?> {
  /// Usulan penyesuaian berdasarkan 2 minggu lengkap terakhir sebelum [weekStart]+7.
  AdjustmentForProvider._({required AdjustmentForFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'adjustmentForProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adjustmentForHash();

  @override
  String toString() {
    return r'adjustmentForProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<({NutritionAdjustment? adjustment, AdjustmentBlock? block})?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({NutritionAdjustment? adjustment, AdjustmentBlock? block})? create(Ref ref) {
    final argument = this.argument as String;
    return adjustmentFor(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({NutritionAdjustment? adjustment, AdjustmentBlock? block})? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({NutritionAdjustment? adjustment, AdjustmentBlock? block})?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdjustmentForProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adjustmentForHash() => r'46001b13261e05cf93725c7fac5c80655d2cdd4d';

/// Usulan penyesuaian berdasarkan 2 minggu lengkap terakhir sebelum [weekStart]+7.

final class AdjustmentForFamily extends $Family
    with
        $FunctionalFamilyOverride<
          ({NutritionAdjustment? adjustment, AdjustmentBlock? block})?,
          String
        > {
  AdjustmentForFamily._()
    : super(
        retry: null,
        name: r'adjustmentForProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Usulan penyesuaian berdasarkan 2 minggu lengkap terakhir sebelum [weekStart]+7.

  AdjustmentForProvider call(String weekStart) =>
      AdjustmentForProvider._(argument: weekStart, from: this);

  @override
  String toString() => r'adjustmentForProvider';
}

@ProviderFor(storedReview)
final storedReviewProvider = StoredReviewFamily._();

final class StoredReviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<StoredWeeklyReview?>,
          StoredWeeklyReview?,
          Stream<StoredWeeklyReview?>
        >
    with $FutureModifier<StoredWeeklyReview?>, $StreamProvider<StoredWeeklyReview?> {
  StoredReviewProvider._({required StoredReviewFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'storedReviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storedReviewHash();

  @override
  String toString() {
    return r'storedReviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<StoredWeeklyReview?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<StoredWeeklyReview?> create(Ref ref) {
    final argument = this.argument as String;
    return storedReview(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StoredReviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storedReviewHash() => r'9d4e4f6671f50600763d6b8e6a463dfdf3abc8b3';

final class StoredReviewFamily extends $Family
    with $FunctionalFamilyOverride<Stream<StoredWeeklyReview?>, String> {
  StoredReviewFamily._()
    : super(
        retry: null,
        name: r'storedReviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StoredReviewProvider call(String weekStart) =>
      StoredReviewProvider._(argument: weekStart, from: this);

  @override
  String toString() => r'storedReviewProvider';
}

@ProviderFor(storedReviews)
final storedReviewsProvider = StoredReviewsProvider._();

final class StoredReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StoredWeeklyReview>>,
          List<StoredWeeklyReview>,
          Stream<List<StoredWeeklyReview>>
        >
    with $FutureModifier<List<StoredWeeklyReview>>, $StreamProvider<List<StoredWeeklyReview>> {
  StoredReviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storedReviewsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storedReviewsHash();

  @$internal
  @override
  $StreamProviderElement<List<StoredWeeklyReview>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<StoredWeeklyReview>> create(Ref ref) {
    return storedReviews(ref);
  }
}

String _$storedReviewsHash() => r'9ba36d3c0c13011f19022ee73a2d229ecaef6038';

@ProviderFor(weeklyReviewService)
final weeklyReviewServiceProvider = WeeklyReviewServiceProvider._();

final class WeeklyReviewServiceProvider
    extends $FunctionalProvider<WeeklyReviewService, WeeklyReviewService, WeeklyReviewService>
    with $Provider<WeeklyReviewService> {
  WeeklyReviewServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyReviewServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyReviewServiceHash();

  @$internal
  @override
  $ProviderElement<WeeklyReviewService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeeklyReviewService create(Ref ref) {
    return weeklyReviewService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeeklyReviewService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeeklyReviewService>(value),
    );
  }
}

String _$weeklyReviewServiceHash() => r'aba9721adf4e2dd405194af523175482b371fb73';

/// Aksi progres (berat, check-in, keputusan penyesuaian, ringkasan AI).
/// keepAlive: dipanggil dari callback yang tidak mendengarkan provider ini.

@ProviderFor(ProgressActions)
final progressActionsProvider = ProgressActionsProvider._();

/// Aksi progres (berat, check-in, keputusan penyesuaian, ringkasan AI).
/// keepAlive: dipanggil dari callback yang tidak mendengarkan provider ini.
final class ProgressActionsProvider extends $AsyncNotifierProvider<ProgressActions, void> {
  /// Aksi progres (berat, check-in, keputusan penyesuaian, ringkasan AI).
  /// keepAlive: dipanggil dari callback yang tidak mendengarkan provider ini.
  ProgressActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressActionsHash();

  @$internal
  @override
  ProgressActions create() => ProgressActions();
}

String _$progressActionsHash() => r'5122639a20f74738a9679864e57b8fa800783a1b';

/// Aksi progres (berat, check-in, keputusan penyesuaian, ringkasan AI).
/// keepAlive: dipanggil dari callback yang tidak mendengarkan provider ini.

abstract class _$ProgressActions extends $AsyncNotifier<void> {
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
