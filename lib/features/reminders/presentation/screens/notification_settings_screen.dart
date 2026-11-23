import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../../core/utils/context_x.dart';
import '../../../assessment/presentation/widgets/assessment_labels.dart';
import '../../../profile/presentation/widgets/settings_group.dart';
import '../../../workout/domain/entities/workout.dart';
import '../../../workout/presentation/providers/workout_providers.dart';
import '../../application/reminder_scheduler.dart';
import '../../domain/notification_settings.dart';
import '../providers/reminder_providers.dart';

/// Pengaturan pengingat: saklar utama (izin diminta dengan penjelasan),
/// kategori, hari/jam, jam tenang, status izin & jumlah jadwal.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen>
    with WidgetsBindingObserver {
  NotificationPermission? _permission;

  /// OS (iOS, Android 13+) tidak membedakan "belum ditanya" dari "ditolak".
  /// Peringatan "ditolak" hanya ditampilkan setelah izin benar-benar diminta
  /// di layar ini, atau bila pengingat aktif tetapi izinnya dicabut.
  bool _requested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Kembali dari pengaturan sistem → izin mungkin sudah berubah.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkPermission();
  }

  Future<void> _checkPermission() async {
    final p = await ref.read(notificationServiceProvider).permission();
    if (mounted) setState(() => _permission = p);
  }

  /// Simpan lalu langsung sinkronkan jadwal agar jumlah di layar tidak basi.
  Future<void> _save(NotificationSettings s) async {
    await ref.read(notificationSettingsRepositoryProvider).save(s);
    await ref.read(reminderStatusProvider.notifier).refresh();
  }

  /// Jelaskan alasan + contoh jadwal SEBELUM meminta izin sistem.
  Future<void> _enable(NotificationSettings s, List<PlanDay> days) async {
    final l = context.l10n;
    final service = ref.read(notificationServiceProvider);
    await _checkPermission();
    if (_permission != NotificationPermission.granted) {
      if (!mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.notifications_active_outlined),
          title: Text(l.notificationPermissionTitle),
          content: Text('${l.notificationPermissionBody}\n\n${reminderExample(l, s, days)}'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.notificationPermissionAllow),
            ),
          ],
        ),
      );
      if (!(ok ?? false)) return;
      await service.requestPermission();
      _requested = true;
      await _checkPermission();
      // Jangan anggap berhasil bila OS menolak izin.
      if (_permission != NotificationPermission.granted) return;
    }
    await _save(s.copyWith(enabled: true));
  }

  Future<String?> _pickTime(String current) async {
    final t = TimeOfDayCodec.parse(current);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: t.hour, minute: t.minute),
      builder: (ctx, child) =>
          MediaQuery(data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true), child: child!),
    );
    return picked == null ? null : TimeOfDayCodec.format(picked.hour, picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = context.palette.muted;
    const rowTitle = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
    final rowSubtitle = TextStyle(fontSize: 12, color: muted);
    final s = ref.watch(notificationSettingsProvider).value;
    final planId = ref.watch(activePlanIdProvider);
    final days = planId == null
        ? const <PlanDay>[]
        : ref.watch(planDaysProvider(planId)).value ?? const <PlanDay>[];
    final status = ref.watch(reminderStatusProvider);

    if (s == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.notificationSettingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    Widget timeTile({
      required String title,
      String? subtitle,
      required TimedReminder value,
      required NotificationSettings Function(TimedReminder) update,
      Key? key,
    }) => SwitchListTile(
      key: key,
      contentPadding: const EdgeInsets.only(left: 8, right: 16),
      title: Text(title, style: rowTitle),
      subtitle: subtitle == null ? null : Text(subtitle, style: rowSubtitle),
      value: value.enabled,
      onChanged: s.enabled ? (v) => _save(update(value.copyWith(enabled: v))) : null,
      secondary: TextButton(
        onPressed: s.enabled && value.enabled
            ? () async {
                final t = await _pickTime(value.time);
                if (t != null) await _save(update(value.copyWith(time: t)));
              }
            : null,
        child: Text(
          value.time,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFeatures: tabular,
          ),
        ),
      ),
    );

    Widget timeButton(String time, NotificationSettings Function(String) update) => TextButton(
      onPressed: () async {
        final t = await _pickTime(time);
        if (t != null) await _save(update(t));
      },
      child: Text(
        time,
        style: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontWeight: FontWeight.w700,
          fontFeatures: tabular,
        ),
      ),
    );

    final denied = _permission == NotificationPermission.denied && (s.enabled || _requested);
    final masterOn = s.enabled && !denied;
    final showScheduled = s.enabled && !denied && status != null;
    return Scaffold(
      appBar: AppBar(title: Text(l.notificationSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(l.notificationIntro, style: TextStyle(fontSize: 14, height: 1.45, color: muted)),
          const SizedBox(height: 16),
          SettingsGroup(
            children: [
              SwitchListTile(
                key: const ValueKey('reminders-master'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                secondary: SettingsIcon(Icons.notifications_outlined, accent: masterOn),
                title: Text(
                  l.notificationEnable,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                value: masterOn,
                onChanged: (v) => v ? _enable(s, days) : _save(s.copyWith(enabled: false)),
              ),
              if (denied)
                Container(
                  color: theme.colorScheme.errorContainer,
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.notificationDenied,
                        style: TextStyle(color: theme.colorScheme.onErrorContainer),
                      ),
                      TextButton(
                        onPressed: () => ref.read(notificationServiceProvider).openSystemSettings(),
                        child: Text(l.openSystemSettings),
                      ),
                    ],
                  ),
                ),
              if (showScheduled || s.timezone != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showScheduled)
                        Text(
                          l.notificationScheduled(status.scheduled),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      if (s.timezone case final zone?)
                        Text(
                          l.notificationTimezone(zone),
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          SettingsSectionLabel(l.pfRemindersCategorySection),
          SettingsGroup(
            children: [
              timeTile(
                key: const ValueKey('reminder-workout'),
                title: l.reminderWorkoutLabel,
                subtitle: days.isEmpty
                    ? l.reminderWorkoutNoPlan
                    : l.reminderWorkoutHelp(days.map((d) => l.weekday(d.weekday)).join(', ')),
                value: s.workout,
                update: (v) => s.copyWith(workout: v),
              ),
            ],
          ),
          SettingsSectionLabel(l.reminderMealsLabel),
          SettingsGroup(
            children: [
              timeTile(
                title: l.breakfastLabel,
                value: s.meals.breakfast,
                update: (v) => s.copyWith(meals: s.meals.copyWith(breakfast: v)),
              ),
              timeTile(
                title: l.lunchLabel,
                value: s.meals.lunch,
                update: (v) => s.copyWith(meals: s.meals.copyWith(lunch: v)),
              ),
              timeTile(
                title: l.dinnerLabel,
                value: s.meals.dinner,
                update: (v) => s.copyWith(meals: s.meals.copyWith(dinner: v)),
              ),
              timeTile(
                title: l.snackLabel,
                value: s.meals.snack,
                update: (v) => s.copyWith(meals: s.meals.copyWith(snack: v)),
              ),
            ],
          ),
          SettingsSectionLabel(l.pfRemindersTrackingSection),
          SettingsGroup(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  timeTile(
                    title: l.reminderWeighInLabel,
                    value: TimedReminder(enabled: s.weighIn.enabled, time: s.weighIn.time),
                    update: (v) => s.copyWith(
                      weighIn: s.weighIn.copyWith(enabled: v.enabled, time: v.time),
                    ),
                  ),
                  if (s.weighIn.enabled)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (var d = 1; d <= 7; d++)
                            FilterChip(
                              label: Text(l.weekday(d)),
                              selected: s.weighIn.daysOfWeek.contains(d),
                              onSelected: !s.enabled
                                  ? null
                                  : (on) {
                                      final next = {...s.weighIn.daysOfWeek};
                                      on ? next.add(d) : next.remove(d);
                                      if (next.isEmpty) return; // minimal satu hari
                                      _save(
                                        s.copyWith(
                                          weighIn: s.weighIn.copyWith(
                                            daysOfWeek: next.toList()..sort(),
                                          ),
                                        ),
                                      );
                                    },
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              timeTile(
                title: l.reminderCheckInLabel,
                value: s.dailyCheckIn,
                update: (v) => s.copyWith(dailyCheckIn: v),
              ),
            ],
          ),
          SettingsSectionLabel(l.quietHoursLabel),
          SettingsGroup(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                secondary: const SettingsIcon(Icons.bedtime_outlined),
                title: Text(l.quietHoursLabel, style: rowTitle),
                subtitle: Text(l.quietHoursHelp, style: rowSubtitle),
                value: s.quietHours.enabled,
                onChanged: s.enabled
                    ? (v) => _save(s.copyWith(quietHours: s.quietHours.copyWith(enabled: v)))
                    : null,
              ),
              if (s.quietHours.enabled)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Text('${l.quietStart}: ', style: TextStyle(color: muted)),
                      timeButton(
                        s.quietHours.start,
                        (t) => s.copyWith(quietHours: s.quietHours.copyWith(start: t)),
                      ),
                      const SizedBox(width: 16),
                      Text('${l.quietEnd}: ', style: TextStyle(color: muted)),
                      timeButton(
                        s.quietHours.end,
                        (t) => s.copyWith(quietHours: s.quietHours.copyWith(end: t)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: s.enabled && !denied
                ? () => ref
                      .read(notificationServiceProvider)
                      .showTest(title: l.testNotificationTitle, body: l.testNotificationBody)
                : null,
            icon: const Icon(Icons.notifications_outlined),
            label: Text(l.sendTestNotification),
          ),
          // Optimasi baterai OEM hanya relevan di Android.
          if (theme.platform == TargetPlatform.android) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(l.notificationBatteryHint, style: TextStyle(fontSize: 12, color: muted)),
            ),
          ],
        ],
      ),
    );
  }
}
