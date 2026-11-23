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
import '../../../../core/widgets/empty_state.dart';
import '../../../assessment/domain/entities/assessment_data.dart';
import '../../../assessment/presentation/widgets/assessment_labels.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/entities/goal.dart';
import '../providers/goal_providers.dart';
import '../widgets/goal_labels.dart';
import '../widgets/nutrition_target_card.dart';

/// Ringkasan & konfirmasi goal: status target, berat, target nutrisi,
/// asumsi perhitungan, dan peringatan keselamatan.
class GoalReviewScreen extends ConsumerStatefulWidget {
  const GoalReviewScreen({super.key, required this.goalId});

  final String goalId;

  @override
  ConsumerState<GoalReviewScreen> createState() => _GoalReviewScreenState();
}

class _GoalReviewScreenState extends ConsumerState<GoalReviewScreen> {
  bool _acknowledged = false;

  /// Langkah "Tujuan" & "Keselamatan" di wizard.
  static const _goalStep = 1;
  static const _safetyStep = 6;

  void _adjust({int? step}) {
    final path = Routes.assessmentPath(step: step);
    if (context.canPop()) {
      context.pushReplacement(path);
    } else {
      context.go(path);
    }
  }

  Future<void> _resubmit(double? targetKg) async {
    final id = await ref.read(goalConfirmControllerProvider.notifier).resubmitWithTarget(targetKg);
    if (!mounted) return;
    if (id != null) {
      context.showSnack(
        targetKg == null
            ? context.l10n.noTargetWeightApplied
            : context.l10n.suggestionApplied(Fmt.one(targetKg)),
      );
      context.pushReplacement(Routes.goalPath(id));
    } else if (ref.read(goalConfirmControllerProvider).error case final e?) {
      context.showSnack(failureMessage(context.l10n, e));
    }
  }

  Future<void> _confirm(Goal goal) async {
    final ok = await ref
        .read(goalConfirmControllerProvider.notifier)
        .confirm(goal.id, acknowledgedWarnings: _acknowledged);
    if (!mounted) return;
    if (ok) {
      await _awaitOnboarded();
      if (!mounted) return;
      context.showSnack(context.l10n.goalConfirmed);
      context.go(Routes.home);
    } else if (ref.read(goalConfirmControllerProvider).error case final e?) {
      context.showSnack(failureMessage(context.l10n, e));
    }
  }

  /// Tunggu profil (listener Firestore) mencatat onboarding selesai agar
  /// gerbang router tidak sempat mengarahkan balik ke onboarding.
  Future<void> _awaitOnboarded() async {
    bool done(AsyncValue<UserProfile?> p) => onboardingStatusOf(p) == OnboardingStatus.completed;
    if (done(ref.read(userProfileProvider))) return;
    final completer = Completer<void>();
    final sub = ref.listenManual(userProfileProvider, (_, next) {
      if (done(next) && !completer.isCompleted) completer.complete();
    });
    await completer.future.timeout(const Duration(seconds: 5), onTimeout: () {});
    sub.close();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(goalProvider(widget.goalId));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          async.value?.status == GoalStatus.active ? l.goalActiveTitle : l.goalReviewTitle,
        ),
      ),
      body: switch (async) {
        AsyncValue(:final value?) => _content(value),
        AsyncData() => EmptyState(icon: Icons.search_off, title: l.goalNotFound),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
          action: FilledButton(
            onPressed: () => ref.invalidate(goalProvider(widget.goalId)),
            child: Text(l.retry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _content(Goal goal) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final busy = ref.watch(goalConfirmControllerProvider).isLoading;
    final proposed = goal.status == GoalStatus.proposed;
    final canSubmit = goal.canConfirm && (!goal.requiresAcknowledgement || _acknowledged) && !busy;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (goal.safety.stop) _SafetyStopCard() else if (proposed) _VerdictCard(goal: goal),
              const SizedBox(height: 12),
              _WeightCard(goal: goal),
              const SizedBox(height: 12),
              if (!goal.safety.stop) ...[
                NutritionTargetCard(plan: goal.nutrition),
                const SizedBox(height: 12),
              ],
              _AssumptionsCard(goal: goal),
              if (goal.safety.warnings.any((w) => w != SafetyWarning.redFlagSymptoms)) ...[
                const SizedBox(height: 12),
                _WarningsCard(goal: goal),
                if (proposed && goal.canConfirm) ...[
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    tileColor: palette.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                    ),
                    value: _acknowledged,
                    title: Text(l.acknowledgeWarnings, style: theme.textTheme.bodyMedium),
                    onChanged: (v) => setState(() => _acknowledged = v ?? false),
                  ),
                ],
              ],
              const SizedBox(height: 16),
              Text(
                l.disclaimerShort,
                style: TextStyle(fontSize: 12, height: 17 / 12, color: palette.muted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (proposed)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: palette.surface2,
                          foregroundColor: theme.colorScheme.onSurface,
                          side: BorderSide.none,
                        ),
                        onPressed: busy
                            ? null
                            : () => _adjust(
                                step: goal.safety.stop
                                    ? _safetyStep
                                    : (goal.canConfirm ? null : _goalStep),
                              ),
                        child: Text(goal.canConfirm ? l.editAnswers : l.adjustTarget),
                      ),
                    ),
                    if (!goal.canConfirm && !goal.safety.stop)
                      if (goal.evaluation.suggestedTargetWeightKg case final kg?) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: busy ? null : () => _resubmit(kg),
                            child: busy
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.5),
                                  )
                                : Text(l.useSuggestion(Fmt.one(kg))),
                          ),
                        ),
                      ],
                    if (goal.canConfirm) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: canSubmit ? () => _confirm(goal) : null,
                          child: busy
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.5),
                                )
                              : Text(l.confirmGoal),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Panel status bertint (vonis target, peringatan, stop keselamatan).
class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.children,
    required this.background,
    required this.foreground,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;
  final Color background;
  final Color foreground;

  /// Warna ikon & judul (default: [foreground]).
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final accent = titleColor ?? foreground;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: foreground, fontSize: 14, height: 20 / 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accent, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SafetyStopCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return _StatusCard(
      icon: Icons.health_and_safety_outlined,
      title: l.safetyStopTitle,
      background: scheme.errorContainer,
      foreground: scheme.onErrorContainer,
      children: [Text(l.safetyStopMessage)],
    );
  }
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final e = goal.evaluation;
    if (e.verdict == GoalVerdict.realistic) {
      return _StatusCard(
        icon: Icons.check_circle_rounded,
        title: l.verdictRealistic,
        background: palette.accentSoft,
        foreground: scheme.onSurface,
        titleColor: scheme.primary,
        children: [Text(l.verdictRealisticMessage)],
      );
    }
    return _StatusCard(
      icon: Icons.tune_rounded,
      title: l.verdictNeedsAdjustment,
      background: palette.warning.withValues(alpha: 0.14),
      foreground: scheme.onSurface,
      titleColor: palette.warning,
      children: [
        for (final r in e.reasons) ...[Text(l.goalReason(r, goal)), const SizedBox(height: 6)],
        if (e.reasons.contains(GoalReason.rateTooFast))
          if (l.conservativeNote(goal.safety) case final note?) ...[
            Text(note),
            const SizedBox(height: 6),
          ],
        if (e.suggestedWeeks case final w?) Text(l.suggestionWeeks(w)),
        if (e.suggestedTargetWeightKg case final kg?)
          Text(l.suggestionTarget(Fmt.one(kg), goal.targetWeeks)),
      ],
    );
  }
}

class _WeightCard extends StatelessWidget {
  const _WeightCard({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final e = goal.evaluation;
    final target = goal.targetWeightKg;
    const big = TextStyle(
      fontSize: 34,
      height: 38 / 34,
      fontWeight: FontWeight.w800,
      fontFeatures: tabular,
      letterSpacing: -0.5,
    );
    final muted = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.muted);
    Widget weight(String label, String? kg) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: muted),
        const SizedBox(height: 2),
        if (kg == null)
          Text(l.noTargetWeight, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
        else
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: kg, style: big),
                TextSpan(text: ' ${l.unitKg}', style: muted),
              ],
            ),
          ),
      ],
    );
    final tiles = <(String, String)>[
      if (e.deltaKg case final d?) (l.labelDelta, l.kgValue(Fmt.signed(d))),
      (l.labelPeriod, l.weeksValue(goal.targetWeeks)),
      if (e.weeklyChangeKg case final w?) (l.labelWeeklyRate, l.kgPerWeekValue(Fmt.two(w))),
    ];
    final rows = <(String, String)>[
      (l.labelGoal, l.primaryGoal(goal.primaryGoal)),
      (l.labelTargetDate, Fmt.isoDate(goal.targetDate)),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.sectionWeightGoal, style: theme.textTheme.titleMedium),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: weight(l.labelStartWeight, Fmt.one(goal.startWeightKg))),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 12),
                  child: Icon(Icons.arrow_forward_rounded, color: theme.colorScheme.primary),
                ),
                Expanded(
                  child: weight(l.labelTargetWeight, target == null ? null : Fmt.one(target)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, (label, value)) in tiles.indexed) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: palette.surface2,
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: muted.copyWith(fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFeatures: tabular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(label, style: TextStyle(fontSize: 14, color: palette.muted)),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFeatures: tabular,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              goal.primaryGoal == PrimaryGoal.recomposition
                  ? l.recompositionNote
                  : l.expectedGainNote(
                      Fmt.two(e.expectedWeeklyGainKg.min),
                      Fmt.two(e.expectedWeeklyGainKg.max),
                    ),
              style: TextStyle(fontSize: 12, height: 17 / 12, color: palette.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssumptionsCard extends StatelessWidget {
  const _AssumptionsCard({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final n = goal.nutrition;
    final items = [
      l.assumptionBmr(l.kcalOf(n.bmrKcal)),
      l.assumptionTdee(l.kcalOf(n.tdeeKcal), Fmt.two(n.activityFactor)),
      if (n.surplusPct > 0)
        l.assumptionSurplus(Fmt.one(n.surplusPct), l.kcalOf(n.targetKcalRange))
      else
        l.assumptionMaintenance(l.kcalOf(n.targetKcalRange)),
      l.assumptionProtein(Fmt.one(n.proteinG / n.proteinBasisKg), Fmt.one(n.proteinBasisKg)),
      if (n.proteinBasisKg < goal.startWeightKg) l.assumptionProteinBasis,
      l.assumptionFat,
      l.assumptionCarbs,
      l.assumptionRounding,
      if (goal.safety.conservative) l.assumptionConservative,
      l.assumptionReview,
      l.assumptionVersion(goal.configVersion),
    ];
    final theme = Theme.of(context);
    final palette = context.palette;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: palette.surface2, shape: BoxShape.circle),
          child: Icon(Icons.functions_rounded, size: 20, color: theme.colorScheme.primary),
        ),
        title: Text(l.sectionAssumptions, style: theme.textTheme.titleMedium),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final t in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7, right: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(t, style: const TextStyle(fontSize: 14, height: 20 / 14)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _WarningsCard extends StatelessWidget {
  const _WarningsCard({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    return _StatusCard(
      icon: Icons.warning_amber_rounded,
      title: l.sectionWarnings,
      background: palette.warning.withValues(alpha: 0.14),
      foreground: scheme.onSurface,
      titleColor: palette.warning,
      children: [
        for (final w in goal.safety.warnings)
          if (w != SafetyWarning.redFlagSymptoms)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('•  ${l.safetyWarning(w, goal)}'),
            ),
      ],
    );
  }
}
