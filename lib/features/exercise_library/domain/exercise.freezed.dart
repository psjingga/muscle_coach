// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exercise {

 String get id; String get name; List<String> get aliases; List<String> get primaryMuscles; List<String> get secondaryMuscles; String get pattern; List<String> get equipment; String get level; bool get compound; String get repUnit; String get loadType; List<String> get instructions; List<String> get mistakes; List<String> get safety; bool get needsSpotter; List<String> get alternatives; String? get videoUrl;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Exercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&const DeepCollectionEquality().equals(other.primaryMuscles, _this.primaryMuscles)&&const DeepCollectionEquality().equals(other.secondaryMuscles, _this.secondaryMuscles)&&(identical(other.pattern, _this.pattern) || other.pattern == _this.pattern)&&const DeepCollectionEquality().equals(other.equipment, _this.equipment)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.compound, _this.compound) || other.compound == _this.compound)&&(identical(other.repUnit, _this.repUnit) || other.repUnit == _this.repUnit)&&(identical(other.loadType, _this.loadType) || other.loadType == _this.loadType)&&const DeepCollectionEquality().equals(other.instructions, _this.instructions)&&const DeepCollectionEquality().equals(other.mistakes, _this.mistakes)&&const DeepCollectionEquality().equals(other.safety, _this.safety)&&(identical(other.needsSpotter, _this.needsSpotter) || other.needsSpotter == _this.needsSpotter)&&const DeepCollectionEquality().equals(other.alternatives, _this.alternatives)&&(identical(other.videoUrl, _this.videoUrl) || other.videoUrl == _this.videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Exercise;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.aliases),const DeepCollectionEquality().hash(_this.primaryMuscles),const DeepCollectionEquality().hash(_this.secondaryMuscles),_this.pattern,const DeepCollectionEquality().hash(_this.equipment),_this.level,_this.compound,_this.repUnit,_this.loadType,const DeepCollectionEquality().hash(_this.instructions),const DeepCollectionEquality().hash(_this.mistakes),const DeepCollectionEquality().hash(_this.safety),_this.needsSpotter,const DeepCollectionEquality().hash(_this.alternatives),_this.videoUrl);
}

@override
String toString() {
  final _this = this as Exercise;
  return 'Exercise(id: ${_this.id}, name: ${_this.name}, aliases: ${_this.aliases}, primaryMuscles: ${_this.primaryMuscles}, secondaryMuscles: ${_this.secondaryMuscles}, pattern: ${_this.pattern}, equipment: ${_this.equipment}, level: ${_this.level}, compound: ${_this.compound}, repUnit: ${_this.repUnit}, loadType: ${_this.loadType}, instructions: ${_this.instructions}, mistakes: ${_this.mistakes}, safety: ${_this.safety}, needsSpotter: ${_this.needsSpotter}, alternatives: ${_this.alternatives}, videoUrl: ${_this.videoUrl})';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> aliases, List<String> primaryMuscles, List<String> secondaryMuscles, String pattern, List<String> equipment, String level, bool compound, String repUnit, String loadType, List<String> instructions, List<String> mistakes, List<String> safety, bool needsSpotter, List<String> alternatives, String? videoUrl
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? aliases = null,Object? primaryMuscles = null,Object? secondaryMuscles = null,Object? pattern = null,Object? equipment = null,Object? level = null,Object? compound = null,Object? repUnit = null,Object? loadType = null,Object? instructions = null,Object? mistakes = null,Object? safety = null,Object? needsSpotter = null,Object? alternatives = null,Object? videoUrl = freezed,}) {
  return _then(Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,primaryMuscles: null == primaryMuscles ? _self.primaryMuscles : primaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryMuscles: null == secondaryMuscles ? _self.secondaryMuscles : secondaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as List<String>,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,compound: null == compound ? _self.compound : compound // ignore: cast_nullable_to_non_nullable
as bool,repUnit: null == repUnit ? _self.repUnit : repUnit // ignore: cast_nullable_to_non_nullable
as String,loadType: null == loadType ? _self.loadType : loadType // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as List<String>,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as List<String>,needsSpotter: null == needsSpotter ? _self.needsSpotter : needsSpotter // ignore: cast_nullable_to_non_nullable
as bool,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> aliases,  List<String> primaryMuscles,  List<String> secondaryMuscles,  String pattern,  List<String> equipment,  String level,  bool compound,  String repUnit,  String loadType,  List<String> instructions,  List<String> mistakes,  List<String> safety,  bool needsSpotter,  List<String> alternatives,  String? videoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.name,_that.aliases,_that.primaryMuscles,_that.secondaryMuscles,_that.pattern,_that.equipment,_that.level,_that.compound,_that.repUnit,_that.loadType,_that.instructions,_that.mistakes,_that.safety,_that.needsSpotter,_that.alternatives,_that.videoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> aliases,  List<String> primaryMuscles,  List<String> secondaryMuscles,  String pattern,  List<String> equipment,  String level,  bool compound,  String repUnit,  String loadType,  List<String> instructions,  List<String> mistakes,  List<String> safety,  bool needsSpotter,  List<String> alternatives,  String? videoUrl)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.name,_that.aliases,_that.primaryMuscles,_that.secondaryMuscles,_that.pattern,_that.equipment,_that.level,_that.compound,_that.repUnit,_that.loadType,_that.instructions,_that.mistakes,_that.safety,_that.needsSpotter,_that.alternatives,_that.videoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> aliases,  List<String> primaryMuscles,  List<String> secondaryMuscles,  String pattern,  List<String> equipment,  String level,  bool compound,  String repUnit,  String loadType,  List<String> instructions,  List<String> mistakes,  List<String> safety,  bool needsSpotter,  List<String> alternatives,  String? videoUrl)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.name,_that.aliases,_that.primaryMuscles,_that.secondaryMuscles,_that.pattern,_that.equipment,_that.level,_that.compound,_that.repUnit,_that.loadType,_that.instructions,_that.mistakes,_that.safety,_that.needsSpotter,_that.alternatives,_that.videoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise implements Exercise {
  const _Exercise({required this.id, required this.name,  List<String> aliases = const <String>[],  List<String> primaryMuscles = const <String>[],  List<String> secondaryMuscles = const <String>[], required this.pattern,  List<String> equipment = const <String>[], required this.level, this.compound = false, this.repUnit = 'reps', this.loadType = 'total',  List<String> instructions = const <String>[],  List<String> mistakes = const <String>[],  List<String> safety = const <String>[], this.needsSpotter = false,  List<String> alternatives = const <String>[], this.videoUrl}): _aliases = aliases,_primaryMuscles = primaryMuscles,_secondaryMuscles = secondaryMuscles,_equipment = equipment,_instructions = instructions,_mistakes = mistakes,_safety = safety,_alternatives = alternatives;
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _aliases;
@override@JsonKey() List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

 final  List<String> _primaryMuscles;
@override@JsonKey() List<String> get primaryMuscles {
  if (_primaryMuscles is EqualUnmodifiableListView) return _primaryMuscles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_primaryMuscles);
}

 final  List<String> _secondaryMuscles;
@override@JsonKey() List<String> get secondaryMuscles {
  if (_secondaryMuscles is EqualUnmodifiableListView) return _secondaryMuscles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondaryMuscles);
}

@override final  String pattern;
 final  List<String> _equipment;
@override@JsonKey() List<String> get equipment {
  if (_equipment is EqualUnmodifiableListView) return _equipment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equipment);
}

@override final  String level;
@override@JsonKey() final  bool compound;
@override@JsonKey() final  String repUnit;
@override@JsonKey() final  String loadType;
 final  List<String> _instructions;
@override@JsonKey() List<String> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

 final  List<String> _mistakes;
@override@JsonKey() List<String> get mistakes {
  if (_mistakes is EqualUnmodifiableListView) return _mistakes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mistakes);
}

 final  List<String> _safety;
@override@JsonKey() List<String> get safety {
  if (_safety is EqualUnmodifiableListView) return _safety;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_safety);
}

@override@JsonKey() final  bool needsSpotter;
 final  List<String> _alternatives;
@override@JsonKey() List<String> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}

@override final  String? videoUrl;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&const DeepCollectionEquality().equals(other.primaryMuscles, _primaryMuscles)&&const DeepCollectionEquality().equals(other.secondaryMuscles, _secondaryMuscles)&&(identical(other.pattern, pattern) || other.pattern == pattern)&&const DeepCollectionEquality().equals(other.equipment, _equipment)&&(identical(other.level, level) || other.level == level)&&(identical(other.compound, compound) || other.compound == compound)&&(identical(other.repUnit, repUnit) || other.repUnit == repUnit)&&(identical(other.loadType, loadType) || other.loadType == loadType)&&const DeepCollectionEquality().equals(other.instructions, _instructions)&&const DeepCollectionEquality().equals(other.mistakes, _mistakes)&&const DeepCollectionEquality().equals(other.safety, _safety)&&(identical(other.needsSpotter, needsSpotter) || other.needsSpotter == needsSpotter)&&const DeepCollectionEquality().equals(other.alternatives, _alternatives)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_aliases),const DeepCollectionEquality().hash(_primaryMuscles),const DeepCollectionEquality().hash(_secondaryMuscles),pattern,const DeepCollectionEquality().hash(_equipment),level,compound,repUnit,loadType,const DeepCollectionEquality().hash(_instructions),const DeepCollectionEquality().hash(_mistakes),const DeepCollectionEquality().hash(_safety),needsSpotter,const DeepCollectionEquality().hash(_alternatives),videoUrl);
}

@override
String toString() {
    return 'Exercise(id: $id, name: $name, aliases: $aliases, primaryMuscles: $primaryMuscles, secondaryMuscles: $secondaryMuscles, pattern: $pattern, equipment: $equipment, level: $level, compound: $compound, repUnit: $repUnit, loadType: $loadType, instructions: $instructions, mistakes: $mistakes, safety: $safety, needsSpotter: $needsSpotter, alternatives: $alternatives, videoUrl: $videoUrl)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> aliases, List<String> primaryMuscles, List<String> secondaryMuscles, String pattern, List<String> equipment, String level, bool compound, String repUnit, String loadType, List<String> instructions, List<String> mistakes, List<String> safety, bool needsSpotter, List<String> alternatives, String? videoUrl
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? aliases = null,Object? primaryMuscles = null,Object? secondaryMuscles = null,Object? pattern = null,Object? equipment = null,Object? level = null,Object? compound = null,Object? repUnit = null,Object? loadType = null,Object? instructions = null,Object? mistakes = null,Object? safety = null,Object? needsSpotter = null,Object? alternatives = null,Object? videoUrl = freezed,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,primaryMuscles: null == primaryMuscles ? _self._primaryMuscles : primaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryMuscles: null == secondaryMuscles ? _self._secondaryMuscles : secondaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,equipment: null == equipment ? _self._equipment : equipment // ignore: cast_nullable_to_non_nullable
as List<String>,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,compound: null == compound ? _self.compound : compound // ignore: cast_nullable_to_non_nullable
as bool,repUnit: null == repUnit ? _self.repUnit : repUnit // ignore: cast_nullable_to_non_nullable
as String,loadType: null == loadType ? _self.loadType : loadType // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,mistakes: null == mistakes ? _self._mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as List<String>,safety: null == safety ? _self._safety : safety // ignore: cast_nullable_to_non_nullable
as List<String>,needsSpotter: null == needsSpotter ? _self.needsSpotter : needsSpotter // ignore: cast_nullable_to_non_nullable
as bool,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
