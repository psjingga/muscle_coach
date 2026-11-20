// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiSettings {

/// 4 karakter terakhir key (untuk ditampilkan), `null` bila belum ada.
 String? get keySuffix; String get model; bool get consent;
/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSettingsCopyWith<AiSettings> get copyWith => _$AiSettingsCopyWithImpl<AiSettings>(this as AiSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AiSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSettings&&(identical(other.keySuffix, _this.keySuffix) || other.keySuffix == _this.keySuffix)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.consent, _this.consent) || other.consent == _this.consent));
}


@override
int get hashCode {
  final _this = this as AiSettings;
  return Object.hash(runtimeType,_this.keySuffix,_this.model,_this.consent);
}

@override
String toString() {
  final _this = this as AiSettings;
  return 'AiSettings(keySuffix: ${_this.keySuffix}, model: ${_this.model}, consent: ${_this.consent})';
}


}

/// @nodoc
abstract mixin class $AiSettingsCopyWith<$Res>  {
  factory $AiSettingsCopyWith(AiSettings value, $Res Function(AiSettings) _then) = _$AiSettingsCopyWithImpl;
@useResult
$Res call({
 String? keySuffix, String model, bool consent
});




}
/// @nodoc
class _$AiSettingsCopyWithImpl<$Res>
    implements $AiSettingsCopyWith<$Res> {
  _$AiSettingsCopyWithImpl(this._self, this._then);

  final AiSettings _self;
  final $Res Function(AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keySuffix = freezed,Object? model = null,Object? consent = null,}) {
  return _then(AiSettings(
keySuffix: freezed == keySuffix ? _self.keySuffix : keySuffix // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,consent: null == consent ? _self.consent : consent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSettings].
extension AiSettingsPatterns on AiSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSettings value)  $default,){
final _that = this;
switch (_that) {
case _AiSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? keySuffix,  String model,  bool consent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
return $default(_that.keySuffix,_that.model,_that.consent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? keySuffix,  String model,  bool consent)  $default,) {final _that = this;
switch (_that) {
case _AiSettings():
return $default(_that.keySuffix,_that.model,_that.consent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? keySuffix,  String model,  bool consent)?  $default,) {final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
return $default(_that.keySuffix,_that.model,_that.consent);case _:
  return null;

}
}

}

/// @nodoc


class _AiSettings extends AiSettings {
  const _AiSettings({this.keySuffix, required this.model, required this.consent}): super._();
  

/// 4 karakter terakhir key (untuk ditampilkan), `null` bila belum ada.
@override final  String? keySuffix;
@override final  String model;
@override final  bool consent;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSettingsCopyWith<_AiSettings> get copyWith => __$AiSettingsCopyWithImpl<_AiSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSettings&&(identical(other.keySuffix, keySuffix) || other.keySuffix == keySuffix)&&(identical(other.model, model) || other.model == model)&&(identical(other.consent, consent) || other.consent == consent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keySuffix,model,consent);
}

@override
String toString() {
    return 'AiSettings(keySuffix: $keySuffix, model: $model, consent: $consent)';
}


}

/// @nodoc
abstract mixin class _$AiSettingsCopyWith<$Res> implements $AiSettingsCopyWith<$Res> {
  factory _$AiSettingsCopyWith(_AiSettings value, $Res Function(_AiSettings) _then) = __$AiSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? keySuffix, String model, bool consent
});




}
/// @nodoc
class __$AiSettingsCopyWithImpl<$Res>
    implements _$AiSettingsCopyWith<$Res> {
  __$AiSettingsCopyWithImpl(this._self, this._then);

  final _AiSettings _self;
  final $Res Function(_AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keySuffix = freezed,Object? model = null,Object? consent = null,}) {
  return _then(_AiSettings(
keySuffix: freezed == keySuffix ? _self.keySuffix : keySuffix // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,consent: null == consent ? _self.consent : consent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
