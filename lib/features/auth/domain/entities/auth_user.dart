import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// Pengguna yang sedang login (hanya data yang dibutuhkan aplikasi).
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String email,
    required bool emailVerified,
  }) = _AuthUser;
}
