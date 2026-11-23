import 'package:timezone/timezone.dart' as tz;

import '../../../core/logging/app_logger.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../workout/data/workout_repository.dart';
import '../../workout/domain/entities/workout.dart';
import '../../assessment/presentation/widgets/assessment_labels.dart';
import '../../workout/presentation/widgets/workout_labels.dart';
import '../data/notification_settings_repository.dart';
import '../domain/notification_settings.dart';
import '../domain/reminder_planner.dart';

/// Ringkasan rekonsiliasi (untuk UI & test).
class ReconcileResult {
  const ReconcileResult({
    required this.scheduled,
    required this.cancelled,
    required this.permission,
  });

  final int scheduled;
  final int cancelled;
  final NotificationPermission permission;
}

/// Rekonsiliasi jadwal OS dengan preferensi + program aktif:
/// hitung jadwal yang diinginkan → batalkan yang tidak lagi diinginkan →
/// jadwalkan ulang yang diinginkan (ID stabil → tanpa duplikat).
/// Dipanggil saat aplikasi dibuka/kembali aktif, preferensi berubah,
/// program berubah, sesi selesai, dan data dihapus.
class ReminderScheduler {
  ReminderScheduler({
    required this.service,
    required this.settings,
    required this.workouts,
    required this.activePlanId,
    this.checkedInDates,
    required this.clock,
    required this.l10n,
  });

  final NotificationService service;
  final NotificationSettingsRepository settings;
  final WorkoutRepository workouts;
  final Future<String?> Function() activePlanId;

  /// Tanggal yang sudah punya check-in (pengingatnya tidak perlu dikirim).
  final Future<Set<String>> Function()? checkedInDates;
  final DateTime Function() clock;
  final AppLocalizations l10n;

  Future<ReconcileResult> reconcile() async {
    final prefs = await settings.read();
    final permission = await service.permission();
    final pending = await service.pendingIds();

    if (!prefs.enabled || permission == NotificationPermission.denied) {
      for (final id in pending) {
        await service.cancel(id);
      }
      return ReconcileResult(scheduled: 0, cancelled: pending.length, permission: permission);
    }

    final location = await service.localLocation();
    if (prefs.timezone != location.name) {
      await settings.save(prefs.copyWith(timezone: location.name));
    }
    final now = tz.TZDateTime.from(clock(), location);
    final planId = await activePlanId();
    final days = planId == null ? const <PlanDay>[] : await workouts.watchDays(planId).first;
    final completed = planId == null
        ? const <String>{}
        : {
            for (final s in await workouts.watchHistory(limit: 14).first)
              if (s.planId == planId) s.date,
          };

    final desired = ReminderPlanner.build(
      settings: prefs,
      now: now,
      planId: planId,
      planDays: days,
      completedWorkoutDates: completed,
      checkedInDates: await checkedInDates?.call() ?? const {},
    );
    final desiredIds = {for (final r in desired) r.id};
    var cancelled = 0;
    for (final id in pending.difference(desiredIds)) {
      await service.cancel(id);
      cancelled++;
    }
    for (final r in desired) {
      await service.schedule(_toNotification(r));
    }
    appLogger.i('Pengingat: ${desired.length} terjadwal, $cancelled dibatalkan');
    return ReconcileResult(scheduled: desired.length, cancelled: cancelled, permission: permission);
  }

  /// Batalkan semua (mis. setelah hapus data).
  Future<void> cancelAll() => service.cancelAll();

  ScheduledNotification _toNotification(PlannedReminder r) {
    final l = l10n;
    final (channel, title, body) = switch (r.category) {
      ReminderCategory.workout => (
        'workout',
        l.reminderWorkoutTitle(l.focus(r.day!.focus)),
        l.reminderWorkoutBody(r.day!.exercises.length, r.day!.estimatedMinutes),
      ),
      ReminderCategory.breakfast => ('meals', l.reminderBreakfastTitle, l.reminderMealBody),
      ReminderCategory.lunch => ('meals', l.reminderLunchTitle, l.reminderMealBody),
      ReminderCategory.dinner => ('meals', l.reminderDinnerTitle, l.reminderMealBody),
      ReminderCategory.snack => ('meals', l.reminderSnackTitle, l.reminderMealBody),
      ReminderCategory.weighIn => ('weigh_in', l.reminderWeighInTitle, l.reminderWeighInBody),
      ReminderCategory.dailyCheckIn => ('check_in', l.reminderCheckInTitle, l.reminderCheckInBody),
    };
    return ScheduledNotification(
      id: r.id,
      channel: channel,
      when: r.when,
      title: title,
      body: body,
      route: r.route,
    );
  }
}

/// Contoh jadwal untuk penjelasan sebelum meminta izin.
String reminderExample(AppLocalizations l, NotificationSettings s, List<PlanDay> days) {
  final workoutDays = days.map((d) => l.weekday(d.weekday)).join('/');
  return l.reminderExample(
    workoutDays.isEmpty ? '–' : workoutDays,
    s.workout.time,
    s.meals.breakfast.time,
    s.dailyCheckIn.time,
  );
}
