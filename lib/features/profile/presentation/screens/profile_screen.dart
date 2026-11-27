import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../workout/domain/guided_settings.dart';
import '../../../workout/presentation/guided/guided_settings_sheet.dart';
import '../../../backup/presentation/backup_flow.dart';
import '../../../backup/presentation/backup_providers.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/tab_app_bar.dart';
import '../../../ai_coach/presentation/providers/ai_providers.dart';
import '../../../assessment/presentation/widgets/assessment_labels.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../providers/profile_providers.dart';
import '../widgets/settings_group.dart';

/// Tab Profil: ringkasan target, assessment & target, pengaturan, data & privasi.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _wipe(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final error = Theme.of(ctx).colorScheme.error;
        return AlertDialog(
          icon: Icon(Icons.warning_amber_rounded, color: error),
          title: Text(l.wipeDataTitle),
          content: Text(l.wipeDataMessage),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: error, minimumSize: const Size(0, 48)),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.wipeDataConfirm),
            ),
          ],
        );
      },
    );
    if (!(ok ?? false)) return;
    try {
      await ref.read(profileRepositoryProvider).wipeAllData();
      // Berkas foto progres di folder privat ikut dihapus.
      await ref.read(photoStoreProvider).deleteAll();
      // API key Gemini ikut dihapus dari penyimpanan terenkripsi.
      await ref.read(aiKeyStoreProvider).delete();
      ref.invalidate(aiSettingsControllerProvider);
      // Semua pengingat terjadwal dibatalkan.
      await ref.read(reminderSchedulerProvider).cancelAll();
      // Router otomatis kembali ke onboarding (profil kosong).
    } catch (e) {
      if (context.mounted) context.showSnack(failureMessage(l, e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final activeGoalId = ref.watch(userProfileProvider).value?.activeGoalId;
    final goal = activeGoalId == null ? null : ref.watch(activeGoalProvider).value;
    final aiReady = ref.watch(aiSettingsControllerProvider).value?.ready ?? false;
    final remindersOn = ref.watch(notificationSettingsProvider).value?.enabled ?? false;
    final guided = ref.watch(guidedSettingsProvider).value ?? const GuidedSettings();

    return Scaffold(
      appBar: TabAppBar(title: l.tabProfile),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (goal != null) _GoalSummary(goal: goal),
          SettingsSectionLabel(l.profileAssessmentSection),
          SettingsGroup(
            children: [
              if (activeGoalId != null)
                SettingsRow(
                  icon: Icons.flag_outlined,
                  title: l.viewActiveGoal,
                  onTap: () => context.push(Routes.goalPath(activeGoalId)),
                ),
              SettingsRow(
                icon: Icons.assignment_outlined,
                title: l.redoAssessment,
                subtitle: l.redoAssessmentHelp,
                onTap: () => context.push(Routes.assessment),
              ),
            ],
          ),
          SettingsSectionLabel(l.pfSettingsSection),
          SettingsGroup(
            children: [
              SettingsRow(
                icon: Icons.auto_awesome,
                accentIcon: true,
                title: l.aiSettingsTitle,
                subtitle: aiReady ? l.aiStatusReady : l.aiStatusNotReady,
                pill: StatusPill(text: aiReady ? l.pfStatusOn : l.pfStatusOff, on: aiReady),
                onTap: () => context.push(Routes.aiSettings),
              ),
              SettingsRow(
                icon: Icons.notifications_outlined,
                title: l.profileRemindersTile,
                subtitle: l.pfRemindersSubtitle,
                pill: StatusPill(
                  text: remindersOn ? l.remindersOn : l.remindersOff,
                  on: remindersOn,
                ),
                onTap: () => context.push(Routes.reminders),
              ),
              SettingsRow(
                key: const Key('profile-guided'),
                icon: Icons.timer_outlined,
                title: l.pfGuidedTitle,
                subtitle: [
                  l.guidedTempo(guided.tempo.label),
                  if (guided.countdownSeconds > 0)
                    '${l.guidedSettingsCountdown.toLowerCase()} ${guided.countdownSeconds} ${l.guidedSecShort}',
                  if (guided.sound) l.guidedSettingsSound.toLowerCase(),
                ].join(' · '),
                onTap: () => showGuidedSettingsSheet(context),
              ),
            ],
          ),
          SettingsSectionLabel(l.dataPrivacySection),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.phone_android, size: 22, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.dataLocalOnly,
                      style: TextStyle(fontSize: 13, height: 1.45, color: palette.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SettingsGroup(
            children: [
              SettingsRow(
                key: const Key('backup-export'),
                icon: Icons.cloud_upload_outlined,
                accentIcon: true,
                title: l.backupExport,
                subtitle: switch (ref.watch(lastBackupProvider).value) {
                  final t? => l.backupLast(Fmt.date(t)),
                  null => l.backupNever,
                },
                onTap: () => exportBackup(context, ref),
              ),
              SettingsRow(
                key: const Key('backup-restore'),
                icon: Icons.settings_backup_restore_rounded,
                title: l.backupRestore,
                subtitle: l.backupRestoreSub,
                onTap: () => restoreBackup(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.4)),
              textStyle: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () => _wipe(context, ref),
            icon: const Icon(Icons.delete_forever_outlined),
            label: Text(l.wipeData),
          ),
          const SizedBox(height: 12),
          Text(
            l.pfFooter,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: palette.muted),
          ),
        ],
      ),
    );
  }
}

/// Ringkasan target aktif: tujuan utama, berat awal → target, minggu, level.
class _GoalSummary extends StatelessWidget {
  const _GoalSummary({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final palette = context.palette;
    final target = goal.targetWeightKg;
    final weight = target == null
        ? l.kgValue(Fmt.one(goal.startWeightKg))
        : '${Fmt.one(goal.startWeightKg)} → ${l.kgValue(Fmt.one(target))}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: palette.accentSoft, shape: BoxShape.circle),
              child: Icon(
                Icons.person_rounded,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.primaryGoal(goal.primaryGoal),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [weight, l.weeksValue(goal.targetWeeks), l.level(goal.level)].join(' · '),
                    style: TextStyle(fontSize: 13, color: palette.muted, fontFeatures: tabular),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
