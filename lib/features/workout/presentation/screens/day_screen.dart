import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
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
    final theme = Theme.of(context);
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

    return Scaffold(
      appBar: AppBar(title: Text(day == null ? '' : l.focus(day.focus))),
      body: switch (daysAsync) {
        AsyncData() when day == null => EmptyState(icon: Icons.search_off, title: l.errorNotFound),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
        ),
        _ when day == null => const Center(child: CircularProgressIndicator()),
        _ => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l.weekdayLong(day.weekday), style: theme.textTheme.titleLarge),
            Text(l.dayMeta(day.exercises.length, day.estimatedMinutes)),
            const SizedBox(height: 8),
            MutedNote(l.warmupNote(day.warmupMinutes)),
            for (final (i, p) in day.exercises.indexed) PlannedExerciseTile(exercise: p, index: i),
            MutedNote(l.cooldownNote),
            MutedNote(l.rirExplain),
            const SizedBox(height: 80),
          ],
        ),
      },
      bottomNavigationBar: day == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: busy ? null : () => start(day),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l.startSession),
                ),
              ),
            ),
    );
  }
}
