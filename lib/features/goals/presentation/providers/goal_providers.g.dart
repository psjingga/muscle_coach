// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(goalRepository)
final goalRepositoryProvider = GoalRepositoryProvider._();

final class GoalRepositoryProvider
    extends $FunctionalProvider<GoalRepository, GoalRepository, GoalRepository>
    with $Provider<GoalRepository> {
  GoalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalRepositoryHash();

  @$internal
  @override
  $ProviderElement<GoalRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoalRepository create(Ref ref) {
    return goalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalRepository>(value),
    );
  }
}

String _$goalRepositoryHash() => r'f1008a4d03e5d836c088db76f76600b6b1aa69c1';

@ProviderFor(goal)
final goalProvider = GoalFamily._();

final class GoalProvider extends $FunctionalProvider<AsyncValue<Goal?>, Goal?, Stream<Goal?>>
    with $FutureModifier<Goal?>, $StreamProvider<Goal?> {
  GoalProvider._({required GoalFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'goalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalHash();

  @override
  String toString() {
    return r'goalProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Goal?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Goal?> create(Ref ref) {
    final argument = this.argument as String;
    return goal(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$goalHash() => r'3fe175dc9d711bb9f931f3f75782e73a9bb01b29';

final class GoalFamily extends $Family with $FunctionalFamilyOverride<Stream<Goal?>, String> {
  GoalFamily._()
    : super(
        retry: null,
        name: r'goalProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GoalProvider call(String goalId) => GoalProvider._(argument: goalId, from: this);

  @override
  String toString() => r'goalProvider';
}

/// Goal aktif berdasarkan `profile.activeGoalId`.

@ProviderFor(activeGoal)
final activeGoalProvider = ActiveGoalProvider._();

/// Goal aktif berdasarkan `profile.activeGoalId`.

final class ActiveGoalProvider extends $FunctionalProvider<AsyncValue<Goal?>, Goal?, Stream<Goal?>>
    with $FutureModifier<Goal?>, $StreamProvider<Goal?> {
  /// Goal aktif berdasarkan `profile.activeGoalId`.
  ActiveGoalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeGoalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeGoalHash();

  @$internal
  @override
  $StreamProviderElement<Goal?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Goal?> create(Ref ref) {
    return activeGoal(ref);
  }
}

String _$activeGoalHash() => r'9371747cadaa7f63866f4214907a66ef1afd2732';

/// Target nutrisi aktif berdasarkan `profile.activeNutritionTargetId`.

@ProviderFor(activeNutritionTarget)
final activeNutritionTargetProvider = ActiveNutritionTargetProvider._();

/// Target nutrisi aktif berdasarkan `profile.activeNutritionTargetId`.

final class ActiveNutritionTargetProvider
    extends $FunctionalProvider<AsyncValue<NutritionPlan?>, NutritionPlan?, Stream<NutritionPlan?>>
    with $FutureModifier<NutritionPlan?>, $StreamProvider<NutritionPlan?> {
  /// Target nutrisi aktif berdasarkan `profile.activeNutritionTargetId`.
  ActiveNutritionTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeNutritionTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeNutritionTargetHash();

  @$internal
  @override
  $StreamProviderElement<NutritionPlan?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<NutritionPlan?> create(Ref ref) {
    return activeNutritionTarget(ref);
  }
}

String _$activeNutritionTargetHash() => r'd803e3c8aaa0c1054f4ddabdeaa1b4c379a3dfbd';

/// Aksi konfirmasi goal; `state` = status aksi terakhir.

@ProviderFor(GoalConfirmController)
final goalConfirmControllerProvider = GoalConfirmControllerProvider._();

/// Aksi konfirmasi goal; `state` = status aksi terakhir.
final class GoalConfirmControllerProvider
    extends $AsyncNotifierProvider<GoalConfirmController, void> {
  /// Aksi konfirmasi goal; `state` = status aksi terakhir.
  GoalConfirmControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalConfirmControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalConfirmControllerHash();

  @$internal
  @override
  GoalConfirmController create() => GoalConfirmController();
}

String _$goalConfirmControllerHash() => r'e673a963b86ca1bc4a7c78519b3713d5e127c894';

/// Aksi konfirmasi goal; `state` = status aksi terakhir.

abstract class _$GoalConfirmController extends $AsyncNotifier<void> {
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
