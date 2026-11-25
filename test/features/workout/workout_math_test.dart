import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/features/workout/domain/workout_math.dart';

import '../../fixtures/workout_fixtures.dart';

void main() {
  group('WorkoutMath', () {
    test('volume: beban × repetisi; dumbbell per tangan ×2; set waktu & dilewati diabaikan', () {
      final sets = [
        doneSet(0, 1, kg: 16, reps: 10), // 160
        doneSet(1, 1, kg: 12, reps: 10), // 12 × 10 × 2 = 240
        doneSet(2, 1, kg: 10, reps: 30), // plank (detik) → 0
        doneSet(0, 2, reps: 10), // tanpa beban → 0
        const SetLog(
          exerciseId: 'x',
          exerciseIndex: 0,
          setNumber: 3,
          weightKg: 50,
          reps: 0,
          status: SetStatus.skipped,
        ),
      ];
      expect(WorkoutMath.volumeKg(sets, session.planned), 400);
      expect(WorkoutMath.doneSets(sets), 4);
      expect(WorkoutMath.plannedSets(session.planned), 8);
    });

    test('urutan set & nomor set berikutnya', () {
      final sets = [doneSet(0, 2), doneSet(1, 1), doneSet(0, 1)];
      expect(WorkoutMath.setsFor(sets, 0).map((s) => s.setNumber), [1, 2]);
      expect(WorkoutMath.nextSetNumber(sets, 0), 3);
      expect(WorkoutMath.nextSetNumber(sets, 2), 1);
    });

    test('progresi ganda: naik beban hanya bila semua set di batas atas tanpa gagal', () {
      final top = [for (var i = 1; i <= 3; i++) doneSet(0, i, kg: 16, reps: 12, rir: 2)];
      expect(WorkoutMath.shouldIncreaseLoad(gobletSquat, top), isTrue);
      expect(WorkoutMath.shouldIncreaseLoad(gobletSquat, top.take(2).toList()), isFalse);
      final short = [...top.take(2), doneSet(0, 3, kg: 16, reps: 11, rir: 2)];
      expect(WorkoutMath.shouldIncreaseLoad(gobletSquat, short), isFalse);
      final failure = [...top.take(2), doneSet(0, 3, kg: 16, reps: 12, rir: 0)];
      expect(WorkoutMath.shouldIncreaseLoad(gobletSquat, failure), isFalse);
    });

    test('validasi input set', () {
      expect(WorkoutMath.validateSet(weightKg: 20, reps: 10), isNull);
      expect(WorkoutMath.validateSet(weightKg: null, reps: 10), isNull);
      expect(WorkoutMath.validateSet(weightKg: 20, reps: null), SetInputError.repsRequired);
      expect(WorkoutMath.validateSet(weightKg: 20, reps: 0), SetInputError.repsOutOfRange);
      expect(WorkoutMath.validateSet(weightKg: -1, reps: 5), SetInputError.weightOutOfRange);
      expect(WorkoutMath.validateSet(weightKg: 1001, reps: 5), SetInputError.weightOutOfRange);
    });

    test('hari latihan berikutnya (termasuk hari ini, melingkar ke minggu depan)', () {
      expect(WorkoutMath.nextDay([dayA, dayB], 4)?.id, 'd1');
      expect(WorkoutMath.nextDay([dayA, dayB], 5)?.id, 'd2');
      expect(WorkoutMath.nextDay([dayA, dayB], 7)?.id, 'd1');
      expect(WorkoutMath.nextDay([], 1), isNull);
    });
  });

  group('status latihan hari ini (Beranda)', () {
    WorkoutSession session(String dayId, SessionStatus status, {DateTime? end}) => WorkoutSession(
      id: 's-$dayId-${status.name}',
      planId: 'p1',
      dayId: dayId,
      date: '2026-11-19',
      weekday: 4,
      focus: 'upper',
      status: status,
      planned: const [],
      startedAt: DateTime(2026, 11, 19, 7),
      completedAt: end,
    );

    TodayWorkout? at(int weekday, [List<WorkoutSession> sessions = const []]) =>
        WorkoutMath.todayWorkout(days: [dayA, dayB], weekday: weekday, sessions: sessions);

    test('hari latihan belum dimulai / sedang berjalan', () {
      final t = at(4) as TodayTraining;
      expect(t.day.id, 'd1');
      expect(t.inProgress, isNull);
      final running = at(4, [session('d1', SessionStatus.inProgress)]) as TodayTraining;
      expect(running.inProgress, isNotNull);
    });

    test('hari istirahat → latihan berikutnya', () {
      expect((at(5) as TodayRest).next.id, 'd2');
      expect((at(7) as TodayRest).next.id, 'd1');
    });

    test('sesi lebih awal di hari istirahat tetap bisa dilanjutkan', () {
      final t = at(5, [session('d2', SessionStatus.inProgress)]) as TodayTraining;
      expect(t.day.id, 'd2');
    });

    test('selesai hari ini → ringkasan + berikutnya setelah hari ini', () {
      final done = at(4, [session('d1', SessionStatus.completed)]) as TodayDone;
      expect(done.session.dayId, 'd1');
      expect(done.next.id, 'd2');
      // Hanya satu hari latihan: berikutnya = minggu depan, bukan hari ini lagi.
      final single = WorkoutMath.todayWorkout(
        days: [dayA],
        weekday: 4,
        sessions: [session('d1', SessionStatus.completed)],
      ) as TodayDone;
      expect(single.next.id, 'd1');
    });

    test('tanpa hari latihan → null', () {
      expect(WorkoutMath.todayWorkout(days: const [], weekday: 4, sessions: const []), isNull);
    });

    test('durasi sesi', () {
      expect(
        WorkoutMath.durationMinutes(
          session('d1', SessionStatus.completed, end: DateTime(2026, 11, 19, 7, 52)),
        ),
        52,
      );
      expect(WorkoutMath.durationMinutes(session('d1', SessionStatus.inProgress)), isNull);
      expect(
        WorkoutMath.durationMinutes(
          session('d1', SessionStatus.completed, end: DateTime(2026, 11, 19, 6)),
        ),
        isNull,
      );
    });
  });

  group('RestTimer', () {
    final t0 = DateTime(2026, 11, 19, 10);

    test('sisa waktu berbasis waktu akhir', () {
      final timer = RestTimer.start(t0, 90);
      expect(timer.remainingSeconds(t0), 90);
      expect(timer.remainingSeconds(t0.add(const Duration(milliseconds: 30500))), 60);
      expect(timer.isDone(t0.add(const Duration(seconds: 90))), isTrue);
      expect(timer.remainingSeconds(t0.add(const Duration(minutes: 5))), 0);
      expect(timer.progress(t0.add(const Duration(seconds: 45))), closeTo(0.5, 0.01));
    });

    test('tambah/kurangi waktu', () {
      final timer = RestTimer.start(t0, 60).adjust(t0.add(const Duration(seconds: 50)), 15);
      expect(timer.remainingSeconds(t0.add(const Duration(seconds: 50))), 25);
      final cut = RestTimer.start(t0, 60).adjust(t0, -100);
      expect(cut.remainingSeconds(t0), 0);
    });
  });
}
