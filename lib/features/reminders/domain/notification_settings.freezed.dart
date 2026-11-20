// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimedReminder {

 bool get enabled; String get time;
/// Create a copy of TimedReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<TimedReminder> get copyWith => _$TimedReminderCopyWithImpl<TimedReminder>(this as TimedReminder, _$identity);

  /// Serializes this TimedReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimedReminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimedReminder&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.time, _this.time) || other.time == _this.time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimedReminder;
  return Object.hash(runtimeType,_this.enabled,_this.time);
}

@override
String toString() {
  final _this = this as TimedReminder;
  return 'TimedReminder(enabled: ${_this.enabled}, time: ${_this.time})';
}


}

/// @nodoc
abstract mixin class $TimedReminderCopyWith<$Res>  {
  factory $TimedReminderCopyWith(TimedReminder value, $Res Function(TimedReminder) _then) = _$TimedReminderCopyWithImpl;
@useResult
$Res call({
 bool enabled, String time
});




}
/// @nodoc
class _$TimedReminderCopyWithImpl<$Res>
    implements $TimedReminderCopyWith<$Res> {
  _$TimedReminderCopyWithImpl(this._self, this._then);

  final TimedReminder _self;
  final $Res Function(TimedReminder) _then;

/// Create a copy of TimedReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? time = null,}) {
  return _then(TimedReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimedReminder].
extension TimedReminderPatterns on TimedReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimedReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimedReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimedReminder value)  $default,){
final _that = this;
switch (_that) {
case _TimedReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimedReminder value)?  $default,){
final _that = this;
switch (_that) {
case _TimedReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  String time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimedReminder() when $default != null:
return $default(_that.enabled,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  String time)  $default,) {final _that = this;
switch (_that) {
case _TimedReminder():
return $default(_that.enabled,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  String time)?  $default,) {final _that = this;
switch (_that) {
case _TimedReminder() when $default != null:
return $default(_that.enabled,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimedReminder implements TimedReminder {
  const _TimedReminder({required this.enabled, required this.time});
  factory _TimedReminder.fromJson(Map<String, dynamic> json) => _$TimedReminderFromJson(json);

@override final  bool enabled;
@override final  String time;

/// Create a copy of TimedReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimedReminderCopyWith<_TimedReminder> get copyWith => __$TimedReminderCopyWithImpl<_TimedReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimedReminderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimedReminder&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,time);
}

@override
String toString() {
    return 'TimedReminder(enabled: $enabled, time: $time)';
}


}

/// @nodoc
abstract mixin class _$TimedReminderCopyWith<$Res> implements $TimedReminderCopyWith<$Res> {
  factory _$TimedReminderCopyWith(_TimedReminder value, $Res Function(_TimedReminder) _then) = __$TimedReminderCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String time
});




}
/// @nodoc
class __$TimedReminderCopyWithImpl<$Res>
    implements _$TimedReminderCopyWith<$Res> {
  __$TimedReminderCopyWithImpl(this._self, this._then);

  final _TimedReminder _self;
  final $Res Function(_TimedReminder) _then;

/// Create a copy of TimedReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? time = null,}) {
  return _then(_TimedReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WeeklyReminder {

 bool get enabled; List<int> get daysOfWeek; String get time;
/// Create a copy of WeeklyReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyReminderCopyWith<WeeklyReminder> get copyWith => _$WeeklyReminderCopyWithImpl<WeeklyReminder>(this as WeeklyReminder, _$identity);

  /// Serializes this WeeklyReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeeklyReminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyReminder&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&const DeepCollectionEquality().equals(other.daysOfWeek, _this.daysOfWeek)&&(identical(other.time, _this.time) || other.time == _this.time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeeklyReminder;
  return Object.hash(runtimeType,_this.enabled,const DeepCollectionEquality().hash(_this.daysOfWeek),_this.time);
}

@override
String toString() {
  final _this = this as WeeklyReminder;
  return 'WeeklyReminder(enabled: ${_this.enabled}, daysOfWeek: ${_this.daysOfWeek}, time: ${_this.time})';
}


}

/// @nodoc
abstract mixin class $WeeklyReminderCopyWith<$Res>  {
  factory $WeeklyReminderCopyWith(WeeklyReminder value, $Res Function(WeeklyReminder) _then) = _$WeeklyReminderCopyWithImpl;
@useResult
$Res call({
 bool enabled, List<int> daysOfWeek, String time
});




}
/// @nodoc
class _$WeeklyReminderCopyWithImpl<$Res>
    implements $WeeklyReminderCopyWith<$Res> {
  _$WeeklyReminderCopyWithImpl(this._self, this._then);

  final WeeklyReminder _self;
  final $Res Function(WeeklyReminder) _then;

/// Create a copy of WeeklyReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? daysOfWeek = null,Object? time = null,}) {
  return _then(WeeklyReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,daysOfWeek: null == daysOfWeek ? _self.daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyReminder].
extension WeeklyReminderPatterns on WeeklyReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyReminder value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyReminder value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  List<int> daysOfWeek,  String time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyReminder() when $default != null:
return $default(_that.enabled,_that.daysOfWeek,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  List<int> daysOfWeek,  String time)  $default,) {final _that = this;
switch (_that) {
case _WeeklyReminder():
return $default(_that.enabled,_that.daysOfWeek,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  List<int> daysOfWeek,  String time)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyReminder() when $default != null:
return $default(_that.enabled,_that.daysOfWeek,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyReminder implements WeeklyReminder {
  const _WeeklyReminder({required this.enabled, required  List<int> daysOfWeek, required this.time}): _daysOfWeek = daysOfWeek;
  factory _WeeklyReminder.fromJson(Map<String, dynamic> json) => _$WeeklyReminderFromJson(json);

@override final  bool enabled;
 final  List<int> _daysOfWeek;
@override List<int> get daysOfWeek {
  if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysOfWeek);
}

@override final  String time;

/// Create a copy of WeeklyReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyReminderCopyWith<_WeeklyReminder> get copyWith => __$WeeklyReminderCopyWithImpl<_WeeklyReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyReminderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyReminder&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.daysOfWeek, _daysOfWeek)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(_daysOfWeek),time);
}

@override
String toString() {
    return 'WeeklyReminder(enabled: $enabled, daysOfWeek: $daysOfWeek, time: $time)';
}


}

/// @nodoc
abstract mixin class _$WeeklyReminderCopyWith<$Res> implements $WeeklyReminderCopyWith<$Res> {
  factory _$WeeklyReminderCopyWith(_WeeklyReminder value, $Res Function(_WeeklyReminder) _then) = __$WeeklyReminderCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, List<int> daysOfWeek, String time
});




}
/// @nodoc
class __$WeeklyReminderCopyWithImpl<$Res>
    implements _$WeeklyReminderCopyWith<$Res> {
  __$WeeklyReminderCopyWithImpl(this._self, this._then);

  final _WeeklyReminder _self;
  final $Res Function(_WeeklyReminder) _then;

/// Create a copy of WeeklyReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? daysOfWeek = null,Object? time = null,}) {
  return _then(_WeeklyReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,daysOfWeek: null == daysOfWeek ? _self._daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuietHours {

 bool get enabled; String get start; String get end;
/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuietHoursCopyWith<QuietHours> get copyWith => _$QuietHoursCopyWithImpl<QuietHours>(this as QuietHours, _$identity);

  /// Serializes this QuietHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuietHours;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuietHours&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuietHours;
  return Object.hash(runtimeType,_this.enabled,_this.start,_this.end);
}

@override
String toString() {
  final _this = this as QuietHours;
  return 'QuietHours(enabled: ${_this.enabled}, start: ${_this.start}, end: ${_this.end})';
}


}

/// @nodoc
abstract mixin class $QuietHoursCopyWith<$Res>  {
  factory $QuietHoursCopyWith(QuietHours value, $Res Function(QuietHours) _then) = _$QuietHoursCopyWithImpl;
@useResult
$Res call({
 bool enabled, String start, String end
});




}
/// @nodoc
class _$QuietHoursCopyWithImpl<$Res>
    implements $QuietHoursCopyWith<$Res> {
  _$QuietHoursCopyWithImpl(this._self, this._then);

  final QuietHours _self;
  final $Res Function(QuietHours) _then;

/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? start = null,Object? end = null,}) {
  return _then(QuietHours(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuietHours].
extension QuietHoursPatterns on QuietHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuietHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuietHours value)  $default,){
final _that = this;
switch (_that) {
case _QuietHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuietHours value)?  $default,){
final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  String start,  String end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
return $default(_that.enabled,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  String start,  String end)  $default,) {final _that = this;
switch (_that) {
case _QuietHours():
return $default(_that.enabled,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  String start,  String end)?  $default,) {final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
return $default(_that.enabled,_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuietHours implements QuietHours {
  const _QuietHours({required this.enabled, required this.start, required this.end});
  factory _QuietHours.fromJson(Map<String, dynamic> json) => _$QuietHoursFromJson(json);

@override final  bool enabled;
@override final  String start;
@override final  String end;

/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuietHoursCopyWith<_QuietHours> get copyWith => __$QuietHoursCopyWithImpl<_QuietHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuietHoursToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuietHours&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,start,end);
}

@override
String toString() {
    return 'QuietHours(enabled: $enabled, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$QuietHoursCopyWith<$Res> implements $QuietHoursCopyWith<$Res> {
  factory _$QuietHoursCopyWith(_QuietHours value, $Res Function(_QuietHours) _then) = __$QuietHoursCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String start, String end
});




}
/// @nodoc
class __$QuietHoursCopyWithImpl<$Res>
    implements _$QuietHoursCopyWith<$Res> {
  __$QuietHoursCopyWithImpl(this._self, this._then);

  final _QuietHours _self;
  final $Res Function(_QuietHours) _then;

/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? start = null,Object? end = null,}) {
  return _then(_QuietHours(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MealReminders {

 TimedReminder get breakfast; TimedReminder get lunch; TimedReminder get dinner; TimedReminder get snack;
/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealRemindersCopyWith<MealReminders> get copyWith => _$MealRemindersCopyWithImpl<MealReminders>(this as MealReminders, _$identity);

  /// Serializes this MealReminders to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MealReminders;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealReminders&&(identical(other.breakfast, _this.breakfast) || other.breakfast == _this.breakfast)&&(identical(other.lunch, _this.lunch) || other.lunch == _this.lunch)&&(identical(other.dinner, _this.dinner) || other.dinner == _this.dinner)&&(identical(other.snack, _this.snack) || other.snack == _this.snack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MealReminders;
  return Object.hash(runtimeType,_this.breakfast,_this.lunch,_this.dinner,_this.snack);
}

@override
String toString() {
  final _this = this as MealReminders;
  return 'MealReminders(breakfast: ${_this.breakfast}, lunch: ${_this.lunch}, dinner: ${_this.dinner}, snack: ${_this.snack})';
}


}

/// @nodoc
abstract mixin class $MealRemindersCopyWith<$Res>  {
  factory $MealRemindersCopyWith(MealReminders value, $Res Function(MealReminders) _then) = _$MealRemindersCopyWithImpl;
@useResult
$Res call({
 TimedReminder breakfast, TimedReminder lunch, TimedReminder dinner, TimedReminder snack
});


$TimedReminderCopyWith<$Res> get breakfast;$TimedReminderCopyWith<$Res> get lunch;$TimedReminderCopyWith<$Res> get dinner;$TimedReminderCopyWith<$Res> get snack;

}
/// @nodoc
class _$MealRemindersCopyWithImpl<$Res>
    implements $MealRemindersCopyWith<$Res> {
  _$MealRemindersCopyWithImpl(this._self, this._then);

  final MealReminders _self;
  final $Res Function(MealReminders) _then;

/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? breakfast = null,Object? lunch = null,Object? dinner = null,Object? snack = null,}) {
  return _then(MealReminders(
breakfast: null == breakfast ? _self.breakfast : breakfast // ignore: cast_nullable_to_non_nullable
as TimedReminder,lunch: null == lunch ? _self.lunch : lunch // ignore: cast_nullable_to_non_nullable
as TimedReminder,dinner: null == dinner ? _self.dinner : dinner // ignore: cast_nullable_to_non_nullable
as TimedReminder,snack: null == snack ? _self.snack : snack // ignore: cast_nullable_to_non_nullable
as TimedReminder,
  ));
}
/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get breakfast {
  
  return $TimedReminderCopyWith<$Res>(_self.breakfast, (value) {
    return _then(_self.copyWith(breakfast: value));
  });
}/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get lunch {
  
  return $TimedReminderCopyWith<$Res>(_self.lunch, (value) {
    return _then(_self.copyWith(lunch: value));
  });
}/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get dinner {
  
  return $TimedReminderCopyWith<$Res>(_self.dinner, (value) {
    return _then(_self.copyWith(dinner: value));
  });
}/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get snack {
  
  return $TimedReminderCopyWith<$Res>(_self.snack, (value) {
    return _then(_self.copyWith(snack: value));
  });
}
}


/// Adds pattern-matching-related methods to [MealReminders].
extension MealRemindersPatterns on MealReminders {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealReminders value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealReminders() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealReminders value)  $default,){
final _that = this;
switch (_that) {
case _MealReminders():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealReminders value)?  $default,){
final _that = this;
switch (_that) {
case _MealReminders() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimedReminder breakfast,  TimedReminder lunch,  TimedReminder dinner,  TimedReminder snack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealReminders() when $default != null:
return $default(_that.breakfast,_that.lunch,_that.dinner,_that.snack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimedReminder breakfast,  TimedReminder lunch,  TimedReminder dinner,  TimedReminder snack)  $default,) {final _that = this;
switch (_that) {
case _MealReminders():
return $default(_that.breakfast,_that.lunch,_that.dinner,_that.snack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimedReminder breakfast,  TimedReminder lunch,  TimedReminder dinner,  TimedReminder snack)?  $default,) {final _that = this;
switch (_that) {
case _MealReminders() when $default != null:
return $default(_that.breakfast,_that.lunch,_that.dinner,_that.snack);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealReminders implements MealReminders {
  const _MealReminders({required this.breakfast, required this.lunch, required this.dinner, required this.snack});
  factory _MealReminders.fromJson(Map<String, dynamic> json) => _$MealRemindersFromJson(json);

@override final  TimedReminder breakfast;
@override final  TimedReminder lunch;
@override final  TimedReminder dinner;
@override final  TimedReminder snack;

/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealRemindersCopyWith<_MealReminders> get copyWith => __$MealRemindersCopyWithImpl<_MealReminders>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealRemindersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealReminders&&(identical(other.breakfast, breakfast) || other.breakfast == breakfast)&&(identical(other.lunch, lunch) || other.lunch == lunch)&&(identical(other.dinner, dinner) || other.dinner == dinner)&&(identical(other.snack, snack) || other.snack == snack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,breakfast,lunch,dinner,snack);
}

@override
String toString() {
    return 'MealReminders(breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snack: $snack)';
}


}

/// @nodoc
abstract mixin class _$MealRemindersCopyWith<$Res> implements $MealRemindersCopyWith<$Res> {
  factory _$MealRemindersCopyWith(_MealReminders value, $Res Function(_MealReminders) _then) = __$MealRemindersCopyWithImpl;
@override @useResult
$Res call({
 TimedReminder breakfast, TimedReminder lunch, TimedReminder dinner, TimedReminder snack
});


@override $TimedReminderCopyWith<$Res> get breakfast;@override $TimedReminderCopyWith<$Res> get lunch;@override $TimedReminderCopyWith<$Res> get dinner;@override $TimedReminderCopyWith<$Res> get snack;

}
/// @nodoc
class __$MealRemindersCopyWithImpl<$Res>
    implements _$MealRemindersCopyWith<$Res> {
  __$MealRemindersCopyWithImpl(this._self, this._then);

  final _MealReminders _self;
  final $Res Function(_MealReminders) _then;

/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? breakfast = null,Object? lunch = null,Object? dinner = null,Object? snack = null,}) {
  return _then(_MealReminders(
breakfast: null == breakfast ? _self.breakfast : breakfast // ignore: cast_nullable_to_non_nullable
as TimedReminder,lunch: null == lunch ? _self.lunch : lunch // ignore: cast_nullable_to_non_nullable
as TimedReminder,dinner: null == dinner ? _self.dinner : dinner // ignore: cast_nullable_to_non_nullable
as TimedReminder,snack: null == snack ? _self.snack : snack // ignore: cast_nullable_to_non_nullable
as TimedReminder,
  ));
}

/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get breakfast {
  
  return $TimedReminderCopyWith<$Res>(_self.breakfast, (value) {
    return _then(_self.copyWith(breakfast: value));
  });
}/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get lunch {
  
  return $TimedReminderCopyWith<$Res>(_self.lunch, (value) {
    return _then(_self.copyWith(lunch: value));
  });
}/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get dinner {
  
  return $TimedReminderCopyWith<$Res>(_self.dinner, (value) {
    return _then(_self.copyWith(dinner: value));
  });
}/// Create a copy of MealReminders
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get snack {
  
  return $TimedReminderCopyWith<$Res>(_self.snack, (value) {
    return _then(_self.copyWith(snack: value));
  });
}
}


/// @nodoc
mixin _$NotificationSettings {

/// Saklar utama (default mati sampai pengguna mengaktifkan & memberi izin).
 bool get enabled;/// Zona waktu IANA terakhir yang dipakai (informasi; jadwal mengikuti perangkat).
 String? get timezone; TimedReminder get workout; MealReminders get meals; WeeklyReminder get weighIn; TimedReminder get dailyCheckIn; QuietHours get quietHours;
/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsCopyWith<NotificationSettings> get copyWith => _$NotificationSettingsCopyWithImpl<NotificationSettings>(this as NotificationSettings, _$identity);

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettings&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.workout, _this.workout) || other.workout == _this.workout)&&(identical(other.meals, _this.meals) || other.meals == _this.meals)&&(identical(other.weighIn, _this.weighIn) || other.weighIn == _this.weighIn)&&(identical(other.dailyCheckIn, _this.dailyCheckIn) || other.dailyCheckIn == _this.dailyCheckIn)&&(identical(other.quietHours, _this.quietHours) || other.quietHours == _this.quietHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationSettings;
  return Object.hash(runtimeType,_this.enabled,_this.timezone,_this.workout,_this.meals,_this.weighIn,_this.dailyCheckIn,_this.quietHours);
}

@override
String toString() {
  final _this = this as NotificationSettings;
  return 'NotificationSettings(enabled: ${_this.enabled}, timezone: ${_this.timezone}, workout: ${_this.workout}, meals: ${_this.meals}, weighIn: ${_this.weighIn}, dailyCheckIn: ${_this.dailyCheckIn}, quietHours: ${_this.quietHours})';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsCopyWith<$Res>  {
  factory $NotificationSettingsCopyWith(NotificationSettings value, $Res Function(NotificationSettings) _then) = _$NotificationSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, String? timezone, TimedReminder workout, MealReminders meals, WeeklyReminder weighIn, TimedReminder dailyCheckIn, QuietHours quietHours
});


$TimedReminderCopyWith<$Res> get workout;$MealRemindersCopyWith<$Res> get meals;$WeeklyReminderCopyWith<$Res> get weighIn;$TimedReminderCopyWith<$Res> get dailyCheckIn;$QuietHoursCopyWith<$Res> get quietHours;

}
/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._self, this._then);

  final NotificationSettings _self;
  final $Res Function(NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? timezone = freezed,Object? workout = null,Object? meals = null,Object? weighIn = null,Object? dailyCheckIn = null,Object? quietHours = null,}) {
  return _then(NotificationSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,workout: null == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as TimedReminder,meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as MealReminders,weighIn: null == weighIn ? _self.weighIn : weighIn // ignore: cast_nullable_to_non_nullable
as WeeklyReminder,dailyCheckIn: null == dailyCheckIn ? _self.dailyCheckIn : dailyCheckIn // ignore: cast_nullable_to_non_nullable
as TimedReminder,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHours,
  ));
}
/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get workout {
  
  return $TimedReminderCopyWith<$Res>(_self.workout, (value) {
    return _then(_self.copyWith(workout: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealRemindersCopyWith<$Res> get meals {
  
  return $MealRemindersCopyWith<$Res>(_self.meals, (value) {
    return _then(_self.copyWith(meals: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyReminderCopyWith<$Res> get weighIn {
  
  return $WeeklyReminderCopyWith<$Res>(_self.weighIn, (value) {
    return _then(_self.copyWith(weighIn: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get dailyCheckIn {
  
  return $TimedReminderCopyWith<$Res>(_self.dailyCheckIn, (value) {
    return _then(_self.copyWith(dailyCheckIn: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursCopyWith<$Res> get quietHours {
  
  return $QuietHoursCopyWith<$Res>(_self.quietHours, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationSettings].
extension NotificationSettingsPatterns on NotificationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettings value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  String? timezone,  TimedReminder workout,  MealReminders meals,  WeeklyReminder weighIn,  TimedReminder dailyCheckIn,  QuietHours quietHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.enabled,_that.timezone,_that.workout,_that.meals,_that.weighIn,_that.dailyCheckIn,_that.quietHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  String? timezone,  TimedReminder workout,  MealReminders meals,  WeeklyReminder weighIn,  TimedReminder dailyCheckIn,  QuietHours quietHours)  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings():
return $default(_that.enabled,_that.timezone,_that.workout,_that.meals,_that.weighIn,_that.dailyCheckIn,_that.quietHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  String? timezone,  TimedReminder workout,  MealReminders meals,  WeeklyReminder weighIn,  TimedReminder dailyCheckIn,  QuietHours quietHours)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.enabled,_that.timezone,_that.workout,_that.meals,_that.weighIn,_that.dailyCheckIn,_that.quietHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSettings implements NotificationSettings {
  const _NotificationSettings({this.enabled = false, this.timezone, this.workout = const TimedReminder(enabled: true, time: '17:00'), this.meals = const MealReminders(breakfast: TimedReminder(enabled: true, time: '07:00'), lunch: TimedReminder(enabled: true, time: '12:00'), dinner: TimedReminder(enabled: true, time: '19:00'), snack: TimedReminder(enabled: false, time: '15:00')), this.weighIn = const WeeklyReminder(enabled: true, daysOfWeek: [1], time: '07:00'), this.dailyCheckIn = const TimedReminder(enabled: true, time: '21:00'), this.quietHours = const QuietHours(enabled: false, start: '22:00', end: '06:00')});
  factory _NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);

/// Saklar utama (default mati sampai pengguna mengaktifkan & memberi izin).
@override@JsonKey() final  bool enabled;
/// Zona waktu IANA terakhir yang dipakai (informasi; jadwal mengikuti perangkat).
@override final  String? timezone;
@override@JsonKey() final  TimedReminder workout;
@override@JsonKey() final  MealReminders meals;
@override@JsonKey() final  WeeklyReminder weighIn;
@override@JsonKey() final  TimedReminder dailyCheckIn;
@override@JsonKey() final  QuietHours quietHours;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsCopyWith<_NotificationSettings> get copyWith => __$NotificationSettingsCopyWithImpl<_NotificationSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.workout, workout) || other.workout == workout)&&(identical(other.meals, meals) || other.meals == meals)&&(identical(other.weighIn, weighIn) || other.weighIn == weighIn)&&(identical(other.dailyCheckIn, dailyCheckIn) || other.dailyCheckIn == dailyCheckIn)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,timezone,workout,meals,weighIn,dailyCheckIn,quietHours);
}

@override
String toString() {
    return 'NotificationSettings(enabled: $enabled, timezone: $timezone, workout: $workout, meals: $meals, weighIn: $weighIn, dailyCheckIn: $dailyCheckIn, quietHours: $quietHours)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsCopyWith<$Res> implements $NotificationSettingsCopyWith<$Res> {
  factory _$NotificationSettingsCopyWith(_NotificationSettings value, $Res Function(_NotificationSettings) _then) = __$NotificationSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String? timezone, TimedReminder workout, MealReminders meals, WeeklyReminder weighIn, TimedReminder dailyCheckIn, QuietHours quietHours
});


@override $TimedReminderCopyWith<$Res> get workout;@override $MealRemindersCopyWith<$Res> get meals;@override $WeeklyReminderCopyWith<$Res> get weighIn;@override $TimedReminderCopyWith<$Res> get dailyCheckIn;@override $QuietHoursCopyWith<$Res> get quietHours;

}
/// @nodoc
class __$NotificationSettingsCopyWithImpl<$Res>
    implements _$NotificationSettingsCopyWith<$Res> {
  __$NotificationSettingsCopyWithImpl(this._self, this._then);

  final _NotificationSettings _self;
  final $Res Function(_NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? timezone = freezed,Object? workout = null,Object? meals = null,Object? weighIn = null,Object? dailyCheckIn = null,Object? quietHours = null,}) {
  return _then(_NotificationSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,workout: null == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as TimedReminder,meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as MealReminders,weighIn: null == weighIn ? _self.weighIn : weighIn // ignore: cast_nullable_to_non_nullable
as WeeklyReminder,dailyCheckIn: null == dailyCheckIn ? _self.dailyCheckIn : dailyCheckIn // ignore: cast_nullable_to_non_nullable
as TimedReminder,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHours,
  ));
}

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get workout {
  
  return $TimedReminderCopyWith<$Res>(_self.workout, (value) {
    return _then(_self.copyWith(workout: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealRemindersCopyWith<$Res> get meals {
  
  return $MealRemindersCopyWith<$Res>(_self.meals, (value) {
    return _then(_self.copyWith(meals: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyReminderCopyWith<$Res> get weighIn {
  
  return $WeeklyReminderCopyWith<$Res>(_self.weighIn, (value) {
    return _then(_self.copyWith(weighIn: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimedReminderCopyWith<$Res> get dailyCheckIn {
  
  return $TimedReminderCopyWith<$Res>(_self.dailyCheckIn, (value) {
    return _then(_self.copyWith(dailyCheckIn: value));
  });
}/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursCopyWith<$Res> get quietHours {
  
  return $QuietHoursCopyWith<$Res>(_self.quietHours, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}
}

// dart format on
