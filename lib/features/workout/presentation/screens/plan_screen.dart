import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
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

    final palette = context.palette;
    final sectionStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.muted);

    return Scaffold(
      appBar: SubtitleAppBar(
        title: plan == null ? l.planDraftTitle : planStatusTitle(context, plan),
        subtitle: plan == null ? null : l.split(plan.split),
        actions: [
          if (plan?.status == PlanStatus.active)
            IconButton(
              tooltip: l.newPlan,
              icon: const Icon(Icons.refresh_rounded),
              onPressed: busy ? null : () => chooseAndCreatePlan(context, ref),
            ),
        ],
      ),
      body: switch (planAsync) {
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SoftPill(l.levelCode(value.level)),
                SoftPill(l.planSummary(value.daysPerWeek, value.sessionMinutes)),
                if (value.isAiGenerated)
                  SoftPill(
                    l.aiPlanBadge(value.model ?? ''),
                    accent: true,
                    icon: Icons.auto_awesome_rounded,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (value.isAiGenerated) ...[
              if (value.rationale case final r? when r.isNotEmpty) ...[
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l.aiPlanRationaleTitle,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(r, style: const TextStyle(fontSize: 14, height: 20 / 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              MutedNote(l.aiPlanValidated),
            ] else
              MutedNote(l.planSourceTemplate),
            const SizedBox(height: 8),
            if (value.warnings.isNotEmpty) ...[
              PlanWarnings(codes: value.warnings),
              const SizedBox(height: 12),
            ],
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(l.wk2PlanDays, style: sectionStyle),
            ),
            for (final day in days) ...[
              PlannedExerciseList(
                exercises: day.exercises,
                header: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l.weekdayLong(day.weekday)} · ${l.focus(day.focus)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        l.dayMeta(day.exercises.length, day.estimatedMinutes),
                        style: TextStyle(fontSize: 13, fontFeatures: tabular, color: palette.muted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
              child: Text(l.wk2PlanNotes, style: sectionStyle),
            ),
            InfoBox([l.restDaysNote, l.progressionRule, l.rirExplain]),
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
          ? StickyBottomBar(
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
            )
          : null,
    );
  }
}
