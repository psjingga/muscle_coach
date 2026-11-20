import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../ai_coach/presentation/ai_plan_flow.dart';
import '../../domain/entities/workout.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';
import '../widgets/workout_widgets.dart';
import 'workout_screen.dart';

/// Pratinjau/detail program: semua hari & latihan. Draft dapat diaktifkan.
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key, required this.planId});

  final String planId;

  Future<void> _activate(BuildContext context, WidgetRef ref, {required bool hasActive}) async {
    final l = context.l10n;
    if (hasActive) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.replacePlanTitle),
          content: Text(l.replacePlanMessage),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.replace)),
          ],
        ),
      );
      if (!(ok ?? false)) return;
    }
    final success = await ref.read(workoutActionsProvider.notifier).activatePlan(planId);
    if (!context.mounted) return;
    if (success) {
      context.showSnack(l.planActivated);
      context.go(Routes.workout);
    } else if (ref.read(workoutActionsProvider).error case final e?) {
      context.showSnack(failureMessage(l, e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final planAsync = ref.watch(workoutPlanProvider(planId));
    final days = ref.watch(planDaysProvider(planId)).value ?? const <PlanDay>[];
    final busy = ref.watch(workoutActionsProvider).isLoading;
    final plan = planAsync.value;
    final activeId = ref.watch(activePlanIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(plan == null ? l.planDraftTitle : planStatusTitle(context, plan)),
        actions: [
          if (plan?.status == PlanStatus.active)
            IconButton(
              tooltip: l.newPlan,
              icon: const Icon(Icons.refresh),
              onPressed: busy ? null : () => chooseAndCreatePlan(context, ref),
            ),
        ],
      ),
      body: switch (planAsync) {
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l.split(value.split), style: theme.textTheme.titleLarge),
            Text(
              '${l.levelCode(value.level)} · ${l.planSummary(value.daysPerWeek, value.sessionMinutes)}',
            ),
            if (value.isAiGenerated) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.auto_awesome, size: 18),
                  label: Text(l.aiPlanBadge(value.model ?? '')),
                ),
              ),
              if (value.rationale case final r? when r.isNotEmpty)
                Card(
                  child: ListTile(title: Text(l.aiPlanRationaleTitle), subtitle: Text(r)),
                ),
              MutedNote(l.aiPlanValidated),
            ] else
              MutedNote(l.planSourceTemplate),
            const SizedBox(height: 8),
            PlanWarnings(codes: value.warnings),
            for (final day in days)
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l.weekdayLong(day.weekday)} · ${l.focus(day.focus)}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(l.dayMeta(day.exercises.length, day.estimatedMinutes)),
                      for (final (i, p) in day.exercises.indexed)
                        PlannedExerciseTile(exercise: p, index: i),
                    ],
                  ),
                ),
              ),
            MutedNote(l.restDaysNote),
            MutedNote(l.progressionRule),
            MutedNote(l.rirExplain),
            const SizedBox(height: 80),
          ],
        ),
        AsyncData() => EmptyState(icon: Icons.search_off, title: l.errorNotFound),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: plan?.status == PlanStatus.draft
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton(
                  onPressed: busy
                      ? null
                      : () => _activate(
                          context,
                          ref,
                          hasActive: activeId != null && activeId != planId,
                        ),
                  child: busy
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(l.activatePlan),
                ),
              ),
            )
          : null,
    );
  }
}
