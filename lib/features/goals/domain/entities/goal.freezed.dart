// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NumRange {

 double get min; double get max;
/// Create a copy of NumRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NumRangeCopyWith<NumRange> get copyWith => _$NumRangeCopyWithImpl<NumRange>(this as NumRange, _$identity);

  /// Serializes this NumRange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NumRange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NumRange&&(identical(other.min, _this.min) || other.min == _this.min)&&(identical(other.max, _this.max) || other.max == _this.max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NumRange;
  return Object.hash(runtimeType,_this.min,_this.max);
}

@override
String toString() {
  final _this = this as NumRange;
  return 'NumRange(min: ${_this.min}, max: ${_this.max})';
}


}

/// @nodoc
abstract mixin class $NumRangeCopyWith<$Res>  {
  factory $NumRangeCopyWith(NumRange value, $Res Function(NumRange) _then) = _$NumRangeCopyWithImpl;
@useResult
$Res call({
 double min, double max
});




}
/// @nodoc
class _$NumRangeCopyWithImpl<$Res>
    implements $NumRangeCopyWith<$Res> {
  _$NumRangeCopyWithImpl(this._self, this._then);

  final NumRange _self;
  final $Res Function(NumRange) _then;

/// Create a copy of NumRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? min = null,Object? max = null,}) {
  return _then(NumRange(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NumRange].
extension NumRangePatterns on NumRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NumRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NumRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NumRange value)  $default,){
final _that = this;
switch (_that) {
case _NumRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NumRange value)?  $default,){
final _that = this;
switch (_that) {
case _NumRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double min,  double max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NumRange() when $default != null:
return $default(_that.min,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double min,  double max)  $default,) {final _that = this;
switch (_that) {
case _NumRange():
return $default(_that.min,_that.max);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double min,  double max)?  $default,) {final _that = this;
switch (_that) {
case _NumRange() when $default != null:
return $default(_that.min,_that.max);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NumRange extends NumRange {
  const _NumRange({required this.min, required this.max}): super._();
  factory _NumRange.fromJson(Map<String, dynamic> json) => _$NumRangeFromJson(json);

@override final  double min;
@override final  double max;

/// Create a copy of NumRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NumRangeCopyWith<_NumRange> get copyWith => __$NumRangeCopyWithImpl<_NumRange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NumRangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NumRange&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,min,max);
}

@override
String toString() {
    return 'NumRange(min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class _$NumRangeCopyWith<$Res> implements $NumRangeCopyWith<$Res> {
  factory _$NumRangeCopyWith(_NumRange value, $Res Function(_NumRange) _then) = __$NumRangeCopyWithImpl;
@override @useResult
$Res call({
 double min, double max
});




}
/// @nodoc
class __$NumRangeCopyWithImpl<$Res>
    implements _$NumRangeCopyWith<$Res> {
  __$NumRangeCopyWithImpl(this._self, this._then);

  final _NumRange _self;
  final $Res Function(_NumRange) _then;

/// Create a copy of NumRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? min = null,Object? max = null,}) {
  return _then(_NumRange(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$EnergySplit {

 int get protein; int get fat; int get carbs;
/// Create a copy of EnergySplit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnergySplitCopyWith<EnergySplit> get copyWith => _$EnergySplitCopyWithImpl<EnergySplit>(this as EnergySplit, _$identity);

  /// Serializes this EnergySplit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnergySplit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnergySplit&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnergySplit;
  return Object.hash(runtimeType,_this.protein,_this.fat,_this.carbs);
}

@override
String toString() {
  final _this = this as EnergySplit;
  return 'EnergySplit(protein: ${_this.protein}, fat: ${_this.fat}, carbs: ${_this.carbs})';
}


}

/// @nodoc
abstract mixin class $EnergySplitCopyWith<$Res>  {
  factory $EnergySplitCopyWith(EnergySplit value, $Res Function(EnergySplit) _then) = _$EnergySplitCopyWithImpl;
@useResult
$Res call({
 int protein, int fat, int carbs
});




}
/// @nodoc
class _$EnergySplitCopyWithImpl<$Res>
    implements $EnergySplitCopyWith<$Res> {
  _$EnergySplitCopyWithImpl(this._self, this._then);

  final EnergySplit _self;
  final $Res Function(EnergySplit) _then;

/// Create a copy of EnergySplit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? protein = null,Object? fat = null,Object? carbs = null,}) {
  return _then(EnergySplit(
protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as int,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as int,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EnergySplit].
extension EnergySplitPatterns on EnergySplit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnergySplit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnergySplit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnergySplit value)  $default,){
final _that = this;
switch (_that) {
case _EnergySplit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnergySplit value)?  $default,){
final _that = this;
switch (_that) {
case _EnergySplit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int protein,  int fat,  int carbs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnergySplit() when $default != null:
return $default(_that.protein,_that.fat,_that.carbs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int protein,  int fat,  int carbs)  $default,) {final _that = this;
switch (_that) {
case _EnergySplit():
return $default(_that.protein,_that.fat,_that.carbs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int protein,  int fat,  int carbs)?  $default,) {final _that = this;
switch (_that) {
case _EnergySplit() when $default != null:
return $default(_that.protein,_that.fat,_that.carbs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnergySplit implements EnergySplit {
  const _EnergySplit({required this.protein, required this.fat, required this.carbs});
  factory _EnergySplit.fromJson(Map<String, dynamic> json) => _$EnergySplitFromJson(json);

@override final  int protein;
@override final  int fat;
@override final  int carbs;

/// Create a copy of EnergySplit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnergySplitCopyWith<_EnergySplit> get copyWith => __$EnergySplitCopyWithImpl<_EnergySplit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnergySplitToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnergySplit&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.carbs, carbs) || other.carbs == carbs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,protein,fat,carbs);
}

@override
String toString() {
    return 'EnergySplit(protein: $protein, fat: $fat, carbs: $carbs)';
}


}

/// @nodoc
abstract mixin class _$EnergySplitCopyWith<$Res> implements $EnergySplitCopyWith<$Res> {
  factory _$EnergySplitCopyWith(_EnergySplit value, $Res Function(_EnergySplit) _then) = __$EnergySplitCopyWithImpl;
@override @useResult
$Res call({
 int protein, int fat, int carbs
});




}
/// @nodoc
class __$EnergySplitCopyWithImpl<$Res>
    implements _$EnergySplitCopyWith<$Res> {
  __$EnergySplitCopyWithImpl(this._self, this._then);

  final _EnergySplit _self;
  final $Res Function(_EnergySplit) _then;

/// Create a copy of EnergySplit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? protein = null,Object? fat = null,Object? carbs = null,}) {
  return _then(_EnergySplit(
protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as int,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as int,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NutritionPlan {

 SexBasis get sexBasis; NumRange get bmrKcal; double get activityFactor; NumRange get tdeeKcal; double get surplusPct; NumRange get targetKcalRange; int get targetKcal; int get proteinG; int get fatG; int get carbsG; double get proteinGPerKg; double get fatGPerKg; double get proteinBasisKg; EnergySplit get energySplitPct;
/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NutritionPlanCopyWith<NutritionPlan> get copyWith => _$NutritionPlanCopyWithImpl<NutritionPlan>(this as NutritionPlan, _$identity);

  /// Serializes this NutritionPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NutritionPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NutritionPlan&&(identical(other.sexBasis, _this.sexBasis) || other.sexBasis == _this.sexBasis)&&(identical(other.bmrKcal, _this.bmrKcal) || other.bmrKcal == _this.bmrKcal)&&(identical(other.activityFactor, _this.activityFactor) || other.activityFactor == _this.activityFactor)&&(identical(other.tdeeKcal, _this.tdeeKcal) || other.tdeeKcal == _this.tdeeKcal)&&(identical(other.surplusPct, _this.surplusPct) || other.surplusPct == _this.surplusPct)&&(identical(other.targetKcalRange, _this.targetKcalRange) || other.targetKcalRange == _this.targetKcalRange)&&(identical(other.targetKcal, _this.targetKcal) || other.targetKcal == _this.targetKcal)&&(identical(other.proteinG, _this.proteinG) || other.proteinG == _this.proteinG)&&(identical(other.fatG, _this.fatG) || other.fatG == _this.fatG)&&(identical(other.carbsG, _this.carbsG) || other.carbsG == _this.carbsG)&&(identical(other.proteinGPerKg, _this.proteinGPerKg) || other.proteinGPerKg == _this.proteinGPerKg)&&(identical(other.fatGPerKg, _this.fatGPerKg) || other.fatGPerKg == _this.fatGPerKg)&&(identical(other.proteinBasisKg, _this.proteinBasisKg) || other.proteinBasisKg == _this.proteinBasisKg)&&(identical(other.energySplitPct, _this.energySplitPct) || other.energySplitPct == _this.energySplitPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NutritionPlan;
  return Object.hash(runtimeType,_this.sexBasis,_this.bmrKcal,_this.activityFactor,_this.tdeeKcal,_this.surplusPct,_this.targetKcalRange,_this.targetKcal,_this.proteinG,_this.fatG,_this.carbsG,_this.proteinGPerKg,_this.fatGPerKg,_this.proteinBasisKg,_this.energySplitPct);
}

@override
String toString() {
  final _this = this as NutritionPlan;
  return 'NutritionPlan(sexBasis: ${_this.sexBasis}, bmrKcal: ${_this.bmrKcal}, activityFactor: ${_this.activityFactor}, tdeeKcal: ${_this.tdeeKcal}, surplusPct: ${_this.surplusPct}, targetKcalRange: ${_this.targetKcalRange}, targetKcal: ${_this.targetKcal}, proteinG: ${_this.proteinG}, fatG: ${_this.fatG}, carbsG: ${_this.carbsG}, proteinGPerKg: ${_this.proteinGPerKg}, fatGPerKg: ${_this.fatGPerKg}, proteinBasisKg: ${_this.proteinBasisKg}, energySplitPct: ${_this.energySplitPct})';
}


}

/// @nodoc
abstract mixin class $NutritionPlanCopyWith<$Res>  {
  factory $NutritionPlanCopyWith(NutritionPlan value, $Res Function(NutritionPlan) _then) = _$NutritionPlanCopyWithImpl;
@useResult
$Res call({
 SexBasis sexBasis, NumRange bmrKcal, double activityFactor, NumRange tdeeKcal, double surplusPct, NumRange targetKcalRange, int targetKcal, int proteinG, int fatG, int carbsG, double proteinGPerKg, double fatGPerKg, double proteinBasisKg, EnergySplit energySplitPct
});


$NumRangeCopyWith<$Res> get bmrKcal;$NumRangeCopyWith<$Res> get tdeeKcal;$NumRangeCopyWith<$Res> get targetKcalRange;$EnergySplitCopyWith<$Res> get energySplitPct;

}
/// @nodoc
class _$NutritionPlanCopyWithImpl<$Res>
    implements $NutritionPlanCopyWith<$Res> {
  _$NutritionPlanCopyWithImpl(this._self, this._then);

  final NutritionPlan _self;
  final $Res Function(NutritionPlan) _then;

/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sexBasis = null,Object? bmrKcal = null,Object? activityFactor = null,Object? tdeeKcal = null,Object? surplusPct = null,Object? targetKcalRange = null,Object? targetKcal = null,Object? proteinG = null,Object? fatG = null,Object? carbsG = null,Object? proteinGPerKg = null,Object? fatGPerKg = null,Object? proteinBasisKg = null,Object? energySplitPct = null,}) {
  return _then(NutritionPlan(
sexBasis: null == sexBasis ? _self.sexBasis : sexBasis // ignore: cast_nullable_to_non_nullable
as SexBasis,bmrKcal: null == bmrKcal ? _self.bmrKcal : bmrKcal // ignore: cast_nullable_to_non_nullable
as NumRange,activityFactor: null == activityFactor ? _self.activityFactor : activityFactor // ignore: cast_nullable_to_non_nullable
as double,tdeeKcal: null == tdeeKcal ? _self.tdeeKcal : tdeeKcal // ignore: cast_nullable_to_non_nullable
as NumRange,surplusPct: null == surplusPct ? _self.surplusPct : surplusPct // ignore: cast_nullable_to_non_nullable
as double,targetKcalRange: null == targetKcalRange ? _self.targetKcalRange : targetKcalRange // ignore: cast_nullable_to_non_nullable
as NumRange,targetKcal: null == targetKcal ? _self.targetKcal : targetKcal // ignore: cast_nullable_to_non_nullable
as int,proteinG: null == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as int,fatG: null == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as int,carbsG: null == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as int,proteinGPerKg: null == proteinGPerKg ? _self.proteinGPerKg : proteinGPerKg // ignore: cast_nullable_to_non_nullable
as double,fatGPerKg: null == fatGPerKg ? _self.fatGPerKg : fatGPerKg // ignore: cast_nullable_to_non_nullable
as double,proteinBasisKg: null == proteinBasisKg ? _self.proteinBasisKg : proteinBasisKg // ignore: cast_nullable_to_non_nullable
as double,energySplitPct: null == energySplitPct ? _self.energySplitPct : energySplitPct // ignore: cast_nullable_to_non_nullable
as EnergySplit,
  ));
}
/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get bmrKcal {
  
  return $NumRangeCopyWith<$Res>(_self.bmrKcal, (value) {
    return _then(_self.copyWith(bmrKcal: value));
  });
}/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get tdeeKcal {
  
  return $NumRangeCopyWith<$Res>(_self.tdeeKcal, (value) {
    return _then(_self.copyWith(tdeeKcal: value));
  });
}/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get targetKcalRange {
  
  return $NumRangeCopyWith<$Res>(_self.targetKcalRange, (value) {
    return _then(_self.copyWith(targetKcalRange: value));
  });
}/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnergySplitCopyWith<$Res> get energySplitPct {
  
  return $EnergySplitCopyWith<$Res>(_self.energySplitPct, (value) {
    return _then(_self.copyWith(energySplitPct: value));
  });
}
}


/// Adds pattern-matching-related methods to [NutritionPlan].
extension NutritionPlanPatterns on NutritionPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NutritionPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NutritionPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NutritionPlan value)  $default,){
final _that = this;
switch (_that) {
case _NutritionPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NutritionPlan value)?  $default,){
final _that = this;
switch (_that) {
case _NutritionPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SexBasis sexBasis,  NumRange bmrKcal,  double activityFactor,  NumRange tdeeKcal,  double surplusPct,  NumRange targetKcalRange,  int targetKcal,  int proteinG,  int fatG,  int carbsG,  double proteinGPerKg,  double fatGPerKg,  double proteinBasisKg,  EnergySplit energySplitPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NutritionPlan() when $default != null:
return $default(_that.sexBasis,_that.bmrKcal,_that.activityFactor,_that.tdeeKcal,_that.surplusPct,_that.targetKcalRange,_that.targetKcal,_that.proteinG,_that.fatG,_that.carbsG,_that.proteinGPerKg,_that.fatGPerKg,_that.proteinBasisKg,_that.energySplitPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SexBasis sexBasis,  NumRange bmrKcal,  double activityFactor,  NumRange tdeeKcal,  double surplusPct,  NumRange targetKcalRange,  int targetKcal,  int proteinG,  int fatG,  int carbsG,  double proteinGPerKg,  double fatGPerKg,  double proteinBasisKg,  EnergySplit energySplitPct)  $default,) {final _that = this;
switch (_that) {
case _NutritionPlan():
return $default(_that.sexBasis,_that.bmrKcal,_that.activityFactor,_that.tdeeKcal,_that.surplusPct,_that.targetKcalRange,_that.targetKcal,_that.proteinG,_that.fatG,_that.carbsG,_that.proteinGPerKg,_that.fatGPerKg,_that.proteinBasisKg,_that.energySplitPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SexBasis sexBasis,  NumRange bmrKcal,  double activityFactor,  NumRange tdeeKcal,  double surplusPct,  NumRange targetKcalRange,  int targetKcal,  int proteinG,  int fatG,  int carbsG,  double proteinGPerKg,  double fatGPerKg,  double proteinBasisKg,  EnergySplit energySplitPct)?  $default,) {final _that = this;
switch (_that) {
case _NutritionPlan() when $default != null:
return $default(_that.sexBasis,_that.bmrKcal,_that.activityFactor,_that.tdeeKcal,_that.surplusPct,_that.targetKcalRange,_that.targetKcal,_that.proteinG,_that.fatG,_that.carbsG,_that.proteinGPerKg,_that.fatGPerKg,_that.proteinBasisKg,_that.energySplitPct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NutritionPlan implements NutritionPlan {
  const _NutritionPlan({required this.sexBasis, required this.bmrKcal, required this.activityFactor, required this.tdeeKcal, required this.surplusPct, required this.targetKcalRange, required this.targetKcal, required this.proteinG, required this.fatG, required this.carbsG, required this.proteinGPerKg, required this.fatGPerKg, required this.proteinBasisKg, required this.energySplitPct});
  factory _NutritionPlan.fromJson(Map<String, dynamic> json) => _$NutritionPlanFromJson(json);

@override final  SexBasis sexBasis;
@override final  NumRange bmrKcal;
@override final  double activityFactor;
@override final  NumRange tdeeKcal;
@override final  double surplusPct;
@override final  NumRange targetKcalRange;
@override final  int targetKcal;
@override final  int proteinG;
@override final  int fatG;
@override final  int carbsG;
@override final  double proteinGPerKg;
@override final  double fatGPerKg;
@override final  double proteinBasisKg;
@override final  EnergySplit energySplitPct;

/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NutritionPlanCopyWith<_NutritionPlan> get copyWith => __$NutritionPlanCopyWithImpl<_NutritionPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NutritionPlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NutritionPlan&&(identical(other.sexBasis, sexBasis) || other.sexBasis == sexBasis)&&(identical(other.bmrKcal, bmrKcal) || other.bmrKcal == bmrKcal)&&(identical(other.activityFactor, activityFactor) || other.activityFactor == activityFactor)&&(identical(other.tdeeKcal, tdeeKcal) || other.tdeeKcal == tdeeKcal)&&(identical(other.surplusPct, surplusPct) || other.surplusPct == surplusPct)&&(identical(other.targetKcalRange, targetKcalRange) || other.targetKcalRange == targetKcalRange)&&(identical(other.targetKcal, targetKcal) || other.targetKcal == targetKcal)&&(identical(other.proteinG, proteinG) || other.proteinG == proteinG)&&(identical(other.fatG, fatG) || other.fatG == fatG)&&(identical(other.carbsG, carbsG) || other.carbsG == carbsG)&&(identical(other.proteinGPerKg, proteinGPerKg) || other.proteinGPerKg == proteinGPerKg)&&(identical(other.fatGPerKg, fatGPerKg) || other.fatGPerKg == fatGPerKg)&&(identical(other.proteinBasisKg, proteinBasisKg) || other.proteinBasisKg == proteinBasisKg)&&(identical(other.energySplitPct, energySplitPct) || other.energySplitPct == energySplitPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sexBasis,bmrKcal,activityFactor,tdeeKcal,surplusPct,targetKcalRange,targetKcal,proteinG,fatG,carbsG,proteinGPerKg,fatGPerKg,proteinBasisKg,energySplitPct);
}

@override
String toString() {
    return 'NutritionPlan(sexBasis: $sexBasis, bmrKcal: $bmrKcal, activityFactor: $activityFactor, tdeeKcal: $tdeeKcal, surplusPct: $surplusPct, targetKcalRange: $targetKcalRange, targetKcal: $targetKcal, proteinG: $proteinG, fatG: $fatG, carbsG: $carbsG, proteinGPerKg: $proteinGPerKg, fatGPerKg: $fatGPerKg, proteinBasisKg: $proteinBasisKg, energySplitPct: $energySplitPct)';
}


}

/// @nodoc
abstract mixin class _$NutritionPlanCopyWith<$Res> implements $NutritionPlanCopyWith<$Res> {
  factory _$NutritionPlanCopyWith(_NutritionPlan value, $Res Function(_NutritionPlan) _then) = __$NutritionPlanCopyWithImpl;
@override @useResult
$Res call({
 SexBasis sexBasis, NumRange bmrKcal, double activityFactor, NumRange tdeeKcal, double surplusPct, NumRange targetKcalRange, int targetKcal, int proteinG, int fatG, int carbsG, double proteinGPerKg, double fatGPerKg, double proteinBasisKg, EnergySplit energySplitPct
});


@override $NumRangeCopyWith<$Res> get bmrKcal;@override $NumRangeCopyWith<$Res> get tdeeKcal;@override $NumRangeCopyWith<$Res> get targetKcalRange;@override $EnergySplitCopyWith<$Res> get energySplitPct;

}
/// @nodoc
class __$NutritionPlanCopyWithImpl<$Res>
    implements _$NutritionPlanCopyWith<$Res> {
  __$NutritionPlanCopyWithImpl(this._self, this._then);

  final _NutritionPlan _self;
  final $Res Function(_NutritionPlan) _then;

/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sexBasis = null,Object? bmrKcal = null,Object? activityFactor = null,Object? tdeeKcal = null,Object? surplusPct = null,Object? targetKcalRange = null,Object? targetKcal = null,Object? proteinG = null,Object? fatG = null,Object? carbsG = null,Object? proteinGPerKg = null,Object? fatGPerKg = null,Object? proteinBasisKg = null,Object? energySplitPct = null,}) {
  return _then(_NutritionPlan(
sexBasis: null == sexBasis ? _self.sexBasis : sexBasis // ignore: cast_nullable_to_non_nullable
as SexBasis,bmrKcal: null == bmrKcal ? _self.bmrKcal : bmrKcal // ignore: cast_nullable_to_non_nullable
as NumRange,activityFactor: null == activityFactor ? _self.activityFactor : activityFactor // ignore: cast_nullable_to_non_nullable
as double,tdeeKcal: null == tdeeKcal ? _self.tdeeKcal : tdeeKcal // ignore: cast_nullable_to_non_nullable
as NumRange,surplusPct: null == surplusPct ? _self.surplusPct : surplusPct // ignore: cast_nullable_to_non_nullable
as double,targetKcalRange: null == targetKcalRange ? _self.targetKcalRange : targetKcalRange // ignore: cast_nullable_to_non_nullable
as NumRange,targetKcal: null == targetKcal ? _self.targetKcal : targetKcal // ignore: cast_nullable_to_non_nullable
as int,proteinG: null == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as int,fatG: null == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as int,carbsG: null == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as int,proteinGPerKg: null == proteinGPerKg ? _self.proteinGPerKg : proteinGPerKg // ignore: cast_nullable_to_non_nullable
as double,fatGPerKg: null == fatGPerKg ? _self.fatGPerKg : fatGPerKg // ignore: cast_nullable_to_non_nullable
as double,proteinBasisKg: null == proteinBasisKg ? _self.proteinBasisKg : proteinBasisKg // ignore: cast_nullable_to_non_nullable
as double,energySplitPct: null == energySplitPct ? _self.energySplitPct : energySplitPct // ignore: cast_nullable_to_non_nullable
as EnergySplit,
  ));
}

/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get bmrKcal {
  
  return $NumRangeCopyWith<$Res>(_self.bmrKcal, (value) {
    return _then(_self.copyWith(bmrKcal: value));
  });
}/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get tdeeKcal {
  
  return $NumRangeCopyWith<$Res>(_self.tdeeKcal, (value) {
    return _then(_self.copyWith(tdeeKcal: value));
  });
}/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get targetKcalRange {
  
  return $NumRangeCopyWith<$Res>(_self.targetKcalRange, (value) {
    return _then(_self.copyWith(targetKcalRange: value));
  });
}/// Create a copy of NutritionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnergySplitCopyWith<$Res> get energySplitPct {
  
  return $EnergySplitCopyWith<$Res>(_self.energySplitPct, (value) {
    return _then(_self.copyWith(energySplitPct: value));
  });
}
}


/// @nodoc
mixin _$GoalEvaluation {

 GoalVerdict get verdict; List<GoalReason> get reasons; double? get deltaKg; double? get weeklyChangeKg; double? get weeklyChangePct; double get maxWeeklyGainPct; NumRange get expectedWeeklyGainKg; int? get suggestedWeeks; double? get suggestedTargetWeightKg;
/// Create a copy of GoalEvaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalEvaluationCopyWith<GoalEvaluation> get copyWith => _$GoalEvaluationCopyWithImpl<GoalEvaluation>(this as GoalEvaluation, _$identity);

  /// Serializes this GoalEvaluation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GoalEvaluation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalEvaluation&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&const DeepCollectionEquality().equals(other.reasons, _this.reasons)&&(identical(other.deltaKg, _this.deltaKg) || other.deltaKg == _this.deltaKg)&&(identical(other.weeklyChangeKg, _this.weeklyChangeKg) || other.weeklyChangeKg == _this.weeklyChangeKg)&&(identical(other.weeklyChangePct, _this.weeklyChangePct) || other.weeklyChangePct == _this.weeklyChangePct)&&(identical(other.maxWeeklyGainPct, _this.maxWeeklyGainPct) || other.maxWeeklyGainPct == _this.maxWeeklyGainPct)&&(identical(other.expectedWeeklyGainKg, _this.expectedWeeklyGainKg) || other.expectedWeeklyGainKg == _this.expectedWeeklyGainKg)&&(identical(other.suggestedWeeks, _this.suggestedWeeks) || other.suggestedWeeks == _this.suggestedWeeks)&&(identical(other.suggestedTargetWeightKg, _this.suggestedTargetWeightKg) || other.suggestedTargetWeightKg == _this.suggestedTargetWeightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GoalEvaluation;
  return Object.hash(runtimeType,_this.verdict,const DeepCollectionEquality().hash(_this.reasons),_this.deltaKg,_this.weeklyChangeKg,_this.weeklyChangePct,_this.maxWeeklyGainPct,_this.expectedWeeklyGainKg,_this.suggestedWeeks,_this.suggestedTargetWeightKg);
}

@override
String toString() {
  final _this = this as GoalEvaluation;
  return 'GoalEvaluation(verdict: ${_this.verdict}, reasons: ${_this.reasons}, deltaKg: ${_this.deltaKg}, weeklyChangeKg: ${_this.weeklyChangeKg}, weeklyChangePct: ${_this.weeklyChangePct}, maxWeeklyGainPct: ${_this.maxWeeklyGainPct}, expectedWeeklyGainKg: ${_this.expectedWeeklyGainKg}, suggestedWeeks: ${_this.suggestedWeeks}, suggestedTargetWeightKg: ${_this.suggestedTargetWeightKg})';
}


}

/// @nodoc
abstract mixin class $GoalEvaluationCopyWith<$Res>  {
  factory $GoalEvaluationCopyWith(GoalEvaluation value, $Res Function(GoalEvaluation) _then) = _$GoalEvaluationCopyWithImpl;
@useResult
$Res call({
 GoalVerdict verdict, List<GoalReason> reasons, double? deltaKg, double? weeklyChangeKg, double? weeklyChangePct, double maxWeeklyGainPct, NumRange expectedWeeklyGainKg, int? suggestedWeeks, double? suggestedTargetWeightKg
});


$NumRangeCopyWith<$Res> get expectedWeeklyGainKg;

}
/// @nodoc
class _$GoalEvaluationCopyWithImpl<$Res>
    implements $GoalEvaluationCopyWith<$Res> {
  _$GoalEvaluationCopyWithImpl(this._self, this._then);

  final GoalEvaluation _self;
  final $Res Function(GoalEvaluation) _then;

/// Create a copy of GoalEvaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verdict = null,Object? reasons = null,Object? deltaKg = freezed,Object? weeklyChangeKg = freezed,Object? weeklyChangePct = freezed,Object? maxWeeklyGainPct = null,Object? expectedWeeklyGainKg = null,Object? suggestedWeeks = freezed,Object? suggestedTargetWeightKg = freezed,}) {
  return _then(GoalEvaluation(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as GoalVerdict,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<GoalReason>,deltaKg: freezed == deltaKg ? _self.deltaKg : deltaKg // ignore: cast_nullable_to_non_nullable
as double?,weeklyChangeKg: freezed == weeklyChangeKg ? _self.weeklyChangeKg : weeklyChangeKg // ignore: cast_nullable_to_non_nullable
as double?,weeklyChangePct: freezed == weeklyChangePct ? _self.weeklyChangePct : weeklyChangePct // ignore: cast_nullable_to_non_nullable
as double?,maxWeeklyGainPct: null == maxWeeklyGainPct ? _self.maxWeeklyGainPct : maxWeeklyGainPct // ignore: cast_nullable_to_non_nullable
as double,expectedWeeklyGainKg: null == expectedWeeklyGainKg ? _self.expectedWeeklyGainKg : expectedWeeklyGainKg // ignore: cast_nullable_to_non_nullable
as NumRange,suggestedWeeks: freezed == suggestedWeeks ? _self.suggestedWeeks : suggestedWeeks // ignore: cast_nullable_to_non_nullable
as int?,suggestedTargetWeightKg: freezed == suggestedTargetWeightKg ? _self.suggestedTargetWeightKg : suggestedTargetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of GoalEvaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get expectedWeeklyGainKg {
  
  return $NumRangeCopyWith<$Res>(_self.expectedWeeklyGainKg, (value) {
    return _then(_self.copyWith(expectedWeeklyGainKg: value));
  });
}
}


/// Adds pattern-matching-related methods to [GoalEvaluation].
extension GoalEvaluationPatterns on GoalEvaluation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalEvaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalEvaluation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalEvaluation value)  $default,){
final _that = this;
switch (_that) {
case _GoalEvaluation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalEvaluation value)?  $default,){
final _that = this;
switch (_that) {
case _GoalEvaluation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GoalVerdict verdict,  List<GoalReason> reasons,  double? deltaKg,  double? weeklyChangeKg,  double? weeklyChangePct,  double maxWeeklyGainPct,  NumRange expectedWeeklyGainKg,  int? suggestedWeeks,  double? suggestedTargetWeightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalEvaluation() when $default != null:
return $default(_that.verdict,_that.reasons,_that.deltaKg,_that.weeklyChangeKg,_that.weeklyChangePct,_that.maxWeeklyGainPct,_that.expectedWeeklyGainKg,_that.suggestedWeeks,_that.suggestedTargetWeightKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GoalVerdict verdict,  List<GoalReason> reasons,  double? deltaKg,  double? weeklyChangeKg,  double? weeklyChangePct,  double maxWeeklyGainPct,  NumRange expectedWeeklyGainKg,  int? suggestedWeeks,  double? suggestedTargetWeightKg)  $default,) {final _that = this;
switch (_that) {
case _GoalEvaluation():
return $default(_that.verdict,_that.reasons,_that.deltaKg,_that.weeklyChangeKg,_that.weeklyChangePct,_that.maxWeeklyGainPct,_that.expectedWeeklyGainKg,_that.suggestedWeeks,_that.suggestedTargetWeightKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GoalVerdict verdict,  List<GoalReason> reasons,  double? deltaKg,  double? weeklyChangeKg,  double? weeklyChangePct,  double maxWeeklyGainPct,  NumRange expectedWeeklyGainKg,  int? suggestedWeeks,  double? suggestedTargetWeightKg)?  $default,) {final _that = this;
switch (_that) {
case _GoalEvaluation() when $default != null:
return $default(_that.verdict,_that.reasons,_that.deltaKg,_that.weeklyChangeKg,_that.weeklyChangePct,_that.maxWeeklyGainPct,_that.expectedWeeklyGainKg,_that.suggestedWeeks,_that.suggestedTargetWeightKg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalEvaluation implements GoalEvaluation {
  const _GoalEvaluation({required this.verdict, required  List<GoalReason> reasons, this.deltaKg, this.weeklyChangeKg, this.weeklyChangePct, required this.maxWeeklyGainPct, required this.expectedWeeklyGainKg, this.suggestedWeeks, this.suggestedTargetWeightKg}): _reasons = reasons;
  factory _GoalEvaluation.fromJson(Map<String, dynamic> json) => _$GoalEvaluationFromJson(json);

@override final  GoalVerdict verdict;
 final  List<GoalReason> _reasons;
@override List<GoalReason> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}

@override final  double? deltaKg;
@override final  double? weeklyChangeKg;
@override final  double? weeklyChangePct;
@override final  double maxWeeklyGainPct;
@override final  NumRange expectedWeeklyGainKg;
@override final  int? suggestedWeeks;
@override final  double? suggestedTargetWeightKg;

/// Create a copy of GoalEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalEvaluationCopyWith<_GoalEvaluation> get copyWith => __$GoalEvaluationCopyWithImpl<_GoalEvaluation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalEvaluationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalEvaluation&&(identical(other.verdict, verdict) || other.verdict == verdict)&&const DeepCollectionEquality().equals(other.reasons, _reasons)&&(identical(other.deltaKg, deltaKg) || other.deltaKg == deltaKg)&&(identical(other.weeklyChangeKg, weeklyChangeKg) || other.weeklyChangeKg == weeklyChangeKg)&&(identical(other.weeklyChangePct, weeklyChangePct) || other.weeklyChangePct == weeklyChangePct)&&(identical(other.maxWeeklyGainPct, maxWeeklyGainPct) || other.maxWeeklyGainPct == maxWeeklyGainPct)&&(identical(other.expectedWeeklyGainKg, expectedWeeklyGainKg) || other.expectedWeeklyGainKg == expectedWeeklyGainKg)&&(identical(other.suggestedWeeks, suggestedWeeks) || other.suggestedWeeks == suggestedWeeks)&&(identical(other.suggestedTargetWeightKg, suggestedTargetWeightKg) || other.suggestedTargetWeightKg == suggestedTargetWeightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,verdict,const DeepCollectionEquality().hash(_reasons),deltaKg,weeklyChangeKg,weeklyChangePct,maxWeeklyGainPct,expectedWeeklyGainKg,suggestedWeeks,suggestedTargetWeightKg);
}

@override
String toString() {
    return 'GoalEvaluation(verdict: $verdict, reasons: $reasons, deltaKg: $deltaKg, weeklyChangeKg: $weeklyChangeKg, weeklyChangePct: $weeklyChangePct, maxWeeklyGainPct: $maxWeeklyGainPct, expectedWeeklyGainKg: $expectedWeeklyGainKg, suggestedWeeks: $suggestedWeeks, suggestedTargetWeightKg: $suggestedTargetWeightKg)';
}


}

/// @nodoc
abstract mixin class _$GoalEvaluationCopyWith<$Res> implements $GoalEvaluationCopyWith<$Res> {
  factory _$GoalEvaluationCopyWith(_GoalEvaluation value, $Res Function(_GoalEvaluation) _then) = __$GoalEvaluationCopyWithImpl;
@override @useResult
$Res call({
 GoalVerdict verdict, List<GoalReason> reasons, double? deltaKg, double? weeklyChangeKg, double? weeklyChangePct, double maxWeeklyGainPct, NumRange expectedWeeklyGainKg, int? suggestedWeeks, double? suggestedTargetWeightKg
});


@override $NumRangeCopyWith<$Res> get expectedWeeklyGainKg;

}
/// @nodoc
class __$GoalEvaluationCopyWithImpl<$Res>
    implements _$GoalEvaluationCopyWith<$Res> {
  __$GoalEvaluationCopyWithImpl(this._self, this._then);

  final _GoalEvaluation _self;
  final $Res Function(_GoalEvaluation) _then;

/// Create a copy of GoalEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verdict = null,Object? reasons = null,Object? deltaKg = freezed,Object? weeklyChangeKg = freezed,Object? weeklyChangePct = freezed,Object? maxWeeklyGainPct = null,Object? expectedWeeklyGainKg = null,Object? suggestedWeeks = freezed,Object? suggestedTargetWeightKg = freezed,}) {
  return _then(_GoalEvaluation(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as GoalVerdict,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<GoalReason>,deltaKg: freezed == deltaKg ? _self.deltaKg : deltaKg // ignore: cast_nullable_to_non_nullable
as double?,weeklyChangeKg: freezed == weeklyChangeKg ? _self.weeklyChangeKg : weeklyChangeKg // ignore: cast_nullable_to_non_nullable
as double?,weeklyChangePct: freezed == weeklyChangePct ? _self.weeklyChangePct : weeklyChangePct // ignore: cast_nullable_to_non_nullable
as double?,maxWeeklyGainPct: null == maxWeeklyGainPct ? _self.maxWeeklyGainPct : maxWeeklyGainPct // ignore: cast_nullable_to_non_nullable
as double,expectedWeeklyGainKg: null == expectedWeeklyGainKg ? _self.expectedWeeklyGainKg : expectedWeeklyGainKg // ignore: cast_nullable_to_non_nullable
as NumRange,suggestedWeeks: freezed == suggestedWeeks ? _self.suggestedWeeks : suggestedWeeks // ignore: cast_nullable_to_non_nullable
as int?,suggestedTargetWeightKg: freezed == suggestedTargetWeightKg ? _self.suggestedTargetWeightKg : suggestedTargetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of GoalEvaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NumRangeCopyWith<$Res> get expectedWeeklyGainKg {
  
  return $NumRangeCopyWith<$Res>(_self.expectedWeeklyGainKg, (value) {
    return _then(_self.copyWith(expectedWeeklyGainKg: value));
  });
}
}


/// @nodoc
mixin _$SafetyAssessment {

 bool get stop; bool get conservative; List<SafetyWarning> get warnings;
/// Create a copy of SafetyAssessment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SafetyAssessmentCopyWith<SafetyAssessment> get copyWith => _$SafetyAssessmentCopyWithImpl<SafetyAssessment>(this as SafetyAssessment, _$identity);

  /// Serializes this SafetyAssessment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SafetyAssessment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SafetyAssessment&&(identical(other.stop, _this.stop) || other.stop == _this.stop)&&(identical(other.conservative, _this.conservative) || other.conservative == _this.conservative)&&const DeepCollectionEquality().equals(other.warnings, _this.warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SafetyAssessment;
  return Object.hash(runtimeType,_this.stop,_this.conservative,const DeepCollectionEquality().hash(_this.warnings));
}

@override
String toString() {
  final _this = this as SafetyAssessment;
  return 'SafetyAssessment(stop: ${_this.stop}, conservative: ${_this.conservative}, warnings: ${_this.warnings})';
}


}

/// @nodoc
abstract mixin class $SafetyAssessmentCopyWith<$Res>  {
  factory $SafetyAssessmentCopyWith(SafetyAssessment value, $Res Function(SafetyAssessment) _then) = _$SafetyAssessmentCopyWithImpl;
@useResult
$Res call({
 bool stop, bool conservative, List<SafetyWarning> warnings
});




}
/// @nodoc
class _$SafetyAssessmentCopyWithImpl<$Res>
    implements $SafetyAssessmentCopyWith<$Res> {
  _$SafetyAssessmentCopyWithImpl(this._self, this._then);

  final SafetyAssessment _self;
  final $Res Function(SafetyAssessment) _then;

/// Create a copy of SafetyAssessment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stop = null,Object? conservative = null,Object? warnings = null,}) {
  return _then(SafetyAssessment(
stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as bool,conservative: null == conservative ? _self.conservative : conservative // ignore: cast_nullable_to_non_nullable
as bool,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<SafetyWarning>,
  ));
}

}


/// Adds pattern-matching-related methods to [SafetyAssessment].
extension SafetyAssessmentPatterns on SafetyAssessment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SafetyAssessment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SafetyAssessment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SafetyAssessment value)  $default,){
final _that = this;
switch (_that) {
case _SafetyAssessment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SafetyAssessment value)?  $default,){
final _that = this;
switch (_that) {
case _SafetyAssessment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool stop,  bool conservative,  List<SafetyWarning> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SafetyAssessment() when $default != null:
return $default(_that.stop,_that.conservative,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool stop,  bool conservative,  List<SafetyWarning> warnings)  $default,) {final _that = this;
switch (_that) {
case _SafetyAssessment():
return $default(_that.stop,_that.conservative,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool stop,  bool conservative,  List<SafetyWarning> warnings)?  $default,) {final _that = this;
switch (_that) {
case _SafetyAssessment() when $default != null:
return $default(_that.stop,_that.conservative,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SafetyAssessment implements SafetyAssessment {
  const _SafetyAssessment({required this.stop, required this.conservative, required  List<SafetyWarning> warnings}): _warnings = warnings;
  factory _SafetyAssessment.fromJson(Map<String, dynamic> json) => _$SafetyAssessmentFromJson(json);

@override final  bool stop;
@override final  bool conservative;
 final  List<SafetyWarning> _warnings;
@override List<SafetyWarning> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of SafetyAssessment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SafetyAssessmentCopyWith<_SafetyAssessment> get copyWith => __$SafetyAssessmentCopyWithImpl<_SafetyAssessment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SafetyAssessmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SafetyAssessment&&(identical(other.stop, stop) || other.stop == stop)&&(identical(other.conservative, conservative) || other.conservative == conservative)&&const DeepCollectionEquality().equals(other.warnings, _warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stop,conservative,const DeepCollectionEquality().hash(_warnings));
}

@override
String toString() {
    return 'SafetyAssessment(stop: $stop, conservative: $conservative, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$SafetyAssessmentCopyWith<$Res> implements $SafetyAssessmentCopyWith<$Res> {
  factory _$SafetyAssessmentCopyWith(_SafetyAssessment value, $Res Function(_SafetyAssessment) _then) = __$SafetyAssessmentCopyWithImpl;
@override @useResult
$Res call({
 bool stop, bool conservative, List<SafetyWarning> warnings
});




}
/// @nodoc
class __$SafetyAssessmentCopyWithImpl<$Res>
    implements _$SafetyAssessmentCopyWith<$Res> {
  __$SafetyAssessmentCopyWithImpl(this._self, this._then);

  final _SafetyAssessment _self;
  final $Res Function(_SafetyAssessment) _then;

/// Create a copy of SafetyAssessment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stop = null,Object? conservative = null,Object? warnings = null,}) {
  return _then(_SafetyAssessment(
stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as bool,conservative: null == conservative ? _self.conservative : conservative // ignore: cast_nullable_to_non_nullable
as bool,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<SafetyWarning>,
  ));
}


}


/// @nodoc
mixin _$Goal {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; GoalStatus get status; PrimaryGoal get primaryGoal; ExperienceLevel get level; int get age; double get bmi; double get startWeightKg; double? get targetWeightKg; int get targetWeeks;/// `YYYY-MM-DD`.
 String get targetDate; GoalEvaluation get evaluation; SafetyAssessment get safety; NutritionPlan get nutrition; String get configVersion;
/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCopyWith<Goal> get copyWith => _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Goal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Goal&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.primaryGoal, _this.primaryGoal) || other.primaryGoal == _this.primaryGoal)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.bmi, _this.bmi) || other.bmi == _this.bmi)&&(identical(other.startWeightKg, _this.startWeightKg) || other.startWeightKg == _this.startWeightKg)&&(identical(other.targetWeightKg, _this.targetWeightKg) || other.targetWeightKg == _this.targetWeightKg)&&(identical(other.targetWeeks, _this.targetWeeks) || other.targetWeeks == _this.targetWeeks)&&(identical(other.targetDate, _this.targetDate) || other.targetDate == _this.targetDate)&&(identical(other.evaluation, _this.evaluation) || other.evaluation == _this.evaluation)&&(identical(other.safety, _this.safety) || other.safety == _this.safety)&&(identical(other.nutrition, _this.nutrition) || other.nutrition == _this.nutrition)&&(identical(other.configVersion, _this.configVersion) || other.configVersion == _this.configVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Goal;
  return Object.hash(runtimeType,_this.id,_this.status,_this.primaryGoal,_this.level,_this.age,_this.bmi,_this.startWeightKg,_this.targetWeightKg,_this.targetWeeks,_this.targetDate,_this.evaluation,_this.safety,_this.nutrition,_this.configVersion);
}

@override
String toString() {
  final _this = this as Goal;
  return 'Goal(id: ${_this.id}, status: ${_this.status}, primaryGoal: ${_this.primaryGoal}, level: ${_this.level}, age: ${_this.age}, bmi: ${_this.bmi}, startWeightKg: ${_this.startWeightKg}, targetWeightKg: ${_this.targetWeightKg}, targetWeeks: ${_this.targetWeeks}, targetDate: ${_this.targetDate}, evaluation: ${_this.evaluation}, safety: ${_this.safety}, nutrition: ${_this.nutrition}, configVersion: ${_this.configVersion})';
}


}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res>  {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) = _$GoalCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, GoalStatus status, PrimaryGoal primaryGoal, ExperienceLevel level, int age, double bmi, double startWeightKg, double? targetWeightKg, int targetWeeks, String targetDate, GoalEvaluation evaluation, SafetyAssessment safety, NutritionPlan nutrition, String configVersion
});


$GoalEvaluationCopyWith<$Res> get evaluation;$SafetyAssessmentCopyWith<$Res> get safety;$NutritionPlanCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$GoalCopyWithImpl<$Res>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? primaryGoal = null,Object? level = null,Object? age = null,Object? bmi = null,Object? startWeightKg = null,Object? targetWeightKg = freezed,Object? targetWeeks = null,Object? targetDate = null,Object? evaluation = null,Object? safety = null,Object? nutrition = null,Object? configVersion = null,}) {
  return _then(Goal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,primaryGoal: null == primaryGoal ? _self.primaryGoal : primaryGoal // ignore: cast_nullable_to_non_nullable
as PrimaryGoal,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ExperienceLevel,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,bmi: null == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double,startWeightKg: null == startWeightKg ? _self.startWeightKg : startWeightKg // ignore: cast_nullable_to_non_nullable
as double,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeeks: null == targetWeeks ? _self.targetWeeks : targetWeeks // ignore: cast_nullable_to_non_nullable
as int,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as String,evaluation: null == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as GoalEvaluation,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as SafetyAssessment,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as NutritionPlan,configVersion: null == configVersion ? _self.configVersion : configVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalEvaluationCopyWith<$Res> get evaluation {
  
  return $GoalEvaluationCopyWith<$Res>(_self.evaluation, (value) {
    return _then(_self.copyWith(evaluation: value));
  });
}/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SafetyAssessmentCopyWith<$Res> get safety {
  
  return $SafetyAssessmentCopyWith<$Res>(_self.safety, (value) {
    return _then(_self.copyWith(safety: value));
  });
}/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionPlanCopyWith<$Res> get nutrition {
  
  return $NutritionPlanCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}


/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Goal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Goal value)  $default,){
final _that = this;
switch (_that) {
case _Goal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Goal value)?  $default,){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  GoalStatus status,  PrimaryGoal primaryGoal,  ExperienceLevel level,  int age,  double bmi,  double startWeightKg,  double? targetWeightKg,  int targetWeeks,  String targetDate,  GoalEvaluation evaluation,  SafetyAssessment safety,  NutritionPlan nutrition,  String configVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.status,_that.primaryGoal,_that.level,_that.age,_that.bmi,_that.startWeightKg,_that.targetWeightKg,_that.targetWeeks,_that.targetDate,_that.evaluation,_that.safety,_that.nutrition,_that.configVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  GoalStatus status,  PrimaryGoal primaryGoal,  ExperienceLevel level,  int age,  double bmi,  double startWeightKg,  double? targetWeightKg,  int targetWeeks,  String targetDate,  GoalEvaluation evaluation,  SafetyAssessment safety,  NutritionPlan nutrition,  String configVersion)  $default,) {final _that = this;
switch (_that) {
case _Goal():
return $default(_that.id,_that.status,_that.primaryGoal,_that.level,_that.age,_that.bmi,_that.startWeightKg,_that.targetWeightKg,_that.targetWeeks,_that.targetDate,_that.evaluation,_that.safety,_that.nutrition,_that.configVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  GoalStatus status,  PrimaryGoal primaryGoal,  ExperienceLevel level,  int age,  double bmi,  double startWeightKg,  double? targetWeightKg,  int targetWeeks,  String targetDate,  GoalEvaluation evaluation,  SafetyAssessment safety,  NutritionPlan nutrition,  String configVersion)?  $default,) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.status,_that.primaryGoal,_that.level,_that.age,_that.bmi,_that.startWeightKg,_that.targetWeightKg,_that.targetWeeks,_that.targetDate,_that.evaluation,_that.safety,_that.nutrition,_that.configVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Goal extends Goal {
  const _Goal({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', required this.status, required this.primaryGoal, required this.level, required this.age, required this.bmi, required this.startWeightKg, this.targetWeightKg, required this.targetWeeks, required this.targetDate, required this.evaluation, required this.safety, required this.nutrition, required this.configVersion}): super._();
  factory _Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override final  GoalStatus status;
@override final  PrimaryGoal primaryGoal;
@override final  ExperienceLevel level;
@override final  int age;
@override final  double bmi;
@override final  double startWeightKg;
@override final  double? targetWeightKg;
@override final  int targetWeeks;
/// `YYYY-MM-DD`.
@override final  String targetDate;
@override final  GoalEvaluation evaluation;
@override final  SafetyAssessment safety;
@override final  NutritionPlan nutrition;
@override final  String configVersion;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalCopyWith<_Goal> get copyWith => __$GoalCopyWithImpl<_Goal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.primaryGoal, primaryGoal) || other.primaryGoal == primaryGoal)&&(identical(other.level, level) || other.level == level)&&(identical(other.age, age) || other.age == age)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.startWeightKg, startWeightKg) || other.startWeightKg == startWeightKg)&&(identical(other.targetWeightKg, targetWeightKg) || other.targetWeightKg == targetWeightKg)&&(identical(other.targetWeeks, targetWeeks) || other.targetWeeks == targetWeeks)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.evaluation, evaluation) || other.evaluation == evaluation)&&(identical(other.safety, safety) || other.safety == safety)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.configVersion, configVersion) || other.configVersion == configVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,primaryGoal,level,age,bmi,startWeightKg,targetWeightKg,targetWeeks,targetDate,evaluation,safety,nutrition,configVersion);
}

@override
String toString() {
    return 'Goal(id: $id, status: $status, primaryGoal: $primaryGoal, level: $level, age: $age, bmi: $bmi, startWeightKg: $startWeightKg, targetWeightKg: $targetWeightKg, targetWeeks: $targetWeeks, targetDate: $targetDate, evaluation: $evaluation, safety: $safety, nutrition: $nutrition, configVersion: $configVersion)';
}


}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) = __$GoalCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, GoalStatus status, PrimaryGoal primaryGoal, ExperienceLevel level, int age, double bmi, double startWeightKg, double? targetWeightKg, int targetWeeks, String targetDate, GoalEvaluation evaluation, SafetyAssessment safety, NutritionPlan nutrition, String configVersion
});


@override $GoalEvaluationCopyWith<$Res> get evaluation;@override $SafetyAssessmentCopyWith<$Res> get safety;@override $NutritionPlanCopyWith<$Res> get nutrition;

}
/// @nodoc
class __$GoalCopyWithImpl<$Res>
    implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? primaryGoal = null,Object? level = null,Object? age = null,Object? bmi = null,Object? startWeightKg = null,Object? targetWeightKg = freezed,Object? targetWeeks = null,Object? targetDate = null,Object? evaluation = null,Object? safety = null,Object? nutrition = null,Object? configVersion = null,}) {
  return _then(_Goal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,primaryGoal: null == primaryGoal ? _self.primaryGoal : primaryGoal // ignore: cast_nullable_to_non_nullable
as PrimaryGoal,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ExperienceLevel,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,bmi: null == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double,startWeightKg: null == startWeightKg ? _self.startWeightKg : startWeightKg // ignore: cast_nullable_to_non_nullable
as double,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeeks: null == targetWeeks ? _self.targetWeeks : targetWeeks // ignore: cast_nullable_to_non_nullable
as int,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as String,evaluation: null == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as GoalEvaluation,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as SafetyAssessment,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as NutritionPlan,configVersion: null == configVersion ? _self.configVersion : configVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalEvaluationCopyWith<$Res> get evaluation {
  
  return $GoalEvaluationCopyWith<$Res>(_self.evaluation, (value) {
    return _then(_self.copyWith(evaluation: value));
  });
}/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SafetyAssessmentCopyWith<$Res> get safety {
  
  return $SafetyAssessmentCopyWith<$Res>(_self.safety, (value) {
    return _then(_self.copyWith(safety: value));
  });
}/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionPlanCopyWith<$Res> get nutrition {
  
  return $NutritionPlanCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}

// dart format on
