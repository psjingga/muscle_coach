import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/progress_math.dart';

/// Selisih berat bertanda, maks. 2 desimal: +0,25 / −0,1.
String signedKg(num v) => v > 0 ? '+${Fmt.two(v)}' : (v < 0 ? '−${Fmt.two(-v)}' : '0');

/// Kartu status target (on track / perlu evaluasi / disesuaikan / data kurang).
class GoalStatusCard extends StatelessWidget {
  const GoalStatusCard({super.key, required this.progress});

  final GoalProgress progress;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final p = progress;
    final min = signedKg(p.expectedKgPerWeek.min);
    final max = signedKg(p.expectedKgPerWeek.max);
    final change = p.lastChangeKg == null ? '' : signedKg(p.lastChangeKg!);
    final (title, body, icon, color) = switch (p.status) {
      GoalProgressStatus.insufficientData => (
        l.goalStatusInsufficient,
        l.goalStatusInsufficientBody,
        Icons.hourglass_empty,
        theme.colorScheme.surfaceContainerHighest,
      ),
      GoalProgressStatus.onTrack => (
        l.goalStatusOnTrack,
        l.goalStatusOnTrackBody(change, min, max),
        Icons.check_circle_outline,
        theme.colorScheme.primaryContainer,
      ),
      GoalProgressStatus.needsReview => (
        l.goalStatusReview,
        l.goalStatusReviewBody(change, min, max),
        Icons.visibility_outlined,
        theme.colorScheme.tertiaryContainer,
      ),
      GoalProgressStatus.adjustTarget => (
        l.goalStatusAdjust,
        l.goalStatusAdjustBody(min, max),
        Icons.tune,
        theme.colorScheme.secondaryContainer,
      ),
    };
    return Card(
      color: color,
      child: ListTile(
        key: Key('goal-status-${p.status.name}'),
        leading: Icon(icon),
        title: Text('${l.goalStatusTitle}: $title'),
        subtitle: Text(body),
      ),
    );
  }
}
