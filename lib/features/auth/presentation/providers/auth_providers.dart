import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/firebase/firebase_providers.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../profile/data/functions_account_repository.dart';
import '../../../profile/domain/account_repository.dart';
import '../../data/firebase_auth_repository.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => FirebaseAuthRepository(ref.watch(firebaseAuthProvider));

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) =>
    FunctionsAccountRepository(ref.watch(functionsClientProvider));

/// Pengguna yang sedang login; `null` bila belum login.
@Riverpod(keepAlive: true)
Stream<AuthUser?> authState(Ref ref) => ref.watch(authRepositoryProvider).userChanges();

/// Aksi autentikasi. `state` mencerminkan aksi terakhir
/// (loading → data/error) untuk ditampilkan di form.
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  AuthRepository get _auth => ref.read(authRepositoryProvider);
  AccountRepository get _account => ref.read(accountRepositoryProvider);

  Future<bool> signIn(String email, String password) => _run(() async {
    await _auth.signIn(email: email, password: password);
    await _ensureProfile();
  });

  Future<bool> register(String email, String password) => _run(() async {
    await _auth.register(email: email, password: password);
    await _ensureProfile();
  });

  Future<bool> sendPasswordReset(String email) => _run(() => _auth.sendPasswordReset(email));

  Future<bool> sendEmailVerification() => _run(_auth.sendEmailVerification);

  Future<bool> reloadUser() => _run(_auth.reloadUser);

  Future<bool> signOut() => _run(_auth.signOut);

  /// Login ulang → hapus data di server → keluar.
  Future<bool> deleteAccount(String password) => _run(() async {
    await _auth.reauthenticate(password);
    await _account.deleteUserData();
    await _auth.signOut();
  });

  /// Profil server dibuat idempoten; kegagalan tidak menggagalkan login
  /// (dicoba lagi pada login berikutnya).
  Future<void> _ensureProfile() async {
    try {
      await _account.ensureUserProfile();
    } catch (e) {
      appLogger.w('createUserProfile gagal: ${FailureMapper.from(e)}');
    }
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      try {
        await action();
      } catch (e) {
        throw FailureMapper.from(e);
      }
    });
    if (!ref.mounted) return !result.hasError;
    state = result;
    return !result.hasError;
  }
}
