import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
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
                if (proposed && goal.canConfirm)
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    value: _acknowledged,
                    title: Text(l.acknowledgeWarnings),
                    onChanged: (v) => setState(() => _acknowledged = v ?? false),
                  ),
              ],
              const SizedBox(height: 12),
              Text(
                l.disclaimerShort,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (proposed)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
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
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.children,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foreground),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: foreground),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(color: foreground),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
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
    final e = goal.evaluation;
    if (e.verdict == GoalVerdict.realistic) {
      return _StatusCard(
        icon: Icons.check_circle_outline,
        title: l.verdictRealistic,
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
        children: [Text(l.verdictRealisticMessage)],
      );
    }
    return _StatusCard(
      icon: Icons.tune,
      title: l.verdictNeedsAdjustment,
      background: scheme.tertiaryContainer,
      foreground: scheme.onTertiaryContainer,
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
    final e = goal.evaluation;
    final target = goal.targetWeightKg;
    final rows = <(String, String)>[
      (l.labelGoal, l.primaryGoal(goal.primaryGoal)),
      (l.labelStartWeight, l.kgValue(Fmt.one(goal.startWeightKg))),
      (l.labelTargetWeight, target == null ? l.noTargetWeight : l.kgValue(Fmt.one(target))),
      if (e.deltaKg case final d?) (l.labelDelta, l.kgValue(Fmt.signed(d))),
      (l.labelPeriod, l.weeksValue(goal.targetWeeks)),
      (l.labelTargetDate, Fmt.isoDate(goal.targetDate)),
      if (e.weeklyChangeKg case final w?) (l.labelWeeklyRate, l.kgPerWeekValue(Fmt.two(w))),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.sectionWeightGoal, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
                    Text(value, style: theme.textTheme.titleSmall),
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
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: const Icon(Icons.functions),
        title: Text(l.sectionAssumptions),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final t in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(t)),
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
    return _StatusCard(
      icon: Icons.warning_amber_rounded,
      title: l.sectionWarnings,
      background: scheme.secondaryContainer,
      foreground: scheme.onSecondaryContainer,
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
