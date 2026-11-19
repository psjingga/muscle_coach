import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/config/app_environment.dart';
import 'package:musclecoach/app/router/auth_redirect.dart';
import 'package:musclecoach/app/router/routes.dart';

import '../helpers/fakes.dart';

void main() {
  const loading = AsyncLoading<Never>();
  const loggedOut = AsyncData(null);
  const loggedIn = AsyncData(testUser);

  test('selama status login dimuat → splash', () {
    expect(authRedirect(auth: loading, location: Routes.home), Routes.splash);
    expect(authRedirect(auth: loading, location: Routes.splash), isNull);
  });

  test('belum login → login, kecuali rute publik', () {
    expect(authRedirect(auth: loggedOut, location: Routes.splash), Routes.login);
    expect(authRedirect(auth: loggedOut, location: Routes.profile), Routes.login);
    expect(authRedirect(auth: loggedOut, location: Routes.register), isNull);
    expect(authRedirect(auth: loggedOut, location: Routes.forgotPassword), isNull);
  });

  test('sudah login → keluar dari splash/rute publik ke home', () {
    expect(authRedirect(auth: loggedIn, location: Routes.splash), Routes.home);
    expect(authRedirect(auth: loggedIn, location: Routes.login), Routes.home);
    expect(authRedirect(auth: loggedIn, location: Routes.workout), isNull);
  });

  test('error stream auth diperlakukan sebagai belum login', () {
    final error = AsyncError<Never>(StateError('x'), StackTrace.empty);
    expect(authRedirect(auth: error, location: Routes.home), Routes.login);
  });

  test('AppEnvironment.parse', () {
    expect(AppEnvironment.parse('dev'), AppEnvironment.dev);
    expect(AppEnvironment.parse('prod'), AppEnvironment.prod);
    expect(AppEnvironment.parse(''), AppEnvironment.emulator);
    expect(AppEnvironment.parse('lainnya'), AppEnvironment.emulator);
  });
}
