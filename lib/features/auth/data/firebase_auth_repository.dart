import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/failure_mapper.dart';
import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  static AuthUser? _map(User? u) =>
      u == null ? null : AuthUser(uid: u.uid, email: u.email ?? '', emailVerified: u.emailVerified);

  @override
  Stream<AuthUser?> userChanges() => _auth.userChanges().map(_map);

  @override
  AuthUser? get currentUser => _map(_auth.currentUser);

  @override
  Future<void> signIn({required String email, required String password}) =>
      _guard(() => _auth.signInWithEmailAndPassword(email: email.trim(), password: password));

  @override
  Future<void> register({required String email, required String password}) => _guard(() async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.sendEmailVerification();
  });

  @override
  Future<void> signOut() => _guard(_auth.signOut);

  @override
  Future<void> sendPasswordReset(String email) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  @override
  Future<void> sendEmailVerification() =>
      _guard(() async => _requireUser().sendEmailVerification());

  @override
  Future<void> reloadUser() => _guard(() async => _requireUser().reload());

  @override
  Future<void> reauthenticate(String password) => _guard(() async {
    final user = _requireUser();
    final cred = EmailAuthProvider.credential(email: user.email ?? '', password: password);
    await user.reauthenticateWithCredential(cred);
  });

  User _requireUser() =>
      _auth.currentUser ?? (throw FirebaseAuthException(code: 'user-token-expired'));

  static Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      throw FailureMapper.from(e);
    }
  }
}
