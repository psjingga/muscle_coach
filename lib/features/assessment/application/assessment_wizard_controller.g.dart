// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_wizard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assessmentRepository)
final assessmentRepositoryProvider = AssessmentRepositoryProvider._();

final class AssessmentRepositoryProvider
    extends $FunctionalProvider<AssessmentRepository, AssessmentRepository, AssessmentRepository>
    with $Provider<AssessmentRepository> {
  AssessmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assessmentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assessmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<AssessmentRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssessmentRepository create(Ref ref) {
    return assessmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssessmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssessmentRepository>(value),
    );
  }
}

String _$assessmentRepositoryHash() => r'b2fac25a9c4de58889eb2ae551611f22f4d690aa';

/// Jam yang dipakai validasi usia (dapat dioverride di test).

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// Jam yang dipakai validasi usia (dapat dioverride di test).

final class ClockProvider
    extends $FunctionalProvider<DateTime Function(), DateTime Function(), DateTime Function()>
    with $Provider<DateTime Function()> {
  /// Jam yang dipakai validasi usia (dapat dioverride di test).
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3b571c5a0c08b7391c0eed04391003191bab6ccf';

/// Wizard assessment 7 langkah: memuat draft (atau assessment terakhir),
/// memvalidasi per langkah, menyimpan draft saat pindah langkah, lalu
/// mengirim ke server.

@ProviderFor(AssessmentWizard)
final assessmentWizardProvider = AssessmentWizardProvider._();

/// Wizard assessment 7 langkah: memuat draft (atau assessment terakhir),
/// memvalidasi per langkah, menyimpan draft saat pindah langkah, lalu
/// mengirim ke server.
final class AssessmentWizardProvider
    extends $AsyncNotifierProvider<AssessmentWizard, AssessmentWizardState> {
  /// Wizard assessment 7 langkah: memuat draft (atau assessment terakhir),
  /// memvalidasi per langkah, menyimpan draft saat pindah langkah, lalu
  /// mengirim ke server.
  AssessmentWizardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assessmentWizardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assessmentWizardHash();

  @$internal
  @override
  AssessmentWizard create() => AssessmentWizard();
}

String _$assessmentWizardHash() => r'3655d61f8c42ebc3458a6af82998a4f18d646d28';

/// Wizard assessment 7 langkah: memuat draft (atau assessment terakhir),
/// memvalidasi per langkah, menyimpan draft saat pindah langkah, lalu
/// mengirim ke server.

abstract class _$AssessmentWizard extends $AsyncNotifier<AssessmentWizardState> {
  FutureOr<AssessmentWizardState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AssessmentWizardState>, AssessmentWizardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssessmentWizardState>, AssessmentWizardState>,
              AsyncValue<AssessmentWizardState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
