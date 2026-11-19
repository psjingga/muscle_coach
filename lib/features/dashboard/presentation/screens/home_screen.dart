import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../assessment/presentation/widgets/assessment_labels.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../../goals/presentation/widgets/nutrition_target_card.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// Tab Home: sapaan, target nutrisi harian, dan ringkasan goal aktif.
/// Latihan berikutnya & check-in menyusul pada fase selanjutnya.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final name = ref.watch(userProfileProvider).value?.displayName;
    final goal = ref.watch(activeGoalProvider).value;
    final nutrition = ref.watch(activeNutritionTargetProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabHome)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            name == null || name.isEmpty ? l.homeGreetingNoName : l.homeGreeting(name),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (nutrition != null) ...[
            NutritionTargetCard(plan: nutrition),
            const SizedBox(height: 12),
          ],
          if (goal != null) _GoalSummaryCard(goal: goal),
          const SizedBox(height: 24),
          Text(
            l.homeNextSteps,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _GoalSummaryCard extends StatelessWidget {
  const _GoalSummaryCard({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final target = goal.targetWeightKg;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(Routes.goalPath(goal.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.goalActiveTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l.primaryGoal(goal.primaryGoal), style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                [
                  l.kgValue(Fmt.one(goal.startWeightKg)),
                  if (target != null) l.kgValue(Fmt.one(target)),
                ].join(' → '),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                '${l.weeksValue(goal.targetWeeks)} · ${Fmt.isoDate(goal.targetDate)}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    l.seeDetails,
                    style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                  ),
                  Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
