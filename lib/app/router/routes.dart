/// Path rute aplikasi.
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static const onboarding = '/onboarding';
  static const assessment = '/assessment';
  static const goal = '/goal';

  static const home = '/home';
  static const workout = '/workout';
  static const nutrition = '/nutrition';
  static const progress = '/progress';
  static const profile = '/profile';

  /// Rute yang boleh dibuka tanpa login.
  static const public = {login, register, forgotPassword};

  /// `/assessment?step=1`
  static String assessmentPath({int? step}) => step == null ? assessment : '$assessment?step=$step';

  static String goalPath(String goalId) => '$goal/$goalId';

  /// Rute yang boleh dibuka selama onboarding belum selesai.
  static bool isOnboardingRoute(String location) =>
      location == onboarding ||
      location == assessment ||
      location.startsWith('$assessment?') ||
      location.startsWith('$goal/');
}
