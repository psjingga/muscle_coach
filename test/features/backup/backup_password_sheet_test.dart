import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/features/backup/presentation/backup_flow.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

void main() {
  testWidgets('kata sandi: minimal 8 karakter & harus sama saat ekspor', (tester) async {
    String? result = 'belum';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        locale: const Locale('id'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showBackupPasswordSheet(context, confirm: true),
            child: const Text('buka'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('backup-password')), 'pendek');
    await tester.tap(find.byKey(const Key('backup-password-submit')));
    await tester.pump();
    expect(find.text('Minimal 8 karakter'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('backup-password')), 'rahasia-kuat');
    await tester.enterText(find.byKey(const Key('backup-password-confirm')), 'rahasia-lain');
    await tester.tap(find.byKey(const Key('backup-password-submit')));
    await tester.pump();
    expect(find.text('Kata sandi tidak sama'), findsOneWidget);
    expect(result, 'belum');

    await tester.enterText(find.byKey(const Key('backup-password-confirm')), 'rahasia-kuat');
    await tester.tap(find.byKey(const Key('backup-password-submit')));
    await tester.pumpAndSettle();
    expect(result, 'rahasia-kuat');
  });
}
