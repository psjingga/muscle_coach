import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import 'routes.dart';

/// Aturan redirect berdasarkan status login dan onboarding (fungsi murni).
///
/// - Status login/profil belum diketahui → splash.
/// - Belum login → login (kecuali rute publik).
/// - Login, onboarding belum selesai → onboarding/assessment/goal saja.
/// - Login, onboarding selesai → keluar dari splash/rute publik/onboarding.
String? authRedirect({
  required AsyncValue<AuthUser?> auth,
  required OnboardingStatus onboarding,
  required String location,
}) {
  if (auth.isLoading && !auth.hasValue) {
    return location == Routes.splash ? null : Routes.splash;
  }
  final loggedIn = auth.value != null;
  final onPublic = Routes.public.contains(location);

  if (!loggedIn) return onPublic ? null : Routes.login;

  switch (onboarding) {
    case OnboardingStatus.unknown:
      return location == Routes.splash ? null : Routes.splash;
    case OnboardingStatus.required:
      return Routes.isOnboardingRoute(location) ? null : Routes.onboarding;
    case OnboardingStatus.completed:
      if (onPublic || location == Routes.splash || location == Routes.onboarding) {
        return Routes.home;
      }
      return null;
  }
}
