import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Basis data lokal (SQLite via drift). Semua data pengguna tersimpan hanya di
/// perangkat ini. Kolom `data`/`exercises`/`planned` berisi JSON terstruktur
/// untuk objek bersarang yang selalu dibaca utuh; data yang di-query (status,
/// tanggal, set) disimpan sebagai kolom biasa.

/// Satu baris (id = 1): status onboarding & entitas aktif.
@DataClassName('ProfileRow')
class ProfileState extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get displayName => text().nullable()();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get activeGoalId => text().nullable()();
  TextColumn get activeNutritionTargetId => text().nullable()();
  TextColumn get latestAssessmentId => text().nullable()();
  TextColumn get activeWorkoutPlanId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Assessment: satu `draft` (id 'draft') + riwayat `final`.
@DataClassName('AssessmentRow')
class Assessments extends Table {
  TextColumn get id => text()();
  TextColumn get status => text()();
  IntColumn get step => integer().withDefault(const Constant(0))();
  TextColumn get data => text()();
  TextColumn get consentVersion => text().nullable()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ConsentRow')
class Consents extends Table {
  TextColumn get id => text()();
  TextColumn get version => text()();
  DateTimeColumn get acceptedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GoalRow')
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get status => text()();
  TextColumn get assessmentId => text()();
  TextColumn get data => text()();
  BoolColumn get warningsAcknowledged => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get activatedAt => dateTime().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NutritionTargetRow')
class NutritionTargets extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get status => text()();
  TextColumn get data => text()();
  TextColumn get configVersion => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutPlanRow')
class WorkoutPlans extends Table {
  TextColumn get id => text()();
  TextColumn get status => text()();
  TextColumn get source => text()();
  TextColumn get generatorVersion => text()();
  TextColumn get catalogVersion => text()();
  TextColumn get assessmentId => text()();
  TextColumn get split => text()();
  TextColumn get level => text()();
  IntColumn get daysPerWeek => integer()();
  IntColumn get sessionMinutes => integer()();
  TextColumn get warnings => text()();

  /// Ringkasan alasan program dari AI (null untuk template).
  TextColumn get rationale => text().nullable()();

  /// Model AI yang menyusun (null untuk template).
  TextColumn get model => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get activatedAt => dateTime().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlanDayRow')
class PlanDays extends Table {
  TextColumn get planId => text().references(WorkoutPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get id => text()();
  IntColumn get position => integer()();
  IntColumn get weekday => integer()();
  TextColumn get focus => text()();
  IntColumn get warmupMinutes => integer()();
  IntColumn get estimatedMinutes => integer()();
  TextColumn get exercises => text()();

  @override
  Set<Column> get primaryKey => {planId, id};
}

@DataClassName('WorkoutSessionRow')
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text()();
  TextColumn get dayId => text()();

  /// Tanggal lokal `YYYY-MM-DD`.
  TextColumn get date => text()();
  IntColumn get weekday => integer()();
  TextColumn get focus => text()();
  TextColumn get status => text()();

  /// Salinan target (JSON) — tidak diubah setelah sesi dibuat.
  TextColumn get planned => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get energy => integer().nullable()();
  TextColumn get discomfort => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SetLogRow')
class SetLogs extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  IntColumn get exerciseIndex => integer()();
  IntColumn get setNumber => integer()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get reps => integer()();
  IntColumn get rir => integer().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Metadata setiap pemanggilan AI — tanpa prompt/isi data pengguna.
@DataClassName('AiLogRow')
class AiGenerationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get model => text()();
  TextColumn get modelVersion => text().nullable()();
  TextColumn get promptVersion => text()();

  /// success | invalid | error
  TextColumn get status => text()();
  IntColumn get attempts => integer()();
  IntColumn get durationMs => integer()();
  IntColumn get inputTokens => integer().nullable()();
  IntColumn get outputTokens => integer().nullable()();
  TextColumn get errorCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Pengaturan aplikasi sebagai key → JSON (mis. preferensi notifikasi).
@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    ProfileState,
    Assessments,
    Consents,
    Goals,
    NutritionTargets,
    WorkoutPlans,
    PlanDays,
    WorkoutSessions,
    SetLogs,
    AiGenerationLogs,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'musclecoach'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX idx_sessions_status_date ON workout_sessions (status, date DESC)',
      );
      await customStatement(
        'CREATE INDEX idx_sessions_plan_day ON workout_sessions (plan_id, day_id, status, date DESC)',
      );
      await customStatement('CREATE INDEX idx_sets_session ON set_logs (session_id)');
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Fase 4: program dari AI + log generasi.
        await m.addColumn(workoutPlans, workoutPlans.rationale);
        await m.addColumn(workoutPlans, workoutPlans.model);
        await m.createTable(aiGenerationLogs);
      }
      if (from < 3) {
        // Pengingat lokal: preferensi notifikasi.
        await m.createTable(appSettings);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Hapus seluruh data pengguna (tabel tetap ada).
  Future<void> wipeAll() => transaction(() async {
    for (final table in allTables.toList().reversed) {
      await delete(table).go();
    }
  });
}

final _random = Random.secure();
const _idChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

/// ID acak 20 karakter (setara auto-ID Firestore).
String newId() => List.generate(20, (_) => _idChars[_random.nextInt(_idChars.length)]).join();
