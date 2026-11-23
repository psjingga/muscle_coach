import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/tab_app_bar.dart';
import '../../../ai_coach/presentation/ai_plan_flow.dart';
import '../../../../core/database/database_providers.dart';
import '../../domain/entities/workout.dart';
import '../../domain/workout_math.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';

/// Tab Latihan: jadwal mingguan program aktif, atau ajakan membuat program.
class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final planId = ref.watch(activePlanIdProvider);
    Widget circle(String tooltip, IconData icon, String route) => Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          fixedSize: const Size.square(44),
        ),
        icon: Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => context.push(route),
      ),
    );
    return Scaffold(
      appBar: TabAppBar(
        title: l.tabWorkout,
        actions: [
          circle(l.exerciseLibrary, Icons.menu_book_outlined, Routes.exercises),
          circle(l.history, Icons.history_rounded, Routes.history),
          const SizedBox(width: 12),
        ],
      ),
      body: planId == null ? const _NoPlan() : _ActivePlan(planId: planId),
    );
  }
}

/// Buat draft program lalu buka pratinjaunya.
Future<void> createAndOpenStarterPlan(BuildContext context, WidgetRef ref) async {
  final planId = await ref.read(workoutActionsProvider.notifier).createStarterPlan();
  if (!context.mounted) return;
  if (planId != null) {
    await context.push(Routes.planPath(planId));
  } else if (ref.read(workoutActionsProvider).error case final e?) {
    context.showSnack(failureMessage(context.l10n, e));
  }
}

class _NoPlan extends ConsumerWidget {
  const _NoPlan();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final busy = ref.watch(workoutActionsProvider).isLoading;
    return EmptyState(
      icon: Icons.fitness_center_outlined,
      title: l.emptyWorkoutTitle,
      message: l.workoutNoPlanMessage,
      action: Column(
        children: [
          FilledButton.icon(
            onPressed: busy ? null : () => generateAiPlan(context, ref),
            icon: const Icon(Icons.auto_awesome),
            label: Text(l.generateWithAi),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: busy ? null : () => createAndOpenStarterPlan(context, ref),
            icon: busy
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.rule),
            label: Text(l.createStarterPlan),
          ),
        ],
      ),
    );
  }
}

class _ActivePlan extends ConsumerWidget {
  const _ActivePlan({required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final plan = ref.watch(workoutPlanProvider(planId)).value;
    final daysAsync = ref.watch(planDaysProvider(planId));
    final now = ref.watch(clockProvider)();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final history = ref.watch(workoutHistoryProvider).value ?? const <WorkoutSession>[];
    final mondayIso = Fmt.toIsoDate(monday);
    final doneThisWeek = {
      for (final s in history)
        if (s.planId == planId && s.date.compareTo(mondayIso) >= 0) s.dayId: s,
    };

    return switch (daysAsync) {
      AsyncValue(:final value?) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          if (plan != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _Pill(text: l.planActiveTitle, accent: true),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l.split(plan.split),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.planSummary(plan.daysPerWeek, plan.sessionMinutes),
                      style: TextStyle(fontSize: 14, color: palette.muted),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.workoutWeekProgress,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: palette.muted,
                            ),
                          ),
                        ),
                        Text(
                          l.workoutSessionsCount(doneThisWeek.length, value.length),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            fontFeatures: tabular,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: value.isEmpty ? 0 : doneThisWeek.length / value.length,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.tonalIcon(
                      key: const Key('workout-view-plan'),
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.surface2,
                        foregroundColor: theme.colorScheme.onSurface,
                        minimumSize: const Size.fromHeight(44),
                      ),
                      onPressed: () => context.push(Routes.planPath(planId)),
                      icon: const Icon(Icons.list_alt_rounded, size: 18),
                      label: Text(l.workoutViewPlan),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: Text(
              l.workoutSchedule.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: palette.muted,
              ),
            ),
          ),
          for (final day in value) ...[
            _DayCard(
              planId: planId,
              day: day,
              date: DateTime(monday.year, monday.month, monday.day + day.weekday - 1),
              today: now,
              done: doneThisWeek[day.id],
            ),
            const SizedBox(height: 12),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.self_improvement_rounded, size: 16, color: palette.muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(l.restDaysNote, style: TextStyle(fontSize: 12, color: palette.muted)),
                ),
              ],
            ),
          ),
          if (history.isNotEmpty) ...[
            const SizedBox(height: 16),
            _RecentHistory(sessions: history.take(2).toList()),
          ],
        ],
      ),
      AsyncValue(:final error?) => EmptyState(
        icon: Icons.cloud_off_outlined,
        title: failureMessage(l, error),
        action: FilledButton(
          onPressed: () => ref.invalidate(planDaysProvider(planId)),
          child: Text(l.retry),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, this.accent = false});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent ? palette.accentSoft : palette.surface2,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: accent ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
    );
  }
}

/// Satu hari di jadwal minggu ini: selesai (centang), hari ini (bingkai volt
/// + "Mulai sesi"), terlewat, atau berikutnya.
class _DayCard extends ConsumerWidget {
  const _DayCard({
    required this.planId,
    required this.day,
    required this.date,
    required this.today,
    required this.done,
  });

  final String planId;
  final PlanDay day;
  final DateTime date;
  final DateTime today;
  final WorkoutSession? done;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final isToday = day.weekday == today.weekday;
    final isPast = day.weekday < today.weekday;
    final finished = done != null;
    final dayName = l.weekdayLong(day.weekday);
    final status = finished
        ? l.workoutDayDone(dayName)
        : isToday
        ? l.todayBadge
        : (isPast ? l.workoutDayMissed(dayName) : dayName);
    void open() => context.push(Routes.dayPath(planId, day.id));

    final badge = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: finished ? theme.colorScheme.primary : (isToday ? null : palette.surface2),
        border: isToday && !finished
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : null,
      ),
      child: finished
          ? Icon(Icons.check_rounded, color: theme.colorScheme.onPrimary)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE', 'id').format(date).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    color: palette.muted,
                  ),
                ),
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                ),
              ],
            ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isToday && !finished ? theme.colorScheme.primary : palette.muted,
          ),
        ),
        Text(
          l.focus(day.focus),
          style: theme.textTheme.titleMedium?.copyWith(fontSize: isToday && !finished ? 18 : 16),
        ),
        Text(
          l.dayMeta(day.exercises.length, day.estimatedMinutes),
          style: TextStyle(fontSize: 13, color: palette.muted),
        ),
      ],
    );

    if (isToday && !finished) {
      final busy = ref.watch(workoutActionsProvider).isLoading;
      final shown = day.exercises.take(3).toList();
      final more = day.exercises.length - shown.length;
      Future<void> start() async {
        final id = await ref.read(workoutActionsProvider.notifier).startOrResume(planId, day);
        if (id != null && context.mounted) await context.push(Routes.sessionPath(id));
      }

      return Card(
        key: ValueKey('day-card-${day.id}'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          side: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: open,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    badge,
                    const SizedBox(width: 12),
                    Expanded(child: info),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in shown) _Pill(text: p.name),
                    if (more > 0) _Pill(text: l.workoutMore(more)),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  key: const Key('workout-start-today'),
                  onPressed: busy ? null : start,
                  icon: const Icon(Icons.play_arrow_rounded, size: 24),
                  label: Text(l.startSession),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Opacity(
      opacity: finished ? 0.7 : 1,
      child: Card(
        key: ValueKey('day-card-${day.id}'),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: finished ? () => context.push(Routes.sessionPath(done!.id)) : open,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                badge,
                const SizedBox(width: 12),
                Expanded(child: info),
                Icon(Icons.chevron_right_rounded, color: palette.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dua sesi selesai terakhir + "Lihat semua".
class _RecentHistory extends ConsumerWidget {
  const _RecentHistory({required this.sessions});

  final List<WorkoutSession> sessions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Row(
              children: [
                Expanded(child: Text(l.workoutRecent, style: theme.textTheme.titleMedium)),
                TextButton(
                  onPressed: () => context.push(Routes.history),
                  child: Text(l.workoutSeeAll),
                ),
              ],
            ),
          ),
          for (final s in sessions) ...[
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Consumer(
              builder: (context, ref, _) {
                final sets = ref.watch(sessionSetsProvider(s.id)).value ?? const <SetLog>[];
                final date = DateFormat('EEE, d MMM', 'id').format(DateTime.parse(s.date));
                return InkWell(
                  onTap: () => context.push(Routes.sessionPath(s.id)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.focus(s.focus),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '$date · ${l.workoutSetsVolume(WorkoutMath.doneSets(sets), Fmt.integer(WorkoutMath.volumeKg(sets, s.planned)))}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFeatures: tabular,
                                  color: palette.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (s.energy != null) _Pill(text: l.workoutEnergy(s.energy!)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Teks status program untuk layar lain.
String planStatusTitle(BuildContext context, WorkoutPlan plan) =>
    plan.status == PlanStatus.draft ? context.l10n.planDraftTitle : context.l10n.planActiveTitle;
