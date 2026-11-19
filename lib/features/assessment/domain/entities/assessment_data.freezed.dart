// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileSection {

 String? get nickname;/// `YYYY-MM-DD`.
 String? get birthDate; Sex? get sex; double? get heightCm; double? get weightKg;
/// Create a copy of ProfileSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSectionCopyWith<ProfileSection> get copyWith => _$ProfileSectionCopyWithImpl<ProfileSection>(this as ProfileSection, _$identity);

  /// Serializes this ProfileSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProfileSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSection&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProfileSection;
  return Object.hash(runtimeType,_this.nickname,_this.birthDate,_this.sex,_this.heightCm,_this.weightKg);
}

@override
String toString() {
  final _this = this as ProfileSection;
  return 'ProfileSection(nickname: ${_this.nickname}, birthDate: ${_this.birthDate}, sex: ${_this.sex}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg})';
}


}

/// @nodoc
abstract mixin class $ProfileSectionCopyWith<$Res>  {
  factory $ProfileSectionCopyWith(ProfileSection value, $Res Function(ProfileSection) _then) = _$ProfileSectionCopyWithImpl;
@useResult
$Res call({
 String? nickname, String? birthDate, Sex? sex, double? heightCm, double? weightKg
});




}
/// @nodoc
class _$ProfileSectionCopyWithImpl<$Res>
    implements $ProfileSectionCopyWith<$Res> {
  _$ProfileSectionCopyWithImpl(this._self, this._then);

  final ProfileSection _self;
  final $Res Function(ProfileSection) _then;

/// Create a copy of ProfileSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nickname = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? heightCm = freezed,Object? weightKg = freezed,}) {
  return _then(ProfileSection(
nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSection].
extension ProfileSectionPatterns on ProfileSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSection value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSection value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? nickname,  String? birthDate,  Sex? sex,  double? heightCm,  double? weightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSection() when $default != null:
return $default(_that.nickname,_that.birthDate,_that.sex,_that.heightCm,_that.weightKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? nickname,  String? birthDate,  Sex? sex,  double? heightCm,  double? weightKg)  $default,) {final _that = this;
switch (_that) {
case _ProfileSection():
return $default(_that.nickname,_that.birthDate,_that.sex,_that.heightCm,_that.weightKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? nickname,  String? birthDate,  Sex? sex,  double? heightCm,  double? weightKg)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSection() when $default != null:
return $default(_that.nickname,_that.birthDate,_that.sex,_that.heightCm,_that.weightKg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileSection implements ProfileSection {
  const _ProfileSection({this.nickname, this.birthDate, this.sex, this.heightCm, this.weightKg});
  factory _ProfileSection.fromJson(Map<String, dynamic> json) => _$ProfileSectionFromJson(json);

@override final  String? nickname;
/// `YYYY-MM-DD`.
@override final  String? birthDate;
@override final  Sex? sex;
@override final  double? heightCm;
@override final  double? weightKg;

/// Create a copy of ProfileSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSectionCopyWith<_ProfileSection> get copyWith => __$ProfileSectionCopyWithImpl<_ProfileSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileSectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSection&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,nickname,birthDate,sex,heightCm,weightKg);
}

@override
String toString() {
    return 'ProfileSection(nickname: $nickname, birthDate: $birthDate, sex: $sex, heightCm: $heightCm, weightKg: $weightKg)';
}


}

/// @nodoc
abstract mixin class _$ProfileSectionCopyWith<$Res> implements $ProfileSectionCopyWith<$Res> {
  factory _$ProfileSectionCopyWith(_ProfileSection value, $Res Function(_ProfileSection) _then) = __$ProfileSectionCopyWithImpl;
@override @useResult
$Res call({
 String? nickname, String? birthDate, Sex? sex, double? heightCm, double? weightKg
});




}
/// @nodoc
class __$ProfileSectionCopyWithImpl<$Res>
    implements _$ProfileSectionCopyWith<$Res> {
  __$ProfileSectionCopyWithImpl(this._self, this._then);

  final _ProfileSection _self;
  final $Res Function(_ProfileSection) _then;

/// Create a copy of ProfileSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nickname = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? heightCm = freezed,Object? weightKg = freezed,}) {
  return _then(_ProfileSection(
nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$GoalSection {

 PrimaryGoal? get primary; double? get targetWeightKg; int? get targetWeeks; List<MuscleGroup> get priorityMuscles; String? get motivation;
/// Create a copy of GoalSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalSectionCopyWith<GoalSection> get copyWith => _$GoalSectionCopyWithImpl<GoalSection>(this as GoalSection, _$identity);

  /// Serializes this GoalSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GoalSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalSection&&(identical(other.primary, _this.primary) || other.primary == _this.primary)&&(identical(other.targetWeightKg, _this.targetWeightKg) || other.targetWeightKg == _this.targetWeightKg)&&(identical(other.targetWeeks, _this.targetWeeks) || other.targetWeeks == _this.targetWeeks)&&const DeepCollectionEquality().equals(other.priorityMuscles, _this.priorityMuscles)&&(identical(other.motivation, _this.motivation) || other.motivation == _this.motivation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GoalSection;
  return Object.hash(runtimeType,_this.primary,_this.targetWeightKg,_this.targetWeeks,const DeepCollectionEquality().hash(_this.priorityMuscles),_this.motivation);
}

@override
String toString() {
  final _this = this as GoalSection;
  return 'GoalSection(primary: ${_this.primary}, targetWeightKg: ${_this.targetWeightKg}, targetWeeks: ${_this.targetWeeks}, priorityMuscles: ${_this.priorityMuscles}, motivation: ${_this.motivation})';
}


}

/// @nodoc
abstract mixin class $GoalSectionCopyWith<$Res>  {
  factory $GoalSectionCopyWith(GoalSection value, $Res Function(GoalSection) _then) = _$GoalSectionCopyWithImpl;
@useResult
$Res call({
 PrimaryGoal? primary, double? targetWeightKg, int? targetWeeks, List<MuscleGroup> priorityMuscles, String? motivation
});




}
/// @nodoc
class _$GoalSectionCopyWithImpl<$Res>
    implements $GoalSectionCopyWith<$Res> {
  _$GoalSectionCopyWithImpl(this._self, this._then);

  final GoalSection _self;
  final $Res Function(GoalSection) _then;

/// Create a copy of GoalSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primary = freezed,Object? targetWeightKg = freezed,Object? targetWeeks = freezed,Object? priorityMuscles = null,Object? motivation = freezed,}) {
  return _then(GoalSection(
primary: freezed == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as PrimaryGoal?,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeeks: freezed == targetWeeks ? _self.targetWeeks : targetWeeks // ignore: cast_nullable_to_non_nullable
as int?,priorityMuscles: null == priorityMuscles ? _self.priorityMuscles : priorityMuscles // ignore: cast_nullable_to_non_nullable
as List<MuscleGroup>,motivation: freezed == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalSection].
extension GoalSectionPatterns on GoalSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalSection value)  $default,){
final _that = this;
switch (_that) {
case _GoalSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalSection value)?  $default,){
final _that = this;
switch (_that) {
case _GoalSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PrimaryGoal? primary,  double? targetWeightKg,  int? targetWeeks,  List<MuscleGroup> priorityMuscles,  String? motivation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalSection() when $default != null:
return $default(_that.primary,_that.targetWeightKg,_that.targetWeeks,_that.priorityMuscles,_that.motivation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PrimaryGoal? primary,  double? targetWeightKg,  int? targetWeeks,  List<MuscleGroup> priorityMuscles,  String? motivation)  $default,) {final _that = this;
switch (_that) {
case _GoalSection():
return $default(_that.primary,_that.targetWeightKg,_that.targetWeeks,_that.priorityMuscles,_that.motivation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PrimaryGoal? primary,  double? targetWeightKg,  int? targetWeeks,  List<MuscleGroup> priorityMuscles,  String? motivation)?  $default,) {final _that = this;
switch (_that) {
case _GoalSection() when $default != null:
return $default(_that.primary,_that.targetWeightKg,_that.targetWeeks,_that.priorityMuscles,_that.motivation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalSection implements GoalSection {
  const _GoalSection({this.primary, this.targetWeightKg, this.targetWeeks,  List<MuscleGroup> priorityMuscles = const <MuscleGroup>[], this.motivation}): _priorityMuscles = priorityMuscles;
  factory _GoalSection.fromJson(Map<String, dynamic> json) => _$GoalSectionFromJson(json);

@override final  PrimaryGoal? primary;
@override final  double? targetWeightKg;
@override final  int? targetWeeks;
 final  List<MuscleGroup> _priorityMuscles;
@override@JsonKey() List<MuscleGroup> get priorityMuscles {
  if (_priorityMuscles is EqualUnmodifiableListView) return _priorityMuscles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_priorityMuscles);
}

@override final  String? motivation;

/// Create a copy of GoalSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalSectionCopyWith<_GoalSection> get copyWith => __$GoalSectionCopyWithImpl<_GoalSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalSectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalSection&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.targetWeightKg, targetWeightKg) || other.targetWeightKg == targetWeightKg)&&(identical(other.targetWeeks, targetWeeks) || other.targetWeeks == targetWeeks)&&const DeepCollectionEquality().equals(other.priorityMuscles, _priorityMuscles)&&(identical(other.motivation, motivation) || other.motivation == motivation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,primary,targetWeightKg,targetWeeks,const DeepCollectionEquality().hash(_priorityMuscles),motivation);
}

@override
String toString() {
    return 'GoalSection(primary: $primary, targetWeightKg: $targetWeightKg, targetWeeks: $targetWeeks, priorityMuscles: $priorityMuscles, motivation: $motivation)';
}


}

/// @nodoc
abstract mixin class _$GoalSectionCopyWith<$Res> implements $GoalSectionCopyWith<$Res> {
  factory _$GoalSectionCopyWith(_GoalSection value, $Res Function(_GoalSection) _then) = __$GoalSectionCopyWithImpl;
@override @useResult
$Res call({
 PrimaryGoal? primary, double? targetWeightKg, int? targetWeeks, List<MuscleGroup> priorityMuscles, String? motivation
});




}
/// @nodoc
class __$GoalSectionCopyWithImpl<$Res>
    implements _$GoalSectionCopyWith<$Res> {
  __$GoalSectionCopyWithImpl(this._self, this._then);

  final _GoalSection _self;
  final $Res Function(_GoalSection) _then;

/// Create a copy of GoalSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primary = freezed,Object? targetWeightKg = freezed,Object? targetWeeks = freezed,Object? priorityMuscles = null,Object? motivation = freezed,}) {
  return _then(_GoalSection(
primary: freezed == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as PrimaryGoal?,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeeks: freezed == targetWeeks ? _self.targetWeeks : targetWeeks // ignore: cast_nullable_to_non_nullable
as int?,priorityMuscles: null == priorityMuscles ? _self._priorityMuscles : priorityMuscles // ignore: cast_nullable_to_non_nullable
as List<MuscleGroup>,motivation: freezed == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ExperienceSection {

 ExperienceLevel? get level; TrainingAge? get trainingAge; int? get currentSessionsPerWeek; String? get knownExercises; String? get workingWeights;
/// Create a copy of ExperienceSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceSectionCopyWith<ExperienceSection> get copyWith => _$ExperienceSectionCopyWithImpl<ExperienceSection>(this as ExperienceSection, _$identity);

  /// Serializes this ExperienceSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExperienceSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExperienceSection&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.trainingAge, _this.trainingAge) || other.trainingAge == _this.trainingAge)&&(identical(other.currentSessionsPerWeek, _this.currentSessionsPerWeek) || other.currentSessionsPerWeek == _this.currentSessionsPerWeek)&&(identical(other.knownExercises, _this.knownExercises) || other.knownExercises == _this.knownExercises)&&(identical(other.workingWeights, _this.workingWeights) || other.workingWeights == _this.workingWeights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExperienceSection;
  return Object.hash(runtimeType,_this.level,_this.trainingAge,_this.currentSessionsPerWeek,_this.knownExercises,_this.workingWeights);
}

@override
String toString() {
  final _this = this as ExperienceSection;
  return 'ExperienceSection(level: ${_this.level}, trainingAge: ${_this.trainingAge}, currentSessionsPerWeek: ${_this.currentSessionsPerWeek}, knownExercises: ${_this.knownExercises}, workingWeights: ${_this.workingWeights})';
}


}

/// @nodoc
abstract mixin class $ExperienceSectionCopyWith<$Res>  {
  factory $ExperienceSectionCopyWith(ExperienceSection value, $Res Function(ExperienceSection) _then) = _$ExperienceSectionCopyWithImpl;
@useResult
$Res call({
 ExperienceLevel? level, TrainingAge? trainingAge, int? currentSessionsPerWeek, String? knownExercises, String? workingWeights
});




}
/// @nodoc
class _$ExperienceSectionCopyWithImpl<$Res>
    implements $ExperienceSectionCopyWith<$Res> {
  _$ExperienceSectionCopyWithImpl(this._self, this._then);

  final ExperienceSection _self;
  final $Res Function(ExperienceSection) _then;

/// Create a copy of ExperienceSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = freezed,Object? trainingAge = freezed,Object? currentSessionsPerWeek = freezed,Object? knownExercises = freezed,Object? workingWeights = freezed,}) {
  return _then(ExperienceSection(
level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ExperienceLevel?,trainingAge: freezed == trainingAge ? _self.trainingAge : trainingAge // ignore: cast_nullable_to_non_nullable
as TrainingAge?,currentSessionsPerWeek: freezed == currentSessionsPerWeek ? _self.currentSessionsPerWeek : currentSessionsPerWeek // ignore: cast_nullable_to_non_nullable
as int?,knownExercises: freezed == knownExercises ? _self.knownExercises : knownExercises // ignore: cast_nullable_to_non_nullable
as String?,workingWeights: freezed == workingWeights ? _self.workingWeights : workingWeights // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExperienceSection].
extension ExperienceSectionPatterns on ExperienceSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExperienceSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExperienceSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExperienceSection value)  $default,){
final _that = this;
switch (_that) {
case _ExperienceSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExperienceSection value)?  $default,){
final _that = this;
switch (_that) {
case _ExperienceSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExperienceLevel? level,  TrainingAge? trainingAge,  int? currentSessionsPerWeek,  String? knownExercises,  String? workingWeights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExperienceSection() when $default != null:
return $default(_that.level,_that.trainingAge,_that.currentSessionsPerWeek,_that.knownExercises,_that.workingWeights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExperienceLevel? level,  TrainingAge? trainingAge,  int? currentSessionsPerWeek,  String? knownExercises,  String? workingWeights)  $default,) {final _that = this;
switch (_that) {
case _ExperienceSection():
return $default(_that.level,_that.trainingAge,_that.currentSessionsPerWeek,_that.knownExercises,_that.workingWeights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExperienceLevel? level,  TrainingAge? trainingAge,  int? currentSessionsPerWeek,  String? knownExercises,  String? workingWeights)?  $default,) {final _that = this;
switch (_that) {
case _ExperienceSection() when $default != null:
return $default(_that.level,_that.trainingAge,_that.currentSessionsPerWeek,_that.knownExercises,_that.workingWeights);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExperienceSection implements ExperienceSection {
  const _ExperienceSection({this.level, this.trainingAge, this.currentSessionsPerWeek, this.knownExercises, this.workingWeights});
  factory _ExperienceSection.fromJson(Map<String, dynamic> json) => _$ExperienceSectionFromJson(json);

@override final  ExperienceLevel? level;
@override final  TrainingAge? trainingAge;
@override final  int? currentSessionsPerWeek;
@override final  String? knownExercises;
@override final  String? workingWeights;

/// Create a copy of ExperienceSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceSectionCopyWith<_ExperienceSection> get copyWith => __$ExperienceSectionCopyWithImpl<_ExperienceSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceSectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExperienceSection&&(identical(other.level, level) || other.level == level)&&(identical(other.trainingAge, trainingAge) || other.trainingAge == trainingAge)&&(identical(other.currentSessionsPerWeek, currentSessionsPerWeek) || other.currentSessionsPerWeek == currentSessionsPerWeek)&&(identical(other.knownExercises, knownExercises) || other.knownExercises == knownExercises)&&(identical(other.workingWeights, workingWeights) || other.workingWeights == workingWeights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,trainingAge,currentSessionsPerWeek,knownExercises,workingWeights);
}

@override
String toString() {
    return 'ExperienceSection(level: $level, trainingAge: $trainingAge, currentSessionsPerWeek: $currentSessionsPerWeek, knownExercises: $knownExercises, workingWeights: $workingWeights)';
}


}

/// @nodoc
abstract mixin class _$ExperienceSectionCopyWith<$Res> implements $ExperienceSectionCopyWith<$Res> {
  factory _$ExperienceSectionCopyWith(_ExperienceSection value, $Res Function(_ExperienceSection) _then) = __$ExperienceSectionCopyWithImpl;
@override @useResult
$Res call({
 ExperienceLevel? level, TrainingAge? trainingAge, int? currentSessionsPerWeek, String? knownExercises, String? workingWeights
});




}
/// @nodoc
class __$ExperienceSectionCopyWithImpl<$Res>
    implements _$ExperienceSectionCopyWith<$Res> {
  __$ExperienceSectionCopyWithImpl(this._self, this._then);

  final _ExperienceSection _self;
  final $Res Function(_ExperienceSection) _then;

/// Create a copy of ExperienceSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = freezed,Object? trainingAge = freezed,Object? currentSessionsPerWeek = freezed,Object? knownExercises = freezed,Object? workingWeights = freezed,}) {
  return _then(_ExperienceSection(
level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ExperienceLevel?,trainingAge: freezed == trainingAge ? _self.trainingAge : trainingAge // ignore: cast_nullable_to_non_nullable
as TrainingAge?,currentSessionsPerWeek: freezed == currentSessionsPerWeek ? _self.currentSessionsPerWeek : currentSessionsPerWeek // ignore: cast_nullable_to_non_nullable
as int?,knownExercises: freezed == knownExercises ? _self.knownExercises : knownExercises // ignore: cast_nullable_to_non_nullable
as String?,workingWeights: freezed == workingWeights ? _self.workingWeights : workingWeights // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EquipmentSelection {

 bool get dumbbell; bool get barbell; bool get bench; bool get rack; bool get pullUpBar;
/// Create a copy of EquipmentSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EquipmentSelectionCopyWith<EquipmentSelection> get copyWith => _$EquipmentSelectionCopyWithImpl<EquipmentSelection>(this as EquipmentSelection, _$identity);

  /// Serializes this EquipmentSelection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EquipmentSelection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EquipmentSelection&&(identical(other.dumbbell, _this.dumbbell) || other.dumbbell == _this.dumbbell)&&(identical(other.barbell, _this.barbell) || other.barbell == _this.barbell)&&(identical(other.bench, _this.bench) || other.bench == _this.bench)&&(identical(other.rack, _this.rack) || other.rack == _this.rack)&&(identical(other.pullUpBar, _this.pullUpBar) || other.pullUpBar == _this.pullUpBar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EquipmentSelection;
  return Object.hash(runtimeType,_this.dumbbell,_this.barbell,_this.bench,_this.rack,_this.pullUpBar);
}

@override
String toString() {
  final _this = this as EquipmentSelection;
  return 'EquipmentSelection(dumbbell: ${_this.dumbbell}, barbell: ${_this.barbell}, bench: ${_this.bench}, rack: ${_this.rack}, pullUpBar: ${_this.pullUpBar})';
}


}

/// @nodoc
abstract mixin class $EquipmentSelectionCopyWith<$Res>  {
  factory $EquipmentSelectionCopyWith(EquipmentSelection value, $Res Function(EquipmentSelection) _then) = _$EquipmentSelectionCopyWithImpl;
@useResult
$Res call({
 bool dumbbell, bool barbell, bool bench, bool rack, bool pullUpBar
});




}
/// @nodoc
class _$EquipmentSelectionCopyWithImpl<$Res>
    implements $EquipmentSelectionCopyWith<$Res> {
  _$EquipmentSelectionCopyWithImpl(this._self, this._then);

  final EquipmentSelection _self;
  final $Res Function(EquipmentSelection) _then;

/// Create a copy of EquipmentSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dumbbell = null,Object? barbell = null,Object? bench = null,Object? rack = null,Object? pullUpBar = null,}) {
  return _then(EquipmentSelection(
dumbbell: null == dumbbell ? _self.dumbbell : dumbbell // ignore: cast_nullable_to_non_nullable
as bool,barbell: null == barbell ? _self.barbell : barbell // ignore: cast_nullable_to_non_nullable
as bool,bench: null == bench ? _self.bench : bench // ignore: cast_nullable_to_non_nullable
as bool,rack: null == rack ? _self.rack : rack // ignore: cast_nullable_to_non_nullable
as bool,pullUpBar: null == pullUpBar ? _self.pullUpBar : pullUpBar // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EquipmentSelection].
extension EquipmentSelectionPatterns on EquipmentSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EquipmentSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EquipmentSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EquipmentSelection value)  $default,){
final _that = this;
switch (_that) {
case _EquipmentSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EquipmentSelection value)?  $default,){
final _that = this;
switch (_that) {
case _EquipmentSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool dumbbell,  bool barbell,  bool bench,  bool rack,  bool pullUpBar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EquipmentSelection() when $default != null:
return $default(_that.dumbbell,_that.barbell,_that.bench,_that.rack,_that.pullUpBar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool dumbbell,  bool barbell,  bool bench,  bool rack,  bool pullUpBar)  $default,) {final _that = this;
switch (_that) {
case _EquipmentSelection():
return $default(_that.dumbbell,_that.barbell,_that.bench,_that.rack,_that.pullUpBar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool dumbbell,  bool barbell,  bool bench,  bool rack,  bool pullUpBar)?  $default,) {final _that = this;
switch (_that) {
case _EquipmentSelection() when $default != null:
return $default(_that.dumbbell,_that.barbell,_that.bench,_that.rack,_that.pullUpBar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EquipmentSelection implements EquipmentSelection {
  const _EquipmentSelection({this.dumbbell = false, this.barbell = false, this.bench = false, this.rack = false, this.pullUpBar = false});
  factory _EquipmentSelection.fromJson(Map<String, dynamic> json) => _$EquipmentSelectionFromJson(json);

@override@JsonKey() final  bool dumbbell;
@override@JsonKey() final  bool barbell;
@override@JsonKey() final  bool bench;
@override@JsonKey() final  bool rack;
@override@JsonKey() final  bool pullUpBar;

/// Create a copy of EquipmentSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EquipmentSelectionCopyWith<_EquipmentSelection> get copyWith => __$EquipmentSelectionCopyWithImpl<_EquipmentSelection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EquipmentSelectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EquipmentSelection&&(identical(other.dumbbell, dumbbell) || other.dumbbell == dumbbell)&&(identical(other.barbell, barbell) || other.barbell == barbell)&&(identical(other.bench, bench) || other.bench == bench)&&(identical(other.rack, rack) || other.rack == rack)&&(identical(other.pullUpBar, pullUpBar) || other.pullUpBar == pullUpBar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dumbbell,barbell,bench,rack,pullUpBar);
}

@override
String toString() {
    return 'EquipmentSelection(dumbbell: $dumbbell, barbell: $barbell, bench: $bench, rack: $rack, pullUpBar: $pullUpBar)';
}


}

/// @nodoc
abstract mixin class _$EquipmentSelectionCopyWith<$Res> implements $EquipmentSelectionCopyWith<$Res> {
  factory _$EquipmentSelectionCopyWith(_EquipmentSelection value, $Res Function(_EquipmentSelection) _then) = __$EquipmentSelectionCopyWithImpl;
@override @useResult
$Res call({
 bool dumbbell, bool barbell, bool bench, bool rack, bool pullUpBar
});




}
/// @nodoc
class __$EquipmentSelectionCopyWithImpl<$Res>
    implements _$EquipmentSelectionCopyWith<$Res> {
  __$EquipmentSelectionCopyWithImpl(this._self, this._then);

  final _EquipmentSelection _self;
  final $Res Function(_EquipmentSelection) _then;

/// Create a copy of EquipmentSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dumbbell = null,Object? barbell = null,Object? bench = null,Object? rack = null,Object? pullUpBar = null,}) {
  return _then(_EquipmentSelection(
dumbbell: null == dumbbell ? _self.dumbbell : dumbbell // ignore: cast_nullable_to_non_nullable
as bool,barbell: null == barbell ? _self.barbell : barbell // ignore: cast_nullable_to_non_nullable
as bool,bench: null == bench ? _self.bench : bench // ignore: cast_nullable_to_non_nullable
as bool,rack: null == rack ? _self.rack : rack // ignore: cast_nullable_to_non_nullable
as bool,pullUpBar: null == pullUpBar ? _self.pullUpBar : pullUpBar // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AvailabilitySection {

/// ISO: 1 = Senin … 7 = Minggu.
 List<int> get trainingDays; int? get sessionMinutes; TrainingLocation? get location; EquipmentSelection get equipment; double? get dumbbellMaxKg; double? get barbellMaxKg; String? get preferences;
/// Create a copy of AvailabilitySection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilitySectionCopyWith<AvailabilitySection> get copyWith => _$AvailabilitySectionCopyWithImpl<AvailabilitySection>(this as AvailabilitySection, _$identity);

  /// Serializes this AvailabilitySection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AvailabilitySection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilitySection&&const DeepCollectionEquality().equals(other.trainingDays, _this.trainingDays)&&(identical(other.sessionMinutes, _this.sessionMinutes) || other.sessionMinutes == _this.sessionMinutes)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.equipment, _this.equipment) || other.equipment == _this.equipment)&&(identical(other.dumbbellMaxKg, _this.dumbbellMaxKg) || other.dumbbellMaxKg == _this.dumbbellMaxKg)&&(identical(other.barbellMaxKg, _this.barbellMaxKg) || other.barbellMaxKg == _this.barbellMaxKg)&&(identical(other.preferences, _this.preferences) || other.preferences == _this.preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AvailabilitySection;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.trainingDays),_this.sessionMinutes,_this.location,_this.equipment,_this.dumbbellMaxKg,_this.barbellMaxKg,_this.preferences);
}

@override
String toString() {
  final _this = this as AvailabilitySection;
  return 'AvailabilitySection(trainingDays: ${_this.trainingDays}, sessionMinutes: ${_this.sessionMinutes}, location: ${_this.location}, equipment: ${_this.equipment}, dumbbellMaxKg: ${_this.dumbbellMaxKg}, barbellMaxKg: ${_this.barbellMaxKg}, preferences: ${_this.preferences})';
}


}

/// @nodoc
abstract mixin class $AvailabilitySectionCopyWith<$Res>  {
  factory $AvailabilitySectionCopyWith(AvailabilitySection value, $Res Function(AvailabilitySection) _then) = _$AvailabilitySectionCopyWithImpl;
@useResult
$Res call({
 List<int> trainingDays, int? sessionMinutes, TrainingLocation? location, EquipmentSelection equipment, double? dumbbellMaxKg, double? barbellMaxKg, String? preferences
});


$EquipmentSelectionCopyWith<$Res> get equipment;

}
/// @nodoc
class _$AvailabilitySectionCopyWithImpl<$Res>
    implements $AvailabilitySectionCopyWith<$Res> {
  _$AvailabilitySectionCopyWithImpl(this._self, this._then);

  final AvailabilitySection _self;
  final $Res Function(AvailabilitySection) _then;

/// Create a copy of AvailabilitySection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trainingDays = null,Object? sessionMinutes = freezed,Object? location = freezed,Object? equipment = null,Object? dumbbellMaxKg = freezed,Object? barbellMaxKg = freezed,Object? preferences = freezed,}) {
  return _then(AvailabilitySection(
trainingDays: null == trainingDays ? _self.trainingDays : trainingDays // ignore: cast_nullable_to_non_nullable
as List<int>,sessionMinutes: freezed == sessionMinutes ? _self.sessionMinutes : sessionMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as TrainingLocation?,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as EquipmentSelection,dumbbellMaxKg: freezed == dumbbellMaxKg ? _self.dumbbellMaxKg : dumbbellMaxKg // ignore: cast_nullable_to_non_nullable
as double?,barbellMaxKg: freezed == barbellMaxKg ? _self.barbellMaxKg : barbellMaxKg // ignore: cast_nullable_to_non_nullable
as double?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AvailabilitySection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EquipmentSelectionCopyWith<$Res> get equipment {
  
  return $EquipmentSelectionCopyWith<$Res>(_self.equipment, (value) {
    return _then(_self.copyWith(equipment: value));
  });
}
}


/// Adds pattern-matching-related methods to [AvailabilitySection].
extension AvailabilitySectionPatterns on AvailabilitySection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilitySection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilitySection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilitySection value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilitySection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilitySection value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilitySection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> trainingDays,  int? sessionMinutes,  TrainingLocation? location,  EquipmentSelection equipment,  double? dumbbellMaxKg,  double? barbellMaxKg,  String? preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilitySection() when $default != null:
return $default(_that.trainingDays,_that.sessionMinutes,_that.location,_that.equipment,_that.dumbbellMaxKg,_that.barbellMaxKg,_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> trainingDays,  int? sessionMinutes,  TrainingLocation? location,  EquipmentSelection equipment,  double? dumbbellMaxKg,  double? barbellMaxKg,  String? preferences)  $default,) {final _that = this;
switch (_that) {
case _AvailabilitySection():
return $default(_that.trainingDays,_that.sessionMinutes,_that.location,_that.equipment,_that.dumbbellMaxKg,_that.barbellMaxKg,_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> trainingDays,  int? sessionMinutes,  TrainingLocation? location,  EquipmentSelection equipment,  double? dumbbellMaxKg,  double? barbellMaxKg,  String? preferences)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilitySection() when $default != null:
return $default(_that.trainingDays,_that.sessionMinutes,_that.location,_that.equipment,_that.dumbbellMaxKg,_that.barbellMaxKg,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilitySection implements AvailabilitySection {
  const _AvailabilitySection({ List<int> trainingDays = const <int>[], this.sessionMinutes, this.location, this.equipment = const EquipmentSelection(), this.dumbbellMaxKg, this.barbellMaxKg, this.preferences}): _trainingDays = trainingDays;
  factory _AvailabilitySection.fromJson(Map<String, dynamic> json) => _$AvailabilitySectionFromJson(json);

/// ISO: 1 = Senin … 7 = Minggu.
 final  List<int> _trainingDays;
/// ISO: 1 = Senin … 7 = Minggu.
@override@JsonKey() List<int> get trainingDays {
  if (_trainingDays is EqualUnmodifiableListView) return _trainingDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trainingDays);
}

@override final  int? sessionMinutes;
@override final  TrainingLocation? location;
@override@JsonKey() final  EquipmentSelection equipment;
@override final  double? dumbbellMaxKg;
@override final  double? barbellMaxKg;
@override final  String? preferences;

/// Create a copy of AvailabilitySection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilitySectionCopyWith<_AvailabilitySection> get copyWith => __$AvailabilitySectionCopyWithImpl<_AvailabilitySection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilitySectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilitySection&&const DeepCollectionEquality().equals(other.trainingDays, _trainingDays)&&(identical(other.sessionMinutes, sessionMinutes) || other.sessionMinutes == sessionMinutes)&&(identical(other.location, location) || other.location == location)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.dumbbellMaxKg, dumbbellMaxKg) || other.dumbbellMaxKg == dumbbellMaxKg)&&(identical(other.barbellMaxKg, barbellMaxKg) || other.barbellMaxKg == barbellMaxKg)&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_trainingDays),sessionMinutes,location,equipment,dumbbellMaxKg,barbellMaxKg,preferences);
}

@override
String toString() {
    return 'AvailabilitySection(trainingDays: $trainingDays, sessionMinutes: $sessionMinutes, location: $location, equipment: $equipment, dumbbellMaxKg: $dumbbellMaxKg, barbellMaxKg: $barbellMaxKg, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$AvailabilitySectionCopyWith<$Res> implements $AvailabilitySectionCopyWith<$Res> {
  factory _$AvailabilitySectionCopyWith(_AvailabilitySection value, $Res Function(_AvailabilitySection) _then) = __$AvailabilitySectionCopyWithImpl;
@override @useResult
$Res call({
 List<int> trainingDays, int? sessionMinutes, TrainingLocation? location, EquipmentSelection equipment, double? dumbbellMaxKg, double? barbellMaxKg, String? preferences
});


@override $EquipmentSelectionCopyWith<$Res> get equipment;

}
/// @nodoc
class __$AvailabilitySectionCopyWithImpl<$Res>
    implements _$AvailabilitySectionCopyWith<$Res> {
  __$AvailabilitySectionCopyWithImpl(this._self, this._then);

  final _AvailabilitySection _self;
  final $Res Function(_AvailabilitySection) _then;

/// Create a copy of AvailabilitySection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trainingDays = null,Object? sessionMinutes = freezed,Object? location = freezed,Object? equipment = null,Object? dumbbellMaxKg = freezed,Object? barbellMaxKg = freezed,Object? preferences = freezed,}) {
  return _then(_AvailabilitySection(
trainingDays: null == trainingDays ? _self._trainingDays : trainingDays // ignore: cast_nullable_to_non_nullable
as List<int>,sessionMinutes: freezed == sessionMinutes ? _self.sessionMinutes : sessionMinutes // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as TrainingLocation?,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as EquipmentSelection,dumbbellMaxKg: freezed == dumbbellMaxKg ? _self.dumbbellMaxKg : dumbbellMaxKg // ignore: cast_nullable_to_non_nullable
as double?,barbellMaxKg: freezed == barbellMaxKg ? _self.barbellMaxKg : barbellMaxKg // ignore: cast_nullable_to_non_nullable
as double?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AvailabilitySection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EquipmentSelectionCopyWith<$Res> get equipment {
  
  return $EquipmentSelectionCopyWith<$Res>(_self.equipment, (value) {
    return _then(_self.copyWith(equipment: value));
  });
}
}


/// @nodoc
mixin _$ActivitySection {

 ActivityLevel? get level; Occupation? get occupation; double? get sleepHours; StressLevel? get stress; String? get cardio;
/// Create a copy of ActivitySection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivitySectionCopyWith<ActivitySection> get copyWith => _$ActivitySectionCopyWithImpl<ActivitySection>(this as ActivitySection, _$identity);

  /// Serializes this ActivitySection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ActivitySection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivitySection&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.occupation, _this.occupation) || other.occupation == _this.occupation)&&(identical(other.sleepHours, _this.sleepHours) || other.sleepHours == _this.sleepHours)&&(identical(other.stress, _this.stress) || other.stress == _this.stress)&&(identical(other.cardio, _this.cardio) || other.cardio == _this.cardio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ActivitySection;
  return Object.hash(runtimeType,_this.level,_this.occupation,_this.sleepHours,_this.stress,_this.cardio);
}

@override
String toString() {
  final _this = this as ActivitySection;
  return 'ActivitySection(level: ${_this.level}, occupation: ${_this.occupation}, sleepHours: ${_this.sleepHours}, stress: ${_this.stress}, cardio: ${_this.cardio})';
}


}

/// @nodoc
abstract mixin class $ActivitySectionCopyWith<$Res>  {
  factory $ActivitySectionCopyWith(ActivitySection value, $Res Function(ActivitySection) _then) = _$ActivitySectionCopyWithImpl;
@useResult
$Res call({
 ActivityLevel? level, Occupation? occupation, double? sleepHours, StressLevel? stress, String? cardio
});




}
/// @nodoc
class _$ActivitySectionCopyWithImpl<$Res>
    implements $ActivitySectionCopyWith<$Res> {
  _$ActivitySectionCopyWithImpl(this._self, this._then);

  final ActivitySection _self;
  final $Res Function(ActivitySection) _then;

/// Create a copy of ActivitySection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = freezed,Object? occupation = freezed,Object? sleepHours = freezed,Object? stress = freezed,Object? cardio = freezed,}) {
  return _then(ActivitySection(
level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as Occupation?,sleepHours: freezed == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double?,stress: freezed == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as StressLevel?,cardio: freezed == cardio ? _self.cardio : cardio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivitySection].
extension ActivitySectionPatterns on ActivitySection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivitySection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivitySection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivitySection value)  $default,){
final _that = this;
switch (_that) {
case _ActivitySection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivitySection value)?  $default,){
final _that = this;
switch (_that) {
case _ActivitySection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActivityLevel? level,  Occupation? occupation,  double? sleepHours,  StressLevel? stress,  String? cardio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivitySection() when $default != null:
return $default(_that.level,_that.occupation,_that.sleepHours,_that.stress,_that.cardio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActivityLevel? level,  Occupation? occupation,  double? sleepHours,  StressLevel? stress,  String? cardio)  $default,) {final _that = this;
switch (_that) {
case _ActivitySection():
return $default(_that.level,_that.occupation,_that.sleepHours,_that.stress,_that.cardio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActivityLevel? level,  Occupation? occupation,  double? sleepHours,  StressLevel? stress,  String? cardio)?  $default,) {final _that = this;
switch (_that) {
case _ActivitySection() when $default != null:
return $default(_that.level,_that.occupation,_that.sleepHours,_that.stress,_that.cardio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivitySection implements ActivitySection {
  const _ActivitySection({this.level, this.occupation, this.sleepHours, this.stress, this.cardio});
  factory _ActivitySection.fromJson(Map<String, dynamic> json) => _$ActivitySectionFromJson(json);

@override final  ActivityLevel? level;
@override final  Occupation? occupation;
@override final  double? sleepHours;
@override final  StressLevel? stress;
@override final  String? cardio;

/// Create a copy of ActivitySection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivitySectionCopyWith<_ActivitySection> get copyWith => __$ActivitySectionCopyWithImpl<_ActivitySection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivitySectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivitySection&&(identical(other.level, level) || other.level == level)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.cardio, cardio) || other.cardio == cardio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,occupation,sleepHours,stress,cardio);
}

@override
String toString() {
    return 'ActivitySection(level: $level, occupation: $occupation, sleepHours: $sleepHours, stress: $stress, cardio: $cardio)';
}


}

/// @nodoc
abstract mixin class _$ActivitySectionCopyWith<$Res> implements $ActivitySectionCopyWith<$Res> {
  factory _$ActivitySectionCopyWith(_ActivitySection value, $Res Function(_ActivitySection) _then) = __$ActivitySectionCopyWithImpl;
@override @useResult
$Res call({
 ActivityLevel? level, Occupation? occupation, double? sleepHours, StressLevel? stress, String? cardio
});




}
/// @nodoc
class __$ActivitySectionCopyWithImpl<$Res>
    implements _$ActivitySectionCopyWith<$Res> {
  __$ActivitySectionCopyWithImpl(this._self, this._then);

  final _ActivitySection _self;
  final $Res Function(_ActivitySection) _then;

/// Create a copy of ActivitySection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = freezed,Object? occupation = freezed,Object? sleepHours = freezed,Object? stress = freezed,Object? cardio = freezed,}) {
  return _then(_ActivitySection(
level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as Occupation?,sleepHours: freezed == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double?,stress: freezed == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as StressLevel?,cardio: freezed == cardio ? _self.cardio : cardio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NutritionSection {

 Diet? get diet; String? get allergies; String? get dislikes; String? get preferences; int? get dailyBudgetIdr; int? get mealsPerDay; Cooking? get cooking; String get country; String? get notes;
/// Create a copy of NutritionSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NutritionSectionCopyWith<NutritionSection> get copyWith => _$NutritionSectionCopyWithImpl<NutritionSection>(this as NutritionSection, _$identity);

  /// Serializes this NutritionSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NutritionSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NutritionSection&&(identical(other.diet, _this.diet) || other.diet == _this.diet)&&(identical(other.allergies, _this.allergies) || other.allergies == _this.allergies)&&(identical(other.dislikes, _this.dislikes) || other.dislikes == _this.dislikes)&&(identical(other.preferences, _this.preferences) || other.preferences == _this.preferences)&&(identical(other.dailyBudgetIdr, _this.dailyBudgetIdr) || other.dailyBudgetIdr == _this.dailyBudgetIdr)&&(identical(other.mealsPerDay, _this.mealsPerDay) || other.mealsPerDay == _this.mealsPerDay)&&(identical(other.cooking, _this.cooking) || other.cooking == _this.cooking)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NutritionSection;
  return Object.hash(runtimeType,_this.diet,_this.allergies,_this.dislikes,_this.preferences,_this.dailyBudgetIdr,_this.mealsPerDay,_this.cooking,_this.country,_this.notes);
}

@override
String toString() {
  final _this = this as NutritionSection;
  return 'NutritionSection(diet: ${_this.diet}, allergies: ${_this.allergies}, dislikes: ${_this.dislikes}, preferences: ${_this.preferences}, dailyBudgetIdr: ${_this.dailyBudgetIdr}, mealsPerDay: ${_this.mealsPerDay}, cooking: ${_this.cooking}, country: ${_this.country}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $NutritionSectionCopyWith<$Res>  {
  factory $NutritionSectionCopyWith(NutritionSection value, $Res Function(NutritionSection) _then) = _$NutritionSectionCopyWithImpl;
@useResult
$Res call({
 Diet? diet, String? allergies, String? dislikes, String? preferences, int? dailyBudgetIdr, int? mealsPerDay, Cooking? cooking, String country, String? notes
});




}
/// @nodoc
class _$NutritionSectionCopyWithImpl<$Res>
    implements $NutritionSectionCopyWith<$Res> {
  _$NutritionSectionCopyWithImpl(this._self, this._then);

  final NutritionSection _self;
  final $Res Function(NutritionSection) _then;

/// Create a copy of NutritionSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diet = freezed,Object? allergies = freezed,Object? dislikes = freezed,Object? preferences = freezed,Object? dailyBudgetIdr = freezed,Object? mealsPerDay = freezed,Object? cooking = freezed,Object? country = null,Object? notes = freezed,}) {
  return _then(NutritionSection(
diet: freezed == diet ? _self.diet : diet // ignore: cast_nullable_to_non_nullable
as Diet?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,dislikes: freezed == dislikes ? _self.dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as String?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as String?,dailyBudgetIdr: freezed == dailyBudgetIdr ? _self.dailyBudgetIdr : dailyBudgetIdr // ignore: cast_nullable_to_non_nullable
as int?,mealsPerDay: freezed == mealsPerDay ? _self.mealsPerDay : mealsPerDay // ignore: cast_nullable_to_non_nullable
as int?,cooking: freezed == cooking ? _self.cooking : cooking // ignore: cast_nullable_to_non_nullable
as Cooking?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NutritionSection].
extension NutritionSectionPatterns on NutritionSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NutritionSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NutritionSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NutritionSection value)  $default,){
final _that = this;
switch (_that) {
case _NutritionSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NutritionSection value)?  $default,){
final _that = this;
switch (_that) {
case _NutritionSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Diet? diet,  String? allergies,  String? dislikes,  String? preferences,  int? dailyBudgetIdr,  int? mealsPerDay,  Cooking? cooking,  String country,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NutritionSection() when $default != null:
return $default(_that.diet,_that.allergies,_that.dislikes,_that.preferences,_that.dailyBudgetIdr,_that.mealsPerDay,_that.cooking,_that.country,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Diet? diet,  String? allergies,  String? dislikes,  String? preferences,  int? dailyBudgetIdr,  int? mealsPerDay,  Cooking? cooking,  String country,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _NutritionSection():
return $default(_that.diet,_that.allergies,_that.dislikes,_that.preferences,_that.dailyBudgetIdr,_that.mealsPerDay,_that.cooking,_that.country,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Diet? diet,  String? allergies,  String? dislikes,  String? preferences,  int? dailyBudgetIdr,  int? mealsPerDay,  Cooking? cooking,  String country,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _NutritionSection() when $default != null:
return $default(_that.diet,_that.allergies,_that.dislikes,_that.preferences,_that.dailyBudgetIdr,_that.mealsPerDay,_that.cooking,_that.country,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NutritionSection implements NutritionSection {
  const _NutritionSection({this.diet, this.allergies, this.dislikes, this.preferences, this.dailyBudgetIdr, this.mealsPerDay = 3, this.cooking, this.country = 'ID', this.notes});
  factory _NutritionSection.fromJson(Map<String, dynamic> json) => _$NutritionSectionFromJson(json);

@override final  Diet? diet;
@override final  String? allergies;
@override final  String? dislikes;
@override final  String? preferences;
@override final  int? dailyBudgetIdr;
@override@JsonKey() final  int? mealsPerDay;
@override final  Cooking? cooking;
@override@JsonKey() final  String country;
@override final  String? notes;

/// Create a copy of NutritionSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NutritionSectionCopyWith<_NutritionSection> get copyWith => __$NutritionSectionCopyWithImpl<_NutritionSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NutritionSectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NutritionSection&&(identical(other.diet, diet) || other.diet == diet)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.dislikes, dislikes) || other.dislikes == dislikes)&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.dailyBudgetIdr, dailyBudgetIdr) || other.dailyBudgetIdr == dailyBudgetIdr)&&(identical(other.mealsPerDay, mealsPerDay) || other.mealsPerDay == mealsPerDay)&&(identical(other.cooking, cooking) || other.cooking == cooking)&&(identical(other.country, country) || other.country == country)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,diet,allergies,dislikes,preferences,dailyBudgetIdr,mealsPerDay,cooking,country,notes);
}

@override
String toString() {
    return 'NutritionSection(diet: $diet, allergies: $allergies, dislikes: $dislikes, preferences: $preferences, dailyBudgetIdr: $dailyBudgetIdr, mealsPerDay: $mealsPerDay, cooking: $cooking, country: $country, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$NutritionSectionCopyWith<$Res> implements $NutritionSectionCopyWith<$Res> {
  factory _$NutritionSectionCopyWith(_NutritionSection value, $Res Function(_NutritionSection) _then) = __$NutritionSectionCopyWithImpl;
@override @useResult
$Res call({
 Diet? diet, String? allergies, String? dislikes, String? preferences, int? dailyBudgetIdr, int? mealsPerDay, Cooking? cooking, String country, String? notes
});




}
/// @nodoc
class __$NutritionSectionCopyWithImpl<$Res>
    implements _$NutritionSectionCopyWith<$Res> {
  __$NutritionSectionCopyWithImpl(this._self, this._then);

  final _NutritionSection _self;
  final $Res Function(_NutritionSection) _then;

/// Create a copy of NutritionSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diet = freezed,Object? allergies = freezed,Object? dislikes = freezed,Object? preferences = freezed,Object? dailyBudgetIdr = freezed,Object? mealsPerDay = freezed,Object? cooking = freezed,Object? country = null,Object? notes = freezed,}) {
  return _then(_NutritionSection(
diet: freezed == diet ? _self.diet : diet // ignore: cast_nullable_to_non_nullable
as Diet?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,dislikes: freezed == dislikes ? _self.dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as String?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as String?,dailyBudgetIdr: freezed == dailyBudgetIdr ? _self.dailyBudgetIdr : dailyBudgetIdr // ignore: cast_nullable_to_non_nullable
as int?,mealsPerDay: freezed == mealsPerDay ? _self.mealsPerDay : mealsPerDay // ignore: cast_nullable_to_non_nullable
as int?,cooking: freezed == cooking ? _self.cooking : cooking // ignore: cast_nullable_to_non_nullable
as Cooking?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SafetySection {

 String? get injuries; String? get avoidedMovements; List<MedicalFlag> get medicalFlags; List<RedFlag> get redFlags;
/// Create a copy of SafetySection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SafetySectionCopyWith<SafetySection> get copyWith => _$SafetySectionCopyWithImpl<SafetySection>(this as SafetySection, _$identity);

  /// Serializes this SafetySection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SafetySection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SafetySection&&(identical(other.injuries, _this.injuries) || other.injuries == _this.injuries)&&(identical(other.avoidedMovements, _this.avoidedMovements) || other.avoidedMovements == _this.avoidedMovements)&&const DeepCollectionEquality().equals(other.medicalFlags, _this.medicalFlags)&&const DeepCollectionEquality().equals(other.redFlags, _this.redFlags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SafetySection;
  return Object.hash(runtimeType,_this.injuries,_this.avoidedMovements,const DeepCollectionEquality().hash(_this.medicalFlags),const DeepCollectionEquality().hash(_this.redFlags));
}

@override
String toString() {
  final _this = this as SafetySection;
  return 'SafetySection(injuries: ${_this.injuries}, avoidedMovements: ${_this.avoidedMovements}, medicalFlags: ${_this.medicalFlags}, redFlags: ${_this.redFlags})';
}


}

/// @nodoc
abstract mixin class $SafetySectionCopyWith<$Res>  {
  factory $SafetySectionCopyWith(SafetySection value, $Res Function(SafetySection) _then) = _$SafetySectionCopyWithImpl;
@useResult
$Res call({
 String? injuries, String? avoidedMovements, List<MedicalFlag> medicalFlags, List<RedFlag> redFlags
});




}
/// @nodoc
class _$SafetySectionCopyWithImpl<$Res>
    implements $SafetySectionCopyWith<$Res> {
  _$SafetySectionCopyWithImpl(this._self, this._then);

  final SafetySection _self;
  final $Res Function(SafetySection) _then;

/// Create a copy of SafetySection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? injuries = freezed,Object? avoidedMovements = freezed,Object? medicalFlags = null,Object? redFlags = null,}) {
  return _then(SafetySection(
injuries: freezed == injuries ? _self.injuries : injuries // ignore: cast_nullable_to_non_nullable
as String?,avoidedMovements: freezed == avoidedMovements ? _self.avoidedMovements : avoidedMovements // ignore: cast_nullable_to_non_nullable
as String?,medicalFlags: null == medicalFlags ? _self.medicalFlags : medicalFlags // ignore: cast_nullable_to_non_nullable
as List<MedicalFlag>,redFlags: null == redFlags ? _self.redFlags : redFlags // ignore: cast_nullable_to_non_nullable
as List<RedFlag>,
  ));
}

}


/// Adds pattern-matching-related methods to [SafetySection].
extension SafetySectionPatterns on SafetySection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SafetySection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SafetySection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SafetySection value)  $default,){
final _that = this;
switch (_that) {
case _SafetySection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SafetySection value)?  $default,){
final _that = this;
switch (_that) {
case _SafetySection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? injuries,  String? avoidedMovements,  List<MedicalFlag> medicalFlags,  List<RedFlag> redFlags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SafetySection() when $default != null:
return $default(_that.injuries,_that.avoidedMovements,_that.medicalFlags,_that.redFlags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? injuries,  String? avoidedMovements,  List<MedicalFlag> medicalFlags,  List<RedFlag> redFlags)  $default,) {final _that = this;
switch (_that) {
case _SafetySection():
return $default(_that.injuries,_that.avoidedMovements,_that.medicalFlags,_that.redFlags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? injuries,  String? avoidedMovements,  List<MedicalFlag> medicalFlags,  List<RedFlag> redFlags)?  $default,) {final _that = this;
switch (_that) {
case _SafetySection() when $default != null:
return $default(_that.injuries,_that.avoidedMovements,_that.medicalFlags,_that.redFlags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SafetySection implements SafetySection {
  const _SafetySection({this.injuries, this.avoidedMovements,  List<MedicalFlag> medicalFlags = const <MedicalFlag>[],  List<RedFlag> redFlags = const <RedFlag>[]}): _medicalFlags = medicalFlags,_redFlags = redFlags;
  factory _SafetySection.fromJson(Map<String, dynamic> json) => _$SafetySectionFromJson(json);

@override final  String? injuries;
@override final  String? avoidedMovements;
 final  List<MedicalFlag> _medicalFlags;
@override@JsonKey() List<MedicalFlag> get medicalFlags {
  if (_medicalFlags is EqualUnmodifiableListView) return _medicalFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicalFlags);
}

 final  List<RedFlag> _redFlags;
@override@JsonKey() List<RedFlag> get redFlags {
  if (_redFlags is EqualUnmodifiableListView) return _redFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redFlags);
}


/// Create a copy of SafetySection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SafetySectionCopyWith<_SafetySection> get copyWith => __$SafetySectionCopyWithImpl<_SafetySection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SafetySectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SafetySection&&(identical(other.injuries, injuries) || other.injuries == injuries)&&(identical(other.avoidedMovements, avoidedMovements) || other.avoidedMovements == avoidedMovements)&&const DeepCollectionEquality().equals(other.medicalFlags, _medicalFlags)&&const DeepCollectionEquality().equals(other.redFlags, _redFlags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,injuries,avoidedMovements,const DeepCollectionEquality().hash(_medicalFlags),const DeepCollectionEquality().hash(_redFlags));
}

@override
String toString() {
    return 'SafetySection(injuries: $injuries, avoidedMovements: $avoidedMovements, medicalFlags: $medicalFlags, redFlags: $redFlags)';
}


}

/// @nodoc
abstract mixin class _$SafetySectionCopyWith<$Res> implements $SafetySectionCopyWith<$Res> {
  factory _$SafetySectionCopyWith(_SafetySection value, $Res Function(_SafetySection) _then) = __$SafetySectionCopyWithImpl;
@override @useResult
$Res call({
 String? injuries, String? avoidedMovements, List<MedicalFlag> medicalFlags, List<RedFlag> redFlags
});




}
/// @nodoc
class __$SafetySectionCopyWithImpl<$Res>
    implements _$SafetySectionCopyWith<$Res> {
  __$SafetySectionCopyWithImpl(this._self, this._then);

  final _SafetySection _self;
  final $Res Function(_SafetySection) _then;

/// Create a copy of SafetySection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? injuries = freezed,Object? avoidedMovements = freezed,Object? medicalFlags = null,Object? redFlags = null,}) {
  return _then(_SafetySection(
injuries: freezed == injuries ? _self.injuries : injuries // ignore: cast_nullable_to_non_nullable
as String?,avoidedMovements: freezed == avoidedMovements ? _self.avoidedMovements : avoidedMovements // ignore: cast_nullable_to_non_nullable
as String?,medicalFlags: null == medicalFlags ? _self._medicalFlags : medicalFlags // ignore: cast_nullable_to_non_nullable
as List<MedicalFlag>,redFlags: null == redFlags ? _self._redFlags : redFlags // ignore: cast_nullable_to_non_nullable
as List<RedFlag>,
  ));
}


}


/// @nodoc
mixin _$AssessmentData {

 ProfileSection get profile; GoalSection get goal; ExperienceSection get experience; AvailabilitySection get availability; ActivitySection get activity; NutritionSection get nutrition; SafetySection get safety;
/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentDataCopyWith<AssessmentData> get copyWith => _$AssessmentDataCopyWithImpl<AssessmentData>(this as AssessmentData, _$identity);

  /// Serializes this AssessmentData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssessmentData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentData&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.experience, _this.experience) || other.experience == _this.experience)&&(identical(other.availability, _this.availability) || other.availability == _this.availability)&&(identical(other.activity, _this.activity) || other.activity == _this.activity)&&(identical(other.nutrition, _this.nutrition) || other.nutrition == _this.nutrition)&&(identical(other.safety, _this.safety) || other.safety == _this.safety));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssessmentData;
  return Object.hash(runtimeType,_this.profile,_this.goal,_this.experience,_this.availability,_this.activity,_this.nutrition,_this.safety);
}

@override
String toString() {
  final _this = this as AssessmentData;
  return 'AssessmentData(profile: ${_this.profile}, goal: ${_this.goal}, experience: ${_this.experience}, availability: ${_this.availability}, activity: ${_this.activity}, nutrition: ${_this.nutrition}, safety: ${_this.safety})';
}


}

/// @nodoc
abstract mixin class $AssessmentDataCopyWith<$Res>  {
  factory $AssessmentDataCopyWith(AssessmentData value, $Res Function(AssessmentData) _then) = _$AssessmentDataCopyWithImpl;
@useResult
$Res call({
 ProfileSection profile, GoalSection goal, ExperienceSection experience, AvailabilitySection availability, ActivitySection activity, NutritionSection nutrition, SafetySection safety
});


$ProfileSectionCopyWith<$Res> get profile;$GoalSectionCopyWith<$Res> get goal;$ExperienceSectionCopyWith<$Res> get experience;$AvailabilitySectionCopyWith<$Res> get availability;$ActivitySectionCopyWith<$Res> get activity;$NutritionSectionCopyWith<$Res> get nutrition;$SafetySectionCopyWith<$Res> get safety;

}
/// @nodoc
class _$AssessmentDataCopyWithImpl<$Res>
    implements $AssessmentDataCopyWith<$Res> {
  _$AssessmentDataCopyWithImpl(this._self, this._then);

  final AssessmentData _self;
  final $Res Function(AssessmentData) _then;

/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,Object? goal = null,Object? experience = null,Object? availability = null,Object? activity = null,Object? nutrition = null,Object? safety = null,}) {
  return _then(AssessmentData(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileSection,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as GoalSection,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as ExperienceSection,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as AvailabilitySection,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivitySection,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as NutritionSection,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as SafetySection,
  ));
}
/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSectionCopyWith<$Res> get profile {
  
  return $ProfileSectionCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalSectionCopyWith<$Res> get goal {
  
  return $GoalSectionCopyWith<$Res>(_self.goal, (value) {
    return _then(_self.copyWith(goal: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExperienceSectionCopyWith<$Res> get experience {
  
  return $ExperienceSectionCopyWith<$Res>(_self.experience, (value) {
    return _then(_self.copyWith(experience: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilitySectionCopyWith<$Res> get availability {
  
  return $AvailabilitySectionCopyWith<$Res>(_self.availability, (value) {
    return _then(_self.copyWith(availability: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySectionCopyWith<$Res> get activity {
  
  return $ActivitySectionCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionSectionCopyWith<$Res> get nutrition {
  
  return $NutritionSectionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SafetySectionCopyWith<$Res> get safety {
  
  return $SafetySectionCopyWith<$Res>(_self.safety, (value) {
    return _then(_self.copyWith(safety: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssessmentData].
extension AssessmentDataPatterns on AssessmentData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentData value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentData value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileSection profile,  GoalSection goal,  ExperienceSection experience,  AvailabilitySection availability,  ActivitySection activity,  NutritionSection nutrition,  SafetySection safety)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentData() when $default != null:
return $default(_that.profile,_that.goal,_that.experience,_that.availability,_that.activity,_that.nutrition,_that.safety);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileSection profile,  GoalSection goal,  ExperienceSection experience,  AvailabilitySection availability,  ActivitySection activity,  NutritionSection nutrition,  SafetySection safety)  $default,) {final _that = this;
switch (_that) {
case _AssessmentData():
return $default(_that.profile,_that.goal,_that.experience,_that.availability,_that.activity,_that.nutrition,_that.safety);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileSection profile,  GoalSection goal,  ExperienceSection experience,  AvailabilitySection availability,  ActivitySection activity,  NutritionSection nutrition,  SafetySection safety)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentData() when $default != null:
return $default(_that.profile,_that.goal,_that.experience,_that.availability,_that.activity,_that.nutrition,_that.safety);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssessmentData implements AssessmentData {
  const _AssessmentData({this.profile = const ProfileSection(), this.goal = const GoalSection(), this.experience = const ExperienceSection(), this.availability = const AvailabilitySection(), this.activity = const ActivitySection(), this.nutrition = const NutritionSection(), this.safety = const SafetySection()});
  factory _AssessmentData.fromJson(Map<String, dynamic> json) => _$AssessmentDataFromJson(json);

@override@JsonKey() final  ProfileSection profile;
@override@JsonKey() final  GoalSection goal;
@override@JsonKey() final  ExperienceSection experience;
@override@JsonKey() final  AvailabilitySection availability;
@override@JsonKey() final  ActivitySection activity;
@override@JsonKey() final  NutritionSection nutrition;
@override@JsonKey() final  SafetySection safety;

/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentDataCopyWith<_AssessmentData> get copyWith => __$AssessmentDataCopyWithImpl<_AssessmentData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentData&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.experience, experience) || other.experience == experience)&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.safety, safety) || other.safety == safety));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,profile,goal,experience,availability,activity,nutrition,safety);
}

@override
String toString() {
    return 'AssessmentData(profile: $profile, goal: $goal, experience: $experience, availability: $availability, activity: $activity, nutrition: $nutrition, safety: $safety)';
}


}

/// @nodoc
abstract mixin class _$AssessmentDataCopyWith<$Res> implements $AssessmentDataCopyWith<$Res> {
  factory _$AssessmentDataCopyWith(_AssessmentData value, $Res Function(_AssessmentData) _then) = __$AssessmentDataCopyWithImpl;
@override @useResult
$Res call({
 ProfileSection profile, GoalSection goal, ExperienceSection experience, AvailabilitySection availability, ActivitySection activity, NutritionSection nutrition, SafetySection safety
});


@override $ProfileSectionCopyWith<$Res> get profile;@override $GoalSectionCopyWith<$Res> get goal;@override $ExperienceSectionCopyWith<$Res> get experience;@override $AvailabilitySectionCopyWith<$Res> get availability;@override $ActivitySectionCopyWith<$Res> get activity;@override $NutritionSectionCopyWith<$Res> get nutrition;@override $SafetySectionCopyWith<$Res> get safety;

}
/// @nodoc
class __$AssessmentDataCopyWithImpl<$Res>
    implements _$AssessmentDataCopyWith<$Res> {
  __$AssessmentDataCopyWithImpl(this._self, this._then);

  final _AssessmentData _self;
  final $Res Function(_AssessmentData) _then;

/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? goal = null,Object? experience = null,Object? availability = null,Object? activity = null,Object? nutrition = null,Object? safety = null,}) {
  return _then(_AssessmentData(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileSection,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as GoalSection,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as ExperienceSection,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as AvailabilitySection,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivitySection,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as NutritionSection,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as SafetySection,
  ));
}

/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSectionCopyWith<$Res> get profile {
  
  return $ProfileSectionCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalSectionCopyWith<$Res> get goal {
  
  return $GoalSectionCopyWith<$Res>(_self.goal, (value) {
    return _then(_self.copyWith(goal: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExperienceSectionCopyWith<$Res> get experience {
  
  return $ExperienceSectionCopyWith<$Res>(_self.experience, (value) {
    return _then(_self.copyWith(experience: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilitySectionCopyWith<$Res> get availability {
  
  return $AvailabilitySectionCopyWith<$Res>(_self.availability, (value) {
    return _then(_self.copyWith(availability: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySectionCopyWith<$Res> get activity {
  
  return $ActivitySectionCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionSectionCopyWith<$Res> get nutrition {
  
  return $NutritionSectionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}/// Create a copy of AssessmentData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SafetySectionCopyWith<$Res> get safety {
  
  return $SafetySectionCopyWith<$Res>(_self.safety, (value) {
    return _then(_self.copyWith(safety: value));
  });
}
}

// dart format on
