import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_logo.dart';

void main() {
  testWidgets('logo tergambar di semua lapisan', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            const AppLogo(size: 64, semanticLabel: 'Muscle Coach'),
            for (final layer in AppLogoLayer.values)
              CustomPaint(
                size: const Size.square(48),
                painter: AppLogoPainter(layer: layer),
              ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.bySemanticsLabel('Muscle Coach'), findsOneWidget);
  });

  test('ikon Android, notifikasi, dan iOS sudah dibuat dari logo', () {
    const res = 'android/app/src/main/res';
    for (final d in ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']) {
      for (final f in [
        'mipmap-$d/ic_launcher.png',
        'mipmap-$d/ic_launcher_background.png',
        'mipmap-$d/ic_launcher_foreground.png',
        'mipmap-$d/ic_launcher_monochrome.png',
        'drawable-$d/ic_notification.png',
      ]) {
        expect(File('$res/$f').existsSync(), isTrue, reason: f);
      }
    }
    expect(File('$res/mipmap-anydpi-v26/ic_launcher.xml').existsSync(), isTrue);
    expect(
      File('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png').existsSync(),
      isTrue,
    );
  });
}
