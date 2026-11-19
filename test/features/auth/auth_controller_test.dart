import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/features/auth/presentation/providers/auth_providers.dart';

import '../../helpers/fakes.dart';

void main() {
  late MockAuthRepository auth;
  late MockAccountRepository account;
  late ProviderContainer container;

  setUp(() {
    final mocks = createAuthMocks();
    auth = mocks.auth;
    account = mocks.account;
    container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        accountRepositoryProvider.overrideWithValue(account),
      ],
    );
    // Jaga provider autoDispose tetap hidup selama test.
    container.listen(authControllerProvider, (_, _) {});
  });

  AuthController controller() => container.read(authControllerProvider.notifier);

  test('signIn sukses memanggil ensureUserProfile', () async {
    when(() => auth.signIn(email: 'a@b.co', password: 'pw')).thenAnswer((_) async {});

    expect(await controller().signIn('a@b.co', 'pw'), isTrue);
    verify(account.ensureUserProfile).called(1);
    expect(container.read(authControllerProvider).hasError, isFalse);
  });

  test('signIn gagal → state error berisi AppFailure', () async {
    when(
      () => auth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AppFailure(FailureKind.invalidCredentials));

    expect(await controller().signIn('a@b.co', 'salah'), isFalse);
    final state = container.read(authControllerProvider);
    expect((state.error! as AppFailure).kind, FailureKind.invalidCredentials);
    verifyNever(account.ensureUserProfile);
  });

  test('exception SDK mentah tetap dipetakan ke AppFailure', () async {
    when(
      () => auth.register(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    expect(await controller().register('a@b.co', 'latihan123'), isFalse);
    expect(
      (container.read(authControllerProvider).error! as AppFailure).kind,
      FailureKind.emailAlreadyInUse,
    );
  });

  test('kegagalan ensureUserProfile tidak menggagalkan login', () async {
    when(
      () => auth.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(account.ensureUserProfile).thenThrow(const AppFailure(FailureKind.unavailable));

    expect(await controller().signIn('a@b.co', 'pw'), isTrue);
  });

  test('deleteAccount: login ulang → hapus data → keluar, berurutan', () async {
    when(() => auth.reauthenticate('pw')).thenAnswer((_) async {});
    when(account.deleteUserData).thenAnswer((_) async {});
    when(auth.signOut).thenAnswer((_) async {});

    expect(await controller().deleteAccount('pw'), isTrue);
    verifyInOrder([() => auth.reauthenticate('pw'), account.deleteUserData, auth.signOut]);
  });

  test('deleteAccount berhenti bila kata sandi salah', () async {
    when(() => auth.reauthenticate(any()))
        .thenThrow(const AppFailure(FailureKind.invalidCredentials));

    expect(await controller().deleteAccount('salah'), isFalse);
    verifyNever(account.deleteUserData);
    verifyNever(auth.signOut);
  });
}
