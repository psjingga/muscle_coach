import '../../features/profile/domain/entities/user_profile.dart';
import 'routes.dart';

/// Aturan redirect berdasarkan status onboarding (fungsi murni).
///
/// - Profil belum dimuat → splash.
/// - Onboarding belum selesai → hanya onboarding/assessment/goal.
/// - Onboarding selesai → keluar dari splash/onboarding ke beranda.
String? onboardingRedirect({required OnboardingStatus onboarding, required String location}) {
  switch (onboarding) {
    case OnboardingStatus.unknown:
      return location == Routes.splash ? null : Routes.splash;
    case OnboardingStatus.required:
      return Routes.isOnboardingRoute(location) ? null : Routes.onboarding;
    case OnboardingStatus.completed:
      return location == Routes.splash || location == Routes.onboarding ? Routes.home : null;
  }
}
