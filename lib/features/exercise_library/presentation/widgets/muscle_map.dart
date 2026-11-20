import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../workout/presentation/widgets/workout_labels.dart';

/// Sisi tubuh pada peta otot.
enum BodyView { front, back }

/// Satu area otot yang digambar; [code] = kode otot katalog
/// (`chest`, `lats`, ...). Koordinat dalam kanvas 100 × 170 per figur,
/// digambar di sisi kiri lalu dicerminkan bila [mirrored].
class MuscleRegion {
  const MuscleRegion(this.code, this.view, this.build, {this.mirrored = true});

  final String code;
  final BodyView view;
  final Path Function() build;
  final bool mirrored;
}

Path _oval(double cx, double cy, double rx, double ry) =>
    Path()..addOval(Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2));

Path _poly(List<(double, double)> pts) {
  final p = Path()..moveTo(pts.first.$1, pts.first.$2);
  for (final (x, y) in pts.skip(1)) {
    p.lineTo(x, y);
  }
  return p..close();
}

/// Peta area otot depan & belakang. Semua kode otot katalog harus punya
/// minimal satu area (diuji di `muscle_map_test.dart`).
final List<MuscleRegion> muscleRegions = [
  // ---- Depan ----
  MuscleRegion('traps', BodyView.front, () => _poly([(45, 27), (37, 33), (45, 32)])),
  MuscleRegion('side_delts', BodyView.front, () => _oval(28, 40, 4, 6.5)),
  MuscleRegion('front_delts', BodyView.front, () => _oval(33, 38, 4.6, 5.8)),
  MuscleRegion(
    'chest',
    BodyView.front,
    () => Path()
      ..moveTo(49.4, 33.5)
      ..lineTo(39, 33.5)
      ..quadraticBezierTo(34.5, 42, 38.5, 49)
      ..quadraticBezierTo(44, 52, 49.4, 50)
      ..close(),
  ),
  MuscleRegion('biceps', BodyView.front, () => _oval(26.2, 54, 3.9, 8.5)),
  MuscleRegion('forearms', BodyView.front, () => _oval(23.4, 72.5, 3.5, 9.5)),
  MuscleRegion(
    'core',
    BodyView.front,
    () => Path()..addRRect(RRect.fromLTRBR(42.6, 52.5, 49.4, 79, const Radius.circular(2))),
  ),
  MuscleRegion(
    'core',
    BodyView.front,
    () => _poly([(37.8, 52), (41.6, 53), (41.6, 76), (38.6, 72)]),
  ),
  MuscleRegion('quads', BodyView.front, () => _oval(41.6, 105, 6.4, 16.5)),
  MuscleRegion('adductors', BodyView.front, () => _oval(48, 98.5, 1.9, 10)),
  MuscleRegion('calves', BodyView.front, () => _oval(41.8, 144, 3.8, 12.5)),
  // ---- Belakang ----
  MuscleRegion(
    'traps',
    BodyView.back,
    () => _poly([(50, 25), (61.5, 34), (50, 58), (38.5, 34)]),
    mirrored: false,
  ),
  MuscleRegion('side_delts', BodyView.back, () => _oval(28, 40.5, 4, 6.5)),
  MuscleRegion('rear_delts', BodyView.back, () => _oval(33, 39, 4.6, 5.8)),
  MuscleRegion(
    'upper_back',
    BodyView.back,
    () => _poly([(38.5, 37.5), (45.5, 44), (44, 50), (37.5, 46)]),
  ),
  MuscleRegion(
    'lats',
    BodyView.back,
    () => _poly([(37, 48.5), (44, 52), (48.6, 60), (48.6, 70), (41, 68), (36, 56)]),
  ),
  MuscleRegion(
    'core',
    BodyView.back,
    () => Path()..addRRect(RRect.fromLTRBR(44, 66, 56, 80, const Radius.circular(3))),
    mirrored: false,
  ),
  MuscleRegion('triceps', BodyView.back, () => _oval(26.2, 54, 3.9, 8.5)),
  MuscleRegion('forearms', BodyView.back, () => _oval(23.4, 72.5, 3.5, 9.5)),
  MuscleRegion('glutes', BodyView.back, () => _oval(43.6, 88, 6.6, 7.6)),
  MuscleRegion('hamstrings', BodyView.back, () => _oval(42, 110, 6, 14.5)),
  MuscleRegion('adductors', BodyView.back, () => _oval(48.2, 103, 1.7, 8)),
  MuscleRegion('calves', BodyView.back, () => _oval(42, 141, 5.2, 11.5)),
];

/// Kode otot yang tergambar pada peta.
Set<String> get muscleMapCodes => {for (final r in muscleRegions) r.code};

final Float64List _mirror = Float64List.fromList([
  -1, 0, 0, 0, //
  0, 1, 0, 0, //
  0, 0, 1, 0, //
  100, 0, 0, 1, //
]);

/// Figur depan dan belakang berdampingan dengan otot utama/pendukung
/// diwarnai. [compact] = tanpa label & legenda (untuk thumbnail).
class MuscleMap extends StatelessWidget {
  const MuscleMap({
    super.key,
    required this.primary,
    this.secondary = const [],
    this.compact = false,
    this.height = 180,
  });

  final List<String> primary;
  final List<String> secondary;
  final bool compact;
  final double height;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final colors = MuscleMapColors(
      body: scheme.surfaceContainerHighest,
      idle: scheme.outlineVariant,
      primary: scheme.primary,
      secondary: scheme.primary.withValues(alpha: 0.4),
    );
    String names(List<String> codes) =>
        codes.isEmpty ? l.noneLabel : codes.map(l.muscleCode).join(', ');

    final map = CustomPaint(
      size: Size.infinite,
      painter: MuscleMapPainter(
        primary: primary.toSet(),
        secondary: secondary.toSet(),
        colors: colors,
      ),
    );
    if (compact) {
      return ExcludeSemantics(
        child: SizedBox(height: height, child: map),
      );
    }

    Widget legend(Color c, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );

    return Semantics(
      container: true,
      label: l.muscleMapSemantics(names(primary), names(secondary)),
      excludeSemantics: true,
      child: Column(
        children: [
          // Lebar dibatasi sesuai rasio figur agar label tepat di bawahnya.
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: height * 200 / 170),
              child: Column(
                children: [
                  SizedBox(height: height, child: map),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: Center(child: Text(l.muscleMapFront))),
                      Expanded(child: Center(child: Text(l.muscleMapBack))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            alignment: WrapAlignment.center,
            children: [
              legend(colors.primary, l.exercisePrimaryMuscles),
              if (secondary.isNotEmpty) legend(colors.secondary, l.exerciseSecondaryMuscles),
            ],
          ),
        ],
      ),
    );
  }
}

class MuscleMapColors {
  const MuscleMapColors({
    required this.body,
    required this.idle,
    required this.primary,
    required this.secondary,
  });

  final Color body;
  final Color idle;
  final Color primary;
  final Color secondary;
}

/// Menggambar dua figur (depan | belakang) dalam kanvas logis 200 × 170.
class MuscleMapPainter extends CustomPainter {
  MuscleMapPainter({required this.primary, required this.secondary, required this.colors});

  final Set<String> primary;
  final Set<String> secondary;
  final MuscleMapColors colors;

  static const _logical = Size(200, 170);

  Color colorFor(String code) => primary.contains(code)
      ? colors.primary
      : secondary.contains(code)
      ? colors.secondary
      : colors.idle;

  void _silhouette(Canvas canvas) {
    final body = Paint()..color = colors.body;
    canvas
      ..drawOval(Rect.fromCenter(center: const Offset(50, 13), width: 17, height: 21), body)
      ..drawRect(const Rect.fromLTRB(45, 22, 55, 30), body)
      ..drawPath(
        _poly([
          (36, 30),
          (64, 30),
          (73, 36),
          (65, 56),
          (64, 80),
          (66, 92),
          (34, 92),
          (36, 80),
          (35, 56),
          (27, 36),
        ]),
        body,
      );
    final limb = Paint()
      ..color = colors.body
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final flip in [false, true]) {
      double x(double v) => flip ? 100 - v : v;
      final arm = Path()
        ..moveTo(x(29), 38)
        ..lineTo(x(26), 58)
        ..lineTo(x(22), 86);
      final leg = Path()
        ..moveTo(x(42), 90)
        ..lineTo(x(42), 128)
        ..lineTo(x(42), 160);
      canvas
        ..drawPath(arm, limb..strokeWidth = 9)
        ..drawPath(leg, limb..strokeWidth = 14)
        ..drawOval(Rect.fromCenter(center: Offset(x(21.5), 89), width: 6, height: 7), body)
        ..drawOval(Rect.fromCenter(center: Offset(x(42), 163), width: 9, height: 6), body);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / _logical.width) < (size.height / _logical.height)
        ? size.width / _logical.width
        : size.height / _logical.height;
    final dx = (size.width - _logical.width * scale) / 2;
    final dy = (size.height - _logical.height * scale) / 2;

    for (final view in BodyView.values) {
      canvas
        ..save()
        ..translate(dx + (view == BodyView.back ? 100 * scale : 0), dy)
        ..scale(scale);
      _silhouette(canvas);
      for (final r in muscleRegions.where((r) => r.view == view)) {
        final paint = Paint()..color = colorFor(r.code);
        final path = r.build();
        canvas.drawPath(path, paint);
        if (r.mirrored) canvas.drawPath(path.transform(_mirror), paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(MuscleMapPainter old) =>
      old.colors.primary != colors.primary ||
      old.colors.body != colors.body ||
      !_sameSet(old.primary, primary) ||
      !_sameSet(old.secondary, secondary);

  static bool _sameSet(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);
}
