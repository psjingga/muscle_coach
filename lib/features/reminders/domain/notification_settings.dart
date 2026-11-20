import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// Pengingat dengan jam lokal `HH:mm`.
@freezed
abstract class TimedReminder with _$TimedReminder {
  const factory TimedReminder({required bool enabled, required String time}) = _TimedReminder;

  factory TimedReminder.fromJson(Map<String, dynamic> json) => _$TimedReminderFromJson(json);
}

/// Pengingat pada hari tertentu (ISO 1 = Senin … 7 = Minggu).
@freezed
abstract class WeeklyReminder with _$WeeklyReminder {
  const factory WeeklyReminder({
    required bool enabled,
    required List<int> daysOfWeek,
    required String time,
  }) = _WeeklyReminder;

  factory WeeklyReminder.fromJson(Map<String, dynamic> json) => _$WeeklyReminderFromJson(json);
}

@freezed
abstract class QuietHours with _$QuietHours {
  const factory QuietHours({required bool enabled, required String start, required String end}) =
      _QuietHours;

  factory QuietHours.fromJson(Map<String, dynamic> json) => _$QuietHoursFromJson(json);
}

@freezed
abstract class MealReminders with _$MealReminders {
  const factory MealReminders({
    required TimedReminder breakfast,
    required TimedReminder lunch,
    required TimedReminder dinner,
    required TimedReminder snack,
  }) = _MealReminders;

  factory MealReminders.fromJson(Map<String, dynamic> json) => _$MealRemindersFromJson(json);
}

/// Preferensi pengingat (brief §15). Jadwal OS bukan sumber kebenaran —
/// selalu dibangun ulang dari preferensi ini + program aktif.
/// Hari latihan diambil dari program aktif; di sini hanya jamnya.
@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    /// Saklar utama (default mati sampai pengguna mengaktifkan & memberi izin).
    @Default(false) bool enabled,

    /// Zona waktu IANA terakhir yang dipakai (informasi; jadwal mengikuti perangkat).
    String? timezone,
    @Default(TimedReminder(enabled: true, time: '17:00')) TimedReminder workout,
    @Default(
      MealReminders(
        breakfast: TimedReminder(enabled: true, time: '07:00'),
        lunch: TimedReminder(enabled: true, time: '12:00'),
        dinner: TimedReminder(enabled: true, time: '19:00'),
        snack: TimedReminder(enabled: false, time: '15:00'),
      ),
    )
    MealReminders meals,
    @Default(WeeklyReminder(enabled: true, daysOfWeek: [1], time: '07:00')) WeeklyReminder weighIn,
    @Default(TimedReminder(enabled: true, time: '21:00')) TimedReminder dailyCheckIn,
    @Default(QuietHours(enabled: false, start: '22:00', end: '06:00')) QuietHours quietHours,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// Jam `HH:mm` (00:00–23:59).
typedef ClockTime = ({int hour, int minute});

abstract final class TimeOfDayCodec {
  static final _re = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');

  static bool isValid(String v) => _re.hasMatch(v);

  static ClockTime parse(String v) {
    final m = _re.firstMatch(v);
    if (m == null) throw FormatException('Jam tidak valid: $v');
    return (hour: int.parse(m.group(1)!), minute: int.parse(m.group(2)!));
  }

  static String format(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Validasi domain preferensi; daftar masalah (kosong = valid).
List<String> validateNotificationSettings(NotificationSettings s) => [
  for (final (name, t) in [
    ('workout', s.workout.time),
    ('breakfast', s.meals.breakfast.time),
    ('lunch', s.meals.lunch.time),
    ('dinner', s.meals.dinner.time),
    ('snack', s.meals.snack.time),
    ('weighIn', s.weighIn.time),
    ('dailyCheckIn', s.dailyCheckIn.time),
    ('quietStart', s.quietHours.start),
    ('quietEnd', s.quietHours.end),
  ])
    if (!TimeOfDayCodec.isValid(t)) '$name: jam tidak valid',
  if (s.weighIn.daysOfWeek.any((d) => d < 1 || d > 7)) 'weighIn: hari harus 1–7',
  if (s.weighIn.enabled && s.weighIn.daysOfWeek.isEmpty) 'weighIn: pilih minimal satu hari',
];
