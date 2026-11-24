import 'package:flutter/material.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/progress_models.dart';
import 'body_widgets.dart';

/// Arah pandang ilustrasi badan.
enum BodyView { front, side, back }

BodyView viewOf(PhotoPose p) => switch (p) {
  PhotoPose.front => BodyView.front,
  PhotoPose.side => BodyView.side,
  PhotoPose.back => BodyView.back,
};

extension BodyGuideText on AppLocalizations {
  List<String> measureSteps(BodySite s) => switch (s) {
    BodySite.chest => measureStepsChest,
    BodySite.waist => measureStepsWaist,
    BodySite.arm => measureStepsArm,
    BodySite.thigh => measureStepsThigh,
    BodySite.hip => measureStepsHip,
  }.split('\n');

  String poseHint(PhotoPose p) => switch (p) {
    PhotoPose.front => photoPoseHintFront,
    PhotoPose.side => photoPoseHintSide,
    PhotoPose.back => photoPoseHintBack,
  };
}

// ---------------------------------------------------------------------------
// Ilustrasi
// ---------------------------------------------------------------------------

/// Siluet badan sederhana (vektor, tanpa aset) dengan pita ukur opsional di
/// [tape] dan garis bantu bingkai foto bila [photoFrame].
class BodyFigure extends StatelessWidget {
  const BodyFigure({
    super.key,
    this.view = BodyView.front,
    this.tape,
    this.photoFrame = false,
    this.semanticLabel,
  });

  final BodyView view;
  final BodySite? tape;
  final bool photoFrame;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final painter = _BodyPainter(
      view: view,
      tape: tape,
      photoFrame: photoFrame,
      body: Color.alphaBlend(scheme.onSurface.withValues(alpha: 0.16), palette.surface2),
      line: scheme.onSurface.withValues(alpha: 0.28),
      accent: scheme.primary,
      guide: scheme.onSurface.withValues(alpha: 0.12),
    );
    final figure = AspectRatio(
      aspectRatio: photoFrame ? 3 / 4 : 1 / 2,
      child: CustomPaint(painter: painter),
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: figure)
        : Semantics(
            image: true,
            label: semanticLabel,
            child: ExcludeSemantics(child: figure),
          );
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.view,
    required this.tape,
    required this.photoFrame,
    required this.body,
    required this.line,
    required this.accent,
    required this.guide,
  });

  final BodyView view;
  final BodySite? tape;
  final bool photoFrame;
  final Color body;
  final Color line;
  final Color accent;
  final Color guide;

  // Badan digambar di kotak 100 × 200 lalu diskalakan.
  static const _w = 100.0;
  static const _h = 200.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (photoFrame) _paintFrame(canvas, size);
    // Tempatkan kotak 100×200 di tengah area (dengan margin bila bingkai foto).
    final area = photoFrame
        ? Rect.fromLTWH(0, size.height * 0.06, size.width, size.height * 0.86)
        : Offset.zero & size;
    final scale = (area.height / _h).clamp(0.0, area.width / _w * 2);
    final dx = area.left + (area.width - _w * scale) / 2;
    canvas
      ..save()
      ..translate(dx, area.top + (area.height - _h * scale) / 2)
      ..scale(scale);

    final fill = Paint()..color = body;
    final limb = Paint()
      ..color = body
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final detail = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    if (view == BodyView.side) {
      _paintSide(canvas, fill, limb, detail);
    } else {
      _paintFront(canvas, fill, limb, detail, back: view == BodyView.back);
    }
    canvas.restore();
  }

  void _paintFrame(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12));
    canvas.drawRRect(
      r,
      Paint()
        ..color = guide
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final grid = Paint()
      ..color = guide
      ..strokeWidth = 1;
    for (final f in [1 / 3, 2 / 3]) {
      canvas
        ..drawLine(Offset(size.width * f, 0), Offset(size.width * f, size.height), grid)
        ..drawLine(Offset(0, size.height * f), Offset(size.width, size.height * f), grid);
    }
    // Garis lantai.
    final floor = size.height * 0.93;
    canvas.drawLine(
      Offset(size.width * 0.12, floor),
      Offset(size.width * 0.88, floor),
      Paint()
        ..color = accent.withValues(alpha: 0.6)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintFront(Canvas canvas, Paint fill, Paint limb, Paint detail, {required bool back}) {
    // Kaki.
    limb.strokeWidth = 14;
    for (final x in [40.5, 59.5]) {
      final s = x < 50 ? -1 : 1;
      final leg = Path()
        ..moveTo(x, 104)
        ..quadraticBezierTo(x + s * 1.5, 140, x + s * 0.5, 150)
        ..lineTo(x + s * 1.0, 186);
      canvas.drawPath(leg, limb);
      // Telapak kaki.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x + s * 2.5, 192), width: 15, height: 6),
          const Radius.circular(3),
        ),
        fill,
      );
    }
    // Lengan (sedikit menjauh dari badan).
    limb.strokeWidth = 9.5;
    for (final s in [-1.0, 1.0]) {
      final arm = Path()
        ..moveTo(50 + s * 24, 44)
        ..quadraticBezierTo(50 + s * 31.5, 62, 50 + s * 33, 78)
        ..quadraticBezierTo(50 + s * 34.5, 94, 50 + s * 36, 108);
      canvas
        ..drawPath(arm, limb)
        ..drawCircle(Offset(50 + s * 36.5, 112), 5, fill);
    }
    // Badan.
    final torso = Path()
      ..moveTo(44, 34)
      ..lineTo(56, 34)
      ..quadraticBezierTo(58, 38, 66, 39)
      ..quadraticBezierTo(74, 41, 72, 52)
      ..quadraticBezierTo(69, 66, 64, 80)
      ..quadraticBezierTo(63, 90, 67, 100)
      ..quadraticBezierTo(70, 108, 66, 113)
      ..lineTo(50, 116)
      ..lineTo(34, 113)
      ..quadraticBezierTo(30, 108, 33, 100)
      ..quadraticBezierTo(37, 90, 36, 80)
      ..quadraticBezierTo(31, 66, 28, 52)
      ..quadraticBezierTo(26, 41, 34, 39)
      ..quadraticBezierTo(42, 38, 44, 34)
      ..close();
    canvas
      ..drawPath(torso, fill)
      // Kepala & leher.
      ..drawRRect(RRect.fromLTRBR(45, 24, 55, 38, const Radius.circular(3)), fill)
      ..drawOval(Rect.fromCenter(center: const Offset(50, 16), width: 21, height: 25), fill);

    if (back) {
      canvas
        ..drawLine(const Offset(50, 40), const Offset(50, 100), detail)
        ..drawPath(
          Path()
            ..moveTo(38, 46)
            ..quadraticBezierTo(42, 58, 46, 60),
          detail,
        )
        ..drawPath(
          Path()
            ..moveTo(62, 46)
            ..quadraticBezierTo(58, 58, 54, 60),
          detail,
        )
        ..drawPath(
          Path()
            ..moveTo(44, 110)
            ..quadraticBezierTo(50, 104, 56, 110),
          detail,
        );
    } else {
      canvas
        ..drawPath(
          Path()
            ..moveTo(33, 58)
            ..quadraticBezierTo(41, 63, 49, 58),
          detail,
        )
        ..drawPath(
          Path()
            ..moveTo(51, 58)
            ..quadraticBezierTo(59, 63, 67, 58),
          detail,
        )
        ..drawCircle(const Offset(50, 82), 1.1, detail..style = PaintingStyle.fill);
      detail.style = PaintingStyle.stroke;
    }

    if (tape case final site?) _paintTape(canvas, site);
  }

  void _paintSide(Canvas canvas, Paint fill, Paint limb, Paint detail) {
    // Kaki (satu terlihat) & telapak menghadap kanan.
    limb.strokeWidth = 16;
    final leg = Path()
      ..moveTo(50, 104)
      ..quadraticBezierTo(53, 140, 50, 150)
      ..lineTo(49, 186);
    canvas
      ..drawPath(leg, limb)
      ..drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(43, 188, 22, 7), const Radius.circular(3.5)),
        fill,
      );
    // Badan: punggung di kiri, dada/perut di kanan.
    final torso = Path()
      ..moveTo(45, 32)
      ..lineTo(54, 32)
      ..quadraticBezierTo(56, 38, 60, 44)
      ..quadraticBezierTo(66, 54, 62, 66)
      ..quadraticBezierTo(60, 76, 61, 86)
      ..quadraticBezierTo(62, 98, 58, 110)
      ..lineTo(42, 112)
      ..quadraticBezierTo(34, 104, 37, 92)
      ..quadraticBezierTo(41, 80, 39, 66)
      ..quadraticBezierTo(37, 50, 42, 40)
      ..quadraticBezierTo(44, 36, 45, 32)
      ..close();
    canvas
      ..drawPath(torso, fill)
      ..drawRRect(RRect.fromLTRBR(45, 22, 54, 36, const Radius.circular(3)), fill)
      ..drawOval(Rect.fromCenter(center: const Offset(51, 15), width: 22, height: 24), fill)
      // Hidung → arah hadap.
      ..drawPath(
        Path()
          ..moveTo(61.5, 13)
          ..lineTo(64.5, 18)
          ..lineTo(61.5, 19)
          ..close(),
        fill,
      );
    // Lengan di samping, sedikit ke depan.
    limb.strokeWidth = 10;
    final arm = Path()
      ..moveTo(49, 44)
      ..quadraticBezierTo(51, 64, 52, 78)
      ..quadraticBezierTo(54, 94, 56, 108);
    limb.color = Color.alphaBlend(line.withValues(alpha: 0.35), body);
    canvas
      ..drawPath(arm, limb)
      ..drawCircle(const Offset(56.5, 112), 5, Paint()..color = limb.color);
    limb.color = body;
  }

  /// Pita ukur: busur depan tegas + busur belakang putus-putus (kesan melingkar).
  void _paintTape(Canvas canvas, BodySite site) {
    final rect = switch (site) {
      BodySite.chest => Rect.fromLTRB(28, 52, 72, 60),
      BodySite.waist => Rect.fromLTRB(35.5, 77, 64.5, 84),
      BodySite.hip => Rect.fromLTRB(31.5, 101, 68.5, 108),
      BodySite.thigh => Rect.fromLTRB(32.5, 121, 48.5, 127),
      BodySite.arm => Rect.fromLTRB(76.5, 59, 87.5, 64),
    };
    final front = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    final backPaint = Paint()
      ..color = accent.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    // Busur belakang (atas) putus-putus.
    final backArc = Path()..addArc(rect, 3.3, 2.8);
    for (final m in backArc.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 4) {
        canvas.drawPath(m.extractPath(d, d + 2), backPaint);
      }
    }
    canvas.drawArc(rect, 0.12, 2.9, false, front);
    // Ujung pita + penanda angka.
    final tip = Offset(rect.right + 1, rect.center.dy + 1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: tip.translate(4, 0), width: 8, height: 5),
        const Radius.circular(1.5),
      ),
      Paint()..color = accent,
    );
    // Panah penunjuk dari samping agar mudah ditemukan.
    final glow = Paint()
      ..color = accent.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(RRect.fromRectAndRadius(rect.inflate(3), const Radius.circular(6)), glow);
  }

  @override
  bool shouldRepaint(_BodyPainter old) =>
      old.view != view ||
      old.tape != tape ||
      old.photoFrame != photoFrame ||
      old.body != body ||
      old.accent != accent ||
      old.line != line;
}

// ---------------------------------------------------------------------------
// Panduan lingkar badan
// ---------------------------------------------------------------------------

Future<void> showMeasurementGuide(BuildContext context, {BodySite initial = BodySite.chest}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _MeasurementGuide(initial: initial),
    );

class _MeasurementGuide extends StatefulWidget {
  const _MeasurementGuide({required this.initial});

  final BodySite initial;

  @override
  State<_MeasurementGuide> createState() => _MeasurementGuideState();
}

class _MeasurementGuideState extends State<_MeasurementGuide> {
  late BodySite _site = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scroll) => ListView(
        key: const Key('measure-guide'),
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(l.measureGuideTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          mutedLine(context, l.measureGuideIntro),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final s in BodySite.values)
                ChoiceChip(
                  key: Key('measure-guide-${s.name}'),
                  label: Text(l.site(s)),
                  selected: s == _site,
                  onSelected: (_) => setState(() => _site = s),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.palette.surface2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: BodyFigure(
                    tape: _site,
                    semanticLabel: l.bodyGuideFigureLabel(l.site(_site).toLowerCase()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.site(_site),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      for (final (i, step) in l.measureSteps(_site).indexed)
                        _NumberedStep(number: i + 1, text: step),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(l.measureTipsTitle, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final tip in l.measureTips.split('\n')) _Bullet(text: tip),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Panduan foto progres
// ---------------------------------------------------------------------------

Future<void> showPhotoGuide(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _PhotoGuide(),
);

class _PhotoGuide extends StatelessWidget {
  const _PhotoGuide();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scroll) => ListView(
        key: const Key('photo-guide'),
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(l.photoGuideTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          mutedLine(context, l.photoGuideIntro),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, p) in PhotoPose.values.indexed) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(child: PoseExample(pose: p)),
              ],
            ],
          ),
          const SizedBox(height: 16),
          for (final p in PhotoPose.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${l.pose(p)} — ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: l.poseHint(p)),
                  ],
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: 12),
          Text(l.photoTipsTitle, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final tip in l.photoTips.split('\n')) _Bullet(text: tip),
        ],
      ),
    );
  }
}

/// Contoh satu pose foto: bingkai kamera + siluet + label.
class PoseExample extends StatelessWidget {
  const PoseExample({super.key, required this.pose, this.showLabel = true});

  final PhotoPose pose;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.palette.surface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: BodyFigure(
            view: viewOf(pose),
            photoFrame: true,
            semanticLabel: l.photoExampleLabel(l.pose(pose).toLowerCase()),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          Text(l.pose(pose), style: Theme.of(context).textTheme.labelLarge),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------

Widget mutedLine(BuildContext context, String text) => Text(
  text,
  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.palette.muted),
);

class _NumberedStep extends StatelessWidget {
  const _NumberedStep({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
            child: Text(
              '$number',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: scheme.onPrimary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7, right: 10),
          child: Icon(Icons.circle, size: 6, color: Theme.of(context).colorScheme.primary),
        ),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    ),
  );
}
