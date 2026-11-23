import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/context_x.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../goals/domain/goal_planner.dart';
import '../../../goals/presentation/widgets/goal_labels.dart';

/// Pilihan pengguna saat target ditolak.
enum TargetFix { useSuggestion, noTargetWeight, editMyself }

/// Pop-up penyebab target perlu disesuaikan, dengan saran yang bisa langsung
/// dipakai. Menutup dialog tanpa memilih = [TargetFix.editMyself].
Future<TargetFix> showTargetRejectionDialog(BuildContext context, TargetPreview p) async {
  final l = context.l10n;
  final theme = Theme.of(context);
  final e = p.evaluation;
  final suggestedKg = e.suggestedTargetWeightKg;
  final note = e.reasons.contains(GoalReason.rateTooFast) ? l.conservativeNote(p.safety) : null;

  final result = await showDialog<TargetFix>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.tune),
      title: Text(l.verdictNeedsAdjustment),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final r in e.reasons) ...[
            Text(l.goalReasonFor(r, e, p.startKg)),
            const SizedBox(height: 8),
          ],
          if (note != null) ...[
            Text(note, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
          ],
          if (e.suggestedWeeks case final w?) Text(l.suggestionWeeks(w)),
          if (suggestedKg != null) Text(l.suggestionTarget(Fmt.one(suggestedKg), p.weeks)),
          const SizedBox(height: 12),
          Text(
            l.targetRejectedHint,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      actionsOverflowDirection: VerticalDirection.down,
      actionsOverflowButtonSpacing: 4,
      actions: [
        if (suggestedKg != null)
          FilledButton(
            onPressed: () => Navigator.pop(context, TargetFix.useSuggestion),
            child: Text(l.useSuggestion(Fmt.one(suggestedKg))),
          ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, TargetFix.noTargetWeight),
          child: Text(l.useNoTargetWeight),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, TargetFix.editMyself),
          child: Text(l.editMyself),
        ),
      ],
    ),
  );
  return result ?? TargetFix.editMyself;
}
