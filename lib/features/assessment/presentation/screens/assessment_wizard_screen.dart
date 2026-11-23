import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/assessment_wizard_controller.dart';
import '../../domain/validators/assessment_validator.dart';
import '../widgets/assessment_labels.dart';
import '../widgets/assessment_steps.dart';
import '../widgets/target_rejection_dialog.dart';

/// Wizard assessment 7 langkah dengan progres, draft, dan tombol kembali.
class AssessmentWizardScreen extends ConsumerStatefulWidget {
  const AssessmentWizardScreen({super.key, this.initialStep});

  /// Langkah awal (mis. dari "Sesuaikan target"); default: langkah draft.
  final int? initialStep;

  @override
  ConsumerState<AssessmentWizardScreen> createState() => _AssessmentWizardScreenState();
}

class _AssessmentWizardScreenState extends ConsumerState<AssessmentWizardScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // Terapkan langkah awal sekali setelah draft dimuat.
    final step = widget.initialStep;
    if (step != null) {
      ref.read(assessmentWizardProvider.future).then((_) {
        if (mounted) ref.read(assessmentWizardProvider.notifier).goTo(step);
      }, onError: (Object _) {});
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _toTop() {
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.onboarding);
    }
  }

  /// Bila target perlu disesuaikan, tampilkan penyebabnya. `true` bila
  /// pengguna harus mengubah target dulu (tidak boleh lanjut).
  Future<bool> _blockedByTarget() async {
    final c = ref.read(assessmentWizardProvider.notifier);
    final rejection = c.targetRejection();
    if (rejection == null) return false;
    final fix = await showTargetRejectionDialog(context, rejection);
    if (!mounted) return true;
    final l = context.l10n;
    switch (fix) {
      case TargetFix.useSuggestion:
        final kg = rejection.evaluation.suggestedTargetWeightKg!;
        c.applySuggestedTarget(kg);
        context.showSnack(l.suggestionApplied(Fmt.one(kg)));
        return c.targetRejection() != null;
      case TargetFix.noTargetWeight:
        c.edit((d) => d.copyWith(goal: d.goal.copyWith(targetWeightKg: null)));
        context.showSnack(l.noTargetWeightApplied);
        return c.targetRejection() != null;
      case TargetFix.editMyself:
        c.goTo(AssessmentValidator.goalStep);
        _toTop();
        return true;
    }
  }

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    if (await _blockedByTarget() || !mounted) return;
    if (ref.read(assessmentWizardProvider.notifier).next()) _toTop();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (await _blockedByTarget() || !mounted) return;
    final goalId = await ref.read(assessmentWizardProvider.notifier).submit();
    if (!mounted) return;
    if (goalId == null) {
      _toTop();
      return;
    }
    context.pushReplacement(Routes.goalPath(goalId));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(assessmentWizardProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), tooltip: l.cancel, onPressed: _close),
        title: Text(l.assessmentTitle),
      ),
      body: switch (async) {
        AsyncValue(:final value?) => _body(value),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
          action: FilledButton(
            onPressed: () => ref.invalidate(assessmentWizardProvider),
            child: Text(l.retry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _body(AssessmentWizardState s) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = ref.read(assessmentWizardProvider.notifier);
    const total = AssessmentValidator.stepCount;
    return Column(
      children: [
        LinearProgressIndicator(value: (s.step + 1) / total),
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(
                l.assessmentStepCounter(s.step + 1, total),
                style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(l.stepTitle(s.step), style: theme.textTheme.headlineSmall),
              const SizedBox(height: 20),
              if (s.submitError case final e?) ...[
                Card(
                  color: theme.colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      failureMessage(l, e),
                      style: TextStyle(color: theme.colorScheme.onErrorContainer),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Key per langkah: field langkah berbeda tidak berbagi state input.
              KeyedSubtree(
                key: ValueKey(s.step),
                child: AssessmentStepView(state: s),
              ),
              Text(
                l.draftSavedHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              children: [
                if (s.step > 0) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: s.submitting
                          ? null
                          : () {
                              c.back();
                              _toTop();
                            },
                      child: Text(l.back),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: s.submitting
                        ? null
                        : s.isLastStep
                        ? _submit
                        : _next,
                    child: s.submitting
                        ? const SizedBox.square(
                            dimension: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(s.isLastStep ? l.submitAssessment : l.next),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
