import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lapisan logo yang bisa digambar. Ikon Android adaptif butuh latar dan
/// gambar depan terpisah; `monochrome` dipakai ikon bertema Android 13+ dan
/// ikon notifikasi.
enum AppLogoLayer { full, background, foreground, monochrome }

/// Logo Muscle Coach: dumbbell di atas grafik batang yang naik.
///
/// Sumber tunggal logo (vektor). Ikon aplikasi dibuat dari sini oleh
/// `tool/app_icon/generate.sh`. Geometri dalam kanvas 1024 × 1024.
class AppLogoPainter extends CustomPainter {
  const AppLogoPainter({this.layer = AppLogoLayer.full, this.markScale});

  final AppLogoLayer layer;

  /// Skala gambar terhadap kanvas; bawaan 1 (penuh) atau zona aman adaptif.
  final double? markScale;

  static const green1 = Color(0xFF2A9670);
  static const green2 = Color(0xFF0E4A37);
  static const lime = Color(0xFFC8F55A);

  /// Pusat gambar (dumbbell + grafik) dalam koordinat kanvas 1024.
  static const _markCenter = Offset(552, 470);

  /// Gambar depan ikon adaptif harus muat di zona aman (lingkaran ±66%).
  static const _adaptiveScale = 0.66;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 1024, size.height / 1024);
    final full = Offset.zero & const Size(1024, 1024);

    if (layer == AppLogoLayer.full || layer == AppLogoLayer.background) {
      canvas.drawRect(
        full,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [green1, green2],
          ).createShader(full),
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
    // Grafik batang naik; batang tertinggi = aksen.
    const xs = [300.0, 450.0, 600.0, 750.0];
    const hs = [170.0, 270.0, 380.0, 500.0];
    final faint = Paint()..color = Colors.white.withValues(alpha: monochrome ? 0.5 : 0.24);
    final accent = Paint()..color = monochrome ? Colors.white : lime;
    for (var i = 0; i < xs.length; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(xs[i] - 55, 800 - hs[i], 110, hs[i]),
          const Radius.circular(28),
        ),
        i == xs.length - 1 ? accent : faint,
      );
    }
    // Dumbbell sedikit miring ke atas.
    canvas
      ..save()
      ..translate(481, 348)
      ..rotate(-math.pi / 9)
      ..scale(0.62);
    final white = Paint()..color = Colors.white;
    RRect rr(double cx, double w, double h, double r) => RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, 0), width: w, height: h),
      Radius.circular(r),
    );
    canvas.drawRRect(rr(0, 600, 62, 31), white);
    for (final side in [-1.0, 1.0]) {
      canvas
        ..drawRRect(rr(side * 180, 92, 320, 36), white)
        ..drawRRect(rr(side * 270, 74, 228, 30), white);
    }
    canvas.restore();
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
