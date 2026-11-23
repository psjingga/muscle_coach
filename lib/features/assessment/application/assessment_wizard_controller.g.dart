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

String _$assessmentRepositoryHash() => r'19141649420d348bd8f3c4752d530ee88a7cf69a';

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

String _$assessmentWizardHash() => r'c14ed24ef02b7156390d7ab7f536f09f67ef7457';

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
