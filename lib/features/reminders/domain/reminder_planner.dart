import 'package:timezone/timezone.dart' as tz;

import '../../../core/utils/formatters.dart';
import '../../workout/domain/entities/workout.dart';
import 'notification_settings.dart';

enum ReminderCategory { workout, breakfast, lunch, dinner, snack, weighIn, dailyCheckIn }

/// Satu notifikasi terjadwal yang diinginkan.
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.category,
    required this.when,
    required this.route,
    this.day,
  });

  final int id;
  final ReminderCategory category;
  final tz.TZDateTime when;

  /// Rute aplikasi yang dibuka saat notifikasi diketuk.
  final String route;

  /// Hari program (untuk teks pengingat latihan).
  final PlanDay? day;

  @override
  String toString() => 'PlannedReminder(${category.name} $when #$id)';
}

/// Penyusun jadwal pengingat — fungsi murni & deterministik.
///
/// - Jendela [horizonDays] hari ke depan (iOS hanya menyimpan 64 notifikasi
///   tertunda → maks. [maxPending], prioritas yang paling dekat).
/// - ID stabil dari kategori + entitas + tanggal (hash FNV-1a 31-bit) sehingga
///   penjadwalan ulang menimpa, bukan menduplikasi.
/// - Pengingat latihan hanya pada hari program aktif; hari yang sesinya sudah
///   selesai dilewati.
/// - Waktu yang jatuh di quiet hours dilewati (tidak digeser).
abstract final class ReminderPlanner {
  static const horizonDays = 14;
  static const maxPending = 60;

  /// FNV-1a 32-bit, dipotong ke 31-bit positif (ID notifikasi Android: int32).
  static int stableId(String key) {
    var hash = 0x811c9dc5;
    for (final unit in key.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }

  static bool inQuietHours(QuietHours q, int hour, int minute) {
    if (!q.enabled) return false;
    final s = TimeOfDayCodec.parse(q.start);
    final e = TimeOfDayCodec.parse(q.end);
    final t = hour * 60 + minute;
    final start = s.hour * 60 + s.minute;
    final end = e.hour * 60 + e.minute;
    if (start == end) return false;
    // Rentang melewati tengah malam (mis. 22:00–06:00).
    return start < end ? t >= start && t < end : t >= start || t < end;
  }

  static List<PlannedReminder> build({
    required NotificationSettings settings,
    required tz.TZDateTime now,
    String? planId,
    List<PlanDay> planDays = const [],
    Set<String> completedWorkoutDates = const {},

    /// Tanggal yang sudah punya check-in → pengingat check-in dilewati.
    Set<String> checkedInDates = const {},
    int horizon = horizonDays,
    int max = maxPending,
  }) {
    if (!settings.enabled) return const [];
    final location = now.location;
    final result = <PlannedReminder>[];

    void add(
      ReminderCategory category,
      String entity,
      tz.TZDateTime date,
      TimedReminder r,
      String route, {
      PlanDay? day,
    }) {
      if (!r.enabled) return;
      final t = TimeOfDayCodec.parse(r.time);
      if (inQuietHours(settings.quietHours, t.hour, t.minute)) return;
      // Konstruktor kalender (bukan Duration) → aman terhadap DST.
      final when = tz.TZDateTime(location, date.year, date.month, date.day, t.hour, t.minute);
      if (!when.isAfter(now)) return;
      final dateKey = Fmt.toIsoDate(when);
      result.add(
        PlannedReminder(
          id: stableId('${category.name}|$entity|$dateKey'),
          category: category,
          when: when,
          route: route,
          day: day,
        ),
      );
    }

    final byWeekday = {for (final d in planDays) d.weekday: d};
    for (var i = 0; i < horizon; i++) {
      final date = tz.TZDateTime(location, now.year, now.month, now.day + i);
      final iso = Fmt.toIsoDate(date);

      final day = byWeekday[date.weekday];
      if (planId != null && day != null && !completedWorkoutDates.contains(iso)) {
        add(
          ReminderCategory.workout,
          '$planId/${day.id}',
          date,
          settings.workout,
          '/day/$planId/${day.id}',
          day: day,
        );
      }
      final m = settings.meals;
      add(ReminderCategory.breakfast, 'meal', date, m.breakfast, '/nutrition');
      add(ReminderCategory.lunch, 'meal', date, m.lunch, '/nutrition');
      add(ReminderCategory.dinner, 'meal', date, m.dinner, '/nutrition');
      add(ReminderCategory.snack, 'meal', date, m.snack, '/nutrition');
      if (settings.weighIn.daysOfWeek.contains(date.weekday)) {
        add(
          ReminderCategory.weighIn,
          'weigh',
          date,
          TimedReminder(enabled: settings.weighIn.enabled, time: settings.weighIn.time),
          '/progress',
        );
      }
      if (!checkedInDates.contains(iso)) {
        add(
          ReminderCategory.dailyCheckIn,
          'checkin',
          date,
          settings.dailyCheckIn,
          '/check-in/$iso',
        );
      }
    }

    result.sort((a, b) => a.when.compareTo(b.when));
    return result.length <= max ? result : result.sublist(0, max);
  }
}
