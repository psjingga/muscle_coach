import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../assessment/application/assessment_wizard_controller.dart';
import '../../domain/entities/workout.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';
import '../widgets/workout_widgets.dart';

/// Tab Latihan: jadwal mingguan program aktif, atau ajakan membuat program.
class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final planId = ref.watch(activePlanIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabWorkout),
        actions: [
          IconButton(
            tooltip: l.exerciseLibrary,
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => context.push(Routes.exercises),
          ),
          IconButton(
            tooltip: l.history,
            icon: const Icon(Icons.history),
            onPressed: () => context.push(Routes.history),
          ),
        ],
      ),
      body: planId == null ? const _NoPlan() : _ActivePlan(planId: planId),
    );
  }
}

/// Buat draft program lalu buka pratinjaunya.
Future<void> createAndOpenStarterPlan(BuildContext context, WidgetRef ref) async {
  final planId = await ref.read(workoutActionsProvider.notifier).createStarterPlan();
  if (!context.mounted) return;
  if (planId != null) {
    await context.push(Routes.planPath(planId));
  } else if (ref.read(workoutActionsProvider).error case final e?) {
    context.showSnack(failureMessage(context.l10n, e));
  }
}

class _NoPlan extends ConsumerWidget {
  const _NoPlan();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final busy = ref.watch(workoutActionsProvider).isLoading;
    return EmptyState(
      icon: Icons.fitness_center_outlined,
      title: l.emptyWorkoutTitle,
      message: l.workoutNoPlanMessage,
      action: FilledButton.icon(
        onPressed: busy ? null : () => createAndOpenStarterPlan(context, ref),
        icon: busy
            ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.auto_fix_high),
        label: Text(l.createStarterPlan),
      ),
    );
  }
}

class _ActivePlan extends ConsumerWidget {
  const _ActivePlan({required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final plan = ref.watch(workoutPlanProvider(planId)).value;
    final daysAsync = ref.watch(planDaysProvider(planId));
    final todayWeekday = ref.watch(clockProvider)().weekday;

    return switch (daysAsync) {
      AsyncValue(:final value?) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (plan != null) ...[
            Text(l.planActiveTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${l.split(plan.split)} · ${l.planSummary(plan.daysPerWeek, plan.sessionMinutes)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
          ],
          for (final day in value)
            PlanDayCard(
              day: day,
              isToday: day.weekday == todayWeekday,
              onTap: () => context.push(Routes.dayPath(planId, day.id)),
            ),
          MutedNote(l.restDaysNote),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push(Routes.planPath(planId)),
            icon: const Icon(Icons.list_alt),
            label: Text(l.planActiveTitle),
          ),
        ],
      ),
      AsyncValue(:final error?) => EmptyState(
        icon: Icons.cloud_off_outlined,
        title: failureMessage(l, error),
        action: FilledButton(
          onPressed: () => ref.invalidate(planDaysProvider(planId)),
          child: Text(l.retry),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

/// Teks status program untuk layar lain.
String planStatusTitle(BuildContext context, WorkoutPlan plan) =>
    plan.status == PlanStatus.draft ? context.l10n.planDraftTitle : context.l10n.planActiveTitle;
