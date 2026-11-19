import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/database/database_providers.dart';
import '../../domain/entities/workout.dart';
import '../../domain/workout_math.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';
import '../widgets/workout_widgets.dart';

/// Sesi latihan: catat set aktual per latihan, timer istirahat, selesaikan.
/// Sesi yang sudah selesai ditampilkan sebagai ringkasan target vs aktual.
class SessionScreen extends ConsumerWidget {
  const SessionScreen({super.key, required this.sessionId});

  final String sessionId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteSessionTitle),
        content: Text(l.deleteSessionMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.delete)),
        ],
      ),
    );
    if (!(ok ?? false) || !context.mounted) return;
    if (await ref.read(workoutActionsProvider.notifier).deleteSession(sessionId) &&
        context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sessionAsync = ref.watch(workoutSessionProvider(sessionId));
    final sets = ref.watch(sessionSetsProvider(sessionId)).value ?? const <SetLog>[];
    final session = sessionAsync.value;
    final inProgress = session?.status == SessionStatus.inProgress;

    return Scaffold(
      appBar: AppBar(
        title: Text(session == null ? l.sessionTitle : l.focus(session.focus)),
        actions: [
          if (session != null)
            PopupMenuButton<String>(
              onSelected: (_) => _delete(context, ref),
              itemBuilder: (_) => [PopupMenuItem(value: 'delete', child: Text(l.deleteSession))],
            ),
        ],
      ),
      body: switch (sessionAsync) {
        AsyncValue(:final value?) => Column(
          children: [
            if (inProgress) _RestTimerBanner(sessionId: sessionId),
            Expanded(
              child: _SessionBody(session: value, sets: sets),
            ),
          ],
        ),
        AsyncData() => EmptyState(icon: Icons.search_off, title: l.errorNotFound),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: failureMessage(l, error),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: inProgress
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  icon: const Icon(Icons.flag),
                  label: Text(l.finishSession),
                  onPressed: () => _FinishSheet.show(context, sessionId),
                ),
              ),
            )
          : null,
    );
  }
}

class _SessionBody extends ConsumerWidget {
  const _SessionBody({required this.session, required this.sets});

  final WorkoutSession session;
  final List<SetLog> sets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final readOnly = session.status != SessionStatus.inProgress;
    final last = ref.watch(lastPerformanceProvider(session.planId, session.dayId)).value;
    // Sesi selesai tidak dibandingkan dengan dirinya sendiri.
    final previous = last?.session.id == session.id ? null : last;
    final done = WorkoutMath.doneSets(sets);
    final planned = WorkoutMath.plannedSets(session.planned);
    final volume = WorkoutMath.volumeKg(sets, session.planned);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${l.weekdayLong(session.weekday)} · ${Fmt.isoDate(session.date)}',
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (readOnly) Chip(label: Text(l.completedBadge), visualDensity: VisualDensity.compact),
          ],
        ),
        Text(l.sessionSummary(done, planned, Fmt.integer(volume))),
        if (readOnly && session.energy != null) Text('${l.energyLabel}: ${session.energy}/5'),
        if (readOnly && session.discomfort != null)
          Text('${l.discomfortLabel}: ${session.discomfort}'),
        if (readOnly && session.notes != null) Text('${l.sessionNotesLabel}: ${session.notes}'),
        if (!readOnly) MutedNote(l.painWarning),
        const SizedBox(height: 8),
        for (final (i, p) in session.planned.indexed)
          _ExerciseLogCard(
            key: ValueKey('ex-$i'),
            sessionId: session.id,
            index: i,
            planned: p,
            sets: WorkoutMath.setsFor(sets, i),
            previous: previous == null ? const [] : WorkoutMath.setsFor(previous.sets, i),
            readOnly: readOnly,
          ),
      ],
    );
  }
}

class _ExerciseLogCard extends ConsumerStatefulWidget {
  const _ExerciseLogCard({
    super.key,
    required this.sessionId,
    required this.index,
    required this.planned,
    required this.sets,
    required this.previous,
    required this.readOnly,
  });

  final String sessionId;
  final int index;
  final PlannedExercise planned;
  final List<SetLog> sets;
  final List<SetLog> previous;
  final bool readOnly;

  @override
  ConsumerState<_ExerciseLogCard> createState() => _ExerciseLogCardState();
}

class _ExerciseLogCardState extends ConsumerState<_ExerciseLogCard> {
  final _weight = TextEditingController();
  final _reps = TextEditingController();
  int? _rir;
  SetInputError? _error;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  @override
  void didUpdateWidget(covariant _ExerciseLogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _prefill();
  }

  /// Isi awal (hanya bila kosong) dari set terakhir sesi ini, atau sesi sebelumnya.
  void _prefill() {
    if (_weight.text.isNotEmpty || _reps.text.isNotEmpty) return;
    final own = widget.sets.where((s) => s.status == SetStatus.done);
    final prev = widget.previous.where((s) => s.status == SetStatus.done);
    final source = own.isNotEmpty ? own.last : (prev.isNotEmpty ? prev.first : null);
    if (source?.weightKg case final w?) _weight.text = Fmt.one(w);
    if (source != null) _reps.text = '${source.reps}';
  }

  @override
  void dispose() {
    _weight.dispose();
    _reps.dispose();
    super.dispose();
  }

  int get _nextSet => WorkoutMath.nextSetNumber(widget.sets, widget.index);

  Future<void> _log() async {
    FocusScope.of(context).unfocus();
    final error = await ref
        .read(sessionLoggerProvider(widget.sessionId).notifier)
        .logSet(
          exerciseIndex: widget.index,
          planned: widget.planned,
          setNumber: _nextSet,
          weightKg: Fmt.parseDecimal(_weight.text),
          reps: Fmt.parseInt(_reps.text),
          rir: _rir,
        );
    setState(() => _error = error);
    if (error == null) unawaited(HapticFeedback.lightImpact());
  }

  Future<void> _skip() => ref
      .read(sessionLoggerProvider(widget.sessionId).notifier)
      .skipSet(exerciseIndex: widget.index, planned: widget.planned, setNumber: _nextSet);

  Future<void> _deleteSet(SetLog s) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteSetTitle),
        content: Text('${l.setLabel(s.setNumber)} · ${l.setSummary(s, widget.planned)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.delete)),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(sessionLoggerProvider(widget.sessionId).notifier).deleteSet(s.id);
    }
  }

  String? _errorText() {
    final l = context.l10n;
    return switch (_error) {
      null => null,
      SetInputError.repsRequired => l.setInputRepsRequired,
      SetInputError.repsOutOfRange => l.setInputRepsRange,
      SetInputError.weightOutOfRange => l.setInputWeightRange,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final p = widget.planned;
    final done = widget.sets.where((s) => s.status == SetStatus.done).length;
    final previousDone = widget.previous.where((s) => s.status == SetStatus.done).toList();
    final canAddSet = _nextSet <= WorkoutMath.maxSetsPerExercise;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context.push(Routes.exercisePath(p.exerciseId)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${widget.index + 1}. ${p.name}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
                Text(l.setsProgress(done, p.sets), style: theme.textTheme.labelLarge),
              ],
            ),
            Text('${l.targetLabel}: ${l.prescriptionOf(p)} · ${l.restRirOf(p)}'),
            if (previousDone.isNotEmpty) ...[
              MutedNote(l.lastTime(previousDone.map((s) => l.setSummary(s, p)).join(', '))),
              if (!widget.readOnly && WorkoutMath.shouldIncreaseLoad(p, previousDone))
                Row(
                  children: [
                    Icon(Icons.trending_up, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l.increaseLoadHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
            for (final s in widget.sets)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  s.status == SetStatus.done ? Icons.check_circle : Icons.remove_circle_outline,
                  color: s.status == SetStatus.done
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                title: Text('${l.setLabel(s.setNumber)} · ${l.setSummary(s, p)}'),
                trailing: widget.readOnly
                    ? null
                    : IconButton(
                        tooltip: l.delete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteSet(s),
                      ),
              ),
            if (!widget.readOnly && canAddSet) ...[
              const SizedBox(height: 8),
              Text(l.setLabel(_nextSet), style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      key: ValueKey('weight-${widget.index}'),
                      controller: _weight,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                      decoration: InputDecoration(labelText: l.weightLabel(p), isDense: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      key: ValueKey('reps-${widget.index}'),
                      controller: _reps,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: p.isTimed ? l.secondsLabel : l.repsLabel,
                        hintText: '${p.repMin}–${p.repMax}',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int?>(
                    value: _rir,
                    hint: Text(l.rirLabel),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l.rirLabel)),
                      for (var r = 0; r <= 5; r++)
                        DropdownMenuItem(value: r, child: Text('${l.rirLabel} $r')),
                    ],
                    onChanged: (v) => setState(() => _rir = v),
                  ),
                ],
              ),
              if (_errorText() case final e?)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(e, style: TextStyle(color: theme.colorScheme.error)),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(onPressed: _skip, child: Text(l.skipSet)),
                  const Spacer(),
                  FilledButton.icon(
                    key: ValueKey('log-${widget.index}'),
                    style: FilledButton.styleFrom(minimumSize: AppTheme.compactButtonSize),
                    onPressed: _log,
                    icon: const Icon(Icons.check),
                    label: Text(l.logSet),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Timer istirahat setelah mencatat set. Berbasis waktu akhir sehingga
/// tetap benar walau aplikasi sempat di background.
class _RestTimerBanner extends ConsumerStatefulWidget {
  const _RestTimerBanner({required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<_RestTimerBanner> createState() => _RestTimerBannerState();
}

class _RestTimerBannerState extends ConsumerState<_RestTimerBanner> {
  Timer? _ticker;
  bool _alerted = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(sessionLoggerProvider(widget.sessionId));
    if (timer == null) {
      _alerted = false;
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    final theme = Theme.of(context);
    final now = ref.read(clockProvider)();
    final remaining = timer.remainingSeconds(now);
    if (remaining == 0 && !_alerted) {
      _alerted = true;
      unawaited(HapticFeedback.heavyImpact());
    } else if (remaining > 0) {
      _alerted = false;
    }
    final notifier = ref.read(sessionLoggerProvider(widget.sessionId).notifier);
    final mm = (remaining ~/ 60).toString();
    final ss = (remaining % 60).toString().padLeft(2, '0');
    return Material(
      color: theme.colorScheme.primaryContainer,
      child: Column(
        children: [
          LinearProgressIndicator(value: timer.progress(now)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: theme.colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  '${l.restTimerLabel} $mm:$ss',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: () => notifier.adjustRest(15), child: Text(l.restAdd)),
                TextButton(onPressed: notifier.stopRest, child: Text(l.restSkip)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinishSheet extends ConsumerStatefulWidget {
  const _FinishSheet({required this.sessionId});

  final String sessionId;

  static Future<void> show(BuildContext context, String sessionId) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FinishSheet(sessionId: sessionId),
  );

  @override
  ConsumerState<_FinishSheet> createState() => _FinishSheetState();
}

class _FinishSheetState extends ConsumerState<_FinishSheet> {
  int? _energy;
  final _discomfort = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _discomfort.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final l = context.l10n;
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref
        .read(workoutActionsProvider.notifier)
        .completeSession(
          widget.sessionId,
          energy: _energy,
          discomfort: _discomfort.text,
          notes: _notes.text,
        );
    ref.read(sessionLoggerProvider(widget.sessionId).notifier).stopRest();
    if (!mounted) return;
    Navigator.pop(context);
    if (ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.sessionCompleted)));
      router.go(Routes.workout);
    } else if (ref.read(workoutActionsProvider).error case final e?) {
      messenger.showSnackBar(SnackBar(content: Text(failureMessage(l, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final busy = ref.watch(workoutActionsProvider).isLoading;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.finishSessionTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(l.energyLabel),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (var e = 1; e <= 5; e++)
                  ChoiceChip(
                    label: Text('$e'),
                    selected: _energy == e,
                    onSelected: (_) => setState(() => _energy = _energy == e ? null : e),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _discomfort,
              maxLength: 300,
              decoration: InputDecoration(labelText: l.discomfortLabel),
            ),
            TextField(
              controller: _notes,
              maxLength: 500,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(labelText: l.sessionNotesLabel),
            ),
            MutedNote(l.painWarning),
            const SizedBox(height: 8),
            FilledButton(onPressed: busy ? null : _finish, child: Text(l.finishConfirm)),
          ],
        ),
      ),
    );
  }
}
