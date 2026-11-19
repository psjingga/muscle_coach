import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/features/assessment/application/assessment_wizard_controller.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:musclecoach/features/assessment/presentation/screens/assessment_wizard_screen.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../../fixtures/assessment_fixtures.dart';
import '../../helpers/fakes.dart';

void main() {
  late MockAssessmentRepository repo;

  setUpAll(() => registerFallbackValue(const AssessmentData()));

  Future<void> pump(WidgetTester tester, {AssessmentDraft? draft}) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    repo = MockAssessmentRepository();
    when(() => repo.loadDraft()).thenAnswer((_) async => draft);
    when(() => repo.saveDraft(any(), any())).thenAnswer((_) async {});
    when(() => repo.submit(any())).thenAnswer((_) async => 'g1');
    final router = GoRouter(
      initialLocation: '/assessment',
      routes: [
        GoRoute(path: '/assessment', builder: (_, _) => const AssessmentWizardScreen()),
        GoRoute(path: '/goal/:id', builder: (_, s) => Text('goal ${s.pathParameters['id']}')),
        GoRoute(path: '/onboarding', builder: (_, _) => const Text('onboarding')),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(repo),
          userProfileProvider.overrideWith((ref) => Stream<UserProfile?>.value(null)),
          clockProvider.overrideWithValue(() => testNow),
        ],
        child: MaterialApp.router(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('langkah 1: progres, error field wajib, lalu lanjut', (tester) async {
    await pump(tester);
    expect(find.text('Langkah 1 dari 7'), findsOneWidget);
    expect(find.text('Profil dasar'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Lanjut'));
    await tester.pump();
    expect(find.text('Wajib diisi.'), findsWidgets);
    expect(find.text('Pilih salah satu.'), findsOneWidget);
    verifyNever(() => repo.saveDraft(any(), any()));

    // Tinggi di luar batas → pesan rentang.
    await tester.enterText(field('Tinggi badan'), '300');
    await tester.pump();
    expect(find.text('Masukkan angka 120–230.'), findsOneWidget);

    await tester.enterText(field('Tinggi badan'), '175');
    await tester.enterText(field('Berat badan saat ini'), '70,5');
    await tester.tap(find.text('Laki-laki'));
    await tester.tap(find.text('Pilih tanggal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OKE'));
    await tester.pumpAndSettle();
    expect(find.text('25 tahun'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Langkah 2 dari 7'), findsOneWidget);
    final saved = verify(() => repo.saveDraft(captureAny(), 1)).captured.single as AssessmentData;
    expect(saved.profile.weightKg, 70.5);
    expect(saved.profile.sex, Sex.male);
  });

  testWidgets('melanjutkan draft di langkah terakhir dan mengirim', (tester) async {
    await pump(tester, draft: (data: completeAssessment, step: 6));
    expect(find.text('Langkah 7 dari 7'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Hitung target saya'));
    await tester.pumpAndSettle();
    expect(find.text('Centang kedua persetujuan untuk melanjutkan.'), findsOneWidget);
    verifyNever(() => repo.submit(any()));

    await tester.tap(find.textContaining('memberi estimasi edukatif'));
    await tester.tap(find.textContaining('diproses untuk menghitung target'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Hitung target saya'));
    await tester.pumpAndSettle();
    expect(find.text('goal g1'), findsOneWidget);
    verify(() => repo.submit(any())).called(1);
  });

  testWidgets('tombol Kembali ke langkah sebelumnya', (tester) async {
    await pump(tester, draft: (data: completeAssessment, step: 3));
    expect(find.text('Jadwal & peralatan'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Pengalaman latihan'), findsOneWidget);
  });
}
