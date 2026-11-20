import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/notifications/local_notification_service.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../workout/presentation/providers/workout_providers.dart';
import '../../application/reminder_scheduler.dart';
import '../../data/notification_settings_repository.dart';
import '../../domain/notification_settings.dart';

part 'reminder_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => LocalNotificationService();

@Riverpod(keepAlive: true)
NotificationSettingsRepository notificationSettingsRepository(Ref ref) =>
    NotificationSettingsRepository(ref.watch(appDatabaseProvider), ref.watch(clockProvider));

@Riverpod(keepAlive: true)
Stream<NotificationSettings> notificationSettings(Ref ref) =>
    ref.watch(notificationSettingsRepositoryProvider).watch();

@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) => ReminderScheduler(
  service: ref.watch(notificationServiceProvider),
  settings: ref.watch(notificationSettingsRepositoryProvider),
  workouts: ref.watch(workoutRepositoryProvider),
  activePlanId: () async => (await ref.read(userProfileProvider.future))?.activeWorkoutPlanId,
  clock: ref.watch(clockProvider),
  l10n: lookupAppLocalizations(const Locale('id')),
);

/// Hasil rekonsiliasi terakhir (jumlah terjadwal & status izin) untuk UI.
@Riverpod(keepAlive: true)
class ReminderStatus extends _$ReminderStatus {
  @override
  ReconcileResult? build() => null;

  Future<ReconcileResult?> refresh() async {
    try {
      final result = await ref.read(reminderSchedulerProvider).reconcile();
      if (ref.mounted) state = result;
      return result;
    } catch (_) {
      return null;
    }
  }
}
