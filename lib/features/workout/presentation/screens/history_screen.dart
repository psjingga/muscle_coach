import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';

/// Riwayat sesi selesai (30 terbaru). Ketuk untuk melihat target vs aktual.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(workoutHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.historyTitle)),
      body: switch (async) {
        AsyncValue(:final value?) when value.isEmpty => EmptyState(
          icon: Icons.history,
          title: l.historyEmpty,
        ),
        AsyncValue(:final value?) => ListView.separated(
          itemCount: value.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final s = value[i];
            return ListTile(
              title: Text(l.focus(s.focus)),
              subtitle: Text('${l.weekdayLong(s.weekday)}, ${Fmt.isoDate(s.date)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.sessionPath(s.id)),
            );
          },
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
