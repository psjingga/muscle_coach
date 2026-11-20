import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/food.dart';
import '../../domain/meal_plan.dart';
import '../providers/nutrition_providers.dart';
import '../widgets/nutrition_labels.dart';

/// Pratinjau menu: alasan, peringatan, bahan & gram, total (dihitung
/// aplikasi) vs target. Draft harus disetujui sebelum dipakai.
class MealPlanScreen extends ConsumerWidget {
  const MealPlanScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final plan = ref.watch(mealPlanProvider(planId));
    return Scaffold(
      appBar: AppBar(title: Text(l.mealPlanTitle)),
      body: plan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.errorUnknown)),
        data: (p) => p == null ? Center(child: Text(l.errorUnknown)) : _Body(plan: p),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.plan});

  final MealPlan plan;

  String _warning(BuildContext context, String code) {
    final l = context.l10n;
    return switch (code) {
      MealPlanWarning.eatingDisorder => l.mealPlanWarnEatingDisorder,
      MealPlanWarning.allergyCheck => l.mealPlanWarnAllergy,
      MealPlanWarning.inconsistentData => l.mealPlanWarnInconsistent,
      MealPlanWarning.portionsAdjusted => l.mealPlanWarnPortions,
      _ => code,
    };
  }

  String _line(
    BuildContext context,
    String Function(String, String, String, String) f,
    Nutrients n,
  ) {
    final l = context.l10n;
    return f(l.kcal(n.kcal), Fmt.integer(n.protein), Fmt.integer(n.carbs), Fmt.integer(n.fat));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final actions = ref.read(nutritionActionsProvider.notifier);
    final isDraft = plan.status == MealPlanStatus.draft;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Chip(
                    label: Text(l.mealPlanAiLabel),
                    avatar: const Icon(Icons.auto_awesome, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              if (plan.rationale.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(plan.rationale, style: theme.textTheme.bodyLarge),
              ],
              for (final w in plan.warnings)
                Card(
                  color: theme.colorScheme.errorContainer,
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_rounded),
                    title: Text(_warning(context, w)),
                  ),
                ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _line(context, l.mealPlanTotals, plan.totals),
                        key: const Key('meal-plan-totals'),
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(_line(context, l.mealPlanVsTarget, plan.target)),
                      const SizedBox(height: 8),
                      Text(
                        '${l.mealPlanRecalc} ${l.nutritionEstimateNote}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              for (final m in plan.meals)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.meal(m.slot), style: theme.textTheme.labelLarge),
                        Text(m.title, style: theme.textTheme.titleMedium),
                        Text('${l.kcal(m.totals.kcal)} · ${l.macros(m.totals)}'),
                        const Divider(),
                        for (final i in m.items)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(i.name),
                            subtitle: Text(
                              [
                                l.gramValue(gramsText(i.grams)),
                                l.macros(i.nutrients),
                                ?l.qualityBadge(i.quality),
                              ].join(' · '),
                            ),
                            trailing: Text(l.kcal(i.nutrients.kcal)),
                          ),
                      ],
                    ),
                  ),
                ),
              if (plan.model != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l.mealPlanModel(plan.model!, plan.promptVersion ?? ''),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
        if (isDraft)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('meal-plan-discard'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      onPressed: () async {
                        await actions.deleteMealPlan(plan.id);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Text(l.mealPlanDiscard),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      key: const Key('meal-plan-use'),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      onPressed: () async {
                        final ok = await actions.activateMealPlan(plan.id);
                        if (!context.mounted) return;
                        if (ok) {
                          context.showSnack(l.mealPlanActivated);
                          Navigator.pop(context);
                        } else {
                          context.showSnack(l.errorUnknown);
                        }
                      },
                      child: Text(l.mealPlanUse),
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
