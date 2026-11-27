import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/progress_ring.dart';
import '../../../exercise_library/domain/exercise.dart';
import '../../domain/entities/workout.dart';
import '../../domain/guided_set.dart';
import '../../domain/workout_math.dart';
import '../providers/workout_providers.dart';
import '../../domain/guided_settings.dart';
import 'guided_cues.dart';
import 'guided_settings_sheet.dart';

/// Buka Mode Panduan untuk satu set. Set dicatat dari layar ini (lalu timer
/// istirahat sesi berjalan seperti biasa).
Future<void> openGuidedSet(
  BuildContext context, {
  required String sessionId,
  required int exerciseIndex,
  required PlannedExercise planned,
  required int setNumber,
  required Exercise? exercise,
  double? initialWeight,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => GuidedSetScreen(
      sessionId: sessionId,
      exerciseIndex: exerciseIndex,
      planned: planned,
      setNumber: setNumber,
      exercise: exercise,
      initialWeight: initialWeight,
    ),
  ),
);

/// Layar set terpandu: siap → aba-aba 3-2-1 → timer per fase tiap repetisi
/// → tunggu "Lanjut" → … → ringkasan & simpan.
class GuidedSetScreen extends ConsumerStatefulWidget {
  const GuidedSetScreen({
    super.key,
    required this.sessionId,
    required this.exerciseIndex,
    required this.planned,
    required this.setNumber,
    required this.exercise,
    this.initialWeight,
  });

  final String sessionId;
  final int exerciseIndex;
  final PlannedExercise planned;
  final int setNumber;
  final Exercise? exercise;
  final double? initialWeight;

  @override
  ConsumerState<GuidedSetScreen> createState() => _GuidedSetScreenState();
}

class _GuidedSetScreenState extends ConsumerState<GuidedSetScreen>
    with SingleTickerProviderStateMixin {
  late GuidedSettings _settings = ref.read(guidedSettingsProvider).value ?? const GuidedSettings();
  late GuidedSet _set = _fresh();
  late DateTime _seenAt = _now;
  late final Ticker _ticker = createTicker((_) => _onFrame());

  /// Dibuat saat Mulai (sesuai pengaturan bunyi), dilepas saat layar ditutup.
  GuidedCuePlayer? _cues;

  GuidedSet _fresh() => GuidedSet.forPlanned(
    widget.planned,
    pattern: widget.exercise?.pattern,
    tempo: _settings.tempo,
    countdownSeconds: _settings.countdownSeconds,
  );

  final _weight = TextEditingController();
  final _reps = TextEditingController();
  int? _rir;
  SetInputError? _error;
  bool _saving = false;

  DateTime get _now => ref.read(clockProvider)();

  @override
  void initState() {
    super.initState();
    if (widget.initialWeight case final w?) _weight.text = Fmt.one(w);
  }

  @override
  void dispose() {
    if (_cues case final c?) unawaited(c.dispose());
    _ticker.dispose();
    _weight.dispose();
    _reps.dispose();
    super.dispose();
  }

  /// Terapkan perubahan keadaan + isyaratnya; jalankan/hentikan ticker.
  void _apply(GuidedSet next) {
    final now = _now;
    if (next.stage != GuidedStage.ready) {
      _cues ??= ref.read(guidedCuePlayerFactoryProvider)(sound: _settings.sound);
    }
    final cues = _cues;
    final cue = GuidedSet.cueBetween(_set, _seenAt, next, now);
    if (cue != null && cues != null) unawaited(cues.play(cue));
    if (next.stage == GuidedStage.finished && _set.stage != GuidedStage.finished) {
      _reps.text = '${next.result}';
    }
    // Layar tetap menyala dari aba-aba sampai set selesai.
    if (cues != null) {
      unawaited(
        cues.keepAwake(switch (next.stage) {
          GuidedStage.countdown || GuidedStage.rep || GuidedStage.repDone => true,
          GuidedStage.ready || GuidedStage.finished => false,
        }),
      );
    }
    final running = next.segmentEndsAt != null && !next.isPaused;
    if (running && !_ticker.isActive) unawaited(_ticker.start());
    if (!running && _ticker.isActive) _ticker.stop();
    setState(() {
      _set = next;
      _seenAt = now;
    });
  }

  void _onFrame() => _apply(_set.tick(_now));

  Future<bool> _confirmExit() async {
    if (_set.stage == GuidedStage.ready) return true;
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.guidedExitTitle),
        content: Text(l.guidedExitBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.guidedExit)),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _exit() async {
    final wasRunning = _set.segmentEndsAt != null && !_set.isPaused;
    if (wasRunning) _apply(_set.pause(_now));
    if (await _confirmExit()) {
      if (mounted) Navigator.of(context).pop();
    } else if (wasRunning) {
      _apply(_set.resume(_now));
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    final error = await ref
        .read(sessionLoggerProvider(widget.sessionId).notifier)
        .logSet(
          exerciseIndex: widget.exerciseIndex,
          planned: widget.planned,
          setNumber: widget.setNumber,
          weightKg: Fmt.parseDecimal(_weight.text),
          reps: Fmt.parseInt(_reps.text),
          rir: _rir,
        );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _error = error;
        _saving = false;
      });
      return;
    }
    unawaited(HapticFeedback.lightImpact());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Pengaturan berubah sebelum Mulai (mis. dari tombol "Atur tempo").
    ref.listen(guidedSettingsProvider, (_, next) {
      final v = next.value;
      if (v == null || v == _settings) return;
      setState(() {
        _settings = v;
        if (_set.stage == GuidedStage.ready) _set = _fresh();
      });
    });
    final l = context.l10n;
    final palette = context.palette;
    final theme = Theme.of(context);
    final now = _now;
    final s = _set;
    final p = widget.planned;

    final subtitle = switch (s.stage) {
      GuidedStage.ready => '${l.guidedSetOf(widget.setNumber, p.sets)} · ${l.guidedOpen}',
      _ when _weight.text.isNotEmpty =>
        '${l.guidedSetOf(widget.setNumber, p.sets)} · ${_weight.text} kg',
      _ => l.guidedSetOf(widget.setNumber, p.sets),
    };

    final body = switch (s.stage) {
      GuidedStage.ready => _ready(context),
      GuidedStage.countdown => _countdown(context, now),
      GuidedStage.rep => _running(context, now),
      GuidedStage.repDone => _repDone(context),
      GuidedStage.finished => _finished(context),
    };

    return PopScope(
      canPop: s.stage == GuidedStage.ready,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_exit());
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      key: const Key('guided-close'),
                      tooltip: l.guidedExit,
                      style: IconButton.styleFrom(backgroundColor: palette.surface2),
                      onPressed: _exit,
                      icon: const Icon(Icons.close_rounded),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(subtitle, style: TextStyle(fontSize: 13, color: palette.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }

  // --- Bagian-bagian layar -------------------------------------------------

  Widget _photo(BuildContext context, {double pose = 0, bool dim = false, String? badge}) {
    final palette = context.palette;
    final images = widget.exercise?.images ?? const <String>[];
    Widget image(String path) => Image.asset(
      path,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => const SizedBox(),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 220,
          color: images.isEmpty ? palette.surface2 : Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (images.isEmpty)
                Icon(Icons.fitness_center_rounded, size: 72, color: palette.muted)
              else ...[
                image(images.first),
                // Foto posisi akhir memudar masuk/keluar mengikuti fase.
                if (images.length > 1) Opacity(opacity: pose.clamp(0, 1), child: image(images[1])),
              ],
              if (dim)
                ColoredBox(color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: .6)),
              if (badge != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String text, {bool accent = false}) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: accent ? palette.accentSoft : palette.surface2,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: accent ? scheme.primary : null,
        ),
      ),
    );
  }

  Widget _bigButton(
    BuildContext context, {
    required Key key,
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool trailingIcon = false,
  }) => SizedBox(
    width: double.infinity,
    height: 60,
    child: FilledButton(
      key: key,
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        textStyle: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null && !trailingIcon) ...[Icon(icon, size: 28), const SizedBox(width: 6)],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          if (icon != null && trailingIcon) ...[const SizedBox(width: 6), Icon(icon)],
        ],
      ),
    ),
  );

  Widget _ring(
    BuildContext context, {
    required double progress,
    required String label,
    required String value,
    required String caption,
    double fontSize = 104,
  }) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    return ProgressRing(
      value: progress,
      size: 260,
      stroke: 14,
      color: scheme.primary,
      track: palette.surface2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 2.4,
              fontWeight: FontWeight.w700,
              color: palette.muted,
            ),
          ),
          Text(
            value,
            key: const Key('guided-seconds'),
            style: TextStyle(
              fontSize: fontSize,
              height: 1.05,
              fontWeight: FontWeight.w800,
              fontFeatures: tabular,
            ),
          ),
          Text(caption, style: TextStyle(fontSize: 14, color: palette.muted)),
        ],
      ),
    );
  }

  Widget _repCounter(BuildContext context, {required int current, required int done}) {
    final l = context.l10n;
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    final total = _set.targetReps;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                l.guidedRepLabel,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.muted),
              ),
              const Spacer(),
              Text.rich(
                key: const Key('guided-rep-count'),
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$current',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: ' / $total',
                      style: TextStyle(fontSize: 16, color: palette.muted),
                    ),
                  ],
                ),
                style: const TextStyle(fontFeatures: tabular),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < total; i++)
                Expanded(
                  child: Container(
                    height: 6,
                    margin: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
                    decoration: BoxDecoration(
                      color: i < done
                          ? scheme.primary
                          : i == done
                          ? scheme.onSurface
                          : palette.surface2,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ready(BuildContext context) {
    final l = context.l10n;
    final palette = context.palette;
    final p = widget.planned;
    final phases = _set.phases.map((x) => '${x.label.toLowerCase()} ${x.seconds} dtk').join(' · ');
    return Column(
      children: [
        _photo(context, badge: l.guidedStartPosition),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(
                    context,
                    p.isTimed
                        ? l.guidedTargetSeconds(p.repMax)
                        : l.guidedTargetReps(p.repMin, p.repMax),
                  ),
                  if (_weight.text.isNotEmpty) _chip(context, '${_weight.text} kg'),
                  _chip(context, 'RIR ${p.rirMin}–${p.rirMax}'),
                  if (!p.isTimed)
                    _chip(context, l.guidedTempo(_settings.tempo.label), accent: true),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: const Key('guided-settings'),
                  onPressed: () => showGuidedSettingsSheet(context),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(l.guidedSettingsOpen),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.guidedHowTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: palette.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.isTimed ? l.guidedHowTimed : l.guidedHowReps(phases),
                      style: const TextStyle(fontSize: 14, height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: _bigButton(
            context,
            key: const Key('guided-start'),
            label: l.guidedStart,
            icon: Icons.play_arrow_rounded,
            onPressed: () => _apply(_set.start(_now)),
          ),
        ),
      ],
    );
  }

  Widget _countdown(BuildContext context, DateTime now) {
    final l = context.l10n;
    return Column(
      children: [
        _photo(context, dim: true),
        Expanded(
          child: Center(
            child: _ring(
              context,
              progress: _set.segmentProgress(now),
              label: l.guidedGetReady,
              value: '${_set.remainingSeconds(now)}',
              caption: l.guidedGetReadyHint,
              fontSize: 128,
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), child: _pauseRow(context)),
      ],
    );
  }

  Widget _running(BuildContext context, DateTime now) {
    final l = context.l10n;
    final phase = _set.phase!;
    return Column(
      children: [
        _photo(context, pose: _set.pose(now), badge: phase.label),
        if (!_set.timed) _repCounter(context, current: _set.currentRep, done: _set.completedReps),
        Expanded(
          child: Center(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _ring(
                  context,
                  progress: _set.segmentProgress(now),
                  label: _set.isPaused ? l.guidedPaused : phase.label,
                  value: '${_set.remainingSeconds(now)}',
                  caption: l.guidedSecondsLeft,
                ),
              ),
            ),
          ),
        ),
        if (!_set.timed) _phaseBar(context),
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), child: _pauseRow(context)),
      ],
    );
  }

  Widget _phaseBar(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          for (final (i, ph) in _set.phases.indexed)
            Expanded(
              flex: ph.seconds,
              child: Padding(
                padding: EdgeInsets.only(right: i == _set.phases.length - 1 ? 0 : 6),
                child: Column(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: i <= _set.phaseIndex ? scheme.primary : palette.surface2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${ph.label} ${ph.seconds}',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: i == _set.phaseIndex ? FontWeight.w800 : FontWeight.w600,
                        color: i == _set.phaseIndex ? scheme.primary : palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _pauseRow(BuildContext context) {
    final l = context.l10n;
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    final paused = _set.isPaused;
    final style = FilledButton.styleFrom(
      backgroundColor: palette.surface2,
      foregroundColor: scheme.onSurface,
      minimumSize: const Size.fromHeight(52),
    );
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            key: const Key('guided-pause'),
            style: style,
            onPressed: () => _apply(paused ? _set.resume(_now) : _set.pause(_now)),
            icon: Icon(paused ? Icons.play_arrow_rounded : Icons.pause_rounded),
            label: Text(paused ? l.guidedResume : l.guidedPause),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            key: const Key('guided-end'),
            style: style.copyWith(foregroundColor: WidgetStatePropertyAll(scheme.error)),
            onPressed: () => _apply(_set.finishEarly(_now)),
            child: Text(l.guidedEnd),
          ),
        ),
      ],
    );
  }

  Widget _repDone(BuildContext context) {
    final l = context.l10n;
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    final done = _set.completedReps;
    return Column(
      children: [
        _photo(context),
        _repCounter(context, current: done, done: done),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(color: palette.accentSoft, shape: BoxShape.circle),
                  child: Icon(Icons.check_rounded, size: 56, color: scheme.primary),
                ),
                const SizedBox(height: 14),
                Text(
                  l.guidedRepDone(done),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(l.guidedRepDoneHint, style: TextStyle(color: palette.muted)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            children: [
              _bigButton(
                context,
                key: const Key('guided-next'),
                label: l.guidedNext(done + 1),
                icon: Icons.arrow_forward_rounded,
                trailingIcon: true,
                onPressed: () => _apply(_set.next(_now)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const Key('guided-finish-now'),
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.surface2,
                    foregroundColor: scheme.onSurface,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () => _apply(_set.finishEarly(_now)),
                  child: Text(l.guidedFinishNow(done)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _finished(BuildContext context) {
    final l = context.l10n;
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    final p = widget.planned;
    final secs = _set.elapsed.inSeconds;
    final duration = secs >= 60 ? '${secs ~/ 60} mnt ${secs % 60} dtk' : '$secs dtk';
    final rest = '${p.restSec ~/ 60}:${(p.restSec % 60).toString().padLeft(2, '0')}';
    final errorText = switch (_error) {
      null => null,
      SetInputError.repsRequired => l.setInputRepsRequired,
      SetInputError.repsOutOfRange => l.setInputRepsRange,
      SetInputError.weightOutOfRange => l.setInputWeightRange,
    };

    Widget field(String label, TextEditingController c, Key key, {bool decimal = false}) =>
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
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
                TextField(
                  key: key,
                  controller: c,
                  keyboardType: decimal
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(decimal ? r'[0-9.,]' : r'[0-9]')),
                  ],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: '–',
                  ),
                ),
              ],
            ),
          ),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        const SizedBox(height: 8),
        Text(
          l.guidedSetDone(widget.setNumber),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          p.isTimed
              ? l.guidedSummaryTimed(_set.result)
              : l.guidedSummaryReps(_set.result, duration),
          style: TextStyle(color: palette.muted),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            field(l.guidedWeight, _weight, const Key('guided-weight'), decimal: true),
            const SizedBox(width: 12),
            field(p.isTimed ? l.guidedSeconds : l.guidedReps, _reps, const Key('guided-reps')),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          l.guidedRir,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.muted),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var r = 0; r <= 5; r++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: r == 5 ? 0 : 6),
                  child: ChoiceChip(
                    key: Key('guided-rir-$r'),
                    label: SizedBox(
                      width: double.infinity,
                      child: Text(r == 5 ? '5+' : '$r', textAlign: TextAlign.center),
                    ),
                    showCheckmark: false,
                    color: WidgetStateProperty.resolveWith(
                      (st) => st.contains(WidgetState.selected) ? scheme.primary : palette.surface2,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _rir == r ? scheme.onPrimary : scheme.onSurface,
                    ),
                    selected: _rir == r,
                    onSelected: (on) => setState(() => _rir = on ? r : null),
                  ),
                ),
              ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 12),
          Text(errorText, style: TextStyle(color: scheme.error)),
        ],
        const SizedBox(height: 24),
        _bigButton(
          context,
          key: const Key('guided-save'),
          label: '${l.guidedSave} $rest',
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }
}
