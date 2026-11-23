import 'package:flutter/material.dart';

import '../../../../app/theme/app_palette.dart';
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
    final palette = Theme.of(context).extension<AppPalette>()!;
    final (title, body, icon, fg) = switch (p.status) {
      GoalProgressStatus.insufficientData => (
        l.goalStatusInsufficient,
        l.goalStatusInsufficientBody,
        Icons.hourglass_empty_rounded,
        palette.muted,
      ),
      GoalProgressStatus.onTrack => (
        l.goalStatusOnTrack,
        l.goalStatusOnTrackBody(change, min, max),
        Icons.check_circle_outline_rounded,
        theme.colorScheme.primary,
      ),
      GoalProgressStatus.needsReview => (
        l.goalStatusReview,
        l.goalStatusReviewBody(change, min, max),
        Icons.visibility_outlined,
        palette.warning,
      ),
      GoalProgressStatus.adjustTarget => (
        l.goalStatusAdjust,
        l.goalStatusAdjustBody(min, max),
        Icons.tune_rounded,
        palette.warning,
      ),
    };
    return Container(
      key: Key('goal-status-${p.status.name}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: palette.surface2, borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l.goalStatusTitle}: $title',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: fg),
                ),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(fontSize: 13, color: palette.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
