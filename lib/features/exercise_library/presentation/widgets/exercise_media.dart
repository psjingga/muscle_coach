import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/utils/context_x.dart';
import '../../domain/exercise.dart';
import 'muscle_map.dart';

/// Foto posisi awal ↔ akhir yang bergantian otomatis seperti animasi.
/// Diam bila pengguna mematikan animasi sistem atau menekan jeda.
class ExerciseImages extends StatefulWidget {
  const ExerciseImages({super.key, required this.exercise, this.height = 220});

  final Exercise exercise;
  final double height;

  static const frameInterval = Duration(milliseconds: 1400);

  @override
  State<ExerciseImages> createState() => _ExerciseImagesState();
}

class _ExerciseImagesState extends State<ExerciseImages> {
  Timer? _timer;
  int _frame = 0;
  bool _paused = false;

  List<String> get _images => widget.exercise.images;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTimer();
  }

  @override
  void didUpdateWidget(ExerciseImages old) {
    super.didUpdateWidget(old);
    if (old.exercise.id != widget.exercise.id) _frame = 0;
    _syncTimer();
  }

  void _syncTimer() {
    final animate = !_paused && _images.length > 1 && !MediaQuery.of(context).disableAnimations;
    if (!animate) {
      _timer?.cancel();
      _timer = null;
    } else {
      _timer ??= Timer.periodic(ExerciseImages.frameInterval, (_) {
        if (mounted) setState(() => _frame = (_frame + 1) % _images.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    if (_images.isEmpty) return const SizedBox.shrink();
    final frame = _frame.clamp(0, _images.length - 1);
    final frameLabel = frame == 0 ? l.exerciseFrameStart : l.exerciseFrameEnd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: widget.height,
            color: theme.colorScheme.surfaceContainerHighest,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Image.asset(
                    _images[frame],
                    key: ValueKey(_images[frame]),
                    fit: BoxFit.contain,
                    semanticLabel: l.exercisePhotoSemantics(widget.exercise.name, frameLabel),
                    errorBuilder: (_, _, _) =>
                        const Center(child: Icon(Icons.image_not_supported_outlined)),
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: _Pill(text: '${frame + 1}/${_images.length} · $frameLabel'),
                ),
                if (_images.length > 1)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: IconButton.filledTonal(
                      key: const ValueKey('exercise-motion-toggle'),
                      tooltip: _paused ? l.playMotion : l.pauseMotion,
                      icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
                      onPressed: () {
                        setState(() => _paused = !_paused);
                        _syncTimer();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l.exercisePhotoCredit,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(text, style: theme.textTheme.labelMedium),
      ),
    );
  }
}

/// Ilustrasi + peta otot satu latihan (dipakai di detail & tampilan cepat).
class ExerciseVisuals extends StatelessWidget {
  const ExerciseVisuals({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (exercise.images.isNotEmpty) ...[
          ExerciseImages(exercise: exercise),
          const SizedBox(height: 16),
        ],
        Text(l.muscleMapTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        MuscleMap(primary: exercise.primaryMuscles, secondary: exercise.secondaryMuscles),
      ],
    );
  }
}

/// Gambar kecil latihan: frame pertama foto, atau peta otot bila tak ada foto.
/// Ketuk → tampilan cepat tanpa meninggalkan layar saat ini.
class ExerciseThumbnail extends StatelessWidget {
  const ExerciseThumbnail({super.key, required this.exercise, this.size = 56});

  final Exercise exercise;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final image = exercise.images.firstOrNull;
    return Semantics(
      button: true,
      label: '${l.exerciseQuickViewHint}: ${exercise.name}',
      excludeSemantics: true,
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('exercise-thumb-${exercise.id}'),
          onTap: () => showExerciseQuickView(context, exercise),
          child: SizedBox.square(
            dimension: size,
            child: image != null
                ? Image.asset(
                    image,
                    fit: BoxFit.cover,
                    cacheWidth: (size * 3).round(),
                    errorBuilder: (_, _, _) => const Icon(Icons.fitness_center),
                  )
                : Padding(
                    padding: const EdgeInsets.all(4),
                    child: MuscleMap(
                      primary: exercise.primaryMuscles,
                      secondary: exercise.secondaryMuscles,
                      compact: true,
                      height: size,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet: gerakan, peta otot, dan langkah singkat.
Future<void> showExerciseQuickView(BuildContext context, Exercise exercise) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (ctx) {
      final l = ctx.l10n;
      final theme = Theme.of(ctx);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (ctx, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Text(exercise.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ExerciseVisuals(exercise: exercise),
            if (exercise.instructions.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l.exerciseInstructions, style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              for (final (i, t) in exercise.instructions.indexed)
                Padding(padding: const EdgeInsets.only(bottom: 6), child: Text('${i + 1}. $t')),
            ],
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push(Routes.exercisePath(exercise.id));
              },
              child: Text(l.exerciseOpenDetail),
            ),
          ],
        ),
      );
    },
  );
}
