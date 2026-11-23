import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/workout.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';
import '../widgets/workout_widgets.dart';

/// Detail satu hari program + tombol mulai/lanjutkan sesi.
class DayScreen extends ConsumerWidget {
  const DayScreen({super.key, required this.planId, required this.dayId});

  final String planId;
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final daysAsync = ref.watch(planDaysProvider(planId));
    final busy = ref.watch(workoutActionsProvider).isLoading;
    final day = daysAsync.value?.where((d) => d.id == dayId).firstOrNull;

    Future<void> start(PlanDay d) async {
      final sessionId = await ref.read(workoutActionsProvider.notifier).startOrResume(planId, d);
      if (!context.mounted) return;
      if (sessionId != null) {
        await context.push(Routes.sessionPath(sessionId));
      } else if (ref.read(workoutActionsProvider).error case final e?) {
        context.showSnack(failureMessage(l, e));
      }
    }

    final palette = context.palette;
    return Scaffold(
      appBar: SubtitleAppBar(
        title: day == null ? '' : l.focus(day.focus),
        subtitle: day == null
            ? null
            : '${l.weekdayLong(day.weekday)} · ${l.dayMeta(day.exercises.length, day.estimatedMinutes)}',
      ),
      body: switch (daysAsync) {
        AsyncData() when day == null => EmptyState(icon: Icons.search_off, title: l.errorNotFound),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
        ),
        _ when day == null => const Center(child: CircularProgressIndicator()),
        _ => ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InfoTile(
                      icon: Icons.local_fire_department_outlined,
                      iconColor: palette.carbs,
                      title: l.wk2WarmupTitle(day.warmupMinutes),
                      body: l.wk2WarmupBody,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoTile(
                      icon: Icons.self_improvement_rounded,
                      iconColor: palette.protein,
                      title: l.wk2CooldownTitle,
                      body: l.wk2CooldownBody,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PlannedExerciseList(exercises: day.exercises),
            const SizedBox(height: 12),
            InfoBox([l.rirExplain]),
          ],
        ),
      },
      bottomNavigationBar: day == null
          ? null
          : StickyBottomBar(
              child: FilledButton.icon(
                onPressed: busy ? null : () => start(day),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l.startSession),
              ),
            ),
    );
  }
}
