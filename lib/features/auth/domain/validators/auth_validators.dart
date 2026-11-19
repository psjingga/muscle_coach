/// Hasil validasi form autentikasi. Teks ditampilkan oleh presentation.
enum AuthFieldError {
  emailRequired,
  emailInvalid,
  passwordRequired,
  passwordTooShort,
  passwordTooWeak,
  passwordMismatch,
}

/// Validator terpusat fitur auth (tanpa ketergantungan UI).
abstract final class AuthValidators {
  static const minPasswordLength = 8;

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _letter = RegExp(r'[A-Za-z]');
  static final _digit = RegExp(r'\d');

  static AuthFieldError? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AuthFieldError.emailRequired;
    if (!_email.hasMatch(v)) return AuthFieldError.emailInvalid;
    return null;
  }

  /// Untuk login: cukup tidak kosong (aturan kekuatan hanya saat daftar).
  static AuthFieldError? loginPassword(String? value) =>
      (value ?? '').isEmpty ? AuthFieldError.passwordRequired : null;

  /// Untuk daftar: minimal 8 karakter, berisi huruf dan angka.
  static AuthFieldError? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return AuthFieldError.passwordRequired;
    if (v.length < minPasswordLength) return AuthFieldError.passwordTooShort;
    if (!_letter.hasMatch(v) || !_digit.hasMatch(v)) return AuthFieldError.passwordTooWeak;
    return null;
  }

  static AuthFieldError? confirmPassword(String? value, String password) =>
      value != password ? AuthFieldError.passwordMismatch : null;
}
