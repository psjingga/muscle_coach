import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/progress_ring.dart';
import '../../../../core/database/database_providers.dart';
import '../../../exercise_library/presentation/providers/exercise_providers.dart';
import '../../../exercise_library/presentation/widgets/exercise_media.dart';
import '../../domain/entities/workout.dart';
import '../../domain/workout_math.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_labels.dart';
import '../widgets/workout_widgets.dart';

/// Sesi latihan (desain Superdesign): tabel set per gerakan dengan tombol ✓
/// besar, gerakan aktif terbuka & lainnya ringkas, timer istirahat melayang.
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
    final theme = Theme.of(context);
    final sessionAsync = ref.watch(workoutSessionProvider(sessionId));
    final sets = ref.watch(sessionSetsProvider(sessionId)).value ?? const <SetLog>[];
    final session = sessionAsync.value;
    final inProgress = session?.status == SessionStatus.inProgress;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session == null ? l.sessionTitle : l.focus(session.focus)),
            if (session != null && inProgress && session.startedAt != null)
              _ElapsedText(startedAt: session.startedAt!),
          ],
        ),
        actions: [
          if (session != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (_) => _delete(context, ref),
              itemBuilder: (_) => [PopupMenuItem(value: 'delete', child: Text(l.deleteSession))],
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
        ),
      ),
      body: switch (sessionAsync) {
        AsyncValue(:final value?) => Stack(
          children: [
            Positioned.fill(
              child: _SessionBody(session: value, sets: sets),
            ),
            if (inProgress)
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: Center(child: _RestTimerPill(sessionId: sessionId)),
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
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: FilledButton.icon(
                    icon: const Icon(Icons.flag_rounded),
                    label: Text(l.finishSession),
                    onPressed: () => _FinishSheet.show(context, sessionId),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

/// "Sesi latihan · 18:42" — durasi sejak sesi dimulai.
class _ElapsedText extends StatefulWidget {
  const _ElapsedText({required this.startedAt});

  final DateTime startedAt;

  @override
  State<_ElapsedText> createState() => _ElapsedTextState();
}

class _ElapsedTextState extends State<_ElapsedText> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
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
    final d = DateTime.now().difference(widget.startedAt);
    final secs = d.isNegative ? 0 : d.inSeconds;
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    final s = (secs % 60).toString().padLeft(2, '0');
    final time = h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
    return Text(
      context.l10n.sessionElapsed(time),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontFeatures: tabular,
        color: context.palette.muted,
      ),
    );
  }
}

class _SessionBody extends ConsumerStatefulWidget {
  const _SessionBody({required this.session, required this.sets});

  final WorkoutSession session;
  final List<SetLog> sets;

  @override
  ConsumerState<_SessionBody> createState() => _SessionBodyState();
}

class _SessionBodyState extends ConsumerState<_SessionBody> {
  /// Kartu yang dibuka pengguna; `null` = gerakan aktif.
  int? _expanded;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final session = widget.session;
    final sets = widget.sets;
    final readOnly = session.status != SessionStatus.inProgress;
    final last = ref.watch(lastPerformanceProvider(session.planId, session.dayId)).value;
    // Sesi selesai tidak dibandingkan dengan dirinya sendiri.
    final previous = last?.session.id == session.id ? null : last;
    final done = WorkoutMath.doneSets(sets);
    final planned = WorkoutMath.plannedSets(session.planned);
    final volume = WorkoutMath.volumeKg(sets, session.planned);

    bool finished(int i) => WorkoutMath.setsFor(sets, i).length >= session.planned[i].sets;
    final active = [
      for (var i = 0; i < session.planned.length; i++)
        if (!finished(i)) i,
    ].firstOrNull;
    final expanded = _expanded ?? active;
    final total = session.planned.length;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, readOnly ? 24 : 120),
      children: [
        if (readOnly) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l.weekdayLong(session.weekday)} · ${Fmt.isoDate(session.date)}',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Chip(label: Text(l.completedBadge), visualDensity: VisualDensity.compact),
            ],
          ),
          Text(l.sessionSummary(done, planned, Fmt.integer(volume))),
          if (session.energy != null) Text('${l.energyLabel}: ${session.energy}/5'),
          if (session.discomfort != null) Text('${l.discomfortLabel}: ${session.discomfort}'),
          if (session.notes != null) Text('${l.sessionNotesLabel}: ${session.notes}'),
          const SizedBox(height: 12),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.exerciseOfTotal((active ?? total - 1) + 1, total),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : ((active ?? total - 1) + 1) / total,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.surface2,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Text(
                  l.setsProgress(done, planned),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        for (final (i, p) in session.planned.indexed) ...[
          if (readOnly || i == expanded)
            _ExerciseLogCard(
              key: ValueKey('ex-$i'),
              sessionId: session.id,
              index: i,
              planned: p,
              sets: WorkoutMath.setsFor(sets, i),
              previous: previous == null ? const [] : WorkoutMath.setsFor(previous.sets, i),
              readOnly: readOnly,
            )
          else
            _CollapsedExercise(
              key: ValueKey('ex-collapsed-$i'),
              planned: p,
              logged: WorkoutMath.setsFor(sets, i),
              finished: finished(i),
              onTap: () => setState(() => _expanded = i),
            ),
          const SizedBox(height: 12),
        ],
        if (!readOnly) MutedNote(l.painWarning),
      ],
    );
  }
}

/// Gerakan yang tidak sedang dikerjakan: nama + "2/3 set".
class _CollapsedExercise extends StatelessWidget {
  const _CollapsedExercise({
    super.key,
    required this.planned,
    required this.logged,
    required this.finished,
    required this.onTap,
  });

  final PlannedExercise planned;
  final List<SetLog> logged;
  final bool finished;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final done = logged.where((s) => s.status == SetStatus.done).length;
    return Opacity(
      opacity: finished ? 0.6 : 0.85,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planned.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: finished ? TextDecoration.lineThrough : null,
                          decorationColor: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.setsProgress(done, planned.sets),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFeatures: tabular,
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  finished ? Icons.check_circle_rounded : Icons.expand_more_rounded,
                  color: finished ? theme.colorScheme.primary : palette.muted,
                ),
              ],
            ),
          ),
        ),
      ),
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

  /// Pengguna menekan "Tambah set" setelah semua set rencana tercatat.
  bool _extra = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  @override
  void didUpdateWidget(covariant _ExerciseLogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sets.length != oldWidget.sets.length) _extra = false;
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

  /// Lewati semua set rencana yang tersisa untuk gerakan ini.
  Future<void> _skipExercise() async {
    final logger = ref.read(sessionLoggerProvider(widget.sessionId).notifier);
    final from = _nextSet;
    for (var n = from; n <= widget.planned.sets; n++) {
      await logger.skipSet(exerciseIndex: widget.index, planned: widget.planned, setNumber: n);
    }
  }

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

  /// "40 × 10" (atau "45 dtk") dari set sesi sebelumnya dengan nomor sama.
  String _prevText(int setNumber) {
    final s = widget.previous
        .where((x) => x.setNumber == setNumber && x.status == SetStatus.done)
        .firstOrNull;
    if (s == null) return '–';
    final reps = widget.planned.isTimed ? '${s.reps} dtk' : '${s.reps}';
    return s.weightKg == null ? reps : '${Fmt.one(s.weightKg!)} × $reps';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final p = widget.planned;
    final previousDone = widget.previous.where((s) => s.status == SetStatus.done).toList();
    final canAddSet = _nextSet <= WorkoutMath.maxSetsPerExercise;
    final plannedLeft = _nextSet <= p.sets;
    final showInput = !widget.readOnly && canAddSet && (plannedLeft || _extra);
    final exercise = ref.watch(exerciseCatalogProvider).value?[p.exerciseId];
    final muscles = exercise?.primaryMuscles ?? const <String>[];

    final head = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
      color: palette.muted,
    );
    const numStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFeatures: tabular);

    Widget row({
      required int number,
      required String prev,
      required Widget kg,
      required Widget reps,
      required Widget rir,
      required Widget check,
      Color? color,
      VoidCallback? onLongPress,
      Key? key,
    }) => GestureDetector(
      key: key,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Center(
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: palette.surface2, shape: BoxShape.circle),
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFeatures: tabular,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                prev,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFeatures: tabular,
                  color: palette.muted,
                ),
              ),
            ),
            SizedBox(width: 64, child: Center(child: kg)),
            SizedBox(width: 54, child: Center(child: reps)),
            SizedBox(width: 40, child: Center(child: rir)),
            SizedBox(width: 48, child: Center(child: check)),
          ],
        ),
      ),
    );

    InputDecoration cell(String hint) => InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      hintStyle: TextStyle(color: palette.muted, fontWeight: FontWeight.w500),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (exercise != null) ...[
                      ExerciseThumbnail(exercise: exercise),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        '${widget.index + 1}. ${p.name}',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        textStyle: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => context.push(Routes.exercisePath(p.exerciseId)),
                      icon: const Icon(Icons.smart_display_rounded, size: 16),
                      label: Text(l.seeTechnique),
                    ),
                  ],
                ),
                if (muscles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      for (final m in muscles)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: palette.surface2,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            l.muscleCode(m).toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: palette.muted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.track_changes_rounded, size: 18, color: palette.muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l.targetLabel}: ${l.prescriptionOf(p)} · ${l.restRirOf(p)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                if (!widget.readOnly && WorkoutMath.shouldIncreaseLoad(p, previousDone)) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.trending_up_rounded, size: 18, color: theme.colorScheme.primary),
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
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(width: 32, child: Text(l.colSet.toUpperCase(), style: head)),
                      Expanded(
                        child: Text(
                          l.colPrevious.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: head,
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        child: Text(
                          l.colKg.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: head,
                        ),
                      ),
                      SizedBox(
                        width: 54,
                        child: Text(
                          (p.isTimed ? l.colSeconds : l.colReps).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: head,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(l.colRir, textAlign: TextAlign.center, style: head),
                      ),
                      SizedBox(
                        width: 48,
                        child: Text('✓', textAlign: TextAlign.center, style: head),
                      ),
                    ],
                  ),
                ),
                for (final s in widget.sets)
                  row(
                    key: ValueKey('set-${widget.index}-${s.setNumber}'),
                    number: s.setNumber,
                    prev: _prevText(s.setNumber),
                    color: s.status == SetStatus.done ? palette.accentSoft : null,
                    onLongPress: widget.readOnly ? null : () => _deleteSet(s),
                    kg: Text(
                      s.status == SetStatus.done && s.weightKg != null ? Fmt.one(s.weightKg!) : '–',
                      style: numStyle,
                    ),
                    reps: Text(s.status == SetStatus.done ? '${s.reps}' : '–', style: numStyle),
                    rir: Text(
                      s.rir == null ? l.rirNone : '${s.rir}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFeatures: tabular,
                        color: palette.muted,
                      ),
                    ),
                    check: s.status == SetStatus.done
                        ? Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: theme.colorScheme.onPrimary,
                              semanticLabel: l.setLabel(s.setNumber),
                            ),
                          )
                        : Tooltip(
                            message: l.setSkippedShort,
                            child: Icon(Icons.remove_circle_outline_rounded, color: palette.muted),
                          ),
                  ),
                if (showInput)
                  row(
                    number: _nextSet,
                    prev: _prevText(_nextSet),
                    kg: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        key: ValueKey('weight-${widget.index}'),
                        controller: _weight,
                        textAlign: TextAlign.center,
                        style: numStyle.copyWith(fontWeight: FontWeight.w800),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                        decoration: cell('–'),
                      ),
                    ),
                    reps: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        key: ValueKey('reps-${widget.index}'),
                        controller: _reps,
                        textAlign: TextAlign.center,
                        style: numStyle.copyWith(fontWeight: FontWeight.w800),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: cell('${p.repMin}–${p.repMax}'),
                      ),
                    ),
                    rir: PopupMenuButton<int?>(
                      key: ValueKey('rir-${widget.index}'),
                      tooltip: l.rirLabel,
                      initialValue: _rir,
                      onSelected: (v) => setState(() => _rir = v),
                      itemBuilder: (_) => [
                        PopupMenuItem(value: null, child: Text('${l.rirLabel} ${l.rirNone}')),
                        for (var r = 0; r <= 5; r++)
                          PopupMenuItem(value: r, child: Text('${l.rirLabel} $r')),
                      ],
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: palette.surface2, shape: BoxShape.circle),
                        child: Text(
                          _rir == null ? l.rirNone : '$_rir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFeatures: tabular,
                            color: _rir == null ? palette.muted : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    check: SizedBox.square(
                      dimension: 44,
                      child: OutlinedButton(
                        key: ValueKey('log-${widget.index}'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.square(44),
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                          side: BorderSide(color: theme.colorScheme.outline, width: 2),
                        ),
                        onPressed: _log,
                        child: Icon(Icons.check_rounded, semanticLabel: l.logSet),
                      ),
                    ),
                  ),
                if (!widget.readOnly)
                  for (var n = _nextSet + (showInput ? 1 : 0); n <= p.sets; n++)
                    Opacity(
                      opacity: 0.5,
                      child: row(
                        number: n,
                        prev: _prevText(n),
                        kg: Text('–', style: numStyle),
                        reps: Text('–', style: numStyle),
                        rir: Text(l.rirNone, style: TextStyle(color: palette.muted)),
                        check: const SizedBox(),
                      ),
                    ),
                if (_errorText() case final e?)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                    child: Text(e, style: TextStyle(color: theme.colorScheme.error)),
                  ),
                if (!widget.readOnly)
                  Row(
                    children: [
                      if (canAddSet && !showInput)
                        TextButton.icon(
                          key: ValueKey('add-set-${widget.index}'),
                          onPressed: () => setState(() => _extra = true),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(l.addSet),
                        ),
                      const Spacer(),
                      if (plannedLeft)
                        TextButton.icon(
                          key: ValueKey('skip-${widget.index}'),
                          style: TextButton.styleFrom(foregroundColor: palette.muted),
                          onPressed: _skipExercise,
                          iconAlignment: IconAlignment.end,
                          icon: const Icon(Icons.skip_next_rounded, size: 18),
                          label: Text(l.skipExercise),
                        ),
                    ],
                  ),
                if (!widget.readOnly && widget.sets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      l.deleteSetHint,
                      style: TextStyle(fontSize: 12, color: palette.muted),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Timer istirahat melayang setelah mencatat set. Berbasis waktu akhir
/// sehingga tetap benar walau aplikasi sempat di background.
class _RestTimerPill extends ConsumerStatefulWidget {
  const _RestTimerPill({required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<_RestTimerPill> createState() => _RestTimerPillState();
}

class _RestTimerPillState extends ConsumerState<_RestTimerPill> {
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
    final palette = context.palette;
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
    final pill = TextButton.styleFrom(
      minimumSize: const Size(48, 40),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontWeight: FontWeight.w700,
        fontFeatures: tabular,
      ),
    );
    return Semantics(
      liveRegion: true,
      label: '${l.restTimerLabel} $mm:$ss',
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 8, 6),
        decoration: BoxDecoration(
          color: palette.surface2,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: const [
            BoxShadow(color: Color(0x80000000), blurRadius: 32, offset: Offset(0, 8)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProgressRing(
              value: 1 - timer.progress(now),
              size: 52,
              stroke: 4,
              color: theme.colorScheme.primary,
              track: theme.colorScheme.outlineVariant,
              child: Text(
                '$mm:$ss',
                key: const Key('rest-remaining'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFeatures: tabular,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l.restTimerLabel.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: palette.muted,
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              style: pill.copyWith(
                backgroundColor: WidgetStatePropertyAll(theme.colorScheme.surfaceContainerLow),
                foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onSurface),
              ),
              onPressed: () => notifier.adjustRest(15),
              child: Text(l.restAdd),
            ),
            const SizedBox(width: 4),
            TextButton(
              style: pill.copyWith(backgroundColor: WidgetStatePropertyAll(palette.accentSoft)),
              onPressed: notifier.stopRest,
              child: Text(l.restSkip),
            ),
          ],
        ),
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
