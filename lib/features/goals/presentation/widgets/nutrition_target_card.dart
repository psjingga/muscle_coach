import 'package:flutter/material.dart';

import '../../../../app/theme/app_palette.dart';
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
    final palette = context.palette;
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: palette.accentSoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calculate_outlined, size: 14, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        l.estimateLabel,
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
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: Fmt.integer(plan.targetKcal),
                    style: const TextStyle(
                      fontSize: 44,
                      height: 48 / 44,
                      fontWeight: FontWeight.w800,
                      fontFeatures: tabular,
                      letterSpacing: -1,
                    ),
                  ),
                  TextSpan(
                    text: ' ${l.obUnitKcal}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (plan.sexBasis == SexBasis.range) ...[
              const SizedBox(height: 4),
              Text(
                l.kcalOf(plan.targetKcalRange),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFeatures: tabular,
                ),
              ),
              const SizedBox(height: 4),
              Text(l.rangeNote, style: TextStyle(fontSize: 12, color: palette.muted)),
            ],
            const SizedBox(height: 16),
            _MacroRow(
              label: l.macroProtein,
              grams: plan.proteinG,
              detail: l.macroDetail(Fmt.one(plan.proteinGPerKg), split.protein),
              color: palette.protein,
              fraction: split.protein / 100,
            ),
            _MacroRow(
              label: l.macroCarbs,
              grams: plan.carbsG,
              detail: l.macroCarbsDetail(split.carbs),
              color: palette.carbs,
              fraction: split.carbs / 100,
            ),
            _MacroRow(
              label: l.macroFat,
              grams: plan.fatG,
              detail: l.macroDetail(Fmt.one(plan.fatGPerKg), split.fat),
              color: palette.fat,
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
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                l.gramValue(Fmt.integer(grams)),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  fontFeatures: tabular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: fraction.clamp(0, 1),
              minHeight: 6,
              color: color,
              backgroundColor: palette.surface2,
            ),
          ),
          const SizedBox(height: 4),
          Text(detail, style: TextStyle(fontSize: 12, color: palette.muted)),
        ],
      ),
    );
  }
}
