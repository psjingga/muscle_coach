import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../data/local_profile_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_repository.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    LocalProfileRepository(ref.watch(appDatabaseProvider));

/// Profil pengguna (`null` bila belum pernah dibuat).
@Riverpod(keepAlive: true)
Stream<UserProfile?> userProfile(Ref ref) => ref.watch(profileRepositoryProvider).watch();

/// Selama (re)load status belum diketahui; profil kosong → onboarding diperlukan.
OnboardingStatus onboardingStatusOf(AsyncValue<UserProfile?> profile) {
  if (profile.isLoading) return OnboardingStatus.unknown;
  return (profile.value?.onboardingCompleted ?? false)
      ? OnboardingStatus.completed
      : OnboardingStatus.required;
}
