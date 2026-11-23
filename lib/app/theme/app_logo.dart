import 'package:flutter/material.dart';

/// Lapisan logo yang bisa digambar. Ikon Android adaptif butuh latar dan
/// gambar depan terpisah; `monochrome` dipakai ikon bertema Android 13+ dan
/// ikon notifikasi.
enum AppLogoLayer { full, background, foreground, monochrome }

/// Logo Muscle Coach (konsep A, desain volt): pelat beban volt dengan garis
/// progres putih yang menembus ke kanan atas — "angkat beban, lihat
/// kemajuan".
///
/// Sumber tunggal logo (vektor). Ikon aplikasi dibuat dari sini oleh
/// `tool/app_icon/generate.sh`. Geometri dalam kanvas 1024 × 1024.
class AppLogoPainter extends CustomPainter {
  const AppLogoPainter({this.layer = AppLogoLayer.full, this.markScale});

  final AppLogoLayer layer;

  /// Skala gambar terhadap kanvas; bawaan 1 (penuh) atau zona aman adaptif.
  final double? markScale;

  static const background = Color(0xFF0B0D0C);
  static const volt = Color(0xFFB6F23E);
  static const white = Color(0xFFF2F5F3);

  /// Pusat gambar (pelat + panah) dalam koordinat kanvas 1024.
  static const _markCenter = Offset(515, 540);

  /// Gambar depan ikon adaptif harus muat di zona aman (lingkaran ±66%).
  static const _adaptiveScale = 0.62;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 1024, size.height / 1024);
    final full = Offset.zero & const Size(1024, 1024);

    if (layer == AppLogoLayer.full || layer == AppLogoLayer.background) {
      canvas
        ..drawRect(full, Paint()..color = background)
        // Pendar volt halus di tengah.
        ..drawCircle(
          const Offset(512, 512),
          430,
          Paint()
            ..shader = RadialGradient(
              colors: [volt.withValues(alpha: 0.16), volt.withValues(alpha: 0)],
            ).createShader(Rect.fromCircle(center: const Offset(512, 512), radius: 430)),
        );
    }
    if (layer != AppLogoLayer.background) {
      final scale = markScale ?? (layer == AppLogoLayer.full ? 1.0 : _adaptiveScale);
      canvas
        ..save()
        ..translate(512, 512)
        ..scale(scale)
        ..translate(-_markCenter.dx, -_markCenter.dy);
      _mark(canvas, monochrome: layer == AppLogoLayer.monochrome);
      canvas.restore();
    }
    canvas.restore();
  }

  void _mark(Canvas canvas, {required bool monochrome}) {
    final plate = monochrome ? Colors.white : volt;
    final line = monochrome ? Colors.white : white;
    Path polyline(List<Offset> pts) {
      final p = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final o in pts.skip(1)) {
        p.lineTo(o.dx, o.dy);
      }
      return p;
    }

    // Lapisan terpisah agar "potongan" di sekitar panah benar-benar transparan.
    canvas.saveLayer(const Offset(0, 0) & const Size(1024, 1024), Paint());
    canvas
      ..drawCircle(
        const Offset(500, 540),
        250,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 112
          ..color = plate,
      )
      ..drawPath(
        polyline(const [Offset(250, 760), Offset(450, 560), Offset(560, 660), Offset(790, 400)]),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 150
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.clear,
      );
    canvas.restore();

    // Garis progres + kepala panah.
    canvas
      ..drawPath(
        polyline(const [Offset(250, 760), Offset(450, 560), Offset(560, 660), Offset(760, 434)]),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 78
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = line,
      )
      ..drawPath(
        Path()
          ..moveTo(836, 346)
          ..lineTo(812, 520)
          ..lineTo(668, 412)
          ..close(),
        Paint()
          ..color = line
          ..style = PaintingStyle.fill,
      )
      ..drawPath(
        Path()
          ..moveTo(836, 346)
          ..lineTo(812, 520)
          ..lineTo(668, 412)
          ..close(),
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..strokeJoin = StrokeJoin.round,
      );
  }

  @override
  bool shouldRepaint(AppLogoPainter old) => old.layer != layer || old.markScale != markScale;
}

/// Logo dalam bentuk kotak membulat (untuk splash, onboarding, dll.).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72, this.semanticLabel});

  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final logo = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.225),
      child: CustomPaint(size: Size.square(size), painter: const AppLogoPainter()),
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: logo)
        : Semantics(image: true, label: semanticLabel, child: logo);
  }
}
