/// Satu penimbangan (satu nilai per tanggal).
class WeightEntry {
  const WeightEntry({required this.date, required this.kg});

  /// `YYYY-MM-DD` lokal.
  final String date;
  final double kg;
}

/// Check-in harian. Semua kolom opsional — pengguna boleh mengisi sebagian.
class DailyCheckIn {
  const DailyCheckIn({
    required this.date,
    this.sleepHours,
    this.energy,
    this.mood,
    this.discomfort,
    this.notes,
  });

  final String date;
  final double? sleepHours;

  /// 1 (sangat rendah) … 5 (sangat baik).
  final int? energy;
  final int? mood;

  /// Nyeri/tidak nyaman saat latihan (teks bebas).
  final String? discomfort;

  /// Catatan kendala.
  final String? notes;

  bool get hasDiscomfort => (discomfort ?? '').trim().isNotEmpty;
}

/// Total asupan tercatat pada satu tanggal.
class DayIntake {
  const DayIntake({required this.date, required this.kcal, required this.protein});

  final String date;
  final double kcal;
  final double protein;
}

/// Satu set selesai (untuk grafik & volume).
class SetEntry {
  const SetEntry({required this.exerciseId, required this.reps, this.weightKg, this.timed = false});

  final String exerciseId;
  final double? weightKg;

  /// Repetisi, atau detik bila [timed].
  final int reps;
  final bool timed;

  /// Volume beban (kg × repetisi); 0 untuk set berbasis waktu / tanpa beban.
  double get volumeKg => timed || weightKg == null ? 0 : weightKg! * reps;
}

/// Sesi latihan selesai beserta set-nya.
class TrainingDay {
  const TrainingDay({
    required this.sessionId,
    required this.date,
    required this.sets,
    this.discomfort = false,
  });

  final String sessionId;
  final String date;
  final List<SetEntry> sets;

  /// Pengguna mencatat rasa nyeri/tidak nyaman di akhir sesi.
  final bool discomfort;

  double get volumeKg => sets.fold(0, (s, e) => s + e.volumeKg);
}
