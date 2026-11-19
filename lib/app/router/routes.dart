/// Path rute aplikasi.
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static const home = '/home';
  static const workout = '/workout';
  static const nutrition = '/nutrition';
  static const progress = '/progress';
  static const profile = '/profile';

  /// Rute yang boleh dibuka tanpa login.
  static const public = {login, register, forgotPassword};
}
