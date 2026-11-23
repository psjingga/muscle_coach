import 'package:flutter/material.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/progress_ring.dart';
import '../../domain/food_log.dart';
import 'nutrition_labels.dart';

/// Ringkasan asupan vs target: cincin kalori, sisa, dan 3 bar makro.
class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({super.key, required this.day});

  final DayNutrition day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final target = day.target;
    final got = day.consumed;
    final left = day.remaining;
    final numStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      fontFeatures: tabular,
      height: 1.1,
    );
    final over = left != null && left.kcal < 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ProgressRing(
                  value: target == null || target.kcal <= 0 ? 0 : got.kcal / target.kcal,
                  size: 128,
                  stroke: 10,
                  color: over ? palette.warning : theme.colorScheme.primary,
                  track: palette.surface2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Fmt.integer(got.kcal),
                        key: const Key('day-kcal'),
                        style: numStyle?.copyWith(fontSize: 28),
                      ),
                      Text(
                        target == null
                            ? l.nutritionConsumed
                            : l.nutritionOfTarget(l.kcal(target.kcal)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                if (left != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Fmt.integer(left.kcal.abs()),
                          key: const Key('day-kcal-left'),
                          style: numStyle?.copyWith(
                            fontSize: 32,
                            color: over ? palette.warning : null,
                          ),
                        ),
                        Text(
                          over ? l.homeKcalOver : l.homeKcalLeft,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: palette.muted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: palette.accentSoft,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            l.homeEstimate,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (target != null) ...[
              const SizedBox(height: 20),
              _Macro(
                label: l.macroProtein,
                got: got.protein,
                target: target.protein,
                color: palette.protein,
              ),
              _Macro(
                label: l.macroCarbs,
                got: got.carbs,
                target: target.carbs,
                color: palette.carbs,
              ),
              _Macro(label: l.macroFat, got: got.fat, target: target.fat, color: palette.fat),
            ],
            const SizedBox(height: 4),
            Text(
              day.hasEstimates
                  ? '${l.nutritionEstimateNote} ${l.nutritionHasEstimates}'
                  : l.nutritionEstimateNote,
              style: TextStyle(fontSize: 12, color: palette.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  const _Macro({required this.label, required this.got, required this.target, required this.color});

  final String label;
  final double got;
  final double target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final palette = context.palette;
    final over = target > 0 && got > target * 1.1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: palette.muted,
                  ),
                ),
              ),
              Text(
                l.nutritionMacroProgress(Fmt.integer(got), Fmt.integer(target)),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFeatures: tabular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: target <= 0 ? 0 : (got / target).clamp(0, 1).toDouble(),
              minHeight: 8,
              color: over ? palette.warning : color,
              backgroundColor: palette.surface2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Satu baris catatan makanan: nama + label sumber, gram & makro, kcal.
class FoodEntryTile extends StatelessWidget {
  const FoodEntryTile({super.key, required this.entry, required this.onTap});

  final FoodLogEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final badge = l.qualityBadge(entry.quality);
    final grams = entry.grams;
    return InkWell(
      key: Key('entry-${entry.id}'),
      onTap: onTap,
      child: Padding(
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
                          entry.name,
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
                          badge ?? 'TKPI',
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
                    [
                      if (grams != null) l.entryGrams(gramsText(grams)),
                      l.macros(entry.nutrients),
                    ].join(' · '),
                    style: TextStyle(fontSize: 12, fontFeatures: tabular, color: palette.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l.kcal(entry.nutrients.kcal),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFeatures: tabular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
