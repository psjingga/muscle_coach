import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/config/app_environment.dart';
import 'package:musclecoach/app/router/auth_redirect.dart';
import 'package:musclecoach/app/router/routes.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';

import '../helpers/fakes.dart';

void main() {
  const loading = AsyncLoading<Never>();
  const loggedOut = AsyncData(null);
  const loggedIn = AsyncData(testUser);
  const done = OnboardingStatus.completed;
  const needed = OnboardingStatus.required;
  const unknown = OnboardingStatus.unknown;

  String? go(AsyncValue<Never?> auth, String location, [OnboardingStatus o = done]) =>
      authRedirect(auth: auth, onboarding: o, location: location);
  String? goIn(String location, [OnboardingStatus o = done]) =>
      authRedirect(auth: loggedIn, onboarding: o, location: location);

  test('selama status login dimuat → splash', () {
    expect(go(loading, Routes.home), Routes.splash);
    expect(go(loading, Routes.splash), isNull);
  });

  test('belum login → login, kecuali rute publik', () {
    expect(go(loggedOut, Routes.splash), Routes.login);
    expect(go(loggedOut, Routes.profile), Routes.login);
    expect(go(loggedOut, Routes.assessment), Routes.login);
    expect(go(loggedOut, Routes.register), isNull);
    expect(go(loggedOut, Routes.forgotPassword), isNull);
  });

  test('sudah login & onboarding selesai → keluar dari splash/publik/onboarding', () {
    expect(goIn(Routes.splash), Routes.home);
    expect(goIn(Routes.login), Routes.home);
    expect(goIn(Routes.onboarding), Routes.home);
    expect(goIn(Routes.workout), isNull);
    // Mengulang assessment & melihat goal tetap boleh.
    expect(goIn(Routes.assessment), isNull);
    expect(goIn(Routes.goalPath('g1')), isNull);
  });

  test('profil belum dimuat → splash', () {
    expect(goIn(Routes.login, unknown), Routes.splash);
    expect(goIn(Routes.splash, unknown), isNull);
  });

  test('onboarding belum selesai → hanya onboarding, assessment, dan goal', () {
    expect(goIn(Routes.splash, needed), Routes.onboarding);
    expect(goIn(Routes.home, needed), Routes.onboarding);
    expect(goIn(Routes.profile, needed), Routes.onboarding);
    expect(goIn(Routes.onboarding, needed), isNull);
    expect(goIn(Routes.assessment, needed), isNull);
    expect(goIn(Routes.assessmentPath(step: 1), needed), isNull);
    expect(goIn(Routes.goalPath('g1'), needed), isNull);
  });

  test('error stream auth diperlakukan sebagai belum login', () {
    final error = AsyncError<Never>(StateError('x'), StackTrace.empty);
    expect(go(error, Routes.home), Routes.login);
  });

  test('onboardingStatusOf', () {
    expect(onboardingStatusOf(const AsyncLoading()), unknown);
    expect(onboardingStatusOf(const AsyncData(null)), needed);
    expect(onboardingStatusOf(const AsyncData(UserProfile())), needed);
    expect(onboardingStatusOf(const AsyncData(UserProfile(onboardingCompleted: true))), done);
    expect(onboardingStatusOf(AsyncError(StateError('x'), StackTrace.empty)), needed);
  });

  test('AppEnvironment.parse', () {
    expect(AppEnvironment.parse('dev'), AppEnvironment.dev);
    expect(AppEnvironment.parse('prod'), AppEnvironment.prod);
    expect(AppEnvironment.parse(''), AppEnvironment.emulator);
    expect(AppEnvironment.parse('lainnya'), AppEnvironment.emulator);
  });
}
