import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
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
                Container(
                  decoration: BoxDecoration(
                    color: context.palette.surface2,
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: l.weeklyPrev,
                        onPressed: () => context.pushReplacement(
                          Routes.weeklyReviewPath(ProgressMath.addDays(ws, -7)),
                        ),
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      Expanded(
                        child: Text(
                          _complete
                              ? l.weeklyRange(Fmt.isoDate(ws), Fmt.isoDate(end))
                              : l.weeklyThisWeek,
                          key: const Key('weekly-range'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFeatures: tabular,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l.weeklyNext,
                        onPressed: _complete
                            ? () => context.pushReplacement(
                                Routes.weeklyReviewPath(ProgressMath.addDays(ws, 7)),
                              )
                            : null,
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (!summary.hasAnyData)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l.weeklyNoData,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.palette.muted),
                    ),
                  )
                else ...[
                  _StatsCard(s: summary),
                  if (progress != null) ...[
                    const SizedBox(height: 12),
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
    final change = s.weightChangeKg;
    final volumeChange = s.prevVolumeKg == null || s.prevVolumeKg == 0
        ? null
        : ((s.volumeKg / s.prevVolumeKg! - 1) * 100).round();
    final weight = _StatTile(
      icon: Icons.monitor_weight_outlined,
      label: l.weeklyWeight,
      value: s.avgWeightKg == null ? '–' : Fmt.one(s.avgWeightKg!),
      unit: s.avgWeightKg == null ? null : l.unitKg,
      lines: [
        if (s.avgWeightKg == null)
          l.weeklyWeightMissing
        else
          l.weeklyWeightValue(Fmt.one(s.avgWeightKg!), s.weighIns),
        if (change != null) l.weeklyWeightChange(signedKg(change)),
      ],
    );
    final training = _StatTile(
      icon: Icons.fitness_center_rounded,
      label: l.weeklyTraining,
      value: s.sessionsPlanned == null
          ? '${s.sessionsCompleted}'
          : '${s.sessionsCompleted}/${s.sessionsPlanned}',
      unit: l.obUnitSessions,
      lines: [
        s.sessionsPlanned == null
            ? l.weeklyTrainingNoPlan(s.sessionsCompleted, s.setsDone)
            : l.weeklyTrainingValue(s.sessionsCompleted, s.sessionsPlanned!, s.setsDone),
        '${l.weeklyVolume(Fmt.integer(s.volumeKg))}'
            '${volumeChange == null ? '' : ' · ${l.weeklyVolumeChange(Fmt.signed(volumeChange))}'}',
      ],
    );
    final intake = _StatTile(
      icon: Icons.restaurant_outlined,
      label: l.weeklyIntake,
      value: s.intakeRatio == null ? '–' : Fmt.integer(s.intakeRatio! * 100),
      unit: s.intakeRatio == null ? null : '%',
      lines: [
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
      ],
    );
    final recovery = _StatTile(
      icon: Icons.bedtime_outlined,
      label: l.weeklyRecovery,
      value: s.avgSleepHours == null ? '–' : Fmt.one(s.avgSleepHours!),
      unit: s.avgSleepHours == null ? null : l.unitHours,
      lines: [
        if (s.checkIns == 0)
          l.weeklyRecoveryNone
        else
          l.weeklyRecoveryValue(
            s.checkIns,
            s.avgSleepHours == null ? '–' : Fmt.one(s.avgSleepHours!),
            s.avgEnergy == null ? '–' : Fmt.one(s.avgEnergy!),
          ),
        if (s.discomfortDays > 0) l.weeklyDiscomfort(s.discomfortDays),
      ],
    );
    Widget pair(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      ),
    );
    return Column(
      children: [pair(weight, training), const SizedBox(height: 12), pair(intake, recovery)],
    );
  }
}

/// Ubin statistik: label redup, angka tabular besar + satuan, rincian kecil.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.lines,
    this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: palette.muted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: palette.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 32 / 28,
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                ),
                if (unit case final u?)
                  TextSpan(
                    text: u == '%' ? u : ' $u',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.muted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          for (final line in lines)
            Text(
              line,
              style: TextStyle(
                fontSize: 12,
                height: 16 / 12,
                color: palette.muted,
                fontFeatures: tabular,
              ),
            ),
        ],
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
    final palette = context.palette;
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
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 20, color: palette.warning),
                const SizedBox(width: 12),
                Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
              ],
            ),
          ),
        ),
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

    final secondary = OutlinedButton.styleFrom(
      minimumSize: AppTheme.compactButtonSize,
      backgroundColor: palette.surface2,
      foregroundColor: theme.colorScheme.onSurface,
      side: BorderSide.none,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: palette.accentSoft, shape: BoxShape.circle),
                    child: Icon(Icons.tune_rounded, size: 20, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.adjustTitle, style: theme.textTheme.titleMedium)),
                ],
              ),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Fmt.integer(proposal.newKcal),
                      style: const TextStyle(
                        fontSize: 32,
                        height: 36 / 32,
                        fontWeight: FontWeight.w800,
                        fontFeatures: tabular,
                      ),
                    ),
                    TextSpan(
                      text: ' ${l.obUnitKcal}  ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: palette.muted,
                      ),
                    ),
                    TextSpan(
                      text: '${up ? '+' : '−'}${Fmt.integer(proposal.deltaKcal.abs())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        fontFeatures: tabular,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(body, key: const Key('adjust-body'), style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(l.adjustNote, style: TextStyle(fontSize: 12, color: palette.muted)),
              const SizedBox(height: 14),
              if (decided != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: decided == 'accepted' ? palette.accentSoft : palette.surface2,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          decided == 'accepted' ? Icons.check_rounded : Icons.close_rounded,
                          size: 16,
                          color: decided == 'accepted' ? theme.colorScheme.primary : palette.muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          decided == 'accepted' ? l.adjustAcceptedLabel : l.adjustDeclinedLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: decided == 'accepted'
                                ? theme.colorScheme.primary
                                : palette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('adjust-decline'),
                        style: secondary,
                        onPressed: () => decide(false),
                        child: Text(l.adjustDecline),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        key: const Key('adjust-accept'),
                        style: FilledButton.styleFrom(minimumSize: AppTheme.compactButtonSize),
                        onPressed: () => decide(true),
                        child: Text(l.adjustAccept),
                      ),
                    ),
                  ],
                ),
            ],
          ),
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
    final palette = context.palette;
    final accent = theme.colorScheme.primary;
    final ai = stored?.aiSummary;
    Widget list(String title, List<String> items) => items.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                for (final i in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 7, right: 10),
                          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                        ),
                        Expanded(child: Text(i, style: theme.textTheme.bodyMedium)),
                      ],
                    ),
                  ),
              ],
            ),
          );
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.weeklyAiTitle, style: theme.textTheme.titleMedium)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: palette.accentSoft,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded, size: 14, color: accent),
                        const SizedBox(width: 4),
                        Text(
                          l.obAiDraftPill,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
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
                Text(l.weeklyAiNote, style: TextStyle(fontSize: 12, color: palette.muted)),
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
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.accentSoft,
                    foregroundColor: accent,
                  ),
                  onPressed: onGenerate,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(ai == null ? l.weeklyAiGenerate : l.weeklyAiRegenerate),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
