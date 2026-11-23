import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/tab_app_bar.dart';
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
      appBar: TabAppBar(title: l.tabProgress),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          CheckInCard(date: today),
          const SizedBox(height: 12),
          const _WeightCard(),
          const SizedBox(height: 12),
          const MeasurementsCard(),
          const SizedBox(height: 12),
          const PhotosCard(),
          const SizedBox(height: 12),
          _WeeklyCard(today: today),
          const SizedBox(height: 12),
          _IntakeCard(today: today),
          const SizedBox(height: 12),
          _VolumeCard(today: today),
          const SizedBox(height: 12),
          const _ExerciseCard(),
          const SizedBox(height: 12),
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
    final palette = context.palette;
    void open() => context.push(Routes.checkInPath(date));
    final subtitle = !done ? l.checkInPrompt : (checkIn.isEmpty ? l.checkInMarkedDone : null);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const Key('checkin-card'),
        onTap: open,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(done ? l.checkInDone : l.checkInToday, style: theme.textTheme.titleMedium),
                    if (subtitle != null)
                      Text(subtitle, style: TextStyle(fontSize: 12, color: palette.muted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: done ? null : palette.accentSoft,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: open,
                child: Text(done ? l.checkInEdit : l.checkInOpen),
              ),
            ],
          ),
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
        style: sectionActionStyle(),
        onPressed: log,
        icon: const Icon(Icons.add),
        label: Text(l.weightLog),
      ),
      children: [
        if (latest == null)
          Text(l.weightEmpty)
        else ...[
          Semantics(
            label: l.weightLatest(Fmt.one(latest.kg), Fmt.isoDate(latest.date)),
            child: ExcludeSemantics(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    Fmt.one(latest.kg),
                    key: const Key('weight-latest'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 40,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      fontFeatures: tabular,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l.weightLatestDate(Fmt.isoDate(latest.date)),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: context.palette.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            l.weightAvg7(Fmt.one(avg.last.kg)),
            style: TextStyle(fontSize: 13, fontFeatures: tabular, color: context.palette.muted),
          ),
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
    final w = ref.watch(weekSummaryProvider(last));
    final palette = context.palette;
    final theme = Theme.of(context);
    Widget tile(String label, String value) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.surface2,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: palette.muted),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                fontFeatures: tabular,
              ),
            ),
          ],
        ),
      ),
    );
    final training = w == null
        ? '–'
        : (w.sessionsPlanned == null
              ? '${w.sessionsCompleted}'
              : '${w.sessionsCompleted}/${w.sessionsPlanned}');
    final intake = w?.intakeRatio == null ? '–' : '${(w!.intakeRatio! * 100).round()}%';
    final weight = w?.weightChangeKg == null ? '–' : signedKg(w!.weightChangeKg!);
    return ProgressSection(
      title: l.weeklyTitle,
      trailing: Text(
        l.weeklyRange(_short(last), _short(ProgressMath.addDays(last, 6))),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: palette.muted),
      ),
      children: [
        Row(
          children: [
            tile(l.weeklyStatTraining, training),
            const SizedBox(width: 8),
            tile(l.weeklyStatIntake, intake),
            const SizedBox(width: 8),
            tile(l.weeklyStatWeight, weight),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(
          key: const Key('weekly-open'),
          style: FilledButton.styleFrom(
            backgroundColor: palette.surface2,
            foregroundColor: theme.colorScheme.onSurface,
          ),
          onPressed: () => context.push(Routes.weeklyReviewPath(last)),
          child: Text(l.weeklyOpenShort),
        ),
        TextButton.icon(
          onPressed: () => context.push(Routes.weeklyReviewPath(current)),
          icon: const Icon(Icons.today_rounded, size: 18),
          label: Text(l.weeklyThisWeek),
        ),
        if (reviews.isNotEmpty) ...[
          const Divider(),
          const SizedBox(height: 4),
          Text(l.weeklyHistory, style: theme.textTheme.titleSmall),
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
              trailing: r.aiSummary == null
                  ? const Icon(Icons.chevron_right_rounded)
                  : Icon(Icons.auto_awesome_rounded, size: 18, color: theme.colorScheme.primary),
              onTap: () => context.push(Routes.weeklyReviewPath(r.weekStart)),
            ),
        ],
      ],
    );
  }
}

/// "9 Nov" dari `YYYY-MM-DD`.
String _short(String iso) => DateFormat('d MMM', 'id').format(DateTime.parse(iso));

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (training.isNotEmpty) ...[
              if (streak > 0)
                _MilestoneChip(
                  icon: Icons.local_fire_department_rounded,
                  text: l.milestoneStreak(streak),
                  highlight: true,
                ),
              _MilestoneChip(
                icon: Icons.event_available_rounded,
                text: l.milestoneSessions(training.length),
              ),
              _MilestoneChip(icon: Icons.fitness_center_rounded, text: l.milestoneSets(sets)),
            ],
            if (weekly.length >= 2)
              _MilestoneChip(
                icon: Icons.monitor_weight_outlined,
                text: l.milestoneWeight(signedKg(weekly.last.avgKg - weekly.first.avgKg)),
              ),
          ],
        ),
      ],
    );
  }
}

class _MilestoneChip extends StatelessWidget {
  const _MilestoneChip({required this.icon, required this.text, this.highlight = false});

  final IconData icon;
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: highlight ? palette.accentSoft : palette.surface2,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: highlight ? accent : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
