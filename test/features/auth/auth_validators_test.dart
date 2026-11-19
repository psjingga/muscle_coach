import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/auth/domain/validators/auth_validators.dart';

void main() {
  group('email', () {
    test('wajib diisi', () {
      expect(AuthValidators.email(null), AuthFieldError.emailRequired);
      expect(AuthValidators.email('   '), AuthFieldError.emailRequired);
    });

    test('format tidak valid', () {
      for (final v in ['abc', 'a@b', 'a@b.c', 'a b@c.com', '@c.com']) {
        expect(AuthValidators.email(v), AuthFieldError.emailInvalid, reason: v);
      }
    });

    test('valid (spasi di tepi diabaikan)', () {
      expect(AuthValidators.email(' user@example.co.id '), isNull);
    });
  });

  group('newPassword', () {
    test('wajib, minimal 8, huruf + angka', () {
      expect(AuthValidators.newPassword(''), AuthFieldError.passwordRequired);
      expect(AuthValidators.newPassword('abc123'), AuthFieldError.passwordTooShort);
      expect(AuthValidators.newPassword('abcdefgh'), AuthFieldError.passwordTooWeak);
      expect(AuthValidators.newPassword('12345678'), AuthFieldError.passwordTooWeak);
      expect(AuthValidators.newPassword('latihan123'), isNull);
    });
  });

  test('loginPassword hanya wajib diisi', () {
    expect(AuthValidators.loginPassword(''), AuthFieldError.passwordRequired);
    expect(AuthValidators.loginPassword('x'), isNull);
  });

  test('confirmPassword harus sama', () {
    expect(AuthValidators.confirmPassword('a', 'b'), AuthFieldError.passwordMismatch);
    expect(AuthValidators.confirmPassword('a', 'a'), isNull);
  });
}
