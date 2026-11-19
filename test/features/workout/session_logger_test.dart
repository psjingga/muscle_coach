import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/features/assessment/application/assessment_wizard_controller.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/features/workout/domain/workout_math.dart';
import 'package:musclecoach/features/workout/presentation/providers/workout_providers.dart';

import '../../fixtures/workout_fixtures.dart';
import '../../helpers/fakes.dart';

void main() {
  late MockWorkoutRepository repo;
  var now = DateTime(2026, 11, 19, 10);

  setUpAll(() {
    registerFallbackValue(
      const SetLog(
        exerciseId: 'x',
        exerciseIndex: 0,
        setNumber: 1,
        reps: 1,
        status: SetStatus.done,
      ),
    );
    registerFallbackValue(dayA);
  });

  setUp(() {
    repo = MockWorkoutRepository();
    now = DateTime(2026, 11, 19, 10);
    when(() => repo.logSet(any(), any())).thenAnswer((_) async {});
  });

  ProviderContainer container() => ProviderContainer.test(
    overrides: [
      workoutRepositoryProvider.overrideWithValue(repo),
      clockProvider.overrideWithValue(() => now),
    ],
  );

  test('logSet valid: menyimpan set & memulai timer istirahat sesuai target', () async {
    final c = container();
    c.listen(sessionLoggerProvider('s1'), (_, _) {});
    final logger = c.read(sessionLoggerProvider('s1').notifier);
    final error = await logger.logSet(
      exerciseIndex: 0,
      planned: gobletSquat,
      setNumber: 1,
      weightKg: 16,
      reps: 10,
      rir: 2,
    );
    expect(error, isNull);
    final saved = verify(() => repo.logSet('s1', captureAny())).captured.single as SetLog;
    expect(
      saved,
      const SetLog(
        exerciseId: 'goblet_squat',
        exerciseIndex: 0,
        setNumber: 1,
        weightKg: 16,
        reps: 10,
        rir: 2,
        status: SetStatus.done,
      ),
    );
    final timer = c.read(sessionLoggerProvider('s1'))!;
    expect(timer.remainingSeconds(now), 120);

    logger.adjustRest(15);
    expect(c.read(sessionLoggerProvider('s1'))!.remainingSeconds(now), 135);
    logger.stopRest();
    expect(c.read(sessionLoggerProvider('s1')), isNull);
  });

  test('logSet tidak valid: tidak menyimpan & tidak memulai timer', () async {
    final c = container();
    c.listen(sessionLoggerProvider('s1'), (_, _) {});
    final error = await c
        .read(sessionLoggerProvider('s1').notifier)
        .logSet(exerciseIndex: 0, planned: gobletSquat, setNumber: 1, weightKg: 16, reps: null);
    expect(error, SetInputError.repsRequired);
    verifyNever(() => repo.logSet(any(), any()));
    expect(c.read(sessionLoggerProvider('s1')), isNull);
  });

  test('skipSet mencatat set dilewati tanpa timer', () async {
    final c = container();
    c.listen(sessionLoggerProvider('s1'), (_, _) {});
    await c
        .read(sessionLoggerProvider('s1').notifier)
        .skipSet(exerciseIndex: 1, planned: dbPress, setNumber: 2);
    final saved = verify(() => repo.logSet('s1', captureAny())).captured.single as SetLog;
    expect(saved.status, SetStatus.skipped);
    expect(saved.setNumber, 2);
    expect(c.read(sessionLoggerProvider('s1')), isNull);
  });

  test('startOrResume melanjutkan sesi hari ini bila ada, atau membuat baru', () async {
    when(() => repo.findInProgress(planId: 'p1', dayId: 'd1', date: '2026-11-19'))
        .thenAnswer((_) async => session);
    final c = container();
    c.listen(workoutActionsProvider, (_, _) {});
    expect(await c.read(workoutActionsProvider.notifier).startOrResume('p1', dayA), 's1');
    verifyNever(
      () => repo.startSession(
        planId: any(named: 'planId'),
        day: any(named: 'day'),
        date: any(named: 'date'),
      ),
    );

    when(() => repo.findInProgress(planId: 'p1', dayId: 'd1', date: '2026-11-19'))
        .thenAnswer((_) async => null);
    when(() => repo.startSession(planId: 'p1', day: dayA, date: '2026-11-19'))
        .thenAnswer((_) async => 's2');
    expect(await c.read(workoutActionsProvider.notifier).startOrResume('p1', dayA), 's2');
  });

  test('completeSession membersihkan teks kosong', () async {
    when(
      () => repo.completeSession(
        any(),
        notes: any(named: 'notes'),
        energy: any(named: 'energy'),
        discomfort: any(named: 'discomfort'),
      ),
    ).thenAnswer((_) async {});
    final c = container();
    c.listen(workoutActionsProvider, (_, _) {});
    expect(
      await c
          .read(workoutActionsProvider.notifier)
          .completeSession('s1', notes: '  ', energy: 4, discomfort: ' Lutut '),
      isTrue,
    );
    verify(() => repo.completeSession('s1', notes: null, energy: 4, discomfort: 'Lutut')).called(1);
  });
}
