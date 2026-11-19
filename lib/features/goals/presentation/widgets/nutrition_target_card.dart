import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/goal.dart';
import 'goal_labels.dart';

/// Kartu target energi & makro harian (dipakai di ringkasan goal & Home).
class NutritionTargetCard extends StatelessWidget {
  const NutritionTargetCard({super.key, required this.plan, this.footer});

  final NutritionPlan plan;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final split = plan.energySplitPct;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.sectionNutrition, style: theme.textTheme.titleMedium)),
                Chip(
                  label: Text(l.estimateLabel),
                  visualDensity: VisualDensity.compact,
                  avatar: const Icon(Icons.calculate_outlined, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.kcalValue(Fmt.integer(plan.targetKcal)),
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (plan.sexBasis == SexBasis.range) ...[
              Text(l.kcalOf(plan.targetKcalRange), style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                l.rangeNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            _MacroRow(
              label: l.macroProtein,
              grams: plan.proteinG,
              detail: l.macroDetail(Fmt.one(plan.proteinGPerKg), split.protein),
              color: theme.colorScheme.primary,
              fraction: split.protein / 100,
            ),
            _MacroRow(
              label: l.macroCarbs,
              grams: plan.carbsG,
              detail: l.macroCarbsDetail(split.carbs),
              color: theme.colorScheme.tertiary,
              fraction: split.carbs / 100,
            ),
            _MacroRow(
              label: l.macroFat,
              grams: plan.fatG,
              detail: l.macroDetail(Fmt.one(plan.fatGPerKg), split.fat),
              color: theme.colorScheme.secondary,
              fraction: split.fat / 100,
            ),
            ?footer,
          ],
        ),
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.grams,
    required this.detail,
    required this.color,
    required this.fraction,
  });

  final String label;
  final int grams;
  final String detail;
  final Color color;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
              Text(l.gramValue(Fmt.integer(grams)), style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction.clamp(0, 1),
              minHeight: 6,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
