import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/failure_mapper.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/logging/app_logger.dart';
import '../../profile/presentation/providers/profile_providers.dart';
import '../data/local_assessment_repository.dart';
import '../domain/entities/assessment_data.dart';
import '../domain/repositories/assessment_repository.dart';
import '../domain/validators/assessment_validator.dart';

part 'assessment_wizard_controller.freezed.dart';
part 'assessment_wizard_controller.g.dart';

@riverpod
AssessmentRepository assessmentRepository(Ref ref) =>
    LocalAssessmentRepository(ref.watch(appDatabaseProvider), ref.watch(clockProvider));

@freezed
abstract class AssessmentWizardState with _$AssessmentWizardState {
  const factory AssessmentWizardState({
    required AssessmentData data,
    @Default(0) int step,

    /// Tampilkan error field setelah pengguna mencoba lanjut.
    @Default(false) bool showErrors,
    @Default(false) bool consentDisclaimer,
    @Default(false) bool consentHealthData,
    @Default(false) bool submitting,
    Object? submitError,
  }) = _AssessmentWizardState;

  const AssessmentWizardState._();

  bool get isLastStep => step == AssessmentValidator.stepCount - 1;
  bool get consentGiven => consentDisclaimer && consentHealthData;
}

/// Wizard assessment 7 langkah: memuat draft (atau assessment terakhir),
/// memvalidasi per langkah, menyimpan draft saat pindah langkah, lalu
/// mengirim ke server.
@riverpod
class AssessmentWizard extends _$AssessmentWizard {
  AssessmentRepository get _repo => ref.read(assessmentRepositoryProvider);

  @override
  Future<AssessmentWizardState> build() async {
    final repo = ref.watch(assessmentRepositoryProvider);
    final draft = await repo.loadDraft();
    if (draft != null) {
      final step = draft.step.clamp(0, AssessmentValidator.stepCount - 1);
      return AssessmentWizardState(data: draft.data, step: step);
    }
    // Mengulang assessment: isi dengan jawaban terakhir.
    // Jaga provider profil tetap hidup selama dibaca.
    final profileSub = ref.listen(userProfileProvider, (_, _) {});
    final String? latestId;
    try {
      latestId = (await ref.read(userProfileProvider.future))?.latestAssessmentId;
    } finally {
      profileSub.close();
    }
    final latest = latestId == null ? null : await repo.loadAssessment(latestId);
    return AssessmentWizardState(data: latest ?? const AssessmentData());
  }

  AssessmentWizardState? get _current => state.value;

  void _set(AssessmentWizardState next) => state = AsyncData(next);

  Set<AssessmentIssue> issuesFor(AssessmentWizardState s) => AssessmentValidator.validateStep(
    s.step,
    s.data,
    now: ref.read(clockProvider)(),
    consentGiven: s.consentGiven,
  );

  void edit(AssessmentData Function(AssessmentData data) change) {
    final s = _current;
    if (s == null || s.submitting) return;
    _set(s.copyWith(data: change(s.data), submitError: null));
  }

  void setConsent({bool? disclaimer, bool? healthData}) {
    final s = _current;
    if (s == null) return;
    _set(
      s.copyWith(
        consentDisclaimer: disclaimer ?? s.consentDisclaimer,
        consentHealthData: healthData ?? s.consentHealthData,
      ),
    );
  }

  /// Lompat ke langkah tertentu (mis. "Sesuaikan target" → langkah tujuan).
  void goTo(int step) {
    final s = _current;
    if (s == null) return;
    _set(s.copyWith(step: step.clamp(0, AssessmentValidator.stepCount - 1), showErrors: false));
  }

  /// Validasi langkah aktif; bila lolos simpan draft & maju. `false` bila ada error.
  bool next() {
    final s = _current;
    if (s == null || s.isLastStep) return false;
    if (issuesFor(s).isNotEmpty) {
      _set(s.copyWith(showErrors: true));
      return false;
    }
    final next = s.copyWith(step: s.step + 1, showErrors: false);
    _set(next);
    _saveDraft(next);
    return true;
  }

  void back() {
    final s = _current;
    if (s == null || s.step == 0 || s.submitting) return;
    _set(s.copyWith(step: s.step - 1, showErrors: false, submitError: null));
  }

  /// Simpan draft tanpa menunggu server (Firestore menyimpannya secara
  /// lokal saat offline lalu menyinkronkan).
  void _saveDraft(AssessmentWizardState s) {
    unawaited(
      _repo
          .saveDraft(s.data, s.step)
          .catchError((Object e) => appLogger.w('Gagal menyimpan draft: ${FailureMapper.from(e)}')),
    );
  }

  /// Kirim assessment. Mengembalikan ID goal usulan, atau `null` bila gagal.
  Future<String?> submit() async {
    final s = _current;
    if (s == null || s.submitting) return null;
    final now = ref.read(clockProvider)();
    final invalid = AssessmentValidator.firstInvalidStep(
      s.data,
      now: now,
      consentGiven: s.consentGiven,
    );
    if (invalid != null) {
      _set(s.copyWith(step: invalid, showErrors: true));
      return null;
    }
    _set(s.copyWith(submitting: true, submitError: null));
    try {
      final goalId = await _repo.submit(normalizeAssessment(s.data));
      if (ref.mounted) _set(s.copyWith(submitting: false));
      return goalId;
    } catch (e) {
      if (ref.mounted) _set(s.copyWith(submitting: false, submitError: FailureMapper.from(e)));
      return null;
    }
  }
}
