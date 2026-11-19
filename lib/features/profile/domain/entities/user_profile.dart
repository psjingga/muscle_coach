import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// `users/{uid}/profile/current`. Field status onboarding ditulis server.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    String? displayName,
    @Default(false) bool onboardingCompleted,
    String? activeGoalId,
    String? activeNutritionTargetId,
    String? latestAssessmentId,
    String? activeWorkoutPlanId,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

/// Status gerbang onboarding untuk router.
enum OnboardingStatus { unknown, required, completed }
