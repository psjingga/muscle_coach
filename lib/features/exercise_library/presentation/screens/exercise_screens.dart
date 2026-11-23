import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../workout/presentation/widgets/workout_labels.dart';
import '../../../workout/presentation/widgets/workout_widgets.dart';
import '../../domain/exercise.dart';
import '../providers/exercise_providers.dart';
import '../widgets/exercise_media.dart';

/// Daftar katalog latihan dengan pencarian nama/otot.
class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  String _query = '';

  bool _matches(Exercise e) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final l = context.l10n;
    final haystack = [
      e.name,
      ...e.aliases,
      ...e.primaryMuscles.map(l.muscleCode),
      ...e.equipment.map(l.equipmentCode),
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(exerciseCatalogProvider);
    final theme = Theme.of(context);
    final palette = context.palette;
    return Scaffold(
      appBar: SubtitleAppBar(title: l.exerciseLibrary),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                labelText: l.searchExercise,
                filled: true,
                fillColor: palette.surface2,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: switch (async) {
              AsyncValue(:final value?) => Builder(
                builder: (context) {
                  final items = value.values.where(_matches).toList();
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          l.wk2ExerciseCount(items.length),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFeatures: tabular,
                            color: palette.muted,
                          ),
                        ),
                      ),
                      if (items.isNotEmpty)
                        Card(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final (i, e) in items.indexed) ...[
                                if (i > 0)
                                  Divider(height: 1, color: theme.colorScheme.outlineVariant),
                                _CatalogRow(exercise: e),
                              ],
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
              AsyncValue(:final error?) => EmptyState(
                icon: Icons.cloud_off_outlined,
                title: failureMessage(l, error),
                action: FilledButton(
                  onPressed: () => ref.invalidate(exerciseCatalogProvider),
                  child: Text(l.retry),
                ),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

/// Baris katalog: thumbnail, nama, otot utama, pill alat.
class _CatalogRow extends StatelessWidget {
  const _CatalogRow({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final palette = context.palette;
    final e = exercise;
    return InkWell(
      onTap: () => context.push(Routes.exercisePath(e.id)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ExerciseThumbnail(exercise: e),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    e.primaryMuscles.map(l.muscleCode).join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (e.equipment.isEmpty)
                        SoftPill(l.noEquipment)
                      else
                        for (final eq in e.equipment) SoftPill(l.equipmentCode(eq)),
                    ],
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

/// Detail teknik, kesalahan umum, keselamatan, dan alternatif.
class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(exerciseCatalogProvider);
    final exercise = async.value?[exerciseId];
    return Scaffold(
      appBar: SubtitleAppBar(title: exercise?.name ?? l.exerciseLibrary),
      body: switch (async) {
        AsyncValue(:final value?) when exercise != null => _Detail(
          exercise: exercise,
          catalog: value,
        ),
        AsyncData() => EmptyState(icon: Icons.search_off, title: l.exerciseNotFound),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
          action: FilledButton(
            onPressed: () => ref.invalidate(exerciseCatalogProvider),
            child: Text(l.retry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.exercise, required this.catalog});

  final Exercise exercise;
  final Map<String, Exercise> catalog;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final e = exercise;
    const titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    final labelStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: palette.muted);

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );

    Widget section(String title, List<String> items, {bool numbered = false}) => card([
      Text(title, style: titleStyle),
      const SizedBox(height: 10),
      for (final (i, t) in items.indexed)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (numbered)
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: palette.surface2, shape: BoxShape.circle),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFeatures: tabular,
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 20,
                  child: Text('•', style: TextStyle(color: palette.muted)),
                ),
              Expanded(
                child: Text(t, style: const TextStyle(fontSize: 14, height: 20 / 14)),
              ),
            ],
          ),
        ),
    ]);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ExerciseVisuals(exercise: e),
          ),
        ),
        card([
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              SoftPill(l.levelCode(e.level), accent: true),
              if (e.equipment.isEmpty)
                SoftPill(l.noEquipment)
              else
                for (final eq in e.equipment) SoftPill(l.equipmentCode(eq)),
            ],
          ),
          const SizedBox(height: 12),
          Text(l.exercisePrimaryMuscles, style: labelStyle),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final m in e.primaryMuscles) SoftPill(l.muscleCode(m), accent: true)],
          ),
          if (e.secondaryMuscles.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(l.exerciseSecondaryMuscles, style: labelStyle),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final m in e.secondaryMuscles) SoftPill(l.muscleCode(m))],
            ),
          ],
        ]),
        if (e.needsSpotter)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.spotterNeeded,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        section(l.exerciseInstructions, e.instructions, numbered: true),
        if (e.mistakes.isNotEmpty) section(l.exerciseMistakes, e.mistakes),
        if (e.safety.isNotEmpty) section(l.exerciseSafety, e.safety),
        if (e.alternatives.isNotEmpty)
          Card(
            margin: const EdgeInsets.only(top: 12),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(l.exerciseAlternatives, style: titleStyle),
                ),
                for (final id in e.alternatives)
                  if (catalog[id] case final alt?) ...[
                    Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    InkWell(
                      onTap: () => context.push(Routes.exercisePath(alt.id)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                alt.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: palette.muted),
                          ],
                        ),
                      ),
                    ),
                  ],
              ],
            ),
          ),
        const SizedBox(height: 16),
        Text(l.disclaimerShort, style: TextStyle(fontSize: 12, color: palette.muted)),
      ],
    );
  }
}
