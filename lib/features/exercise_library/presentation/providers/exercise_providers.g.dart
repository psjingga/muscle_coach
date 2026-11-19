// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseRepository)
final exerciseRepositoryProvider = ExerciseRepositoryProvider._();

final class ExerciseRepositoryProvider
    extends $FunctionalProvider<ExerciseRepository, ExerciseRepository, ExerciseRepository>
    with $Provider<ExerciseRepository> {
  ExerciseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExerciseRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExerciseRepository create(Ref ref) {
    return exerciseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseRepository>(value),
    );
  }
}

String _$exerciseRepositoryHash() => r'5f8cc9ab5f0020ac7df33dbc1148374734957dfd';

/// Katalog latihan, dimuat sekali lalu di-cache selama aplikasi berjalan.

@ProviderFor(exerciseCatalog)
final exerciseCatalogProvider = ExerciseCatalogProvider._();

/// Katalog latihan, dimuat sekali lalu di-cache selama aplikasi berjalan.

final class ExerciseCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Exercise>>,
          Map<String, Exercise>,
          FutureOr<Map<String, Exercise>>
        >
    with $FutureModifier<Map<String, Exercise>>, $FutureProvider<Map<String, Exercise>> {
  /// Katalog latihan, dimuat sekali lalu di-cache selama aplikasi berjalan.
  ExerciseCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseCatalogHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, Exercise>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, Exercise>> create(Ref ref) {
    return exerciseCatalog(ref);
  }
}

String _$exerciseCatalogHash() => r'af7b6a28670a9880b980742162ce293dabd9bfd5';
