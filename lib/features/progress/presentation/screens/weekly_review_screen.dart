import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../ai_coach/application/ai_plan_service.dart';
import '../../data/progress_repository.dart';
import '../../domain/progress_math.dart';
import '../providers/progress_providers.dart';
import '../widgets/progress_labels.dart';

/// Ringkasan satu minggu: statistik aktual, status target, usulan
/// penyesuaian (butuh persetujuan), dan ringkasan AI opsional.
class WeeklyReviewScreen extends ConsumerStatefulWidget {
  const WeeklyReviewScreen({super.key, required this.weekStart});

  final String weekStart;

  @override
  ConsumerState<WeeklyReviewScreen> createState() => _WeeklyReviewScreenState();
}

class _WeeklyReviewScreenState extends ConsumerState<WeeklyReviewScreen> {
  bool _saved = false;
  bool _generating = false;

  String get _currentWeek => ProgressMath.weekStartOf(ref.read(progressTodayProvider));
  String get _lastCompleted => ProgressMath.addDays(_currentWeek, -7);
  bool get _complete => widget.weekStart.compareTo(_currentWeek) < 0;

  /// Simpan statistik minggu lengkap sekali per kunjungan (keputusan &
  /// ringkasan AI yang sudah ada dipertahankan repository).
  void _persist(WeekSummary s, GoalProgress? progress, NutritionAdjustment? proposal) {
    if (_saved || !_complete || !s.hasAnyData) return;
    _saved = true;
    final isLatest = widget.weekStart == _lastCompleted;
    // Setelah frame: provider tidak boleh diubah selama build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        ref
            .read(progressActionsProvider.notifier)
            .saveReview(
              s,
              status: isLatest && progress != null
                  ? progress.status
                  : GoalProgressStatus.insufficientData,
              proposal: isLatest ? proposal : null,
            ),
      );
    });
  }

  Future<void> _generate() async {
    final l = context.l10n;
    setState(() => _generating = true);
    final ok = await ref.read(progressActionsProvider.notifier).generateAiSummary(widget.weekStart);
    if (!mounted) return;
    setState(() => _generating = false);
    if (ok) return;
    final error = ref.read(progressActionsProvider).error;
    final setup =
        error is AiPlanException &&
        (error.error == AiPlanError.noKey || error.error == AiPlanError.noConsent);
    final message = switch (error) {
      AiPlanException(error: AiPlanError.noKey || AiPlanError.noConsent) => l.aiErrorSetup,
      AiPlanException(error: AiPlanError.quotaReached) => l.mealPlanErrorQuota,
      AiPlanException(error: AiPlanError.invalidOutput) => l.weeklyAiError,
      null => l.errorUnknown,
      _ => failureMessage(l, error),
    };
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.weeklyAiError),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.close)),
          if (setup)
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.openAiSettings)),
        ],
      ),
    );
    if (go == true && mounted) await context.push(Routes.aiSettings);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final ws = widget.weekStart;
    final summary = ref.watch(weekSummaryProvider(ws));
    final stored = ref.watch(storedReviewProvider(ws)).value;
    final isLatest = ws == _lastCompleted;
    final progress = isLatest ? ref.watch(goalProgressProvider) : null;
    final adjustment = isLatest ? ref.watch(adjustmentForProvider(ws)) : null;
    if (summary != null) _persist(summary, progress, adjustment?.adjustment);

    final end = ProgressMath.addDays(ws, 6);
    return Scaffold(
      appBar: AppBar(title: Text(l.weeklyTitle)),
      body: summary == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: l.weeklyPrev,
                      onPressed: () => context.pushReplacement(
                        Routes.weeklyReviewPath(ProgressMath.addDays(ws, -7)),
                      ),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        _complete
                            ? l.weeklyRange(Fmt.isoDate(ws), Fmt.isoDate(end))
                            : l.weeklyThisWeek,
                        key: const Key('weekly-range'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: l.weeklyNext,
                      onPressed: _complete
                          ? () => context.pushReplacement(
                              Routes.weeklyReviewPath(ProgressMath.addDays(ws, 7)),
                            )
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                if (!summary.hasAnyData)
                  Padding(padding: const EdgeInsets.all(16), child: Text(l.weeklyNoData))
                else ...[
                  _StatsCard(s: summary),
                  if (progress != null) ...[
                    const SizedBox(height: 8),
                    GoalStatusCard(progress: progress),
                  ],
                  _AdjustmentSection(weekStart: ws, stored: stored, current: adjustment),
                  if (_complete)
                    _AiSection(
                      stored: stored,
                      generating: _generating,
                      onGenerate: stored == null ? null : _generate,
                    ),
                ],
              ],
            ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.s});

  final WeekSummary s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    Widget row(IconData icon, String title, List<String> lines) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title, style: theme.textTheme.titleSmall),
      subtitle: Text(lines.join('\n')),
    );
    final change = s.weightChangeKg;
    final volumeChange = s.prevVolumeKg == null || s.prevVolumeKg == 0
        ? null
        : ((s.volumeKg / s.prevVolumeKg! - 1) * 100).round();
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            row(Icons.monitor_weight_outlined, l.weeklyWeight, [
              if (s.avgWeightKg == null)
                l.weeklyWeightMissing
              else
                l.weeklyWeightValue(Fmt.one(s.avgWeightKg!), s.weighIns),
              if (change != null) l.weeklyWeightChange(signedKg(change)),
            ]),
            row(Icons.fitness_center, l.weeklyTraining, [
              s.sessionsPlanned == null
                  ? l.weeklyTrainingNoPlan(s.sessionsCompleted, s.setsDone)
                  : l.weeklyTrainingValue(s.sessionsCompleted, s.sessionsPlanned!, s.setsDone),
              '${l.weeklyVolume(Fmt.integer(s.volumeKg))}'
                  '${volumeChange == null ? '' : ' · ${l.weeklyVolumeChange(Fmt.signed(volumeChange))}'}',
            ]),
            row(Icons.restaurant_outlined, l.weeklyIntake, [
              if (s.avgKcal == null)
                l.weeklyIntakeNone
              else
                l.weeklyIntakeValue(
                  s.loggedDays,
                  l.kcalValue(Fmt.integer(s.avgKcal!)),
                  s.intakeRatio == null ? '–' : Fmt.integer(s.intakeRatio! * 100),
                ),
              if (s.avgProtein != null && s.targetProtein != null)
                l.weeklyProtein(Fmt.integer(s.avgProtein!), Fmt.integer(s.targetProtein!)),
            ]),
            row(Icons.bedtime_outlined, l.weeklyRecovery, [
              if (s.checkIns == 0)
                l.weeklyRecoveryNone
              else
                l.weeklyRecoveryValue(
                  s.checkIns,
                  s.avgSleepHours == null ? '–' : Fmt.one(s.avgSleepHours!),
                  s.avgEnergy == null ? '–' : Fmt.one(s.avgEnergy!),
                ),
              if (s.discomfortDays > 0) l.weeklyDiscomfort(s.discomfortDays),
            ]),
          ],
        ),
      ),
    );
  }
}

class _AdjustmentSection extends ConsumerWidget {
  const _AdjustmentSection({required this.weekStart, required this.stored, required this.current});

  final String weekStart;
  final StoredWeeklyReview? stored;
  final ({NutritionAdjustment? adjustment, AdjustmentBlock? block})? current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final decided = stored?.decision;
    final proposal = decided != null ? stored!.proposal : stored?.proposal;
    final block = current?.block;
    if (proposal == null) {
      final text = switch (block) {
        AdjustmentBlock.intakeNotConsistent => l.adjustBlockedIntake,
        AdjustmentBlock.safety => l.adjustBlockedSafety,
        _ => null,
      };
      if (text == null) return const SizedBox.shrink();
      return Card(
        child: ListTile(leading: const Icon(Icons.info_outline), title: Text(text)),
      );
    }
    final up = proposal.deltaKcal > 0;
    final body = up
        ? l.adjustUp(
            Fmt.integer(proposal.deltaKcal),
            Fmt.integer(proposal.deltaCarbsG),
            l.kcalValue(Fmt.integer(proposal.newKcal)),
          )
        : l.adjustDown(
            Fmt.integer(-proposal.deltaKcal),
            Fmt.integer(-proposal.deltaCarbsG),
            l.kcalValue(Fmt.integer(proposal.newKcal)),
          );
    final actions = ref.read(progressActionsProvider.notifier);
    Future<void> decide(bool accept) async {
      final ok = await actions.decide(weekStart, accept: accept);
      if (!context.mounted) return;
      context.showSnack(ok ? (accept ? l.adjustAccepted : l.adjustDeclined) : l.errorUnknown);
    }

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.adjustTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body, key: const Key('adjust-body')),
            const SizedBox(height: 8),
            Text(l.adjustNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            if (decided != null)
              Chip(
                avatar: Icon(decided == 'accepted' ? Icons.check : Icons.close, size: 16),
                label: Text(decided == 'accepted' ? l.adjustAcceptedLabel : l.adjustDeclinedLabel),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    key: const Key('adjust-decline'),
                    onPressed: () => decide(false),
                    child: Text(l.adjustDecline),
                  ),
                  FilledButton(
                    key: const Key('adjust-accept'),
                    onPressed: () => decide(true),
                    child: Text(l.adjustAccept),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AiSection extends StatelessWidget {
  const _AiSection({required this.stored, required this.generating, required this.onGenerate});

  final StoredWeeklyReview? stored;
  final bool generating;
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final ai = stored?.aiSummary;
    Widget list(String title, List<String> items) => items.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                for (final i in items) Text('• $i'),
              ],
            ),
          );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.weeklyAiTitle, style: theme.textTheme.titleMedium)),
                Chip(
                  label: Text(l.mealPlanAiLabel),
                  visualDensity: VisualDensity.compact,
                  avatar: const Icon(Icons.auto_awesome, size: 16),
                ),
              ],
            ),
            if (ai != null) ...[
              const SizedBox(height: 8),
              Text(ai.summary, style: theme.textTheme.bodyLarge),
              list(l.weeklyAiWentWell, ai.wentWell),
              list(l.weeklyAiObstacles, ai.obstacles),
              list(l.weeklyAiSuggestions, ai.suggestions),
              const SizedBox(height: 8),
              Text(l.weeklyAiNote, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            if (generating)
              Row(
                children: [
                  const SizedBox.square(dimension: 20, child: CircularProgressIndicator()),
                  const SizedBox(width: 12),
                  Text(l.weeklyAiGenerating),
                ],
              )
            else
              FilledButton.tonalIcon(
                key: const Key('weekly-ai-generate'),
                onPressed: onGenerate,
                icon: const Icon(Icons.auto_awesome),
                label: Text(ai == null ? l.weeklyAiGenerate : l.weeklyAiRegenerate),
              ),
          ],
        ),
      ),
    );
  }
}
