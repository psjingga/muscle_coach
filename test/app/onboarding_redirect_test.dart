import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/router/onboarding_redirect.dart';
import 'package:musclecoach/app/router/routes.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';

void main() {
  const done = OnboardingStatus.completed;
  const needed = OnboardingStatus.required;
  const unknown = OnboardingStatus.unknown;

  String? go(String location, OnboardingStatus o) =>
      onboardingRedirect(onboarding: o, location: location);

  test('profil belum dimuat → splash', () {
    expect(go(Routes.home, unknown), Routes.splash);
    expect(go(Routes.splash, unknown), isNull);
  });

  test('onboarding belum selesai → hanya onboarding, assessment, dan goal', () {
    expect(go(Routes.splash, needed), Routes.onboarding);
    expect(go(Routes.home, needed), Routes.onboarding);
    expect(go(Routes.profile, needed), Routes.onboarding);
    expect(go(Routes.onboarding, needed), isNull);
    expect(go(Routes.assessment, needed), isNull);
    expect(go(Routes.assessmentPath(step: 1), needed), isNull);
    expect(go(Routes.goalPath('g1'), needed), isNull);
  });

  test('onboarding selesai → keluar dari splash/onboarding, rute lain bebas', () {
    expect(go(Routes.splash, done), Routes.home);
    expect(go(Routes.onboarding, done), Routes.home);
    expect(go(Routes.workout, done), isNull);
    expect(go(Routes.assessment, done), isNull);
    expect(go(Routes.goalPath('g1'), done), isNull);
    expect(go(Routes.sessionPath('s1'), done), isNull);
  });

  test('onboardingStatusOf', () {
    expect(onboardingStatusOf(const AsyncLoading()), unknown);
    expect(onboardingStatusOf(const AsyncData(null)), needed);
    expect(onboardingStatusOf(const AsyncData(UserProfile())), needed);
    expect(onboardingStatusOf(const AsyncData(UserProfile(onboardingCompleted: true))), done);
    expect(onboardingStatusOf(AsyncError(StateError('x'), StackTrace.empty)), needed);
  });
}
