import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_palette.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/utils/context_x.dart';
import '../../../core/utils/formatters.dart';
import '../../nutrition/presentation/food_scan_flow.dart';
import '../../progress/presentation/providers/progress_providers.dart';
import '../../progress/presentation/widgets/progress_forms.dart';
import '../../workout/presentation/providers/workout_providers.dart';

enum QuickAction { scanFood, logFood, logWeight, startSession }

/// Lembar aksi cepat dari tombol "+" di bottom bar; aksinya dijalankan
/// dengan [context] pemanggil (shell) setelah lembar ditutup.
Future<void> showQuickActions(BuildContext context, WidgetRef ref) async {
  final action = await showModalBottomSheet<QuickAction>(
    context: context,
    showDragHandle: true,
    // Tinggi mengikuti isi (tidak dibatasi 9/16 layar) agar tidak meluap.
    isScrollControlled: true,
    builder: (_) => const _QuickActionsSheet(),
  );
  if (action == null || !context.mounted) return;
  await runQuickAction(context, ref, action);
}

Future<void> runQuickAction(BuildContext context, WidgetRef ref, QuickAction action) async {
  final l = context.l10n;
  final now = ref.read(clockProvider)();
  final date = Fmt.toIsoDate(now);
  switch (action) {
    case QuickAction.scanFood:
      await scanFood(context, ref, date: date);
    case QuickAction.logFood:
      await context.push(Routes.addFoodPath(date, mealForHour(now.hour).name));
    case QuickAction.logWeight:
      final weights = ref.read(weightsProvider).value;
      final res = await showWeightSheet(
        context,
        today: now,
        initialKg: weights == null || weights.isEmpty ? null : weights.last.kg,
      );
      if (res == null || !context.mounted) return;
      final ok = await ref.read(progressActionsProvider.notifier).saveWeight(res.date, res.kg);
      if (context.mounted) context.showSnack(ok ? l.weightSaved : l.errorUnknown);
    case QuickAction.startSession:
      final planId = ref.read(activePlanIdProvider);
      if (planId == null) {
        context.go(Routes.workout);
        context.showSnack(l.qaNoPlan);
        return;
      }
      final days = await ref.read(planDaysProvider(planId).future);
      final today = days.where((d) => d.weekday == now.weekday).firstOrNull;
      if (!context.mounted) return;
      if (today == null) {
        context.go(Routes.workout);
        context.showSnack(l.qaNoWorkoutToday);
        return;
      }
      final id = await ref.read(workoutActionsProvider.notifier).startOrResume(planId, today);
      if (id != null && context.mounted) await context.push(Routes.sessionPath(id));
  }
}

class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    Widget tile(QuickAction a, IconData icon, String title, String subtitle, {Color? color}) =>
        InkWell(
          key: Key('qa-${a.name}'),
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pop(context, a),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color == null ? palette.surface2 : palette.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color ?? theme.colorScheme.onSurface),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: palette.muted)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: palette.muted),
              ],
            ),
          ),
        );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(l.quickActions, style: theme.textTheme.titleLarge),
            ),
            tile(
              QuickAction.scanFood,
              Icons.photo_camera_outlined,
              l.scanFood,
              l.scanFoodSubtitle,
              color: theme.colorScheme.primary,
            ),
            tile(QuickAction.logFood, Icons.restaurant_rounded, l.nutritionHomeLog, l.qaLogFoodSub),
            tile(
              QuickAction.logWeight,
              Icons.monitor_weight_outlined,
              l.weightLog,
              l.qaLogWeightSub,
            ),
            tile(
              QuickAction.startSession,
              Icons.play_arrow_rounded,
              l.startSession,
              l.qaStartSessionSub,
            ),
          ],
        ),
      ),
    );
  }
}
