/// Operasi akun yang dijalankan di server (Cloud Functions).
abstract interface class AccountRepository {
  /// Membuat dokumen `users/{uid}` beserta profil & entitlement awal bila
  /// belum ada. Aman dipanggil berulang (idempoten).
  Future<void> ensureUserProfile();

  /// Menghapus seluruh data pengguna di Firestore dan akun Firebase Auth.
  /// Server mensyaratkan login ulang dalam 5 menit terakhir.
  Future<void> deleteUserData();
}
