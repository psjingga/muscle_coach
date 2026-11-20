// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiKeyStore)
final aiKeyStoreProvider = AiKeyStoreProvider._();

final class AiKeyStoreProvider extends $FunctionalProvider<AiKeyStore, AiKeyStore, AiKeyStore>
    with $Provider<AiKeyStore> {
  AiKeyStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiKeyStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiKeyStoreHash();

  @$internal
  @override
  $ProviderElement<AiKeyStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiKeyStore create(Ref ref) {
    return aiKeyStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiKeyStore value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AiKeyStore>(value));
  }
}

String _$aiKeyStoreHash() => r'89bd51807790dc466f95adaf3f98d2534683377c';

@ProviderFor(aiClient)
final aiClientProvider = AiClientProvider._();

final class AiClientProvider extends $FunctionalProvider<AiClient, AiClient, AiClient>
    with $Provider<AiClient> {
  AiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiClientHash();

  @$internal
  @override
  $ProviderElement<AiClient> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AiClient create(Ref ref) {
    return aiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiClient value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AiClient>(value));
  }
}

String _$aiClientHash() => r'9a47215210177d86bebf43761f8e7aa58add9c18';

@ProviderFor(aiRepository)
final aiRepositoryProvider = AiRepositoryProvider._();

final class AiRepositoryProvider
    extends $FunctionalProvider<AiRepository, AiRepository, AiRepository>
    with $Provider<AiRepository> {
  AiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiRepository create(Ref ref) {
    return aiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiRepository>(value),
    );
  }
}

String _$aiRepositoryHash() => r'8030bf92f1b381a352fd8fc9f4cb831a9ff4ced9';

@ProviderFor(aiPlanService)
final aiPlanServiceProvider = AiPlanServiceProvider._();

final class AiPlanServiceProvider
    extends $FunctionalProvider<AiPlanService, AiPlanService, AiPlanService>
    with $Provider<AiPlanService> {
  AiPlanServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiPlanServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiPlanServiceHash();

  @$internal
  @override
  $ProviderElement<AiPlanService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiPlanService create(Ref ref) {
    return aiPlanService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiPlanService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiPlanService>(value),
    );
  }
}

String _$aiPlanServiceHash() => r'1b81f714726d499f733e2a58512f9480aa08f4cf';

/// Pengaturan AI. Key tidak pernah disimpan di state (hanya akhiran).

@ProviderFor(AiSettingsController)
final aiSettingsControllerProvider = AiSettingsControllerProvider._();

/// Pengaturan AI. Key tidak pernah disimpan di state (hanya akhiran).
final class AiSettingsControllerProvider
    extends $AsyncNotifierProvider<AiSettingsController, AiSettings> {
  /// Pengaturan AI. Key tidak pernah disimpan di state (hanya akhiran).
  AiSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSettingsControllerHash();

  @$internal
  @override
  AiSettingsController create() => AiSettingsController();
}

String _$aiSettingsControllerHash() => r'aac323d06a10a3cdb0d282dc6ed51d0483f8df58';

/// Pengaturan AI. Key tidak pernah disimpan di state (hanya akhiran).

abstract class _$AiSettingsController extends $AsyncNotifier<AiSettings> {
  FutureOr<AiSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AiSettings>, AiSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiSettings>, AiSettings>,
              AsyncValue<AiSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Aksi "Susun program dengan AI"; `state` = status aksi terakhir.

@ProviderFor(AiPlanGenerator)
final aiPlanGeneratorProvider = AiPlanGeneratorProvider._();

/// Aksi "Susun program dengan AI"; `state` = status aksi terakhir.
final class AiPlanGeneratorProvider extends $AsyncNotifierProvider<AiPlanGenerator, void> {
  /// Aksi "Susun program dengan AI"; `state` = status aksi terakhir.
  AiPlanGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiPlanGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiPlanGeneratorHash();

  @$internal
  @override
  AiPlanGenerator create() => AiPlanGenerator();
}

String _$aiPlanGeneratorHash() => r'339ba2f26465f363c95a22328962b55e09438071';

/// Aksi "Susun program dengan AI"; `state` = status aksi terakhir.

abstract class _$AiPlanGenerator extends $AsyncNotifier<void> {
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
