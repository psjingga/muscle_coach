import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/progress_ring.dart';
import '../../../assessment/presentation/widgets/assessment_labels.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../../nutrition/presentation/providers/nutrition_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../progress/domain/progress_math.dart';
import '../../../progress/domain/progress_models.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../../../workout/domain/entities/workout.dart';
import '../../../workout/domain/workout_math.dart';
import '../../../workout/presentation/providers/workout_providers.dart';
import '../../../workout/presentation/widgets/workout_labels.dart';

/// Tab Beranda (desain Superdesign "Training-first + Ring"): tanggal & sapaan,
/// strip minggu ini, latihan hari ini/berikutnya, cincin kalori, statistik
/// singkat, check-in, dan target aktif.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final name = ref.watch(userProfileProvider).value?.displayName;
    final goal = ref.watch(activeGoalProvider).value;
    final now = ref.watch(clockProvider)();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Text(
              DateFormat('EEEE, d MMM', 'id').format(now),
              style: theme.textTheme.labelLarge?.copyWith(color: context.palette.muted),
            ),
            const SizedBox(height: 4),
            Text(
              name == null || name.isEmpty ? l.homeGreetingNoName : l.homeGreeting(name),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const _WeekStrip(),
            const SizedBox(height: 16),
            const _WorkoutHero(),
            const SizedBox(height: 12),
            const _NutritionRingCard(),
            const _StatTiles(),
            if (goal != null) ...[
              const SizedBox(height: 12),
              const _CheckInRow(),
              const SizedBox(height: 12),
              _GoalCompact(goal: goal),
            ],
          ],
        ),
      ),
    );
  }
}

/// Kartu datar standar desain (permukaan + garis 1 px, radius 20).
class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

/// "3 × 8–12" (ringkas untuk daftar di kartu).
String _shortPrescription(PlannedExercise p) {
  final range = p.repMin == p.repMax ? '${p.repMin}' : '${p.repMin}–${p.repMax}';
  return '${p.sets} × $range${p.isTimed ? ' dtk' : ''}';
}

TextStyle? _num(BuildContext context, double size) => Theme.of(context).textTheme.headlineSmall
    ?.copyWith(fontSize: size, height: 1.15, fontWeight: FontWeight.w800, fontFeatures: tabular);

/// Senin–Minggu pekan ini: hari latihan program, sesi selesai, hari ini.
class _WeekStrip extends ConsumerWidget {
  const _WeekStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final now = ref.watch(clockProvider)();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final planId = ref.watch(activePlanIdProvider);
    final planDays = planId == null
        ? const <PlanDay>[]
        : ref.watch(planDaysProvider(planId)).value ?? const <PlanDay>[];
    final trainingWeekdays = {for (final d in planDays) d.weekday};
    final done = {
      for (final t in ref.watch(trainingDaysProvider).value ?? const <TrainingDay>[]) t.date,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 7; i++)
          Builder(
            builder: (context) {
              final day = DateTime(monday.year, monday.month, monday.day + i);
              final iso = Fmt.toIsoDate(day);
              final isToday = day.day == now.day && day.month == now.month;
              final completed = done.contains(iso);
              final training = trainingWeekdays.contains(day.weekday);
              final strong = training || completed || isToday;
              return Semantics(
                label: '${l.weekdayLong(day.weekday)} ${day.day}',
                selected: isToday,
                child: Column(
                  children: [
                    Text(
                      l.weekday(day.weekday),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: strong ? scheme.onSurface : palette.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: completed
                            ? scheme.primary
                            : (training ? palette.surface2 : Colors.transparent),
                        border: isToday && !completed
                            ? Border.all(color: scheme.primary, width: 2)
                            : null,
                      ),
                      child: completed
                          ? Icon(Icons.check_rounded, size: 18, color: scheme.onPrimary)
                          : Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
                                fontFeatures: tabular,
                                color: strong ? scheme.onSurface : palette.muted,
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Latihan hari ini / berikutnya dengan 3 gerakan pertama + "Mulai latihan".
class _WorkoutHero extends ConsumerWidget {
  const _WorkoutHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final planId = ref.watch(activePlanIdProvider);
    if (planId == null) {
      return _Panel(
        onTap: () => context.go(Routes.workout),
        child: Row(
          children: [
            Icon(Icons.fitness_center_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(l.homeNoPlan)),
            const Icon(Icons.chevron_right),
          ],
        ),
      );
    }
    final days = ref.watch(planDaysProvider(planId)).value;
    final todayWeekday = ref.watch(clockProvider)().weekday;
    final next = days == null ? null : WorkoutMath.nextDay(days, todayWeekday);
    if (next == null) return const SizedBox.shrink();
    final isToday = next.weekday == todayWeekday;
    final busy = ref.watch(workoutActionsProvider).isLoading;
    final shown = next.exercises.take(3).toList();
    final more = next.exercises.length - shown.length;

    Future<void> start() async {
      final id = await ref.read(workoutActionsProvider.notifier).startOrResume(planId, next);
      if (id != null && context.mounted) await context.push(Routes.sessionPath(id));
    }

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fitness_center_rounded, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                isToday ? l.homeTodayWorkout : l.homeNextWorkout(l.weekdayLong(next.weekday)),
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l.focus(next.focus), style: _num(context, 28)),
          const SizedBox(height: 4),
          Text(
            l.dayMeta(next.exercises.length, next.estimatedMinutes),
            style: theme.textTheme.bodyLarge?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 16),
          for (final p in shown)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _shortPrescription(p),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontFeatures: tabular,
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
            ),
          if (more > 0)
            Text(
              l.homeMoreExercises(more),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: palette.muted),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: isToday
                ? FilledButton.icon(
                    key: const Key('home-start-workout'),
                    onPressed: busy ? null : start,
                    icon: const Icon(Icons.play_arrow_rounded, size: 24),
                    label: Text(l.homeStartWorkout),
                  )
                : FilledButton.tonal(
                    key: const Key('home-view-workout'),
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.surface2,
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => context.push(Routes.dayPath(planId, next.id)),
                    child: Text(l.homeViewWorkout),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Cincin sisa kalori + protein & karbohidrat + "Catat makanan".
class _NutritionRingCard extends ConsumerWidget {
  const _NutritionRingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final date = ref.watch(todayDateProvider);
    final day = ref.watch(dayNutritionProvider(date)).value;
    final target = day?.target;
    if (day == null || target == null || target.kcal <= 0) return const SizedBox.shrink();
    final got = day.consumed;
    final left = target.kcal - got.kcal;

    Widget macro(String label, double got, double target, Color color) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: palette.muted,
                  ),
                ),
              ),
              Text(
                '${l.homeMacroValue(Fmt.integer(got), Fmt.integer(target))} g',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFeatures: tabular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: target <= 0 ? 0 : (got / target).clamp(0, 1).toDouble(),
              minHeight: 6,
              color: color,
              backgroundColor: theme.colorScheme.surfaceContainerLow,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.nutritionHomeTitle, style: theme.textTheme.titleMedium)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: palette.accentSoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    l.homeEstimate,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ProgressRing(
                  value: got.kcal / target.kcal,
                  size: 120,
                  stroke: 12,
                  color: left < 0 ? palette.warning : theme.colorScheme.primary,
                  track: palette.surface2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Fmt.integer(left.abs()), style: _num(context, 26)),
                      Text(
                        left < 0 ? l.homeKcalOver : l.homeKcalLeft,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      macro(l.macroProtein, got.protein, target.protein, palette.protein),
                      const SizedBox(height: 10),
                      macro(l.macroCarbs, got.carbs, target.carbs, palette.carbs),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              key: const Key('home-log-food'),
              style: FilledButton.styleFrom(
                backgroundColor: palette.surface2,
                foregroundColor: theme.colorScheme.onSurface,
              ),
              onPressed: () => context.go(Routes.nutrition),
              child: Text(l.nutritionHomeLog),
            ),
          ],
        ),
      ),
    );
  }
}

/// Berat rata-rata 7 hari + latihan selesai minggu ini.
class _StatTiles extends ConsumerWidget {
  const _StatTiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final palette = context.palette;
    final weights = ref.watch(weightsProvider).value ?? const <WeightEntry>[];
    final avg = weights.isEmpty ? null : ProgressMath.movingAverage(weights).last.kg;
    final now = ref.watch(clockProvider)();
    final monday = Fmt.toIsoDate(DateTime(now.year, now.month, now.day - (now.weekday - 1)));
    final doneThisWeek = {
      for (final t in ref.watch(trainingDaysProvider).value ?? const <TrainingDay>[])
        if (t.date.compareTo(monday) >= 0) t.date,
    }.length;
    final planned = ref.watch(plannedSessionsPerWeekProvider).value;
    if (avg == null && planned == null) return const SizedBox.shrink();

    Widget tile(String label, String value, String? unit) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surface2,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.muted),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: value,
                style: _num(context, 28),
                children: [
                  if (unit != null)
                    TextSpan(
                      text: ' $unit',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: palette.muted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Row(
      children: [
        tile(l.homeAvgWeight7, avg == null ? '–' : Fmt.one(avg), avg == null ? null : 'kg'),
        const SizedBox(width: 12),
        tile(
          l.homeSessionsWeek,
          planned == null ? '$doneThisWeek' : '$doneThisWeek/$planned',
          null,
        ),
      ],
    );
  }
}

/// Baris check-in hari ini (ringkas).
class _CheckInRow extends ConsumerWidget {
  const _CheckInRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final date = ref.watch(todayDateProvider);
    final done = ref.watch(checkInsProvider).value?.any((c) => c.date == date) ?? false;
    void open() => context.push(Routes.checkInPath(date));
    return _Panel(
      onTap: open,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: palette.surface2, shape: BoxShape.circle),
            child: Icon(
              done ? Icons.task_alt_rounded : Icons.edit_calendar_rounded,
              size: 20,
              color: done ? theme.colorScheme.primary : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              done ? l.homeCheckInDoneShort : l.checkInToday,
              style: theme.textTheme.titleMedium,
            ),
          ),
          TextButton(
            key: const Key('home-checkin'),
            style: TextButton.styleFrom(
              backgroundColor: done ? null : palette.accentSoft,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onPressed: open,
            child: Text(done ? l.homeEdit : l.homeCheckInFill),
          ),
        ],
      ),
    );
  }
}

/// Target aktif: berat awal → target + progres dari tren berat.
class _GoalCompact extends ConsumerWidget {
  const _GoalCompact({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final target = goal.targetWeightKg;
    final latest = ref.watch(goalProgressProvider)?.latestAverageKg;
    final span = target == null ? 0.0 : target - goal.startWeightKg;
    final fraction = span == 0 || latest == null
        ? 0.0
        : ((latest - goal.startWeightKg) / span).clamp(0, 1).toDouble();
    final big = _num(context, 24);
    return _Panel(
      onTap: () => context.push(Routes.goalPath(goal.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.primaryGoal(goal.primaryGoal),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                l.weeksValue(goal.targetWeeks),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: palette.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(Fmt.one(goal.startWeightKg), style: big),
              if (target != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_right_alt_rounded, color: palette.muted),
                ),
                Text(Fmt.one(target), style: big),
              ],
              Text(
                ' kg',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: palette.muted),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: palette.muted),
            ],
          ),
          if (target == null)
            Text(l.noTargetWeight, style: TextStyle(color: palette.muted))
          else ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 4,
                backgroundColor: palette.surface2,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
