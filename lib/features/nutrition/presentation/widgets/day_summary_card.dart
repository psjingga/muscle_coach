import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/food_log.dart';
import 'nutrition_labels.dart';

/// Ringkasan asupan hari ini vs target: kalori + 3 makro.
class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({super.key, required this.day, this.compact = false, this.footer});

  final DayNutrition day;
  final bool compact;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final target = day.target;
    final got = day.consumed;
    final left = day.remaining;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.nutritionConsumed, style: theme.textTheme.labelLarge),
                      Text(
                        l.kcal(got.kcal),
                        key: const Key('day-kcal'),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      if (target != null)
                        Text(
                          l.nutritionOfTarget(l.kcal(target.kcal)),
                          style: theme.textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
                if (left != null)
                  Text(
                    left.kcal >= 0
                        ? l.nutritionKcalLeft(Fmt.integer(left.kcal))
                        : l.nutritionKcalOver(Fmt.integer(-left.kcal)),
                    key: const Key('day-kcal-left'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: left.kcal >= 0 ? null : theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
            if (target != null) ...[
              const SizedBox(height: 8),
              _bar(context, got.kcal, target.kcal, theme.colorScheme.primary),
              const SizedBox(height: 12),
              _Macro(
                label: l.macroProtein,
                got: got.protein,
                target: target.protein,
                color: theme.colorScheme.primary,
              ),
              _Macro(
                label: l.macroCarbs,
                got: got.carbs,
                target: target.carbs,
                color: theme.colorScheme.tertiary,
              ),
              _Macro(
                label: l.macroFat,
                got: got.fat,
                target: target.fat,
                color: theme.colorScheme.secondary,
              ),
            ],
            if (!compact) ...[
              const SizedBox(height: 4),
              Text(
                day.hasEstimates
                    ? '${l.nutritionEstimateNote} ${l.nutritionHasEstimates}'
                    : l.nutritionEstimateNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            ?footer,
          ],
        ),
      ),
    );
  }
}

Widget _bar(BuildContext context, double got, double target, Color color) {
  final over = target > 0 && got > target * 1.1;
  final c = over ? Theme.of(context).colorScheme.error : color;
  return ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: LinearProgressIndicator(
      value: target <= 0 ? 0 : (got / target).clamp(0, 1),
      minHeight: 8,
      color: c,
      backgroundColor: color.withValues(alpha: 0.15),
    ),
  );
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
              Text(
                l.nutritionMacroProgress(Fmt.integer(got), Fmt.integer(target)),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          _bar(context, got, target, color),
        ],
      ),
    );
  }
}

/// Satu baris catatan makanan.
class FoodEntryTile extends StatelessWidget {
  const FoodEntryTile({super.key, required this.entry, required this.onTap});

  final FoodLogEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final badge = l.qualityBadge(entry.quality);
    final grams = entry.grams;
    return ListTile(
      key: Key('entry-${entry.id}'),
      contentPadding: EdgeInsets.zero,
      title: Text(entry.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          if (grams != null) l.entryGrams(gramsText(grams)),
          l.macros(entry.nutrients),
          ?badge,
        ].join(' · '),
      ),
      trailing: Text(l.kcal(entry.nutrients.kcal), style: theme.textTheme.titleSmall),
      onTap: onTap,
    );
  }
}
