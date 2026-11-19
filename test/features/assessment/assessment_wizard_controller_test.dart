import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/assessment/application/assessment_wizard_controller.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';

import '../../fixtures/assessment_fixtures.dart';
import '../../helpers/fakes.dart';

void main() {
  late MockAssessmentRepository repo;

  setUpAll(() => registerFallbackValue(const AssessmentData()));

  setUp(() {
    repo = MockAssessmentRepository();
    when(() => repo.loadDraft()).thenAnswer((_) async => null);
    when(() => repo.saveDraft(any(), any())).thenAnswer((_) async {});
  });

  ProviderContainer container({UserProfile? profile}) => ProviderContainer.test(
    overrides: [
      assessmentRepositoryProvider.overrideWithValue(repo),
      userProfileProvider.overrideWith((ref) => Stream<UserProfile?>.value(profile)),
      clockProvider.overrideWithValue(() => testNow),
    ],
  );

  Future<(ProviderContainer, AssessmentWizard)> load({UserProfile? profile}) async {
    final c = container(profile: profile);
    c.listen(assessmentWizardProvider, (_, _) {});
    await c.read(assessmentWizardProvider.future);
    return (c, c.read(assessmentWizardProvider.notifier));
  }

  AssessmentWizardState stateOf(ProviderContainer c) => c.read(assessmentWizardProvider).value!;

  test('memuat draft beserta langkah terakhir', () async {
    when(() => repo.loadDraft()).thenAnswer((_) async => (data: completeAssessment, step: 4));
    final (c, _) = await load();
    expect(stateOf(c).step, 4);
    expect(stateOf(c).data, completeAssessment);
  });

  test('tanpa draft: isi ulang dari assessment terakhir di profil', () async {
    when(() => repo.loadAssessment('a0')).thenAnswer((_) async => completeAssessment);
    final (c, _) = await load(profile: const UserProfile(latestAssessmentId: 'a0'));
    expect(stateOf(c).step, 0);
    expect(stateOf(c).data, completeAssessment);
  });

  test('next() menolak langkah tidak valid dan menampilkan error', () async {
    final (c, w) = await load();
    expect(w.next(), isFalse);
    expect(stateOf(c).step, 0);
    expect(stateOf(c).showErrors, isTrue);
    verifyNever(() => repo.saveDraft(any(), any()));
  });

  test('next() maju & menyimpan draft; back() kembali', () async {
    final (c, w) = await load();
    w.edit((_) => completeAssessment);
    expect(w.next(), isTrue);
    expect(stateOf(c).step, 1);
    expect(stateOf(c).showErrors, isFalse);
    verify(() => repo.saveDraft(completeAssessment, 1)).called(1);
    w.back();
    expect(stateOf(c).step, 0);
  });

  test('submit tanpa persetujuan → pindah ke langkah keselamatan', () async {
    final (c, w) = await load();
    w.edit((_) => completeAssessment);
    expect(await w.submit(), isNull);
    expect(stateOf(c).step, 6);
    expect(stateOf(c).showErrors, isTrue);
    verifyNever(() => repo.submit(any()));
  });

  test('submit data belum lengkap → pindah ke langkah pertama yang salah', () async {
    final (c, w) = await load();
    w.edit((_) => completeAssessment.copyWith(activity: const ActivitySection()));
    w.setConsent(disclaimer: true, healthData: true);
    expect(await w.submit(), isNull);
    expect(stateOf(c).step, 4);
  });

  test('submit valid mengirim data yang dinormalisasi dan mengembalikan ID goal', () async {
    when(() => repo.submit(any())).thenAnswer((_) async => 'g1');
    final (c, w) = await load();
    w.edit((_) => completeAssessment);
    w.setConsent(disclaimer: true, healthData: true);
    expect(await w.submit(), 'g1');
    final sent = verify(() => repo.submit(captureAny())).captured.single as AssessmentData;
    expect(sent.availability.barbellMaxKg, isNull); // tidak punya barbell
    expect(stateOf(c).submitting, isFalse);
  });

  test('submit gagal menyimpan error untuk ditampilkan', () async {
    when(() => repo.submit(any())).thenThrow(const AppFailure(FailureKind.network));
    final (c, w) = await load();
    w.edit((_) => completeAssessment);
    w.setConsent(disclaimer: true, healthData: true);
    expect(await w.submit(), isNull);
    expect(stateOf(c).submitError, isA<AppFailure>());
    // Mengubah jawaban menghapus error lama.
    w.edit((d) => d);
    expect(stateOf(c).submitError, isNull);
  });
}
