// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  displayName: json['displayName'] as String?,
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
  activeGoalId: json['activeGoalId'] as String?,
  activeNutritionTargetId: json['activeNutritionTargetId'] as String?,
  latestAssessmentId: json['latestAssessmentId'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) => <String, dynamic>{
  'displayName': instance.displayName,
  'onboardingCompleted': instance.onboardingCompleted,
  'activeGoalId': instance.activeGoalId,
  'activeNutritionTargetId': instance.activeNutritionTargetId,
  'latestAssessmentId': instance.latestAssessmentId,
};
