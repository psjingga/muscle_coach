import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../exercise_library/presentation/providers/exercise_providers.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../domain/progress_math.dart';
import '../../domain/progress_models.dart';
import '../providers/progress_providers.dart';
import '../widgets/body_widgets.dart';
import '../widgets/progress_charts.dart';
import '../widgets/progress_forms.dart';
import '../widgets/progress_labels.dart';
import '../widgets/progress_section.dart';

/// Tab Progres: check-in, berat & status target, lingkar badan, foto, ringkasan mingguan,
/// asupan vs target, volume latihan, progres per gerakan, pencapaian.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final today = ref.watch(progressTodayProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.tabProgress)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          CheckInCard(date: today),
          const SizedBox(height: 8),
          const _WeightCard(),
          const SizedBox(height: 8),
          const MeasurementsCard(),
          const SizedBox(height: 8),
          const PhotosCard(),
          const SizedBox(height: 8),
          _WeeklyCard(today: today),
          const SizedBox(height: 8),
          _IntakeCard(today: today),
          const SizedBox(height: 8),
          _VolumeCard(today: today),
          const SizedBox(height: 8),
          const _ExerciseCard(),
          const SizedBox(height: 8),
          _MilestonesCard(today: today),
        ],
      ),
    );
  }
}

/// Kartu check-in hari ini (juga dipakai di Beranda).
class CheckInCard extends ConsumerWidget {
  const CheckInCard({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final checkIn = ref.watch(checkInsProvider).value?.where((c) => c.date == date).firstOrNull;
    final done = checkIn != null;
    final theme = Theme.of(context);
    return Card(
      color: done ? null : theme.colorScheme.tertiaryContainer,
      child: ListTile(
        key: const Key('checkin-card'),
        leading: Icon(done ? Icons.task_alt : Icons.edit_calendar_outlined),
        title: Text(done ? l.checkInDone : l.checkInToday),
        subtitle: !done
            ? Text(l.checkInPrompt)
            : (checkIn.isEmpty ? Text(l.checkInMarkedDone) : null),
        trailing: TextButton(
          onPressed: () => context.push(Routes.checkInPath(date)),
          child: Text(done ? l.checkInEdit : l.checkInOpen),
        ),
      ),
    );
  }
}

class _WeightCard extends ConsumerWidget {
  const _WeightCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final weights = ref.watch(weightsProvider).value ?? const <WeightEntry>[];
    final progress = ref.watch(goalProgressProvider);
    final today = ref.watch(clockProvider)();
    final from = Fmt.toIsoDate(today.subtract(const Duration(days: 83)));
    final recent = [
      for (final w in weights)
        if (w.date.compareTo(from) >= 0) w,
    ];
    final avg = ProgressMath.movingAverage(weights);
    final recentAvg = [
      for (final a in avg)
        if (a.date.compareTo(from) >= 0) a,
    ];
    final latest = weights.isEmpty ? null : weights.last;

    Future<void> log() async {
      final res = await showWeightSheet(context, today: today, initialKg: latest?.kg);
      if (res == null || !context.mounted) return;
      final ok = await ref.read(progressActionsProvider.notifier).saveWeight(res.date, res.kg);
      if (context.mounted) context.showSnack(ok ? l.weightSaved : l.errorUnknown);
    }

    return ProgressSection(
      title: l.weightTitle,
      trailing: FilledButton.tonalIcon(
        key: const Key('weight-log'),
        style: FilledButton.styleFrom(minimumSize: AppTheme.compactButtonSize),
        onPressed: log,
        icon: const Icon(Icons.add),
        label: Text(l.weightLog),
      ),
      children: [
        if (latest == null)
          Text(l.weightEmpty)
        else ...[
          Text(
            l.weightLatest(Fmt.one(latest.kg), Fmt.isoDate(latest.date)),
            key: const Key('weight-latest'),
            style: theme.textTheme.titleSmall,
          ),
          Text(l.weightAvg7(Fmt.one(avg.last.kg))),
          const SizedBox(height: 12),
          if (recent.length >= 2)
            WeightChart(
              points: [for (final w in recent) (date: w.date, kg: w.kg)],
              average: recentAvg,
              semanticLabel:
                  '${l.weightTitle}: ${l.weightLatest(Fmt.one(latest.kg), Fmt.isoDate(latest.date))}',
            ),
        ],
        const SizedBox(height: 8),
        mutedText(context, l.weightNote),
        if (progress != null) ...[const SizedBox(height: 8), GoalStatusCard(progress: progress)],
      ],
    );
  }
}

class _WeeklyCard extends ConsumerWidget {
  const _WeeklyCard({required this.today});

  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final current = ProgressMath.weekStartOf(today);
    final last = ProgressMath.addDays(current, -7);
    final reviews = ref.watch(storedReviewsProvider).value ?? const [];
    return ProgressSection(
      title: l.weeklyTitle,
      children: [
        ListTile(
          key: const Key('weekly-open'),
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.summarize_outlined),
          title: Text(l.weeklyOpen),
          subtitle: Text(
            l.weeklyRange(Fmt.isoDate(last), Fmt.isoDate(ProgressMath.addDays(last, 6))),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(Routes.weeklyReviewPath(last)),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.today_outlined),
          title: Text(l.weeklyThisWeek),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(Routes.weeklyReviewPath(current)),
        ),
        if (reviews.isNotEmpty) ...[
          const Divider(),
          Text(l.weeklyHistory, style: Theme.of(context).textTheme.titleSmall),
          for (final r in reviews.take(6))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                l.weeklyRange(
                  Fmt.isoDate(r.weekStart),
                  Fmt.isoDate(ProgressMath.addDays(r.weekStart, 6)),
                ),
              ),
              trailing: r.aiSummary == null ? null : const Icon(Icons.auto_awesome, size: 18),
              onTap: () => context.push(Routes.weeklyReviewPath(r.weekStart)),
            ),
        ],
      ],
    );
  }
}

class _IntakeCard extends ConsumerWidget {
  const _IntakeCard({required this.today});

  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final intake = ref.watch(intakeByDayProvider).value ?? const <DayIntake>[];
    final target = ref.watch(activeNutritionTargetProvider).value;
    final byDate = {for (final d in intake) d.date: d.kcal};
    final days = [
      for (var i = 13; i >= 0; i--)
        () {
          final d = ProgressMath.addDays(today, -i);
          return (date: d, kcal: byDate[d] ?? 0.0);
        }(),
    ];
    final any = days.any((d) => d.kcal > 0);
    return ProgressSection(
      title: l.intakeChartTitle,
      children: [
        if (!any)
          Text(l.intakeChartEmpty)
        else ...[
          IntakeChart(
            days: days,
            targetKcal: target?.targetKcal.toDouble(),
            semanticLabel: l.intakeChartTitle,
          ),
          if (target != null) ...[
            const SizedBox(height: 4),
            mutedText(context, l.intakeChartLegend(l.kcalValue(Fmt.integer(target.targetKcal)))),
          ],
        ],
      ],
    );
  }
}

class _VolumeCard extends ConsumerWidget {
  const _VolumeCard({required this.today});

  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final training = ref.watch(trainingDaysProvider).value ?? const <TrainingDay>[];
    final weeks = ProgressMath.weeklyVolume(training, today: today);
    final thisWeek = weeks.last;
    return ProgressSection(
      title: l.volumeChartTitle,
      children: [
        if (training.isEmpty)
          Text(l.volumeChartEmpty)
        else ...[
          VolumeChart(weeks: weeks, semanticLabel: l.volumeChartTitle),
          const SizedBox(height: 4),
          Text(
            '${l.weeklyThisWeek}: ${l.weeklyVolume(Fmt.integer(thisWeek.volumeKg))} · '
            '${l.volumeWeek(thisWeek.sessions)}',
          ),
          mutedText(context, l.volumeChartNote),
        ],
      ],
    );
  }
}

class _ExerciseCard extends ConsumerStatefulWidget {
  const _ExerciseCard();

  @override
  ConsumerState<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<_ExerciseCard> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final training = ref.watch(trainingDaysProvider).value ?? const <TrainingDay>[];
    final catalog = ref.watch(exerciseCatalogProvider).value ?? const {};
    // Gerakan dengan set berbeban, terbanyak dulu.
    final counts = <String, int>{};
    for (final t in training) {
      for (final s in t.sets) {
        if (s.weightKg != null && !s.timed) counts[s.exerciseId] = (counts[s.exerciseId] ?? 0) + 1;
      }
    }
    final ids = counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    if (ids.isEmpty) {
      return ProgressSection(title: l.exerciseChartTitle, children: [Text(l.exerciseChartEmpty)]);
    }
    final id = ids.contains(_selected) ? _selected! : ids.first;
    final points = ProgressMath.exerciseProgress(training, id);
    String name(String x) => catalog[x]?.name ?? x;
    final last = points.last;
    return ProgressSection(
      title: l.exerciseChartTitle,
      children: [
        DropdownButtonFormField<String>(
          key: const Key('exercise-progress-select'),
          initialValue: id,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.exerciseChartHint),
          items: [for (final x in ids) DropdownMenuItem(value: x, child: Text(name(x)))],
          onChanged: (v) => setState(() => _selected = v),
        ),
        const SizedBox(height: 12),
        if (points.length >= 2)
          ExerciseChart(
            points: points,
            semanticLabel:
                '${name(id)}: ${l.exerciseChartLatest(Fmt.one(last.weightKg), last.reps)}',
          ),
        const SizedBox(height: 4),
        Text(l.exerciseChartLatest(Fmt.one(last.weightKg), last.reps)),
      ],
    );
  }
}

class _MilestonesCard extends ConsumerWidget {
  const _MilestonesCard({required this.today});

  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final training = ref.watch(trainingDaysProvider).value ?? const <TrainingDay>[];
    final weights = ref.watch(weightsProvider).value ?? const <WeightEntry>[];
    if (training.isEmpty && weights.isEmpty) return const SizedBox.shrink();
    final weekly = ProgressMath.weeklyWeights(weights);
    final sets = training.fold<int>(0, (s, t) => s + t.sets.length);
    final streak = ProgressMath.trainingStreakWeeks(training, today: today);
    return ProgressSection(
      title: l.milestonesTitle,
      children: [
        if (training.isNotEmpty) ...[
          Text('• ${l.milestoneSessions(training.length)}'),
          Text('• ${l.milestoneSets(sets)}'),
          if (streak > 0) Text('• ${l.milestoneStreak(streak)}'),
        ],
        if (weekly.length >= 2)
          Text('• ${l.milestoneWeight(signedKg(weekly.last.avgKg - weekly.first.avgKg))}'),
      ],
    );
  }
}
