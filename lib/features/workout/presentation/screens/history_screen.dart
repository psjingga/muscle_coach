import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/workout.dart';
import '../../domain/workout_math.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';
import '../widgets/workout_widgets.dart';

/// Riwayat sesi selesai (30 terbaru). Ketuk untuk melihat target vs aktual.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final async = ref.watch(workoutHistoryProvider);
    return Scaffold(
      appBar: SubtitleAppBar(title: l.historyTitle),
      body: switch (async) {
        AsyncValue(:final value?) when value.isEmpty => EmptyState(
          icon: Icons.history,
          title: l.historyEmpty,
        ),
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, s) in value.indexed) ...[
                    if (i > 0) Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    _HistoryRow(session: s),
                  ],
                ],
              ),
            ),
          ],
        ),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
          action: FilledButton(
            onPressed: () => ref.invalidate(workoutHistoryProvider),
            child: Text(l.retry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// Satu sesi: fokus, tanggal · set · volume, pill energi.
class _HistoryRow extends ConsumerWidget {
  const _HistoryRow({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final palette = context.palette;
    final s = session;
    final sets = ref.watch(sessionSetsProvider(s.id)).value ?? const <SetLog>[];
    final date = DateFormat('d MMM yyyy', 'id').format(DateTime.parse(s.date));
    final volume = l.workoutSetsVolume(
      WorkoutMath.doneSets(sets),
      Fmt.integer(WorkoutMath.volumeKg(sets, s.planned)),
    );
    return InkWell(
      onTap: () => context.push(Routes.sessionPath(s.id)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.focus(s.focus),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l.weekdayLong(s.weekday)}, $date · $volume',
                    style: TextStyle(fontSize: 12, fontFeatures: tabular, color: palette.muted),
                  ),
                ],
              ),
            ),
            if (s.energy != null) ...[
              const SizedBox(width: 8),
              SoftPill(l.workoutEnergy(s.energy!)),
            ],
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: palette.muted),
          ],
        ),
      ),
    );
  }
}
