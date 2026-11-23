import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/app_restart.dart';
import 'package:musclecoach/core/database/app_database.dart';

var _opened = 0;
final _dbProvider = Provider<AppDatabase>((ref) {
  _opened++;
  final db = AppDatabase(NativeDatabase.memory());
  ref.onDispose(db.close);
  return db;
});
final _countProvider = StreamProvider<int>(
  (ref) => ref
      .watch(_dbProvider)
      .select(ref.watch(_dbProvider).bodyMetrics)
      .watch()
      .map((r) => r.length),
);

class _Page extends ConsumerWidget {
  const _Page();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(_countProvider).value;
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            final db = ref.read(_dbProvider);
            AppRestartScope.restartWith(context, () async {
              await db.close().timeout(const Duration(seconds: 5));
              _steps.add('pulihkan');
            });
          },
          child: Text('jumlah $n'),
        ),
      ),
    );
  }
}

final _steps = <String>[];

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('restartWith: lepas aplikasi, tutup DB yang sedang didengar, bangun ulang', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const AppRestartScope(child: MaterialApp(home: _Page())));
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
      expect(find.text('jumlah 0'), findsOneWidget);
      expect(_opened, 1);

      await tester.tap(find.text('jumlah 0'));
      await tester.pump();
      // Selama berhenti: hanya layar progres, tanpa halaman lama.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('jumlah 0'), findsNothing);

      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
      expect(_steps, ['pulihkan']);
      expect(_opened, 2, reason: 'basis data dibuka ulang di ProviderScope baru');
      expect(find.text('jumlah 0'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
  });
}
