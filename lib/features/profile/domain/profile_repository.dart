import 'entities/user_profile.dart';

abstract interface class ProfileRepository {
  /// Profil pengguna; `null` bila belum pernah dibuat (pengguna baru).
  Stream<UserProfile?> watch();

  /// Hapus seluruh data aplikasi di perangkat ini.
  Future<void> wipeAllData();
}
