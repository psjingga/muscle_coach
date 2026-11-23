// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_scan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(foodScanService)
final foodScanServiceProvider = FoodScanServiceProvider._();

final class FoodScanServiceProvider
    extends $FunctionalProvider<FoodScanService, FoodScanService, FoodScanService>
    with $Provider<FoodScanService> {
  FoodScanServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodScanServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodScanServiceHash();

  @$internal
  @override
  $ProviderElement<FoodScanService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FoodScanService create(Ref ref) {
    return foodScanService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodScanService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodScanService>(value),
    );
  }
}

String _$foodScanServiceHash() => r'21c5da9e7373628679b7d21cc3dad6ae5b6020c0';

/// Status scan terakhir (`AsyncError` berisi [AiPlanException]/`AppFailure`).

@ProviderFor(FoodScanner)
final foodScannerProvider = FoodScannerProvider._();

/// Status scan terakhir (`AsyncError` berisi [AiPlanException]/`AppFailure`).
final class FoodScannerProvider extends $AsyncNotifierProvider<FoodScanner, void> {
  /// Status scan terakhir (`AsyncError` berisi [AiPlanException]/`AppFailure`).
  FoodScannerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodScannerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodScannerHash();

  @$internal
  @override
  FoodScanner create() => FoodScanner();
}

String _$foodScannerHash() => r'd0f646b2b5dadac1560c02137734e696d43ee406';

/// Status scan terakhir (`AsyncError` berisi [AiPlanException]/`AppFailure`).

abstract class _$FoodScanner extends $AsyncNotifier<void> {
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

/// Draft yang ditinjau di layar hasil scan.

@ProviderFor(FoodScanDraftController)
final foodScanDraftControllerProvider = FoodScanDraftControllerProvider._();

/// Draft yang ditinjau di layar hasil scan.
final class FoodScanDraftControllerProvider
    extends $NotifierProvider<FoodScanDraftController, FoodScanDraft?> {
  /// Draft yang ditinjau di layar hasil scan.
  FoodScanDraftControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodScanDraftControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodScanDraftControllerHash();

  @$internal
  @override
  FoodScanDraftController create() => FoodScanDraftController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodScanDraft? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodScanDraft?>(value),
    );
  }
}

String _$foodScanDraftControllerHash() => r'c8de5584ab2481c26296310230c41f3575f79a4e';

/// Draft yang ditinjau di layar hasil scan.

abstract class _$FoodScanDraftController extends $Notifier<FoodScanDraft?> {
  FoodScanDraft? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FoodScanDraft?, FoodScanDraft?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FoodScanDraft?, FoodScanDraft?>,
              FoodScanDraft?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
