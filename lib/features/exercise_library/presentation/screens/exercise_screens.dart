import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../workout/presentation/widgets/workout_labels.dart';
import '../../domain/exercise.dart';
import '../providers/exercise_providers.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(l.exerciseLibrary)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: l.searchExercise,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: switch (async) {
              AsyncValue(:final value?) => ListView(
                children: [
                  for (final e in value.values.where(_matches))
                    ListTile(
                      title: Text(e.name),
                      subtitle: Text(
                        [
                          e.primaryMuscles.map(l.muscleCode).join(', '),
                          if (e.equipment.isEmpty)
                            l.noEquipment
                          else
                            e.equipment.map(l.equipmentCode).join(' + '),
                        ].join(' · '),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(Routes.exercisePath(e.id)),
                    ),
                ],
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
      appBar: AppBar(title: Text(exercise?.name ?? l.exerciseLibrary)),
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
    final e = exercise;

    Widget section(String title, List<String> items, {bool numbered = false}) => Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          for (final (i, t) in items.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 24, child: Text(numbered ? '${i + 1}.' : '•')),
                  Expanded(child: Text(t)),
                ],
              ),
            ),
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text(l.levelCode(e.level))),
            if (e.equipment.isEmpty)
              Chip(label: Text(l.noEquipment))
            else
              for (final eq in e.equipment) Chip(label: Text(l.equipmentCode(eq))),
          ],
        ),
        if (e.needsSpotter)
          Card(
            color: theme.colorScheme.errorContainer,
            child: ListTile(
              leading: Icon(Icons.warning_amber_rounded, color: theme.colorScheme.onErrorContainer),
              title: Text(
                l.spotterNeeded,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          '${l.exercisePrimaryMuscles}: ${e.primaryMuscles.map(l.muscleCode).join(', ')}',
          style: theme.textTheme.bodyLarge,
        ),
        if (e.secondaryMuscles.isNotEmpty)
          Text('${l.exerciseSecondaryMuscles}: ${e.secondaryMuscles.map(l.muscleCode).join(', ')}'),
        section(l.exerciseInstructions, e.instructions, numbered: true),
        if (e.mistakes.isNotEmpty) section(l.exerciseMistakes, e.mistakes),
        if (e.safety.isNotEmpty) section(l.exerciseSafety, e.safety),
        if (e.alternatives.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l.exerciseAlternatives, style: theme.textTheme.titleMedium),
          for (final id in e.alternatives)
            if (catalog[id] case final alt?)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(alt.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(Routes.exercisePath(alt.id)),
              ),
        ],
        const SizedBox(height: 16),
        Text(l.disclaimerShort, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
