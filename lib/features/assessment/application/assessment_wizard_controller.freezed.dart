// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_wizard_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssessmentWizardState {

 AssessmentData get data; int get step;/// Tampilkan error field setelah pengguna mencoba lanjut.
 bool get showErrors; bool get consentDisclaimer; bool get consentHealthData; bool get submitting; Object? get submitError;
/// Create a copy of AssessmentWizardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentWizardStateCopyWith<AssessmentWizardState> get copyWith => _$AssessmentWizardStateCopyWithImpl<AssessmentWizardState>(this as AssessmentWizardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AssessmentWizardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentWizardState&&(identical(other.data, _this.data) || other.data == _this.data)&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.showErrors, _this.showErrors) || other.showErrors == _this.showErrors)&&(identical(other.consentDisclaimer, _this.consentDisclaimer) || other.consentDisclaimer == _this.consentDisclaimer)&&(identical(other.consentHealthData, _this.consentHealthData) || other.consentHealthData == _this.consentHealthData)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&const DeepCollectionEquality().equals(other.submitError, _this.submitError));
}


@override
int get hashCode {
  final _this = this as AssessmentWizardState;
  return Object.hash(runtimeType,_this.data,_this.step,_this.showErrors,_this.consentDisclaimer,_this.consentHealthData,_this.submitting,const DeepCollectionEquality().hash(_this.submitError));
}

@override
String toString() {
  final _this = this as AssessmentWizardState;
  return 'AssessmentWizardState(data: ${_this.data}, step: ${_this.step}, showErrors: ${_this.showErrors}, consentDisclaimer: ${_this.consentDisclaimer}, consentHealthData: ${_this.consentHealthData}, submitting: ${_this.submitting}, submitError: ${_this.submitError})';
}


}

/// @nodoc
abstract mixin class $AssessmentWizardStateCopyWith<$Res>  {
  factory $AssessmentWizardStateCopyWith(AssessmentWizardState value, $Res Function(AssessmentWizardState) _then) = _$AssessmentWizardStateCopyWithImpl;
@useResult
$Res call({
 AssessmentData data, int step, bool showErrors, bool consentDisclaimer, bool consentHealthData, bool submitting, Object? submitError
});


$AssessmentDataCopyWith<$Res> get data;

}
/// @nodoc
class _$AssessmentWizardStateCopyWithImpl<$Res>
    implements $AssessmentWizardStateCopyWith<$Res> {
  _$AssessmentWizardStateCopyWithImpl(this._self, this._then);

  final AssessmentWizardState _self;
  final $Res Function(AssessmentWizardState) _then;

/// Create a copy of AssessmentWizardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? step = null,Object? showErrors = null,Object? consentDisclaimer = null,Object? consentHealthData = null,Object? submitting = null,Object? submitError = freezed,}) {
  return _then(AssessmentWizardState(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AssessmentData,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,showErrors: null == showErrors ? _self.showErrors : showErrors // ignore: cast_nullable_to_non_nullable
as bool,consentDisclaimer: null == consentDisclaimer ? _self.consentDisclaimer : consentDisclaimer // ignore: cast_nullable_to_non_nullable
as bool,consentHealthData: null == consentHealthData ? _self.consentHealthData : consentHealthData // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError ,
  ));
}
/// Create a copy of AssessmentWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssessmentDataCopyWith<$Res> get data {
  
  return $AssessmentDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssessmentWizardState].
extension AssessmentWizardStatePatterns on AssessmentWizardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentWizardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentWizardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentWizardState value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentWizardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentWizardState value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentWizardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AssessmentData data,  int step,  bool showErrors,  bool consentDisclaimer,  bool consentHealthData,  bool submitting,  Object? submitError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentWizardState() when $default != null:
return $default(_that.data,_that.step,_that.showErrors,_that.consentDisclaimer,_that.consentHealthData,_that.submitting,_that.submitError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AssessmentData data,  int step,  bool showErrors,  bool consentDisclaimer,  bool consentHealthData,  bool submitting,  Object? submitError)  $default,) {final _that = this;
switch (_that) {
case _AssessmentWizardState():
return $default(_that.data,_that.step,_that.showErrors,_that.consentDisclaimer,_that.consentHealthData,_that.submitting,_that.submitError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AssessmentData data,  int step,  bool showErrors,  bool consentDisclaimer,  bool consentHealthData,  bool submitting,  Object? submitError)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentWizardState() when $default != null:
return $default(_that.data,_that.step,_that.showErrors,_that.consentDisclaimer,_that.consentHealthData,_that.submitting,_that.submitError);case _:
  return null;

}
}

}

/// @nodoc


class _AssessmentWizardState extends AssessmentWizardState {
  const _AssessmentWizardState({required this.data, this.step = 0, this.showErrors = false, this.consentDisclaimer = false, this.consentHealthData = false, this.submitting = false, this.submitError}): super._();
  

@override final  AssessmentData data;
@override@JsonKey() final  int step;
/// Tampilkan error field setelah pengguna mencoba lanjut.
@override@JsonKey() final  bool showErrors;
@override@JsonKey() final  bool consentDisclaimer;
@override@JsonKey() final  bool consentHealthData;
@override@JsonKey() final  bool submitting;
@override final  Object? submitError;

/// Create a copy of AssessmentWizardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentWizardStateCopyWith<_AssessmentWizardState> get copyWith => __$AssessmentWizardStateCopyWithImpl<_AssessmentWizardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentWizardState&&(identical(other.data, data) || other.data == data)&&(identical(other.step, step) || other.step == step)&&(identical(other.showErrors, showErrors) || other.showErrors == showErrors)&&(identical(other.consentDisclaimer, consentDisclaimer) || other.consentDisclaimer == consentDisclaimer)&&(identical(other.consentHealthData, consentHealthData) || other.consentHealthData == consentHealthData)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&const DeepCollectionEquality().equals(other.submitError, submitError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,data,step,showErrors,consentDisclaimer,consentHealthData,submitting,const DeepCollectionEquality().hash(submitError));
}

@override
String toString() {
    return 'AssessmentWizardState(data: $data, step: $step, showErrors: $showErrors, consentDisclaimer: $consentDisclaimer, consentHealthData: $consentHealthData, submitting: $submitting, submitError: $submitError)';
}


}

/// @nodoc
abstract mixin class _$AssessmentWizardStateCopyWith<$Res> implements $AssessmentWizardStateCopyWith<$Res> {
  factory _$AssessmentWizardStateCopyWith(_AssessmentWizardState value, $Res Function(_AssessmentWizardState) _then) = __$AssessmentWizardStateCopyWithImpl;
@override @useResult
$Res call({
 AssessmentData data, int step, bool showErrors, bool consentDisclaimer, bool consentHealthData, bool submitting, Object? submitError
});


@override $AssessmentDataCopyWith<$Res> get data;

}
/// @nodoc
class __$AssessmentWizardStateCopyWithImpl<$Res>
    implements _$AssessmentWizardStateCopyWith<$Res> {
  __$AssessmentWizardStateCopyWithImpl(this._self, this._then);

  final _AssessmentWizardState _self;
  final $Res Function(_AssessmentWizardState) _then;

/// Create a copy of AssessmentWizardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? step = null,Object? showErrors = null,Object? consentDisclaimer = null,Object? consentHealthData = null,Object? submitting = null,Object? submitError = freezed,}) {
  return _then(_AssessmentWizardState(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AssessmentData,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,showErrors: null == showErrors ? _self.showErrors : showErrors // ignore: cast_nullable_to_non_nullable
as bool,consentDisclaimer: null == consentDisclaimer ? _self.consentDisclaimer : consentDisclaimer // ignore: cast_nullable_to_non_nullable
as bool,consentHealthData: null == consentHealthData ? _self.consentHealthData : consentHealthData // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError ,
  ));
}

/// Create a copy of AssessmentWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssessmentDataCopyWith<$Res> get data {
  
  return $AssessmentDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
