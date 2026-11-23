import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:musclecoach/app/router/app_shell.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/database_providers.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester tester) async {
    StatefulShellBranch branch(String path) => StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          builder: (_, _) => Center(child: Text('halaman $path')),
        ),
      ],
    );
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => AppShell(shell: shell),
          branches: [
            branch('/home'),
            branch('/workout'),
            branch('/nutrition'),
            branch('/progress'),
            branch('/profile'),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileProvider.overrideWith((ref) => Stream.value(const UserProfile())),
          clockProvider.overrideWithValue(() => DateTime(2026, 11, 23, 12)),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark(),
          locale: const Locale('id'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('bar: 4 tab (tanpa Profil) berpindah halaman', (tester) async {
    await pump(tester);
    final nav = find.byKey(const Key('app-nav'));
    for (final t in ['Beranda', 'Latihan', 'Nutrisi', 'Progres']) {
      expect(find.descendant(of: nav, matching: find.text(t)), findsOneWidget);
    }
    expect(find.descendant(of: nav, matching: find.text('Profil')), findsNothing);
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.text('halaman /nutrition'), findsOneWidget);
  });

  testWidgets('tombol + membuka aksi cepat; mulai sesi tanpa program → tab Latihan', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('quick-add')));
    await tester.pumpAndSettle();
    expect(find.text('Aksi cepat'), findsOneWidget);
    for (final k in ['scanFood', 'logFood', 'logWeight', 'startSession']) {
      expect(find.byKey(Key('qa-$k')), findsOneWidget);
    }
    await tester.tap(find.byKey(const Key('qa-startSession')));
    await tester.pumpAndSettle();
    expect(find.text('halaman /workout'), findsOneWidget);
    expect(find.textContaining('Belum ada program latihan'), findsOneWidget);
  });
}
