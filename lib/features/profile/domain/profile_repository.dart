import 'entities/user_profile.dart';

abstract interface class ProfileRepository {
  /// Profil pengguna; `null` bila dokumen belum dibuat.
  Stream<UserProfile?> watch(String uid);
}
