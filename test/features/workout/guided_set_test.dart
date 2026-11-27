import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/features/workout/domain/guided_set.dart';
import 'package:musclecoach/features/workout/domain/guided_settings.dart';

const _squat = PlannedExercise(
  exerciseId: 'barbell_back_squat',
  name: 'Barbell Back Squat',
  sets: 3,
  repMin: 2,
  repMax: 3,
  restSec: 90,
  rirMin: 1,
  rirMax: 2,
);

const _plank = PlannedExercise(
  exerciseId: 'plank',
  name: 'Plank',
  sets: 3,
  repMin: 20,
  repMax: 30,
  repUnit: 'seconds',
  restSec: 60,
  rirMin: 1,
  rirMax: 2,
);

void main() {
  final t0 = DateTime(2026, 11, 27, 10);
  DateTime at(num seconds) => t0.add(Duration(milliseconds: (seconds * 1000).round()));

  group('MovementCue', () {
    test('squat: eksentrik dulu (TURUN–TAHAN–NAIK, 2-1-1)', () {
      final p = MovementCue.forPattern('squat').phases(Tempo.standard);
      expect(p.map((x) => (x.label, x.seconds)), [('TURUN', 2), ('TAHAN', 1), ('NAIK', 1)]);
    });

    test('row: konsentrik dulu (TARIK–TAHAN–TURUNKAN)', () {
      final p = MovementCue.forPattern('horizontal_pull').phases(Tempo.standard);
      expect(p.map((x) => x.label), ['TARIK', 'TAHAN', 'TURUNKAN']);
      expect(p.first.kind, PhaseKind.concentric);
      expect(p.last.seconds, 2);
    });

    test('jeda 0 detik dilewati; pola tak dikenal pakai bawaan', () {
      final p = MovementCue.forPattern('???').phases(const Tempo(eccentric: 3, pause: 0));
      expect(p.map((x) => (x.label, x.seconds)), [('TURUN', 3), ('NAIK', 1)]);
    });
  });

  group('GuidedSet', () {
    test('alur lengkap: aba-aba → rep menyambung otomatis → selesai di target minimal', () {
      var g = GuidedSet.forPlanned(_squat, pattern: 'squat');
      expect(g.stage, GuidedStage.ready);
      expect(g.targetReps, 2); // batas bawah rentang 2–3

      g = g.start(t0);
      expect(g.stage, GuidedStage.countdown);
      expect(g.remainingSeconds(at(0)), 3);
      expect(g.remainingSeconds(at(1.2)), 2);

      g = g.tick(at(3));
      expect(g.stage, GuidedStage.rep);
      expect(g.phase!.label, 'TURUN');
      expect(g.remainingSeconds(at(3)), 2);

      g = g.tick(at(5.5)); // 2 dtk turun lewat → TAHAN
      expect(g.phase!.label, 'TAHAN');
      g = g.tick(at(7.1)); // naik 1 dtk selesai → rep 2 langsung mulai
      expect(g.stage, GuidedStage.rep);
      expect(g.completedReps, 1);
      expect(g.currentRep, 2);
      expect(g.phase!.label, 'TURUN');
      expect(g.remainingSeconds(at(7.1)), 2); // rep 2 mulai tepat dtk 7

      g = g.tick(at(11));
      expect(g.stage, GuidedStage.finished);
      expect(g.result, 2);
      expect(g.elapsed, const Duration(seconds: 11));
    });

    test('tick terlambat memproses beberapa segmen sekaligus', () {
      final g = GuidedSet.forPlanned(_squat, pattern: 'squat').start(t0).tick(at(30));
      expect(g.stage, GuidedStage.finished);
      expect(g.completedReps, 2);
      expect(g.finishedAt, at(11));
    });

    test('jeda menahan waktu, lanjut meneruskan sisa', () {
      var g = GuidedSet.forPlanned(_squat, pattern: 'squat').start(t0).tick(at(3.5));
      expect(g.phase!.label, 'TURUN');
      g = g.pause(at(3.5));
      expect(g.isPaused, isTrue);
      g = g.tick(at(100));
      expect(g.phase!.label, 'TURUN');
      expect(g.remainingSeconds(at(100)), 2); // 1,5 dtk → dibulatkan 2
      g = g.resume(at(100)).tick(at(101.6));
      expect(g.phase!.label, 'TAHAN');
    });

    test('akhiri lebih awal: rep yang belum tuntas tidak dihitung', () {
      var g = GuidedSet.forPlanned(_squat, pattern: 'squat').start(t0).tick(at(8));
      expect(g.completedReps, 1);
      g = g.tick(at(9)).finishEarly(at(9)); // rep 2 baru separuh
      expect(g.stage, GuidedStage.finished);
      expect(g.result, 1);
    });

    test('latihan waktu: satu fase TAHAN; diakhiri awal mencatat detik', () {
      var g = GuidedSet.forPlanned(_plank, pattern: 'core');
      expect(g.timed, isTrue);
      expect(g.phases.single.seconds, 20); // batas bawah 20–30 dtk
      g = g.start(t0).tick(at(3));
      expect(g.phase!.label, 'TAHAN');
      expect(g.finishEarly(at(15)).result, 12);
      expect(g.tick(at(40)).stage, GuidedStage.finished);
      expect(g.tick(at(40)).result, 20);
    });

    test('posisi visual: 0→1 di fase pertama, 1 saat tahan, 1→0 di akhir', () {
      final g = GuidedSet.forPlanned(_squat, pattern: 'squat').start(t0).tick(at(3));
      expect(g.pose(at(4)), closeTo(.5, .01));
      final hold = g.tick(at(5.5));
      expect(hold.pose(at(5.5)), 1);
      final up = hold.tick(at(6.2));
      expect(up.pose(at(6.6)), closeTo(.4, .01)); // NAIK mulai dtk 6
    });

    test('isyarat: hitungan, mulai, ganti fase, rep selesai, set selesai', () {
      final ready = GuidedSet.forPlanned(_squat, pattern: 'squat');
      final c3 = ready.start(t0);
      expect(GuidedSet.cueBetween(ready, t0, c3, t0), GuidedCue.countdownTick);
      expect(GuidedSet.cueBetween(c3, at(.2), c3, at(.5)), isNull);
      expect(GuidedSet.cueBetween(c3, at(.5), c3, at(1.1)), GuidedCue.countdownTick);
      final rep = c3.tick(at(3));
      expect(GuidedSet.cueBetween(c3, at(2.9), rep, at(3)), GuidedCue.go);
      final hold = rep.tick(at(5));
      expect(GuidedSet.cueBetween(rep, at(4.9), hold, at(5)), GuidedCue.phaseChange);
      final done = hold.tick(at(7));
      expect(GuidedSet.cueBetween(hold, at(6.9), done, at(7)), GuidedCue.repComplete);
      expect(done.stage, GuidedStage.rep); // rep 2 sudah berjalan
      final fin = done.tick(at(11));
      expect(GuidedSet.cueBetween(done, at(10.9), fin, at(11)), GuidedCue.setComplete);
    });
  });

  group('GuidedSettings', () {
    test('bawaan 2-1-1, aba-aba 3, bunyi aktif; JSON bolak-balik', () {
      const d = GuidedSettings();
      expect(d.tempo.label, '2-1-1');
      expect(d.tempo.total, 4);
      final s = d.copyWith(
        tempo: const Tempo(eccentric: 3, pause: 0),
        countdownSeconds: 5,
        sound: false,
      );
      expect(GuidedSettings.fromJson(s.toJson()), s);
    });

    test('nilai rusak/di luar rentang kembali ke bawaan', () {
      final s = GuidedSettings.fromJson({
        'eccentric': 99,
        'pause': -1,
        'countdown': 4,
        'sound': 'ya',
      });
      expect(s, const GuidedSettings());
    });

    test('tanpa aba-aba: Mulai langsung ke repetisi', () {
      final g = GuidedSet.forPlanned(_squat, pattern: 'squat', countdownSeconds: 0).start(t0);
      expect(g.stage, GuidedStage.rep);
      expect(g.phase!.label, 'TURUN');
    });
  });
}
