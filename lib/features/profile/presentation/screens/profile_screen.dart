import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../ai_coach/presentation/providers/ai_providers.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../providers/profile_providers.dart';

/// Tab Profil: assessment & target, serta data & privasi.
/// Peralatan, notifikasi, dan backup menyusul.
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
    final activeGoalId = ref.watch(userProfileProvider).value?.activeGoalId;
    final aiReady = ref.watch(aiSettingsControllerProvider).value?.ready ?? false;
    final remindersOn = ref.watch(notificationSettingsProvider).value?.enabled ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l.tabProfile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(l.profileAssessmentSection, style: theme.textTheme.titleMedium),
                ),
                if (activeGoalId != null)
                  ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: Text(l.viewActiveGoal),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(Routes.goalPath(activeGoalId)),
                  ),
                ListTile(
                  leading: const Icon(Icons.assignment_outlined),
                  title: Text(l.redoAssessment),
                  subtitle: Text(l.redoAssessmentHelp),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.assessment),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: Text(l.aiSettingsTitle),
              subtitle: Text(aiReady ? l.aiStatusReady : l.aiStatusNotReady),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.aiSettings),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(l.profileRemindersTile),
              subtitle: Text(remindersOn ? l.remindersOn : l.remindersOff),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.reminders),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.dataPrivacySection, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.phone_android, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text(l.dataLocalOnly)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(l.dangerZone, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () => _wipe(context, ref),
            icon: const Icon(Icons.delete_forever_outlined),
            label: Text(l.wipeData),
          ),
        ],
      ),
    );
  }
}
