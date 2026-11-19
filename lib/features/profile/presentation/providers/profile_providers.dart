import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/firebase/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/firestore_profile_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_repository.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    FirestoreProfileRepository(ref.watch(firestoreProvider));

/// Profil pengguna yang sedang login (`null` bila belum login / belum dibuat).
@Riverpod(keepAlive: true)
Stream<UserProfile?> userProfile(Ref ref) {
  final uid = ref.watch(authStateProvider.select((a) => a.value?.uid));
  if (uid == null) return Stream.value(null);
  return ref.watch(profileRepositoryProvider).watch(uid);
}

/// Profil belum ada (baru daftar) → onboarding diperlukan. Error tanpa data
/// sebelumnya juga diarahkan ke onboarding (submit akan membuat profil).
/// Selama (re)load — mis. tepat setelah login — status belum diketahui;
/// nilai lama milik sesi sebelumnya tidak dipakai.
OnboardingStatus onboardingStatusOf(AsyncValue<UserProfile?> profile) {
  if (profile.isLoading) return OnboardingStatus.unknown;
  return (profile.value?.onboardingCompleted ?? false)
      ? OnboardingStatus.completed
      : OnboardingStatus.required;
}
