import '../entities/auth_user.dart';

/// Kontrak autentikasi. Semua method melempar `AppFailure` bila gagal.
abstract interface class AuthRepository {
  /// Berubah saat login/logout dan saat data pengguna dimuat ulang
  /// (mis. setelah email terverifikasi).
  Stream<AuthUser?> userChanges();

  AuthUser? get currentUser;

  Future<void> signIn({required String email, required String password});

  Future<void> register({required String email, required String password});

  Future<void> signOut();

  Future<void> sendPasswordReset(String email);

  Future<void> sendEmailVerification();

  /// Muat ulang status akun dari server (mis. `emailVerified`).
  Future<void> reloadUser();

  /// Wajib sebelum operasi sensitif seperti menghapus akun.
  Future<void> reauthenticate(String password);
}
