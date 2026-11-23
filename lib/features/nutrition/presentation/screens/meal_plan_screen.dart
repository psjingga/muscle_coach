import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
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
      appBar: AppBar(
        title: Text(l.mealPlanTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
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
    final palette = context.palette;
    final actions = ref.read(nutritionActionsProvider.notifier);
    final isDraft = plan.status == MealPlanStatus.draft;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: palette.accentSoft,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 14, color: theme.colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          l.mealPlanAiLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (plan.rationale.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(plan.rationale, style: theme.textTheme.bodyLarge),
              ],
              for (final w in plan.warnings) ...[
                const SizedBox(height: 12),
                _WarningCallout(text: _warning(context, w)),
              ],
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _line(context, l.mealPlanTotals, plan.totals),
                        key: const Key('meal-plan-totals'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFeatures: tabular,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _line(context, l.mealPlanVsTarget, plan.target),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFeatures: tabular,
                          color: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${l.mealPlanRecalc} ${l.nutritionEstimateNote}',
                        style: TextStyle(fontSize: 12, color: palette.muted),
                      ),
                    ],
                  ),
                ),
              ),
              for (final m in plan.meals) ...[const SizedBox(height: 12), _MealCard(meal: m)],
              if (plan.model != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    l.mealPlanModel(plan.model!, plan.promptVersion ?? ''),
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                ),
            ],
          ),
        ),
        if (isDraft)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('meal-plan-discard'),
                        onPressed: () async {
                          await actions.deleteMealPlan(plan.id);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text(l.mealPlanDiscard),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        key: const Key('meal-plan-use'),
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
          ),
      ],
    );
  }
}

/// Kartu satu waktu makan: judul, total, lalu bahan bergaya baris catatan.
class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal});

  final PlannedMeal meal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final m = meal;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.meal(m.slot).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                          color: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(m.title, style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l.kcal(m.totals.kcal),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              l.macros(m.totals),
              style: TextStyle(fontSize: 12, fontFeatures: tabular, color: palette.muted),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            for (var idx = 0; idx < m.items.length; idx++) ...[
              if (idx > 0) const Divider(height: 1),
              _ItemRow(item: m.items[idx]),
            ],
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final PlannedFood item;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final badge = l.qualityBadge(item.quality);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badge == null ? palette.surface2 : palette.accentSoft,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        badge ?? l.fmSourceTkpi,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: badge == null ? palette.muted : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  [l.gramValue(gramsText(item.grams)), l.macros(item.nutrients)].join(' · '),
                  style: TextStyle(fontSize: 12, fontFeatures: tabular, color: palette.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l.kcal(item.nutrients.kcal),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFeatures: tabular,
            ),
          ),
        ],
      ),
    );
  }
}

/// Kotak peringatan bertint warning dengan ikon.
class _WarningCallout extends StatelessWidget {
  const _WarningCallout({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: palette.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 18 / 13)),
          ),
        ],
      ),
    );
  }
}
