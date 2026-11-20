import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/utils/context_x.dart';
import '../../domain/entities/workout.dart';
import 'workout_labels.dart';

/// Baris target satu latihan; ketuk untuk detail teknik.
class PlannedExerciseTile extends StatelessWidget {
  const PlannedExerciseTile({super.key, required this.exercise, this.index});

  final PlannedExercise exercise;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: index == null
          ? null
          : CircleAvatar(
              radius: 16,
              child: Text('${index! + 1}', style: theme.textTheme.labelLarge),
            ),
      title: Row(
        children: [
          Flexible(child: Text(exercise.name)),
          if (exercise.priority) ...[const SizedBox(width: 8), _Badge(l.priorityBadge)],
        ],
      ),
      subtitle: Text(
        [l.prescriptionOf(exercise), l.restRirOf(exercise), ?exercise.rationale].join('\n'),
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.info_outline),
      onTap: () => context.push(Routes.exercisePath(exercise.exerciseId)),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onTertiaryContainer),
      ),
    );
  }
}

/// Kartu satu hari program (jadwal mingguan).
class PlanDayCard extends StatelessWidget {
  const PlanDayCard({super.key, required this.day, required this.isToday, this.onTap});

  final PlanDay day;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: isToday ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        onTap: onTap,
        title: Text('${l.weekdayLong(day.weekday)} · ${l.focus(day.focus)}'),
        subtitle: Text(l.dayMeta(day.exercises.length, day.estimatedMinutes)),
        trailing: isToday
            ? Chip(label: Text(l.todayBadge), visualDensity: VisualDensity.compact)
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}

/// Daftar peringatan program.
class PlanWarnings extends StatelessWidget {
  const PlanWarnings({super.key, required this.codes});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final texts = codes.map(l.planWarning).whereType<String>().toList();
    if (texts.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final t in texts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 20, color: scheme.onSecondaryContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(t, style: TextStyle(color: scheme.onSecondaryContainer)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Catatan kecil abu-abu.
class MutedNote extends StatelessWidget {
  const MutedNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
