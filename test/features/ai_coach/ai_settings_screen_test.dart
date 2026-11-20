import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_client.dart';
import 'package:musclecoach/features/ai_coach/presentation/providers/ai_providers.dart';
import 'package:musclecoach/features/ai_coach/presentation/screens/ai_settings_screen.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

import 'ai_coach_test.dart' show MemoryKeyStore;

class _VerifyingClient implements AiClient {
  @override
  Future<void> verifyKey(String apiKey) async {
    if (apiKey != 'kunci-benar') throw const AppFailure(FailureKind.unauthenticated);
  }

  @override
  Future<AiResponse> generateJson({
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String userContent,
    required Map<String, Object?> responseSchema,
  }) => throw UnimplementedError();
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('simpan key (diverifikasi), persetujuan, hapus key', (tester) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final keys = MemoryKeyStore();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          aiKeyStoreProvider.overrideWithValue(keys),
          aiClientProvider.overrideWithValue(_VerifyingClient()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AiSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Belum siap'), findsOneWidget);
    // Isi data yang dikirim ke AI dijelaskan.
    expect(find.textContaining('Tidak dikirim: nama, umur'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('ai-key')), 'kunci-salah');
    await tester.tap(find.text('Simpan & uji'));
    await tester.pumpAndSettle();
    expect(find.textContaining('API key tidak valid'), findsOneWidget);
    expect(keys.key, isNull);

    await tester.enterText(find.byKey(const ValueKey('ai-key')), '  kunci-benar ');
    await tester.tap(find.text('Simpan & uji'));
    await tester.pumpAndSettle();
    expect(keys.key, 'kunci-benar');
    expect(find.text('Key tersimpan (…enar)'), findsOneWidget);
    // Key tidak pernah ditampilkan utuh.
    expect(find.textContaining('kunci-benar'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('ai-consent')));
    await tester.pumpAndSettle();
    expect(find.text('Siap dipakai'), findsOneWidget);

    await tester.tap(find.text('Hapus key'));
    await tester.pumpAndSettle();
    expect(keys.key, isNull);
    expect(find.textContaining('Belum siap'), findsOneWidget);
  });
}
