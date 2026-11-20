import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../assessment/presentation/widgets/assessment_labels.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../../nutrition/presentation/providers/nutrition_providers.dart';
import '../../../nutrition/presentation/widgets/day_summary_card.dart';
import '../../../../core/database/database_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../workout/domain/workout_math.dart';
import '../../../workout/presentation/providers/workout_providers.dart';
import '../../../workout/presentation/widgets/workout_labels.dart';

/// Tab Home: sapaan, latihan berikutnya, asupan & sisa target hari ini, dan
/// ringkasan goal aktif. Check-in menyusul pada fase selanjutnya.
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
          const _WorkoutCard(),
          const SizedBox(height: 12),
          if (nutrition != null) ...[const _TodayNutritionCard(), const SizedBox(height: 12)],
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

/// Asupan hari ini vs target (ringkas) + tombol catat makanan.
class _TodayNutritionCard extends ConsumerWidget {
  const _TodayNutritionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final date = ref.watch(todayDateProvider);
    final day = ref.watch(dayNutritionProvider(date)).value;
    if (day == null) return const SizedBox.shrink();
    return DaySummaryCard(
      day: day,
      compact: true,
      footer: Row(
        children: [
          Expanded(
            child: Text(l.nutritionHomeTitle, style: Theme.of(context).textTheme.labelLarge),
          ),
          TextButton.icon(
            key: const Key('home-log-food'),
            onPressed: () => context.go(Routes.nutrition),
            icon: const Icon(Icons.restaurant),
            label: Text(l.nutritionHomeLog),
          ),
        ],
      ),
    );
  }
}

/// Latihan hari ini / berikutnya dari program aktif.
class _WorkoutCard extends ConsumerWidget {
  const _WorkoutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final planId = ref.watch(activePlanIdProvider);
    if (planId == null) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.fitness_center),
          title: Text(l.homeNoPlan),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go(Routes.workout),
        ),
      );
    }
    final days = ref.watch(planDaysProvider(planId)).value;
    final todayWeekday = ref.watch(clockProvider)().weekday;
    final next = days == null ? null : WorkoutMath.nextDay(days, todayWeekday);
    if (next == null) return const SizedBox.shrink();
    final isToday = next.weekday == todayWeekday;
    return Card(
      color: isToday ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        leading: const Icon(Icons.fitness_center),
        title: Text(isToday ? l.homeTodayWorkout : l.homeNextWorkout(l.weekdayLong(next.weekday))),
        subtitle: Text(
          '${l.focus(next.focus)} · ${l.dayMeta(next.exercises.length, next.estimatedMinutes)}',
        ),
        trailing: FilledButton.tonal(
          style: FilledButton.styleFrom(minimumSize: AppTheme.compactButtonSize),
          onPressed: () => context.push(Routes.dayPath(planId, next.id)),
          child: Text(l.openWorkout),
        ),
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
