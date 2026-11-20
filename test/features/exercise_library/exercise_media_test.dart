import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/features/exercise_library/domain/exercise.dart';
import 'package:musclecoach/features/exercise_library/presentation/providers/exercise_providers.dart';
import 'package:musclecoach/features/exercise_library/presentation/screens/exercise_screens.dart';
import 'package:musclecoach/features/exercise_library/presentation/widgets/exercise_media.dart';
import 'package:musclecoach/features/exercise_library/presentation/widgets/muscle_map.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';

/// Katalog asli dari aset (dibaca langsung dari disk).
Map<String, Exercise> _catalog() {
  final json = jsonDecode(File('assets/catalog/exercises.json').readAsStringSync()) as Map;
  return {
    for (final e in (json['exercises'] as List).cast<Map<String, dynamic>>())
      e['id'] as String: Exercise.fromJson(e),
  };
}

void main() {
  final catalog = _catalog();

  group('katalog media', () {
    test('setiap foto yang dirujuk ada di aset dan berpasangan awal/akhir', () {
      for (final e in catalog.values) {
        expect(e.images.length, anyOf(0, 2), reason: e.id);
        for (final path in e.images) {
          expect(path, startsWith('assets/exercises/${e.id}_'), reason: e.id);
          expect(File(path).existsSync(), isTrue, reason: path);
        }
      }
      // Hampir semua latihan punya foto; sisanya cukup peta otot.
      expect(catalog.values.where((e) => e.images.isNotEmpty).length, greaterThanOrEqualTo(40));
    });

    test('tidak ada file foto yatim di folder aset', () {
      final referenced = {for (final e in catalog.values) ...e.images};
      final files = Directory('assets/exercises')
          .listSync()
          .whereType<File>()
          .map((f) => f.path)
          .where((p) => p.endsWith('.jpg'));
      expect(files.toSet().difference(referenced), isEmpty);
    });

    test('setiap kode otot di katalog tergambar di peta otot', () {
      final codes = {
        for (final e in catalog.values) ...[...e.primaryMuscles, ...e.secondaryMuscles],
      };
      expect(codes.difference(muscleMapCodes), isEmpty);
    });
  });

  test('pewarnaan: utama > pendukung > netral', () {
    final p = MuscleMapPainter(
      primary: {'chest'},
      secondary: {'triceps'},
      colors: const MuscleMapColors(
        body: Colors.grey,
        idle: Colors.white,
        primary: Colors.red,
        secondary: Colors.pink,
      ),
    );
    expect(p.colorFor('chest'), Colors.red);
    expect(p.colorFor('triceps'), Colors.pink);
    expect(p.colorFor('quads'), Colors.white);
  });

  group('tampilan', () {
    Future<void> pump(WidgetTester tester, Widget child, {bool disableAnimations = false}) async {
      tester.view.physicalSize = const Size(900, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [exerciseCatalogProvider.overrideWith((ref) async => catalog)],
          child: MaterialApp(
            theme: AppTheme.light(),
            locale: const Locale('id'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(900, 2400),
                disableAnimations: disableAnimations,
              ),
              child: child,
            ),
          ),
        ),
      );
      await tester.pump();
    }

    Finder asset(String path) => find.byWidgetPredicate(
      (w) => w is Image && w.image is AssetImage && (w.image as AssetImage).assetName == path,
    );

    testWidgets('detail: foto bergantian otomatis, bisa dijeda, plus peta otot', (tester) async {
      await pump(tester, const ExerciseDetailScreen(exerciseId: 'barbell_back_squat'));
      expect(asset('assets/exercises/barbell_back_squat_0.jpg'), findsOneWidget);
      expect(find.byType(MuscleMap), findsOneWidget);
      expect(find.textContaining('Free Exercise DB'), findsOneWidget);

      await tester.pump(ExerciseImages.frameInterval);
      await tester.pump(const Duration(milliseconds: 300));
      expect(asset('assets/exercises/barbell_back_squat_1.jpg'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('exercise-motion-toggle')));
      await tester.pump(ExerciseImages.frameInterval * 3);
      await tester.pump(const Duration(milliseconds: 300));
      expect(asset('assets/exercises/barbell_back_squat_1.jpg'), findsOneWidget);
      expect(asset('assets/exercises/barbell_back_squat_0.jpg'), findsNothing);
    });

    testWidgets('animasi sistem dimatikan → foto diam', (tester) async {
      await pump(
        tester,
        const ExerciseDetailScreen(exerciseId: 'goblet_squat'),
        disableAnimations: true,
      );
      await tester.pump(ExerciseImages.frameInterval * 2);
      expect(asset('assets/exercises/goblet_squat_0.jpg'), findsOneWidget);
      expect(find.byKey(const ValueKey('exercise-motion-toggle')), findsOneWidget);
    });

    testWidgets('tanpa foto: hanya peta otot', (tester) async {
      final noPhoto = catalog.values.firstWhere((e) => e.images.isEmpty);
      await pump(tester, ExerciseDetailScreen(exerciseId: noPhoto.id));
      expect(find.byType(ExerciseImages), findsNothing);
      expect(find.byType(MuscleMap), findsOneWidget);
      final semantics = tester.ensureSemantics();
      await tester.pump();
      expect(find.bySemanticsLabel(RegExp('^Peta otot. Otot utama: ')), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('thumbnail → tampilan cepat dengan gerakan & langkah', (tester) async {
      await pump(
        tester,
        Scaffold(
          body: Center(child: ExerciseThumbnail(exercise: catalog['push_up']!)),
        ),
        disableAnimations: true,
      );
      await tester.tap(find.byKey(const ValueKey('exercise-thumb-push_up')));
      await tester.pumpAndSettle();
      expect(find.text('Push-Up'), findsOneWidget);
      expect(find.byType(ExerciseImages), findsOneWidget);
      expect(find.byType(MuscleMap), findsOneWidget);
      expect(find.text('Lihat detail lengkap'), findsOneWidget);
    });
  });
}
