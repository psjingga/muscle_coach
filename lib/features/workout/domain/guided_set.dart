import 'entities/workout.dart';

/// Tempo repetisi dalam detik: eksentrik (menurunkan/melepas beban),
/// jeda di posisi bawah/puncak, konsentrik (mengangkat/mendorong/menarik).
/// Bawaan 2-1-1 ≈ 4 detik per repetisi.
class Tempo {
  const Tempo({this.eccentric = 2, this.pause = 1, this.concentric = 1})
    : assert(eccentric >= 1 && pause >= 0 && concentric >= 1);

  final int eccentric;
  final int pause;
  final int concentric;

  static const standard = Tempo();

  int get total => eccentric + pause + concentric;

  /// "2-1-1".
  String get label => '$eccentric-$pause-$concentric';
}

/// Jenis fase satu repetisi.
enum PhaseKind { eccentric, pause, concentric, hold }

/// Satu fase dengan durasi & label (mis. TURUN 2 dtk).
class RepPhase {
  const RepPhase(this.kind, this.seconds, this.label);

  final PhaseKind kind;
  final int seconds;
  final String label;
}

/// Cara gerakan dimulai & kata kerjanya, menurut pola gerakan katalog.
///
/// Foto katalog `_0` = posisi awal, `_1` = posisi akhir gerakan pertama.
/// Gerakan "eksentrik dulu" (squat, bench press) dimulai dari atas lalu
/// turun; gerakan "konsentrik dulu" (deadlift, row, curl, pull-up) dimulai
/// dari posisi terulur lalu diangkat/ditarik. Urutan fase mengikuti ini agar
/// foto, label, dan timer selalu sinkron.
class MovementCue {
  const MovementCue({
    required this.concentricFirst,
    required this.concentricLabel,
    required this.eccentricLabel,
  });

  final bool concentricFirst;
  final String concentricLabel;
  final String eccentricLabel;

  static const _byPattern = <String, MovementCue>{
    'squat': MovementCue(concentricFirst: false, concentricLabel: 'NAIK', eccentricLabel: 'TURUN'),
    'lunge': MovementCue(concentricFirst: false, concentricLabel: 'NAIK', eccentricLabel: 'TURUN'),
    'horizontal_push': MovementCue(
      concentricFirst: false,
      concentricLabel: 'DORONG',
      eccentricLabel: 'TURUNKAN',
    ),
    'chest_isolation': MovementCue(
      concentricFirst: false,
      concentricLabel: 'RAPATKAN',
      eccentricLabel: 'BUKA',
    ),
    'elbow_extension': MovementCue(
      concentricFirst: false,
      concentricLabel: 'LURUSKAN',
      eccentricLabel: 'TEKUK',
    ),
    'hinge': MovementCue(
      concentricFirst: true,
      concentricLabel: 'ANGKAT',
      eccentricLabel: 'TURUNKAN',
    ),
    'hip_extension': MovementCue(
      concentricFirst: true,
      concentricLabel: 'ANGKAT',
      eccentricLabel: 'TURUNKAN',
    ),
    'vertical_push': MovementCue(
      concentricFirst: true,
      concentricLabel: 'DORONG',
      eccentricLabel: 'TURUNKAN',
    ),
    'horizontal_pull': MovementCue(
      concentricFirst: true,
      concentricLabel: 'TARIK',
      eccentricLabel: 'TURUNKAN',
    ),
    'vertical_pull': MovementCue(
      concentricFirst: true,
      concentricLabel: 'TARIK',
      eccentricLabel: 'TURUN',
    ),
    'shoulder_isolation': MovementCue(
      concentricFirst: true,
      concentricLabel: 'ANGKAT',
      eccentricLabel: 'TURUNKAN',
    ),
    'elbow_flexion': MovementCue(
      concentricFirst: true,
      concentricLabel: 'ANGKAT',
      eccentricLabel: 'TURUNKAN',
    ),
    'calf': MovementCue(concentricFirst: true, concentricLabel: 'JINJIT', eccentricLabel: 'TURUN'),
  };

  static const fallback = MovementCue(
    concentricFirst: false,
    concentricLabel: 'NAIK',
    eccentricLabel: 'TURUN',
  );

  static MovementCue forPattern(String? pattern) => _byPattern[pattern] ?? fallback;

  /// Urutan fase satu repetisi. Fase dengan durasi 0 dilewati.
  List<RepPhase> phases(Tempo t) {
    final ecc = RepPhase(PhaseKind.eccentric, t.eccentric, eccentricLabel);
    final con = RepPhase(PhaseKind.concentric, t.concentric, concentricLabel);
    final pause = RepPhase(PhaseKind.pause, t.pause, 'TAHAN');
    return [
      if (concentricFirst) con else ecc,
      if (t.pause > 0) pause,
      if (concentricFirst) ecc else con,
    ];
  }
}

enum GuidedStage {
  /// Belum mulai; menunggu tombol Mulai.
  ready,

  /// Aba-aba 3-2-1.
  countdown,

  /// Repetisi sedang berjalan (atau tahan untuk latihan berbasis waktu).
  /// Repetisi berikutnya langsung menyambung sampai target tercapai.
  rep,

  /// Set selesai (semua target tercapai atau diakhiri lebih awal).
  finished,
}

/// Isyarat untuk suara/getar saat keadaan berubah.
enum GuidedCue {
  /// Hitungan aba-aba (3, 2, 1).
  countdownTick,

  /// Aba-aba selesai; repetisi pertama dimulai.
  go,

  /// Pindah fase dalam satu repetisi (mis. TURUN → TAHAN).
  phaseChange,

  /// Satu repetisi selesai.
  repComplete,

  /// Set selesai.
  setComplete,
}

/// Keadaan set terpandu. Imutabel & berbasis waktu akhir (seperti
/// [RestTimer]) sehingga tetap akurat walau layar sempat tidak diperbarui.
///
/// Alur: [GuidedStage.ready] → `start` → aba-aba → rep 1 (fase demi fase)
/// → rep 2 … otomatis tanpa ketukan → rep ke-[targetReps] selesai →
/// [GuidedStage.finished]. Latihan berbasis waktu (plank) hanya satu fase
/// tahan sepanjang target detik.
class GuidedSet {
  const GuidedSet._({
    required this.stage,
    required this.phases,
    required this.targetReps,
    required this.timed,
    required this.countdownSeconds,
    required this.completedReps,
    required this.phaseIndex,
    required this.segmentEndsAt,
    required this.segmentSeconds,
    required this.pausedRemaining,
    required this.startedAt,
    required this.finishedAt,
    required this.heldSeconds,
  });

  /// Set baru untuk [planned]. Target = batas bawah rentang yang
  /// direkomendasikan (bisa diakhiri lebih awal kapan saja; repetisi
  /// tambahan bisa diisi di layar simpan).
  factory GuidedSet.forPlanned(
    PlannedExercise planned, {
    String? pattern,
    Tempo tempo = Tempo.standard,
    int countdownSeconds = 3,
  }) {
    final timed = planned.isTimed;
    return GuidedSet._(
      stage: GuidedStage.ready,
      phases: timed
          ? [RepPhase(PhaseKind.hold, planned.repMin, 'TAHAN')]
          : MovementCue.forPattern(pattern).phases(tempo),
      targetReps: timed ? 1 : planned.repMin,
      timed: timed,
      countdownSeconds: countdownSeconds,
      completedReps: 0,
      phaseIndex: 0,
      segmentEndsAt: null,
      segmentSeconds: 0,
      pausedRemaining: null,
      startedAt: null,
      finishedAt: null,
      heldSeconds: 0,
    );
  }

  final GuidedStage stage;

  /// Fase satu repetisi (untuk latihan berbasis waktu: satu fase tahan).
  final List<RepPhase> phases;
  final int targetReps;
  final bool timed;
  final int countdownSeconds;

  /// Repetisi yang sudah tuntas.
  final int completedReps;

  /// Fase yang sedang berjalan dalam repetisi (stage [GuidedStage.rep]).
  final int phaseIndex;

  /// Akhir segmen berjalan (aba-aba atau fase); `null` saat dijeda/diam.
  final DateTime? segmentEndsAt;

  /// Panjang segmen berjalan (detik) untuk cincin progres.
  final int segmentSeconds;

  /// Sisa waktu segmen saat dijeda.
  final Duration? pausedRemaining;

  final DateTime? startedAt;
  final DateTime? finishedAt;

  /// Latihan berbasis waktu: detik yang sudah ditahan (hasil akhir).
  final int heldSeconds;

  bool get isPaused => pausedRemaining != null;

  /// Nomor repetisi yang sedang/akan dikerjakan (1-based).
  int get currentRep => completedReps + 1 > targetReps ? targetReps : completedReps + 1;

  RepPhase? get phase => stage == GuidedStage.rep ? phases[phaseIndex] : null;

  /// Hasil yang dicatat: jumlah repetisi, atau detik untuk latihan waktu.
  int get result => timed ? heldSeconds : completedReps;

  /// Durasi set (dari Mulai sampai selesai).
  Duration get elapsed => (finishedAt != null && startedAt != null)
      ? finishedAt!.difference(startedAt!)
      : Duration.zero;

  GuidedSet _copy({
    GuidedStage? stage,
    int? completedReps,
    int? phaseIndex,
    DateTime? segmentEndsAt,
    bool clearSegment = false,
    int? segmentSeconds,
    Duration? pausedRemaining,
    bool clearPause = false,
    DateTime? startedAt,
    DateTime? finishedAt,
    int? heldSeconds,
  }) => GuidedSet._(
    stage: stage ?? this.stage,
    phases: phases,
    targetReps: targetReps,
    timed: timed,
    countdownSeconds: countdownSeconds,
    completedReps: completedReps ?? this.completedReps,
    phaseIndex: phaseIndex ?? this.phaseIndex,
    segmentEndsAt: clearSegment ? null : (segmentEndsAt ?? this.segmentEndsAt),
    segmentSeconds: segmentSeconds ?? this.segmentSeconds,
    pausedRemaining: clearPause ? null : (pausedRemaining ?? this.pausedRemaining),
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt ?? this.finishedAt,
    heldSeconds: heldSeconds ?? this.heldSeconds,
  );

  GuidedSet _segment(DateTime from, int seconds, {GuidedStage? stage, int? phaseIndex}) => _copy(
    stage: stage,
    phaseIndex: phaseIndex,
    segmentEndsAt: from.add(Duration(seconds: seconds)),
    segmentSeconds: seconds,
    clearPause: true,
  );

  /// Tombol Mulai: aba-aba (atau langsung rep bila aba-aba 0).
  GuidedSet start(DateTime now) {
    if (stage != GuidedStage.ready) return this;
    final s = _copy(startedAt: now);
    return countdownSeconds > 0
        ? s._segment(now, countdownSeconds, stage: GuidedStage.countdown)
        : s._segment(now, phases.first.seconds, stage: GuidedStage.rep, phaseIndex: 0);
  }

  /// Majukan keadaan sampai [now]. Segmen yang lewat diproses berurutan
  /// (aman bila tick terlambat, mis. aplikasi sempat di latar belakang).
  GuidedSet tick(DateTime now) {
    var s = this;
    while (s.segmentEndsAt != null && !s.isPaused && !now.isBefore(s.segmentEndsAt!)) {
      final end = s.segmentEndsAt!;
      switch (s.stage) {
        case GuidedStage.countdown:
          s = s._segment(end, s.phases.first.seconds, stage: GuidedStage.rep, phaseIndex: 0);
        case GuidedStage.rep when s.phaseIndex + 1 < s.phases.length:
          final i = s.phaseIndex + 1;
          s = s._segment(end, s.phases[i].seconds, phaseIndex: i);
        case GuidedStage.rep:
          final done = s.completedReps + 1;
          s = done >= s.targetReps
              ? s._copy(
                  stage: GuidedStage.finished,
                  completedReps: done,
                  clearSegment: true,
                  finishedAt: end,
                  heldSeconds: s.timed ? s.phases.first.seconds : null,
                )
              : s._copy(completedReps: done)._segment(end, s.phases.first.seconds, phaseIndex: 0);
        case GuidedStage.ready || GuidedStage.finished:
          return s;
      }
    }
    return s;
  }

  GuidedSet pause(DateTime now) {
    final end = segmentEndsAt;
    if (end == null || isPaused) return this;
    final left = end.difference(now);
    return _copy(pausedRemaining: left.isNegative ? Duration.zero : left);
  }

  GuidedSet resume(DateTime now) {
    final left = pausedRemaining;
    if (left == null) return this;
    return _copy(segmentEndsAt: now.add(left), clearPause: true);
  }

  /// Akhiri set sekarang. Repetisi yang belum tuntas tidak dihitung;
  /// latihan waktu mencatat detik yang sudah ditahan.
  GuidedSet finishEarly(DateTime now) {
    if (stage == GuidedStage.finished) return this;
    var held = heldSeconds;
    if (timed && stage == GuidedStage.rep) {
      final total = phases.first.seconds;
      held = total - remainingSeconds(now);
      if (held < 0) held = 0;
    }
    return _copy(
      stage: GuidedStage.finished,
      clearSegment: true,
      clearPause: true,
      finishedAt: now,
      startedAt: startedAt ?? now,
      heldSeconds: held,
    );
  }

  /// Sisa detik segmen berjalan (dibulatkan ke atas, seperti jam hitung mundur).
  int remainingSeconds(DateTime now) {
    final left = pausedRemaining ?? segmentEndsAt?.difference(now);
    if (left == null) return 0;
    final ms = left.inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  /// 0..1 bagian segmen yang sudah berjalan.
  double segmentProgress(DateTime now) {
    if (segmentSeconds == 0) return stage == GuidedStage.finished ? 1 : 0;
    final left = pausedRemaining ?? segmentEndsAt?.difference(now) ?? Duration.zero;
    final p = 1 - left.inMilliseconds / (segmentSeconds * 1000);
    return p.clamp(0, 1);
  }

  /// Posisi visual 0 (foto awal) .. 1 (foto akhir) dalam repetisi: fase
  /// pertama bergerak 0→1, jeda di 1, fase terakhir kembali 1→0.
  double pose(DateTime now) {
    if (stage != GuidedStage.rep || timed) return 0;
    final p = segmentProgress(now);
    final last = phases.length - 1;
    if (phaseIndex == 0) return p;
    if (phaseIndex == last) return 1 - p;
    return 1;
  }

  /// Isyarat suara/getar saat berpindah dari [before] (dilihat pada
  /// [beforeAt]) ke [after] (pada [now]).
  static GuidedCue? cueBetween(GuidedSet before, DateTime beforeAt, GuidedSet after, DateTime now) {
    if (after.stage == GuidedStage.finished && before.stage != GuidedStage.finished) {
      return GuidedCue.setComplete;
    }
    if (after.completedReps > before.completedReps) return GuidedCue.repComplete;
    if (before.stage == GuidedStage.countdown && after.stage == GuidedStage.rep) {
      return GuidedCue.go;
    }
    if (after.stage == GuidedStage.countdown) {
      final changed =
          before.stage != GuidedStage.countdown ||
          before.remainingSeconds(beforeAt) != after.remainingSeconds(now);
      return changed ? GuidedCue.countdownTick : null;
    }
    if (after.stage == GuidedStage.rep &&
        before.stage == GuidedStage.rep &&
        before.phaseIndex != after.phaseIndex) {
      return GuidedCue.phaseChange;
    }
    return null;
  }
}
