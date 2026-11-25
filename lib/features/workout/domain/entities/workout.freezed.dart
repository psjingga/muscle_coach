// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlannedExercise {

 String get exerciseId; String get name; int get sets; int get repMin; int get repMax; String get repUnit; String get loadType; int get restSec; int get rirMin; int get rirMax; bool get priority;/// Alasan singkat dari AI (null untuk program template).
 String? get rationale;
/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedExerciseCopyWith<PlannedExercise> get copyWith => _$PlannedExerciseCopyWithImpl<PlannedExercise>(this as PlannedExercise, _$identity);

  /// Serializes this PlannedExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlannedExercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedExercise&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sets, _this.sets) || other.sets == _this.sets)&&(identical(other.repMin, _this.repMin) || other.repMin == _this.repMin)&&(identical(other.repMax, _this.repMax) || other.repMax == _this.repMax)&&(identical(other.repUnit, _this.repUnit) || other.repUnit == _this.repUnit)&&(identical(other.loadType, _this.loadType) || other.loadType == _this.loadType)&&(identical(other.restSec, _this.restSec) || other.restSec == _this.restSec)&&(identical(other.rirMin, _this.rirMin) || other.rirMin == _this.rirMin)&&(identical(other.rirMax, _this.rirMax) || other.rirMax == _this.rirMax)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.rationale, _this.rationale) || other.rationale == _this.rationale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlannedExercise;
  return Object.hash(runtimeType,_this.exerciseId,_this.name,_this.sets,_this.repMin,_this.repMax,_this.repUnit,_this.loadType,_this.restSec,_this.rirMin,_this.rirMax,_this.priority,_this.rationale);
}

@override
String toString() {
  final _this = this as PlannedExercise;
  return 'PlannedExercise(exerciseId: ${_this.exerciseId}, name: ${_this.name}, sets: ${_this.sets}, repMin: ${_this.repMin}, repMax: ${_this.repMax}, repUnit: ${_this.repUnit}, loadType: ${_this.loadType}, restSec: ${_this.restSec}, rirMin: ${_this.rirMin}, rirMax: ${_this.rirMax}, priority: ${_this.priority}, rationale: ${_this.rationale})';
}


}

/// @nodoc
abstract mixin class $PlannedExerciseCopyWith<$Res>  {
  factory $PlannedExerciseCopyWith(PlannedExercise value, $Res Function(PlannedExercise) _then) = _$PlannedExerciseCopyWithImpl;
@useResult
$Res call({
 String exerciseId, String name, int sets, int repMin, int repMax, String repUnit, String loadType, int restSec, int rirMin, int rirMax, bool priority, String? rationale
});




}
/// @nodoc
class _$PlannedExerciseCopyWithImpl<$Res>
    implements $PlannedExerciseCopyWith<$Res> {
  _$PlannedExerciseCopyWithImpl(this._self, this._then);

  final PlannedExercise _self;
  final $Res Function(PlannedExercise) _then;

/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? name = null,Object? sets = null,Object? repMin = null,Object? repMax = null,Object? repUnit = null,Object? loadType = null,Object? restSec = null,Object? rirMin = null,Object? rirMax = null,Object? priority = null,Object? rationale = freezed,}) {
  return _then(PlannedExercise(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int,repMin: null == repMin ? _self.repMin : repMin // ignore: cast_nullable_to_non_nullable
as int,repMax: null == repMax ? _self.repMax : repMax // ignore: cast_nullable_to_non_nullable
as int,repUnit: null == repUnit ? _self.repUnit : repUnit // ignore: cast_nullable_to_non_nullable
as String,loadType: null == loadType ? _self.loadType : loadType // ignore: cast_nullable_to_non_nullable
as String,restSec: null == restSec ? _self.restSec : restSec // ignore: cast_nullable_to_non_nullable
as int,rirMin: null == rirMin ? _self.rirMin : rirMin // ignore: cast_nullable_to_non_nullable
as int,rirMax: null == rirMax ? _self.rirMax : rirMax // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as bool,rationale: freezed == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedExercise].
extension PlannedExercisePatterns on PlannedExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedExercise value)  $default,){
final _that = this;
switch (_that) {
case _PlannedExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedExercise value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseId,  String name,  int sets,  int repMin,  int repMax,  String repUnit,  String loadType,  int restSec,  int rirMin,  int rirMax,  bool priority,  String? rationale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
return $default(_that.exerciseId,_that.name,_that.sets,_that.repMin,_that.repMax,_that.repUnit,_that.loadType,_that.restSec,_that.rirMin,_that.rirMax,_that.priority,_that.rationale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseId,  String name,  int sets,  int repMin,  int repMax,  String repUnit,  String loadType,  int restSec,  int rirMin,  int rirMax,  bool priority,  String? rationale)  $default,) {final _that = this;
switch (_that) {
case _PlannedExercise():
return $default(_that.exerciseId,_that.name,_that.sets,_that.repMin,_that.repMax,_that.repUnit,_that.loadType,_that.restSec,_that.rirMin,_that.rirMax,_that.priority,_that.rationale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseId,  String name,  int sets,  int repMin,  int repMax,  String repUnit,  String loadType,  int restSec,  int rirMin,  int rirMax,  bool priority,  String? rationale)?  $default,) {final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
return $default(_that.exerciseId,_that.name,_that.sets,_that.repMin,_that.repMax,_that.repUnit,_that.loadType,_that.restSec,_that.rirMin,_that.rirMax,_that.priority,_that.rationale);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlannedExercise extends PlannedExercise {
  const _PlannedExercise({required this.exerciseId, required this.name, required this.sets, required this.repMin, required this.repMax, this.repUnit = 'reps', this.loadType = 'total', required this.restSec, required this.rirMin, required this.rirMax, this.priority = false, this.rationale}): super._();
  factory _PlannedExercise.fromJson(Map<String, dynamic> json) => _$PlannedExerciseFromJson(json);

@override final  String exerciseId;
@override final  String name;
@override final  int sets;
@override final  int repMin;
@override final  int repMax;
@override@JsonKey() final  String repUnit;
@override@JsonKey() final  String loadType;
@override final  int restSec;
@override final  int rirMin;
@override final  int rirMax;
@override@JsonKey() final  bool priority;
/// Alasan singkat dari AI (null untuk program template).
@override final  String? rationale;

/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedExerciseCopyWith<_PlannedExercise> get copyWith => __$PlannedExerciseCopyWithImpl<_PlannedExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlannedExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedExercise&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sets, sets) || other.sets == sets)&&(identical(other.repMin, repMin) || other.repMin == repMin)&&(identical(other.repMax, repMax) || other.repMax == repMax)&&(identical(other.repUnit, repUnit) || other.repUnit == repUnit)&&(identical(other.loadType, loadType) || other.loadType == loadType)&&(identical(other.restSec, restSec) || other.restSec == restSec)&&(identical(other.rirMin, rirMin) || other.rirMin == rirMin)&&(identical(other.rirMax, rirMax) || other.rirMax == rirMax)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.rationale, rationale) || other.rationale == rationale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,exerciseId,name,sets,repMin,repMax,repUnit,loadType,restSec,rirMin,rirMax,priority,rationale);
}

@override
String toString() {
    return 'PlannedExercise(exerciseId: $exerciseId, name: $name, sets: $sets, repMin: $repMin, repMax: $repMax, repUnit: $repUnit, loadType: $loadType, restSec: $restSec, rirMin: $rirMin, rirMax: $rirMax, priority: $priority, rationale: $rationale)';
}


}

/// @nodoc
abstract mixin class _$PlannedExerciseCopyWith<$Res> implements $PlannedExerciseCopyWith<$Res> {
  factory _$PlannedExerciseCopyWith(_PlannedExercise value, $Res Function(_PlannedExercise) _then) = __$PlannedExerciseCopyWithImpl;
@override @useResult
$Res call({
 String exerciseId, String name, int sets, int repMin, int repMax, String repUnit, String loadType, int restSec, int rirMin, int rirMax, bool priority, String? rationale
});




}
/// @nodoc
class __$PlannedExerciseCopyWithImpl<$Res>
    implements _$PlannedExerciseCopyWith<$Res> {
  __$PlannedExerciseCopyWithImpl(this._self, this._then);

  final _PlannedExercise _self;
  final $Res Function(_PlannedExercise) _then;

/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? name = null,Object? sets = null,Object? repMin = null,Object? repMax = null,Object? repUnit = null,Object? loadType = null,Object? restSec = null,Object? rirMin = null,Object? rirMax = null,Object? priority = null,Object? rationale = freezed,}) {
  return _then(_PlannedExercise(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int,repMin: null == repMin ? _self.repMin : repMin // ignore: cast_nullable_to_non_nullable
as int,repMax: null == repMax ? _self.repMax : repMax // ignore: cast_nullable_to_non_nullable
as int,repUnit: null == repUnit ? _self.repUnit : repUnit // ignore: cast_nullable_to_non_nullable
as String,loadType: null == loadType ? _self.loadType : loadType // ignore: cast_nullable_to_non_nullable
as String,restSec: null == restSec ? _self.restSec : restSec // ignore: cast_nullable_to_non_nullable
as int,rirMin: null == rirMin ? _self.rirMin : rirMin // ignore: cast_nullable_to_non_nullable
as int,rirMax: null == rirMax ? _self.rirMax : rirMax // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as bool,rationale: freezed == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PlanDay {

 String get id; int get order;/// ISO 1 = Senin … 7 = Minggu.
 int get weekday; String get focus; int get warmupMinutes; int get estimatedMinutes; List<PlannedExercise> get exercises;
/// Create a copy of PlanDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanDayCopyWith<PlanDay> get copyWith => _$PlanDayCopyWithImpl<PlanDay>(this as PlanDay, _$identity);

  /// Serializes this PlanDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlanDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanDay&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.focus, _this.focus) || other.focus == _this.focus)&&(identical(other.warmupMinutes, _this.warmupMinutes) || other.warmupMinutes == _this.warmupMinutes)&&(identical(other.estimatedMinutes, _this.estimatedMinutes) || other.estimatedMinutes == _this.estimatedMinutes)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlanDay;
  return Object.hash(runtimeType,_this.id,_this.order,_this.weekday,_this.focus,_this.warmupMinutes,_this.estimatedMinutes,const DeepCollectionEquality().hash(_this.exercises));
}

@override
String toString() {
  final _this = this as PlanDay;
  return 'PlanDay(id: ${_this.id}, order: ${_this.order}, weekday: ${_this.weekday}, focus: ${_this.focus}, warmupMinutes: ${_this.warmupMinutes}, estimatedMinutes: ${_this.estimatedMinutes}, exercises: ${_this.exercises})';
}


}

/// @nodoc
abstract mixin class $PlanDayCopyWith<$Res>  {
  factory $PlanDayCopyWith(PlanDay value, $Res Function(PlanDay) _then) = _$PlanDayCopyWithImpl;
@useResult
$Res call({
 String id, int order, int weekday, String focus, int warmupMinutes, int estimatedMinutes, List<PlannedExercise> exercises
});




}
/// @nodoc
class _$PlanDayCopyWithImpl<$Res>
    implements $PlanDayCopyWith<$Res> {
  _$PlanDayCopyWithImpl(this._self, this._then);

  final PlanDay _self;
  final $Res Function(PlanDay) _then;

/// Create a copy of PlanDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? order = null,Object? weekday = null,Object? focus = null,Object? warmupMinutes = null,Object? estimatedMinutes = null,Object? exercises = null,}) {
  return _then(PlanDay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,warmupMinutes: null == warmupMinutes ? _self.warmupMinutes : warmupMinutes // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<PlannedExercise>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanDay].
extension PlanDayPatterns on PlanDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanDay value)  $default,){
final _that = this;
switch (_that) {
case _PlanDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanDay value)?  $default,){
final _that = this;
switch (_that) {
case _PlanDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int order,  int weekday,  String focus,  int warmupMinutes,  int estimatedMinutes,  List<PlannedExercise> exercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanDay() when $default != null:
return $default(_that.id,_that.order,_that.weekday,_that.focus,_that.warmupMinutes,_that.estimatedMinutes,_that.exercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int order,  int weekday,  String focus,  int warmupMinutes,  int estimatedMinutes,  List<PlannedExercise> exercises)  $default,) {final _that = this;
switch (_that) {
case _PlanDay():
return $default(_that.id,_that.order,_that.weekday,_that.focus,_that.warmupMinutes,_that.estimatedMinutes,_that.exercises);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int order,  int weekday,  String focus,  int warmupMinutes,  int estimatedMinutes,  List<PlannedExercise> exercises)?  $default,) {final _that = this;
switch (_that) {
case _PlanDay() when $default != null:
return $default(_that.id,_that.order,_that.weekday,_that.focus,_that.warmupMinutes,_that.estimatedMinutes,_that.exercises);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanDay implements PlanDay {
  const _PlanDay({required this.id, required this.order, required this.weekday, required this.focus, required this.warmupMinutes, required this.estimatedMinutes, required  List<PlannedExercise> exercises}): _exercises = exercises;
  factory _PlanDay.fromJson(Map<String, dynamic> json) => _$PlanDayFromJson(json);

@override final  String id;
@override final  int order;
/// ISO 1 = Senin … 7 = Minggu.
@override final  int weekday;
@override final  String focus;
@override final  int warmupMinutes;
@override final  int estimatedMinutes;
 final  List<PlannedExercise> _exercises;
@override List<PlannedExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}


/// Create a copy of PlanDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanDayCopyWith<_PlanDay> get copyWith => __$PlanDayCopyWithImpl<_PlanDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanDay&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.warmupMinutes, warmupMinutes) || other.warmupMinutes == warmupMinutes)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.exercises, _exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,order,weekday,focus,warmupMinutes,estimatedMinutes,const DeepCollectionEquality().hash(_exercises));
}

@override
String toString() {
    return 'PlanDay(id: $id, order: $order, weekday: $weekday, focus: $focus, warmupMinutes: $warmupMinutes, estimatedMinutes: $estimatedMinutes, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class _$PlanDayCopyWith<$Res> implements $PlanDayCopyWith<$Res> {
  factory _$PlanDayCopyWith(_PlanDay value, $Res Function(_PlanDay) _then) = __$PlanDayCopyWithImpl;
@override @useResult
$Res call({
 String id, int order, int weekday, String focus, int warmupMinutes, int estimatedMinutes, List<PlannedExercise> exercises
});




}
/// @nodoc
class __$PlanDayCopyWithImpl<$Res>
    implements _$PlanDayCopyWith<$Res> {
  __$PlanDayCopyWithImpl(this._self, this._then);

  final _PlanDay _self;
  final $Res Function(_PlanDay) _then;

/// Create a copy of PlanDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? order = null,Object? weekday = null,Object? focus = null,Object? warmupMinutes = null,Object? estimatedMinutes = null,Object? exercises = null,}) {
  return _then(_PlanDay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,warmupMinutes: null == warmupMinutes ? _self.warmupMinutes : warmupMinutes // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<PlannedExercise>,
  ));
}


}


/// @nodoc
mixin _$WorkoutPlan {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; PlanStatus get status; String get source; String get split; String get level; int get daysPerWeek; int get sessionMinutes; List<String> get warnings;/// Ringkasan alasan dari AI & model penyusun (null untuk template).
 String? get rationale; String? get model;
/// Create a copy of WorkoutPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutPlanCopyWith<WorkoutPlan> get copyWith => _$WorkoutPlanCopyWithImpl<WorkoutPlan>(this as WorkoutPlan, _$identity);

  /// Serializes this WorkoutPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutPlan&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.split, _this.split) || other.split == _this.split)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.daysPerWeek, _this.daysPerWeek) || other.daysPerWeek == _this.daysPerWeek)&&(identical(other.sessionMinutes, _this.sessionMinutes) || other.sessionMinutes == _this.sessionMinutes)&&const DeepCollectionEquality().equals(other.warnings, _this.warnings)&&(identical(other.rationale, _this.rationale) || other.rationale == _this.rationale)&&(identical(other.model, _this.model) || other.model == _this.model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutPlan;
  return Object.hash(runtimeType,_this.id,_this.status,_this.source,_this.split,_this.level,_this.daysPerWeek,_this.sessionMinutes,const DeepCollectionEquality().hash(_this.warnings),_this.rationale,_this.model);
}

@override
String toString() {
  final _this = this as WorkoutPlan;
  return 'WorkoutPlan(id: ${_this.id}, status: ${_this.status}, source: ${_this.source}, split: ${_this.split}, level: ${_this.level}, daysPerWeek: ${_this.daysPerWeek}, sessionMinutes: ${_this.sessionMinutes}, warnings: ${_this.warnings}, rationale: ${_this.rationale}, model: ${_this.model})';
}


}

/// @nodoc
abstract mixin class $WorkoutPlanCopyWith<$Res>  {
  factory $WorkoutPlanCopyWith(WorkoutPlan value, $Res Function(WorkoutPlan) _then) = _$WorkoutPlanCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, PlanStatus status, String source, String split, String level, int daysPerWeek, int sessionMinutes, List<String> warnings, String? rationale, String? model
});




}
/// @nodoc
class _$WorkoutPlanCopyWithImpl<$Res>
    implements $WorkoutPlanCopyWith<$Res> {
  _$WorkoutPlanCopyWithImpl(this._self, this._then);

  final WorkoutPlan _self;
  final $Res Function(WorkoutPlan) _then;

/// Create a copy of WorkoutPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? source = null,Object? split = null,Object? level = null,Object? daysPerWeek = null,Object? sessionMinutes = null,Object? warnings = null,Object? rationale = freezed,Object? model = freezed,}) {
  return _then(WorkoutPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,split: null == split ? _self.split : split // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,sessionMinutes: null == sessionMinutes ? _self.sessionMinutes : sessionMinutes // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,rationale: freezed == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutPlan].
extension WorkoutPlanPatterns on WorkoutPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutPlan value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutPlan value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  PlanStatus status,  String source,  String split,  String level,  int daysPerWeek,  int sessionMinutes,  List<String> warnings,  String? rationale,  String? model)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutPlan() when $default != null:
return $default(_that.id,_that.status,_that.source,_that.split,_that.level,_that.daysPerWeek,_that.sessionMinutes,_that.warnings,_that.rationale,_that.model);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  PlanStatus status,  String source,  String split,  String level,  int daysPerWeek,  int sessionMinutes,  List<String> warnings,  String? rationale,  String? model)  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlan():
return $default(_that.id,_that.status,_that.source,_that.split,_that.level,_that.daysPerWeek,_that.sessionMinutes,_that.warnings,_that.rationale,_that.model);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  PlanStatus status,  String source,  String split,  String level,  int daysPerWeek,  int sessionMinutes,  List<String> warnings,  String? rationale,  String? model)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlan() when $default != null:
return $default(_that.id,_that.status,_that.source,_that.split,_that.level,_that.daysPerWeek,_that.sessionMinutes,_that.warnings,_that.rationale,_that.model);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutPlan extends WorkoutPlan {
  const _WorkoutPlan({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', required this.status, this.source = 'template', required this.split, required this.level, required this.daysPerWeek, required this.sessionMinutes,  List<String> warnings = const <String>[], this.rationale, this.model}): _warnings = warnings,super._();
  factory _WorkoutPlan.fromJson(Map<String, dynamic> json) => _$WorkoutPlanFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override final  PlanStatus status;
@override@JsonKey() final  String source;
@override final  String split;
@override final  String level;
@override final  int daysPerWeek;
@override final  int sessionMinutes;
 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

/// Ringkasan alasan dari AI & model penyusun (null untuk template).
@override final  String? rationale;
@override final  String? model;

/// Create a copy of WorkoutPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutPlanCopyWith<_WorkoutPlan> get copyWith => __$WorkoutPlanCopyWithImpl<_WorkoutPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutPlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.split, split) || other.split == split)&&(identical(other.level, level) || other.level == level)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.sessionMinutes, sessionMinutes) || other.sessionMinutes == sessionMinutes)&&const DeepCollectionEquality().equals(other.warnings, _warnings)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&(identical(other.model, model) || other.model == model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,source,split,level,daysPerWeek,sessionMinutes,const DeepCollectionEquality().hash(_warnings),rationale,model);
}

@override
String toString() {
    return 'WorkoutPlan(id: $id, status: $status, source: $source, split: $split, level: $level, daysPerWeek: $daysPerWeek, sessionMinutes: $sessionMinutes, warnings: $warnings, rationale: $rationale, model: $model)';
}


}

/// @nodoc
abstract mixin class _$WorkoutPlanCopyWith<$Res> implements $WorkoutPlanCopyWith<$Res> {
  factory _$WorkoutPlanCopyWith(_WorkoutPlan value, $Res Function(_WorkoutPlan) _then) = __$WorkoutPlanCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, PlanStatus status, String source, String split, String level, int daysPerWeek, int sessionMinutes, List<String> warnings, String? rationale, String? model
});




}
/// @nodoc
class __$WorkoutPlanCopyWithImpl<$Res>
    implements _$WorkoutPlanCopyWith<$Res> {
  __$WorkoutPlanCopyWithImpl(this._self, this._then);

  final _WorkoutPlan _self;
  final $Res Function(_WorkoutPlan) _then;

/// Create a copy of WorkoutPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? source = null,Object? split = null,Object? level = null,Object? daysPerWeek = null,Object? sessionMinutes = null,Object? warnings = null,Object? rationale = freezed,Object? model = freezed,}) {
  return _then(_WorkoutPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,split: null == split ? _self.split : split // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,sessionMinutes: null == sessionMinutes ? _self.sessionMinutes : sessionMinutes // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,rationale: freezed == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WorkoutSession {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get planId; String get dayId;/// Tanggal lokal pengguna `YYYY-MM-DD`.
 String get date; int get weekday; String get focus; SessionStatus get status; List<PlannedExercise> get planned; String? get notes; int? get energy; String? get discomfort;/// Waktu mulai (untuk durasi sesi berjalan).
@JsonKey(includeFromJson: false, includeToJson: false) DateTime? get startedAt;/// Waktu sesi ditandai selesai (untuk durasi).
@JsonKey(includeFromJson: false, includeToJson: false) DateTime? get completedAt;
/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSessionCopyWith<WorkoutSession> get copyWith => _$WorkoutSessionCopyWithImpl<WorkoutSession>(this as WorkoutSession, _$identity);

  /// Serializes this WorkoutSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.planId, _this.planId) || other.planId == _this.planId)&&(identical(other.dayId, _this.dayId) || other.dayId == _this.dayId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.focus, _this.focus) || other.focus == _this.focus)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.planned, _this.planned)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.energy, _this.energy) || other.energy == _this.energy)&&(identical(other.discomfort, _this.discomfort) || other.discomfort == _this.discomfort)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutSession;
  return Object.hash(runtimeType,_this.id,_this.planId,_this.dayId,_this.date,_this.weekday,_this.focus,_this.status,const DeepCollectionEquality().hash(_this.planned),_this.notes,_this.energy,_this.discomfort,_this.startedAt,_this.completedAt);
}

@override
String toString() {
  final _this = this as WorkoutSession;
  return 'WorkoutSession(id: ${_this.id}, planId: ${_this.planId}, dayId: ${_this.dayId}, date: ${_this.date}, weekday: ${_this.weekday}, focus: ${_this.focus}, status: ${_this.status}, planned: ${_this.planned}, notes: ${_this.notes}, energy: ${_this.energy}, discomfort: ${_this.discomfort}, startedAt: ${_this.startedAt}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $WorkoutSessionCopyWith<$Res>  {
  factory $WorkoutSessionCopyWith(WorkoutSession value, $Res Function(WorkoutSession) _then) = _$WorkoutSessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String planId, String dayId, String date, int weekday, String focus, SessionStatus status, List<PlannedExercise> planned, String? notes, int? energy, String? discomfort,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? startedAt,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? completedAt
});




}
/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._self, this._then);

  final WorkoutSession _self;
  final $Res Function(WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? planId = null,Object? dayId = null,Object? date = null,Object? weekday = null,Object? focus = null,Object? status = null,Object? planned = null,Object? notes = freezed,Object? energy = freezed,Object? discomfort = freezed,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(WorkoutSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as List<PlannedExercise>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int?,discomfort: freezed == discomfort ? _self.discomfort : discomfort // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSession].
extension WorkoutSessionPatterns on WorkoutSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSession value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSession value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String planId,  String dayId,  String date,  int weekday,  String focus,  SessionStatus status,  List<PlannedExercise> planned,  String? notes,  int? energy,  String? discomfort, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? startedAt, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.id,_that.planId,_that.dayId,_that.date,_that.weekday,_that.focus,_that.status,_that.planned,_that.notes,_that.energy,_that.discomfort,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String planId,  String dayId,  String date,  int weekday,  String focus,  SessionStatus status,  List<PlannedExercise> planned,  String? notes,  int? energy,  String? discomfort, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? startedAt, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession():
return $default(_that.id,_that.planId,_that.dayId,_that.date,_that.weekday,_that.focus,_that.status,_that.planned,_that.notes,_that.energy,_that.discomfort,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String planId,  String dayId,  String date,  int weekday,  String focus,  SessionStatus status,  List<PlannedExercise> planned,  String? notes,  int? energy,  String? discomfort, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? startedAt, @JsonKey(includeFromJson: false, includeToJson: false)  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.id,_that.planId,_that.dayId,_that.date,_that.weekday,_that.focus,_that.status,_that.planned,_that.notes,_that.energy,_that.discomfort,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutSession implements WorkoutSession {
  const _WorkoutSession({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', required this.planId, required this.dayId, required this.date, required this.weekday, required this.focus, required this.status, required  List<PlannedExercise> planned, this.notes, this.energy, this.discomfort, @JsonKey(includeFromJson: false, includeToJson: false) this.startedAt, @JsonKey(includeFromJson: false, includeToJson: false) this.completedAt}): _planned = planned;
  factory _WorkoutSession.fromJson(Map<String, dynamic> json) => _$WorkoutSessionFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override final  String planId;
@override final  String dayId;
/// Tanggal lokal pengguna `YYYY-MM-DD`.
@override final  String date;
@override final  int weekday;
@override final  String focus;
@override final  SessionStatus status;
 final  List<PlannedExercise> _planned;
@override List<PlannedExercise> get planned {
  if (_planned is EqualUnmodifiableListView) return _planned;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_planned);
}

@override final  String? notes;
@override final  int? energy;
@override final  String? discomfort;
/// Waktu mulai (untuk durasi sesi berjalan).
@override@JsonKey(includeFromJson: false, includeToJson: false) final  DateTime? startedAt;
/// Waktu sesi ditandai selesai (untuk durasi).
@override@JsonKey(includeFromJson: false, includeToJson: false) final  DateTime? completedAt;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSessionCopyWith<_WorkoutSession> get copyWith => __$WorkoutSessionCopyWithImpl<_WorkoutSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutSession&&(identical(other.id, id) || other.id == id)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.date, date) || other.date == date)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.planned, _planned)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.discomfort, discomfort) || other.discomfort == discomfort)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,planId,dayId,date,weekday,focus,status,const DeepCollectionEquality().hash(_planned),notes,energy,discomfort,startedAt,completedAt);
}

@override
String toString() {
    return 'WorkoutSession(id: $id, planId: $planId, dayId: $dayId, date: $date, weekday: $weekday, focus: $focus, status: $status, planned: $planned, notes: $notes, energy: $energy, discomfort: $discomfort, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSessionCopyWith<$Res> implements $WorkoutSessionCopyWith<$Res> {
  factory _$WorkoutSessionCopyWith(_WorkoutSession value, $Res Function(_WorkoutSession) _then) = __$WorkoutSessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String planId, String dayId, String date, int weekday, String focus, SessionStatus status, List<PlannedExercise> planned, String? notes, int? energy, String? discomfort,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? startedAt,@JsonKey(includeFromJson: false, includeToJson: false) DateTime? completedAt
});




}
/// @nodoc
class __$WorkoutSessionCopyWithImpl<$Res>
    implements _$WorkoutSessionCopyWith<$Res> {
  __$WorkoutSessionCopyWithImpl(this._self, this._then);

  final _WorkoutSession _self;
  final $Res Function(_WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? planId = null,Object? dayId = null,Object? date = null,Object? weekday = null,Object? focus = null,Object? status = null,Object? planned = null,Object? notes = freezed,Object? energy = freezed,Object? discomfort = freezed,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_WorkoutSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,dayId: null == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,planned: null == planned ? _self._planned : planned // ignore: cast_nullable_to_non_nullable
as List<PlannedExercise>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int?,discomfort: freezed == discomfort ? _self.discomfort : discomfort // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SetLog {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get exerciseId; int get exerciseIndex; int get setNumber; double? get weightKg; int get reps; int? get rir; SetStatus get status;
/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetLogCopyWith<SetLog> get copyWith => _$SetLogCopyWithImpl<SetLog>(this as SetLog, _$identity);

  /// Serializes this SetLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.exerciseIndex, _this.exerciseIndex) || other.exerciseIndex == _this.exerciseIndex)&&(identical(other.setNumber, _this.setNumber) || other.setNumber == _this.setNumber)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.reps, _this.reps) || other.reps == _this.reps)&&(identical(other.rir, _this.rir) || other.rir == _this.rir)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetLog;
  return Object.hash(runtimeType,_this.id,_this.exerciseId,_this.exerciseIndex,_this.setNumber,_this.weightKg,_this.reps,_this.rir,_this.status);
}

@override
String toString() {
  final _this = this as SetLog;
  return 'SetLog(id: ${_this.id}, exerciseId: ${_this.exerciseId}, exerciseIndex: ${_this.exerciseIndex}, setNumber: ${_this.setNumber}, weightKg: ${_this.weightKg}, reps: ${_this.reps}, rir: ${_this.rir}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $SetLogCopyWith<$Res>  {
  factory $SetLogCopyWith(SetLog value, $Res Function(SetLog) _then) = _$SetLogCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String exerciseId, int exerciseIndex, int setNumber, double? weightKg, int reps, int? rir, SetStatus status
});




}
/// @nodoc
class _$SetLogCopyWithImpl<$Res>
    implements $SetLogCopyWith<$Res> {
  _$SetLogCopyWithImpl(this._self, this._then);

  final SetLog _self;
  final $Res Function(SetLog) _then;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exerciseId = null,Object? exerciseIndex = null,Object? setNumber = null,Object? weightKg = freezed,Object? reps = null,Object? rir = freezed,Object? status = null,}) {
  return _then(SetLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,exerciseIndex: null == exerciseIndex ? _self.exerciseIndex : exerciseIndex // ignore: cast_nullable_to_non_nullable
as int,setNumber: null == setNumber ? _self.setNumber : setNumber // ignore: cast_nullable_to_non_nullable
as int,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,rir: freezed == rir ? _self.rir : rir // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SetStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [SetLog].
extension SetLogPatterns on SetLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetLog value)  $default,){
final _that = this;
switch (_that) {
case _SetLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetLog value)?  $default,){
final _that = this;
switch (_that) {
case _SetLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String exerciseId,  int exerciseIndex,  int setNumber,  double? weightKg,  int reps,  int? rir,  SetStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetLog() when $default != null:
return $default(_that.id,_that.exerciseId,_that.exerciseIndex,_that.setNumber,_that.weightKg,_that.reps,_that.rir,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String exerciseId,  int exerciseIndex,  int setNumber,  double? weightKg,  int reps,  int? rir,  SetStatus status)  $default,) {final _that = this;
switch (_that) {
case _SetLog():
return $default(_that.id,_that.exerciseId,_that.exerciseIndex,_that.setNumber,_that.weightKg,_that.reps,_that.rir,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String exerciseId,  int exerciseIndex,  int setNumber,  double? weightKg,  int reps,  int? rir,  SetStatus status)?  $default,) {final _that = this;
switch (_that) {
case _SetLog() when $default != null:
return $default(_that.id,_that.exerciseId,_that.exerciseIndex,_that.setNumber,_that.weightKg,_that.reps,_that.rir,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetLog implements SetLog {
  const _SetLog({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', required this.exerciseId, required this.exerciseIndex, required this.setNumber, this.weightKg, required this.reps, this.rir, required this.status});
  factory _SetLog.fromJson(Map<String, dynamic> json) => _$SetLogFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override final  String exerciseId;
@override final  int exerciseIndex;
@override final  int setNumber;
@override final  double? weightKg;
@override final  int reps;
@override final  int? rir;
@override final  SetStatus status;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetLogCopyWith<_SetLog> get copyWith => __$SetLogCopyWithImpl<_SetLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetLog&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.exerciseIndex, exerciseIndex) || other.exerciseIndex == exerciseIndex)&&(identical(other.setNumber, setNumber) || other.setNumber == setNumber)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.rir, rir) || other.rir == rir)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,exerciseId,exerciseIndex,setNumber,weightKg,reps,rir,status);
}

@override
String toString() {
    return 'SetLog(id: $id, exerciseId: $exerciseId, exerciseIndex: $exerciseIndex, setNumber: $setNumber, weightKg: $weightKg, reps: $reps, rir: $rir, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SetLogCopyWith<$Res> implements $SetLogCopyWith<$Res> {
  factory _$SetLogCopyWith(_SetLog value, $Res Function(_SetLog) _then) = __$SetLogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String exerciseId, int exerciseIndex, int setNumber, double? weightKg, int reps, int? rir, SetStatus status
});




}
/// @nodoc
class __$SetLogCopyWithImpl<$Res>
    implements _$SetLogCopyWith<$Res> {
  __$SetLogCopyWithImpl(this._self, this._then);

  final _SetLog _self;
  final $Res Function(_SetLog) _then;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exerciseId = null,Object? exerciseIndex = null,Object? setNumber = null,Object? weightKg = freezed,Object? reps = null,Object? rir = freezed,Object? status = null,}) {
  return _then(_SetLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,exerciseIndex: null == exerciseIndex ? _self.exerciseIndex : exerciseIndex // ignore: cast_nullable_to_non_nullable
as int,setNumber: null == setNumber ? _self.setNumber : setNumber // ignore: cast_nullable_to_non_nullable
as int,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,rir: freezed == rir ? _self.rir : rir // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SetStatus,
  ));
}


}

// dart format on
