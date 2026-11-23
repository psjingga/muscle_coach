import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/context_x.dart';
import '../../../exercise_library/presentation/providers/exercise_providers.dart';
import '../../../exercise_library/presentation/widgets/exercise_media.dart';
import '../../domain/entities/workout.dart';
import 'workout_labels.dart';

/// Baris target satu latihan (thumbnail · nomor · nama · resep · istirahat/RIR);
/// ketuk untuk detail teknik. Dipakai di dalam satu kartu, dipisah [Divider].
class PlannedExerciseTile extends ConsumerWidget {
  const PlannedExerciseTile({super.key, required this.exercise, this.index});

  final PlannedExercise exercise;
  final int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final palette = context.palette;
    final entry = ref.watch(exerciseCatalogProvider).value?[exercise.exerciseId];
    return InkWell(
      onTap: () => context.push(Routes.exercisePath(exercise.exerciseId)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (entry != null)
              ExerciseThumbnail(exercise: entry)
            else
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: palette.surface2,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                child: Icon(Icons.fitness_center_rounded, color: palette.muted),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (index != null) ...[
                        Text(
                          '${index! + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFeatures: tabular,
                            color: palette.muted,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          exercise.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (exercise.priority) ...[
                        const SizedBox(width: 8),
                        SoftPill(l.priorityBadge, accent: true),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.prescriptionOf(exercise),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      fontFeatures: tabular,
                    ),
                  ),
                  Text(
                    l.restRirOf(exercise),
                    style: TextStyle(fontSize: 12, fontFeatures: tabular, color: palette.muted),
                  ),
                  if (exercise.rationale case final r?)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        r,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: palette.muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 22, color: palette.muted),
          ],
        ),
      ),
    );
  }
}

/// Daftar latihan dalam satu kartu, tiap baris dipisah garis tipis.
class PlannedExerciseList extends StatelessWidget {
  const PlannedExerciseList({super.key, required this.exercises, this.header});

  final List<PlannedExercise> exercises;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?header,
          for (final (i, p) in exercises.indexed) ...[
            if (i > 0 || header != null) divider,
            PlannedExerciseTile(exercise: p, index: i),
          ],
        ],
      ),
    );
  }
}

/// Pill kecil: surface-2, atau aksen lembut bila [accent].
class SoftPill extends StatelessWidget {
  const SoftPill(this.text, {super.key, this.accent = false, this.icon});

  final String text;
  final bool accent;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = accent ? Theme.of(context).colorScheme.primary : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: accent ? palette.accentSoft : palette.surface2,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kotak info surface-2 dengan ikon (mis. penjelasan RIR).
class InfoBox extends StatelessWidget {
  const InfoBox(this.texts, {super.key, this.icon = Icons.info_outline_rounded});

  final List<String> texts;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = TextStyle(fontSize: 12, height: 17 / 12, color: palette.muted);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: palette.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, t) in texts.indexed)
                  Padding(
                    padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
                    child: Text(t, style: style),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ubin info kecil (ikon + judul pendek + baris redup), mis. pemanasan.
class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(body, style: TextStyle(fontSize: 11, color: palette.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bilah bawah lengket: surface + garis atas, berisi satu tombol penuh.
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        child: Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), child: child),
      ),
    );
  }
}

/// AppBar layar turunan: judul + subjudul redup, garis bawah.
class SubtitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubtitleAppBar({super.key, required this.title, this.subtitle, this.actions});

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          if (subtitle case final s? when s.isNotEmpty)
            Text(
              s,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFeatures: tabular,
                color: context.palette.muted,
              ),
            ),
        ],
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
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
    final palette = context.palette;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: isToday
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            )
          : null,
      child: ListTile(
        onTap: onTap,
        title: Text(
          '${l.weekdayLong(day.weekday)} · ${l.focus(day.focus)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          l.dayMeta(day.exercises.length, day.estimatedMinutes),
          style: TextStyle(fontFeatures: tabular, color: palette.muted),
        ),
        trailing: isToday
            ? SoftPill(l.todayBadge, accent: true)
            : Icon(Icons.chevron_right_rounded, color: palette.muted),
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
    final warning = context.palette.warning;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: warning.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final t in texts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 20, color: warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(t, style: TextStyle(fontSize: 13, color: scheme.onSurface)),
                  ),
                ],
              ),
            ),
        ],
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
      child: Text(text, style: theme.textTheme.bodySmall?.copyWith(color: context.palette.muted)),
    );
  }
}
