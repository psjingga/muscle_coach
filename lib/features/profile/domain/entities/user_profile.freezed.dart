// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String? get displayName; bool get onboardingCompleted; String? get activeGoalId; String? get activeNutritionTargetId; String? get latestAssessmentId;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.onboardingCompleted, _this.onboardingCompleted) || other.onboardingCompleted == _this.onboardingCompleted)&&(identical(other.activeGoalId, _this.activeGoalId) || other.activeGoalId == _this.activeGoalId)&&(identical(other.activeNutritionTargetId, _this.activeNutritionTargetId) || other.activeNutritionTargetId == _this.activeNutritionTargetId)&&(identical(other.latestAssessmentId, _this.latestAssessmentId) || other.latestAssessmentId == _this.latestAssessmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.displayName,_this.onboardingCompleted,_this.activeGoalId,_this.activeNutritionTargetId,_this.latestAssessmentId);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(displayName: ${_this.displayName}, onboardingCompleted: ${_this.onboardingCompleted}, activeGoalId: ${_this.activeGoalId}, activeNutritionTargetId: ${_this.activeNutritionTargetId}, latestAssessmentId: ${_this.latestAssessmentId})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String? displayName, bool onboardingCompleted, String? activeGoalId, String? activeNutritionTargetId, String? latestAssessmentId
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = freezed,Object? onboardingCompleted = null,Object? activeGoalId = freezed,Object? activeNutritionTargetId = freezed,Object? latestAssessmentId = freezed,}) {
  return _then(UserProfile(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,activeGoalId: freezed == activeGoalId ? _self.activeGoalId : activeGoalId // ignore: cast_nullable_to_non_nullable
as String?,activeNutritionTargetId: freezed == activeNutritionTargetId ? _self.activeNutritionTargetId : activeNutritionTargetId // ignore: cast_nullable_to_non_nullable
as String?,latestAssessmentId: freezed == latestAssessmentId ? _self.latestAssessmentId : latestAssessmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayName,  bool onboardingCompleted,  String? activeGoalId,  String? activeNutritionTargetId,  String? latestAssessmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.displayName,_that.onboardingCompleted,_that.activeGoalId,_that.activeNutritionTargetId,_that.latestAssessmentId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayName,  bool onboardingCompleted,  String? activeGoalId,  String? activeNutritionTargetId,  String? latestAssessmentId)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.displayName,_that.onboardingCompleted,_that.activeGoalId,_that.activeNutritionTargetId,_that.latestAssessmentId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayName,  bool onboardingCompleted,  String? activeGoalId,  String? activeNutritionTargetId,  String? latestAssessmentId)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.displayName,_that.onboardingCompleted,_that.activeGoalId,_that.activeNutritionTargetId,_that.latestAssessmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({this.displayName, this.onboardingCompleted = false, this.activeGoalId, this.activeNutritionTargetId, this.latestAssessmentId});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String? displayName;
@override@JsonKey() final  bool onboardingCompleted;
@override final  String? activeGoalId;
@override final  String? activeNutritionTargetId;
@override final  String? latestAssessmentId;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.activeGoalId, activeGoalId) || other.activeGoalId == activeGoalId)&&(identical(other.activeNutritionTargetId, activeNutritionTargetId) || other.activeNutritionTargetId == activeNutritionTargetId)&&(identical(other.latestAssessmentId, latestAssessmentId) || other.latestAssessmentId == latestAssessmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayName,onboardingCompleted,activeGoalId,activeNutritionTargetId,latestAssessmentId);
}

@override
String toString() {
    return 'UserProfile(displayName: $displayName, onboardingCompleted: $onboardingCompleted, activeGoalId: $activeGoalId, activeNutritionTargetId: $activeNutritionTargetId, latestAssessmentId: $latestAssessmentId)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String? displayName, bool onboardingCompleted, String? activeGoalId, String? activeNutritionTargetId, String? latestAssessmentId
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = freezed,Object? onboardingCompleted = null,Object? activeGoalId = freezed,Object? activeNutritionTargetId = freezed,Object? latestAssessmentId = freezed,}) {
  return _then(_UserProfile(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,activeGoalId: freezed == activeGoalId ? _self.activeGoalId : activeGoalId // ignore: cast_nullable_to_non_nullable
as String?,activeNutritionTargetId: freezed == activeNutritionTargetId ? _self.activeNutritionTargetId : activeNutritionTargetId // ignore: cast_nullable_to_non_nullable
as String?,latestAssessmentId: freezed == latestAssessmentId ? _self.latestAssessmentId : latestAssessmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
