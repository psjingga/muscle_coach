import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import 'routes.dart';

/// Aturan redirect berdasarkan status login (fungsi murni agar mudah dites).
/// Fase berikutnya menambahkan gerbang assessment & konfirmasi goal di sini.
String? authRedirect({required AsyncValue<AuthUser?> auth, required String location}) {
  // Status login belum diketahui → tetap di splash.
  if (auth.isLoading && !auth.hasValue) {
    return location == Routes.splash ? null : Routes.splash;
  }
  final loggedIn = auth.value != null;
  final onPublic = Routes.public.contains(location);

  if (!loggedIn) return onPublic ? null : Routes.login;
  if (onPublic || location == Routes.splash) return Routes.home;
  return null;
}
