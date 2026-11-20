import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../goals/domain/entities/goal.dart';
import '../../profile/data/local_profile_repository.dart';
import '../../workout/domain/entities/workout.dart';
import '../domain/progress_math.dart';
import '../domain/progress_models.dart';

/// Ringkasan mingguan yang tersimpan.
class StoredWeeklyReview {
  const StoredWeeklyReview({
    required this.weekStart,
    required this.stats,
    required this.goalStatus,
    this.proposal,
    this.decision,
    this.aiSummary,
    this.model,
    this.promptVersion,
  });

  final String weekStart;
  final WeekSummary stats;
  final GoalProgressStatus goalStatus;
  final NutritionAdjustment? proposal;

  /// `accepted` / `declined` / null (belum diputuskan).
  final String? decision;
  final WeeklyAiSummary? aiSummary;
  final String? model;
  final String? promptVersion;
}

/// Ringkasan AI yang sudah divalidasi.
class WeeklyAiSummary {
  const WeeklyAiSummary({
    required this.summary,
    required this.wentWell,
    required this.obstacles,
    required this.suggestions,
  });

  final String summary;
  final List<String> wentWell;
  final List<String> obstacles;
  final List<String> suggestions;

  Map<String, Object?> toJson() => {
    'summary': summary,
    'wentWell': wentWell,
    'obstacles': obstacles,
    'suggestions': suggestions,
  };

  factory WeeklyAiSummary.fromJson(Map<String, dynamic> j) {
    List<String> l(String k) => [for (final x in j[k] as List<dynamic>? ?? const []) x as String];
    return WeeklyAiSummary(
      summary: j['summary'] as String? ?? '',
      wentWell: l('wentWell'),
      obstacles: l('obstacles'),
      suggestions: l('suggestions'),
    );
  }
}

abstract interface class ProgressRepository {
  Stream<List<WeightEntry>> watchWeights();
  Future<void> saveWeight(String date, double kg);
  Future<void> deleteWeight(String date);

  Stream<List<DailyCheckIn>> watchCheckIns();
  Future<void> saveCheckIn(DailyCheckIn checkIn);

  /// Total asupan per tanggal (hanya tanggal yang punya catatan).
  Stream<List<DayIntake>> watchIntake();

  /// Sesi selesai + set yang dikerjakan.
  Stream<List<TrainingDay>> watchTraining();

  /// Jumlah hari latihan per minggu pada program aktif.
  Future<int?> plannedSessionsPerWeek();

  Stream<StoredWeeklyReview?> watchReview(String weekStart);
  Stream<List<StoredWeeklyReview>> watchReviews();

  /// Simpan/perbarui statistik minggu (keputusan & ringkasan AI dipertahankan).
  Future<void> saveReviewStats(
    WeekSummary stats, {
    required GoalProgressStatus goalStatus,
    NutritionAdjustment? proposal,
  });

  Future<void> saveAiSummary(
    String weekStart,
    WeeklyAiSummary summary, {
    required String model,
    required String promptVersion,
  });

  /// Terima/tolak usulan. Bila diterima: target nutrisi baru dibuat (yang
  /// lama diarsipkan) — tidak pernah otomatis tanpa persetujuan.
  Future<void> decideAdjustment(String weekStart, {required bool accept});
}

class LocalProgressRepository implements ProgressRepository {
  LocalProgressRepository(this._db, this._clock);

  final AppDatabase _db;
  final DateTime Function() _clock;

  static const minWeightKg = 25.0;
  static const maxWeightKg = 400.0;
  static const maxTextLength = 500;

  @override
  Stream<List<WeightEntry>> watchWeights() =>
      (_db.select(_db.bodyMetrics)..orderBy([(t) => OrderingTerm.asc(t.date)])).watch().map(
        (rows) => [for (final r in rows) WeightEntry(date: r.date, kg: r.weightKg)],
      );

  static void _checkDate(String date) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) || DateTime.tryParse(date) == null) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'date');
    }
  }

  @override
  Future<void> saveWeight(String date, double kg) async {
    _checkDate(date);
    if (!(kg >= minWeightKg && kg <= maxWeightKg)) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'weight-range');
    }
    final now = _clock();
    final rounded = (kg * 10).roundToDouble() / 10;
    await _db
        .into(_db.bodyMetrics)
        .insert(
          BodyMetricsCompanion.insert(
            date: date,
            weightKg: rounded,
            createdAt: now,
            updatedAt: now,
          ),
          onConflict: DoUpdate(
            (_) => BodyMetricsCompanion(weightKg: Value(rounded), updatedAt: Value(now)),
          ),
        );
  }

  @override
  Future<void> deleteWeight(String date) =>
      (_db.delete(_db.bodyMetrics)..where((t) => t.date.equals(date))).go();

  static DailyCheckIn _checkIn(DailyCheckInRow r) => DailyCheckIn(
    date: r.date,
    sleepHours: r.sleepHours,
    energy: r.energy,
    mood: r.mood,
    discomfort: r.discomfort,
    notes: r.notes,
  );

  @override
  Stream<List<DailyCheckIn>> watchCheckIns() =>
      (_db.select(_db.dailyCheckIns)..orderBy([(t) => OrderingTerm.asc(t.date)])).watch().map(
        (rows) => [for (final r in rows) _checkIn(r)],
      );

  @override
  Future<void> saveCheckIn(DailyCheckIn c) async {
    _checkDate(c.date);
    String? clean(String? v) {
      final t = v?.trim();
      if (t == null || t.isEmpty) return null;
      return t.length > maxTextLength ? t.substring(0, maxTextLength) : t;
    }

    final sleep = c.sleepHours;
    final scaleOk = [c.energy, c.mood].every((v) => v == null || (v >= 1 && v <= 5));
    if ((sleep != null && (sleep < 0 || sleep > 24)) || !scaleOk) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'check-in-range');
    }
    final now = _clock();
    final companion = DailyCheckInsCompanion.insert(
      date: c.date,
      sleepHours: Value(sleep),
      energy: Value(c.energy),
      mood: Value(c.mood),
      discomfort: Value(clean(c.discomfort)),
      notes: Value(clean(c.notes)),
      createdAt: now,
      updatedAt: now,
    );
    await _db
        .into(_db.dailyCheckIns)
        .insert(
          companion,
          onConflict: DoUpdate(
            (_) => companion.copyWith(createdAt: const Value.absent(), updatedAt: Value(now)),
          ),
        );
  }

  @override
  Stream<List<DayIntake>> watchIntake() {
    final kcal = _db.foodLogs.kcal.sum();
    final protein = _db.foodLogs.protein.sum();
    final q = _db.selectOnly(_db.foodLogs)
      ..addColumns([_db.foodLogs.date, kcal, protein])
      ..groupBy([_db.foodLogs.date])
      ..orderBy([OrderingTerm.asc(_db.foodLogs.date)]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          DayIntake(
            date: r.read(_db.foodLogs.date)!,
            kcal: r.read(kcal) ?? 0,
            protein: r.read(protein) ?? 0,
          ),
      ],
    );
  }

  @override
  Stream<List<TrainingDay>> watchTraining() {
    final sessions = _db.select(_db.workoutSessions)
      ..where((t) => t.status.equals(SessionStatus.completed.name))
      ..orderBy([(t) => OrderingTerm.asc(t.date)]);
    return sessions.watch().asyncMap((rows) async {
      if (rows.isEmpty) return const <TrainingDay>[];
      final ids = [for (final r in rows) r.id];
      final sets = await (_db.select(
        _db.setLogs,
      )..where((t) => t.sessionId.isIn(ids) & t.status.equals(SetStatus.done.name))).get();
      final bySession = <String, List<SetLogRow>>{};
      for (final s in sets) {
        bySession.putIfAbsent(s.sessionId, () => []).add(s);
      }
      return [
        for (final r in rows)
          () {
            final planned = [
              for (final e in jsonDecode(r.planned) as List<dynamic>)
                PlannedExercise.fromJson(e as Map<String, dynamic>),
            ];
            bool timed(int i) => i < planned.length && planned[i].repUnit == 'seconds';
            return TrainingDay(
              sessionId: r.id,
              date: r.date,
              discomfort: (r.discomfort ?? '').trim().isNotEmpty,
              sets: [
                for (final s in bySession[r.id] ?? const <SetLogRow>[])
                  SetEntry(
                    exerciseId: s.exerciseId,
                    weightKg: s.weightKg,
                    reps: s.reps,
                    timed: timed(s.exerciseIndex),
                  ),
              ],
            );
          }(),
      ];
    });
  }

  @override
  Future<int?> plannedSessionsPerWeek() async {
    final planId = (await readProfile(_db))?.activeWorkoutPlanId;
    if (planId == null) return null;
    final count = _db.planDays.id.count();
    final row =
        await (_db.selectOnly(_db.planDays)
              ..addColumns([count])
              ..where(_db.planDays.planId.equals(planId)))
            .getSingle();
    return row.read(count);
  }

  static StoredWeeklyReview _review(WeeklyReviewRow r) => StoredWeeklyReview(
    weekStart: r.weekStart,
    stats: WeekSummary.fromJson(jsonDecode(r.stats) as Map<String, dynamic>),
    goalStatus: GoalProgressStatus.values.byName(r.goalStatus),
    proposal: r.proposal == null
        ? null
        : NutritionAdjustment.fromJson(jsonDecode(r.proposal!) as Map<String, dynamic>),
    decision: r.decision,
    aiSummary: r.aiSummary == null
        ? null
        : WeeklyAiSummary.fromJson(jsonDecode(r.aiSummary!) as Map<String, dynamic>),
    model: r.model,
    promptVersion: r.promptVersion,
  );

  @override
  Stream<StoredWeeklyReview?> watchReview(String weekStart) =>
      (_db.select(_db.weeklyReviews)..where((t) => t.weekStart.equals(weekStart)))
          .watchSingleOrNull()
          .map((r) => r == null ? null : _review(r));

  @override
  Stream<List<StoredWeeklyReview>> watchReviews() =>
      (_db.select(_db.weeklyReviews)..orderBy([(t) => OrderingTerm.desc(t.weekStart)])).watch().map(
        (rows) => [for (final r in rows) _review(r)],
      );

  @override
  Future<void> saveReviewStats(
    WeekSummary stats, {
    required GoalProgressStatus goalStatus,
    NutritionAdjustment? proposal,
  }) async {
    final now = _clock();
    await _db.transaction(() async {
      final existing = await (_db.select(
        _db.weeklyReviews,
      )..where((t) => t.weekStart.equals(stats.weekStart))).getSingleOrNull();
      // Usulan yang sudah diputuskan tidak ditimpa.
      final keepProposal = existing?.decision != null;
      final companion = WeeklyReviewsCompanion(
        weekStart: Value(stats.weekStart),
        stats: Value(jsonEncode(stats.toJson())),
        goalStatus: Value(goalStatus.name),
        proposal: keepProposal
            ? const Value.absent()
            : Value(proposal == null ? null : jsonEncode(proposal.toJson())),
        configVersion: const Value(ProgressConfig.version),
        updatedAt: Value(now),
      );
      if (existing == null) {
        await _db.into(_db.weeklyReviews).insert(companion.copyWith(createdAt: Value(now)));
      } else {
        await (_db.update(
          _db.weeklyReviews,
        )..where((t) => t.weekStart.equals(stats.weekStart))).write(companion);
      }
    });
  }

  @override
  Future<void> saveAiSummary(
    String weekStart,
    WeeklyAiSummary summary, {
    required String model,
    required String promptVersion,
  }) async {
    final n = await (_db.update(_db.weeklyReviews)..where((t) => t.weekStart.equals(weekStart)))
        .write(
          WeeklyReviewsCompanion(
            aiSummary: Value(jsonEncode(summary.toJson())),
            model: Value(model),
            promptVersion: Value(promptVersion),
            updatedAt: Value(_clock()),
          ),
        );
    if (n == 0) throw const AppFailure(FailureKind.notFound, debugMessage: 'review-missing');
  }

  @override
  Future<void> decideAdjustment(String weekStart, {required bool accept}) async {
    final now = _clock();
    await _db.transaction(() async {
      final row = await (_db.select(
        _db.weeklyReviews,
      )..where((t) => t.weekStart.equals(weekStart))).getSingleOrNull();
      if (row == null || row.proposal == null) {
        throw const AppFailure(FailureKind.notFound, debugMessage: 'proposal-missing');
      }
      if (row.decision != null) {
        throw const AppFailure(FailureKind.invalidInput, debugMessage: 'already-decided');
      }
      if (accept) {
        final adj = NutritionAdjustment.fromJson(jsonDecode(row.proposal!) as Map<String, dynamic>);
        await _applyAdjustment(adj, now);
      }
      await (_db.update(_db.weeklyReviews)..where((t) => t.weekStart.equals(weekStart))).write(
        WeeklyReviewsCompanion(
          decision: Value(accept ? 'accepted' : 'declined'),
          decidedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> _applyAdjustment(NutritionAdjustment adj, DateTime now) async {
    final profile = await readProfile(_db);
    final targetId = profile?.activeNutritionTargetId;
    final row = targetId == null
        ? null
        : await (_db.select(
            _db.nutritionTargets,
          )..where((t) => t.id.equals(targetId))).getSingleOrNull();
    if (row == null) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'no-nutrition-target');
    }
    final plan = NutritionPlan.fromJson(jsonDecode(row.data) as Map<String, dynamic>);
    final kcal = adj.newKcal;
    int pct(num v) => (v / kcal * 100).round();
    final delta = (kcal - plan.targetKcal).toDouble();
    final updated = plan.copyWith(
      targetKcal: kcal,
      carbsG: adj.newCarbsG,
      targetKcalRange: NumRange(
        min: plan.targetKcalRange.min + delta,
        max: plan.targetKcalRange.max + delta,
      ),
      energySplitPct: EnergySplit(
        protein: pct(plan.proteinG * 4),
        fat: pct(plan.fatG * 9),
        carbs: pct(adj.newCarbsG * 4),
      ),
    );
    await (_db.update(_db.nutritionTargets)..where((t) => t.id.equals(row.id))).write(
      NutritionTargetsCompanion(status: const Value('archived'), archivedAt: Value(now)),
    );
    final newId_ = newId();
    await _db
        .into(_db.nutritionTargets)
        .insert(
          NutritionTargetsCompanion.insert(
            id: newId_,
            goalId: row.goalId,
            status: 'active',
            data: jsonEncode(updated.toJson()),
            configVersion: '${row.configVersion}+${ProgressConfig.version}',
            createdAt: now,
          ),
        );
    await updateProfile(_db, ProfileStateCompanion(activeNutritionTargetId: Value(newId_)), now);
  }
}
