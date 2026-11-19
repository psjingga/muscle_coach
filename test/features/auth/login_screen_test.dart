import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/features/auth/presentation/providers/auth_providers.dart';
import 'package:musclecoach/features/auth/presentation/screens/login_screen.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import '../../helpers/fakes.dart';

void main() {
  late MockAuthRepository auth;

  Future<void> pumpLogin(WidgetTester tester) async {
    final mocks = createAuthMocks();
    auth = mocks.auth;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          accountRepositoryProvider.overrideWithValue(mocks.account),
        ],
        child: const MaterialApp(
          locale: Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      ),
    );
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('menampilkan error validasi saat form kosong', (tester) async {
    await pumpLogin(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();

    expect(find.text('Email wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
    verifyNever(
      () => auth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('input valid memanggil signIn', (tester) async {
    await pumpLogin(tester);
    when(
      () => auth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await tester.enterText(field('Email'), 'user@example.com');
    await tester.enterText(field('Kata sandi'), 'rahasia123');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    verify(() => auth.signIn(email: 'user@example.com', password: 'rahasia123')).called(1);
  });

  testWidgets('kredensial salah menampilkan pesan ramah', (tester) async {
    await pumpLogin(tester);
    when(
      () => auth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AppFailure(FailureKind.invalidCredentials));

    await tester.enterText(field('Email'), 'user@example.com');
    await tester.enterText(field('Kata sandi'), 'salah');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Email atau kata sandi salah.'), findsOneWidget);
  });
}
