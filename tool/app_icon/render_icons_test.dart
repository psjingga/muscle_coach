// Membuat ikon aplikasi Android & iOS dari AppLogoPainter (vektor).
// Jangan dijalankan langsung; pakai `tool/app_icon/generate.sh`.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_logo.dart';

const _res = 'android/app/src/main/res';
const _ios = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';

/// Kepadatan Android → faktor skala terhadap mdpi.
const _densities = {'mdpi': 1.0, 'hdpi': 1.5, 'xhdpi': 2.0, 'xxhdpi': 3.0, 'xxxhdpi': 4.0};

Future<void> _render(
  String path,
  int px, {
  AppLogoLayer layer = AppLogoLayer.full,
  double cornerRadius = 0,
  double inset = 0,
  double? markScale,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final s = px.toDouble();
  final rect = Rect.fromLTWH(inset, inset, s - inset * 2, s - inset * 2);
  if (cornerRadius > 0) {
    canvas.clipRRect(RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)));
  }
  canvas.translate(rect.left, rect.top);
  AppLogoPainter(layer: layer, markScale: markScale).paint(canvas, rect.size);
  final image = await recorder.endRecording().toImage(px, px);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('render ikon', () async {
    // Sumber 1024 px untuk dokumentasi/branding.
    await _render('assets/branding/app_icon.png', 1024);
    await _render('assets/branding/app_icon_foreground.png', 1024, layer: AppLogoLayer.foreground);

    for (final MapEntry(key: d, value: f) in _densities.entries) {
      // Ikon lama (Android < 8): kotak membulat dengan sedikit margin.
      final legacy = (48 * f).round();
      await _render(
        '$_res/mipmap-$d/ic_launcher.png',
        legacy,
        cornerRadius: legacy * 0.2,
        inset: legacy / 48 * 2,
      );
      // Ikon adaptif (Android 8+): lapisan 108 dp.
      final adaptive = (108 * f).round();
      for (final (name, layer) in [
        ('ic_launcher_background', AppLogoLayer.background),
        ('ic_launcher_foreground', AppLogoLayer.foreground),
        ('ic_launcher_monochrome', AppLogoLayer.monochrome),
      ]) {
        await _render('$_res/mipmap-$d/$name.png', adaptive, layer: layer);
      }
      // Ikon kecil notifikasi: siluet putih 24 dp.
      await _render(
        '$_res/drawable-$d/ic_notification.png',
        (24 * f).round(),
        layer: AppLogoLayer.monochrome,
        markScale: 1.3,
      );
    }

    // Layar pembuka iOS (LaunchScreen.storyboard): logo 96 pt.
    for (final (suffix, f) in [('', 1), ('@2x', 2), ('@3x', 3)]) {
      await _render(
        'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage$suffix.png',
        96 * f,
        cornerRadius: 96 * f * 0.225,
      );
    }

    // iOS: semua ukuran di Contents.json (alpha dibuang oleh generate.sh).
    final contents = jsonDecode(File('$_ios/Contents.json').readAsStringSync()) as Map;
    for (final img in (contents['images'] as List).cast<Map<String, dynamic>>()) {
      final size = double.parse((img['size'] as String).split('x').first);
      final scale = double.parse((img['scale'] as String).replaceAll('x', ''));
      await _render('$_ios/${img['filename']}', (size * scale).round());
    }
  });
}
