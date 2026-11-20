// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimedReminder _$TimedReminderFromJson(Map<String, dynamic> json) =>
    _TimedReminder(enabled: json['enabled'] as bool, time: json['time'] as String);

Map<String, dynamic> _$TimedReminderToJson(_TimedReminder instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'time': instance.time,
};

_WeeklyReminder _$WeeklyReminderFromJson(Map<String, dynamic> json) => _WeeklyReminder(
  enabled: json['enabled'] as bool,
  daysOfWeek: (json['daysOfWeek'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  time: json['time'] as String,
);

Map<String, dynamic> _$WeeklyReminderToJson(_WeeklyReminder instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'daysOfWeek': instance.daysOfWeek,
  'time': instance.time,
};

_QuietHours _$QuietHoursFromJson(Map<String, dynamic> json) => _QuietHours(
  enabled: json['enabled'] as bool,
  start: json['start'] as String,
  end: json['end'] as String,
);

Map<String, dynamic> _$QuietHoursToJson(_QuietHours instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'start': instance.start,
  'end': instance.end,
};

_MealReminders _$MealRemindersFromJson(Map<String, dynamic> json) => _MealReminders(
  breakfast: TimedReminder.fromJson(json['breakfast'] as Map<String, dynamic>),
  lunch: TimedReminder.fromJson(json['lunch'] as Map<String, dynamic>),
  dinner: TimedReminder.fromJson(json['dinner'] as Map<String, dynamic>),
  snack: TimedReminder.fromJson(json['snack'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MealRemindersToJson(_MealReminders instance) => <String, dynamic>{
  'breakfast': instance.breakfast.toJson(),
  'lunch': instance.lunch.toJson(),
  'dinner': instance.dinner.toJson(),
  'snack': instance.snack.toJson(),
};

_NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) =>
    _NotificationSettings(
      enabled: json['enabled'] as bool? ?? false,
      timezone: json['timezone'] as String?,
      workout: json['workout'] == null
          ? const TimedReminder(enabled: true, time: '17:00')
          : TimedReminder.fromJson(json['workout'] as Map<String, dynamic>),
      meals: json['meals'] == null
          ? const MealReminders(
              breakfast: TimedReminder(enabled: true, time: '07:00'),
              lunch: TimedReminder(enabled: true, time: '12:00'),
              dinner: TimedReminder(enabled: true, time: '19:00'),
              snack: TimedReminder(enabled: false, time: '15:00'),
            )
          : MealReminders.fromJson(json['meals'] as Map<String, dynamic>),
      weighIn: json['weighIn'] == null
          ? const WeeklyReminder(enabled: true, daysOfWeek: [1], time: '07:00')
          : WeeklyReminder.fromJson(json['weighIn'] as Map<String, dynamic>),
      dailyCheckIn: json['dailyCheckIn'] == null
          ? const TimedReminder(enabled: true, time: '21:00')
          : TimedReminder.fromJson(json['dailyCheckIn'] as Map<String, dynamic>),
      quietHours: json['quietHours'] == null
          ? const QuietHours(enabled: false, start: '22:00', end: '06:00')
          : QuietHours.fromJson(json['quietHours'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationSettingsToJson(_NotificationSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'timezone': instance.timezone,
      'workout': instance.workout.toJson(),
      'meals': instance.meals.toJson(),
      'weighIn': instance.weighIn.toJson(),
      'dailyCheckIn': instance.dailyCheckIn.toJson(),
      'quietHours': instance.quietHours.toJson(),
    };
