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

/// Makanan yang dimasukkan pengguna dari label kemasan (nilai per 100 g).
@DataClassName('CustomFoodRow')
class CustomFoods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get kcal => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();

  /// Ukuran porsi pada label (g), untuk isian bawaan.
  RealColumn get servingGrams => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Catatan makanan. Nilai gizi = salinan saat dicatat (kcal & gram).
@DataClassName('FoodLogRow')
class FoodLogs extends Table {
  TextColumn get id => text()();

  /// Tanggal lokal `YYYY-MM-DD`.
  TextColumn get date => text()();

  /// breakfast | lunch | dinner | snack
  TextColumn get meal => text()();

  /// `tkpi:<kode>` / `custom:<id>`; null = catatan manual.
  TextColumn get foodId => text().nullable()();
  TextColumn get name => text()();
  RealColumn get grams => real().nullable()();
  RealColumn get kcal => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();

  /// source | inconsistent | user_label | manual
  TextColumn get quality => text()();

  /// `<mealPlanId>:<indeks waktu makan>` bila dicatat dari menu.
  TextColumn get planRef => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Contoh menu harian (AI, sudah divalidasi). Isi menu di kolom `data`.
@DataClassName('MealPlanRow')
class MealPlans extends Table {
  TextColumn get id => text()();

  /// draft | active | archived
  TextColumn get status => text()();
  TextColumn get source => text()();
  TextColumn get data => text()();
  TextColumn get model => text().nullable()();
  TextColumn get promptVersion => text()();
  TextColumn get catalogVersion => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get activatedAt => dateTime().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Penimbangan berat badan: satu nilai per tanggal lokal.
@DataClassName('BodyMetricRow')
class BodyMetrics extends Table {
  TextColumn get date => text()();
  RealColumn get weightKg => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

/// Lingkar badan (cm), satu baris per tanggal lokal; semua ukuran opsional.
@DataClassName('BodyMeasurementRow')
class BodyMeasurements extends Table {
  TextColumn get date => text()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get armCm => real().nullable()();
  RealColumn get thighCm => real().nullable()();
  RealColumn get hipCm => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

/// Foto progres: hanya metadata; berkasnya di folder privat aplikasi.
@DataClassName('ProgressPhotoRow')
class ProgressPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();

  /// front | side | back
  TextColumn get pose => text()();

  /// Nama berkas di folder foto (bukan path absolut).
  TextColumn get fileName => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Check-in harian (satu per tanggal). Semua isian opsional.
@DataClassName('DailyCheckInRow')
class DailyCheckIns extends Table {
  TextColumn get date => text()();
  RealColumn get sleepHours => real().nullable()();
  IntColumn get energy => integer().nullable()();
  IntColumn get mood => integer().nullable()();
  TextColumn get discomfort => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

/// Ringkasan mingguan: salinan statistik, status target, usulan
/// penyesuaian + keputusan pengguna, dan ringkasan AI (opsional).
@DataClassName('WeeklyReviewRow')
class WeeklyReviews extends Table {
  /// Senin `YYYY-MM-DD`.
  TextColumn get weekStart => text()();
  TextColumn get stats => text()();
  TextColumn get goalStatus => text()();
  TextColumn get proposal => text().nullable()();

  /// accepted | declined
  TextColumn get decision => text().nullable()();
  DateTimeColumn get decidedAt => dateTime().nullable()();
  TextColumn get aiSummary => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get promptVersion => text().nullable()();
  TextColumn get configVersion => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {weekStart};
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
    CustomFoods,
    FoodLogs,
    MealPlans,
    BodyMetrics,
    DailyCheckIns,
    WeeklyReviews,
    BodyMeasurements,
    ProgressPhotos,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'musclecoach'));

  @override
  int get schemaVersion => 6;

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
      await _createFoodLogIndexes();
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
      if (from < 4) {
        // Fase 5: nutrisi.
        await m.createTable(customFoods);
        await m.createTable(foodLogs);
        await m.createTable(mealPlans);
        await _createFoodLogIndexes();
      }
      if (from < 5) {
        // Fase 6: progres & check-in.
        await m.createTable(bodyMetrics);
        await m.createTable(dailyCheckIns);
        await m.createTable(weeklyReviews);
      }
      if (from < 6) {
        // Lingkar badan & foto progres.
        await m.createTable(bodyMeasurements);
        await m.createTable(progressPhotos);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Aksi notifikasi di latar belakang bisa membuka koneksi kedua.
      await customStatement('PRAGMA busy_timeout = 5000');
      // Data yang dihapus ditimpa nol, bukan sekadar ditandai bebas.
      await customStatement('PRAGMA secure_delete = ON');
    },
  );

  Future<void> _createFoodLogIndexes() async {
    await customStatement('CREATE INDEX idx_food_logs_date ON food_logs (date, created_at)');
    await customStatement(
      'CREATE INDEX idx_food_logs_food ON food_logs (food_id, created_at DESC)',
    );
  }

  /// Hapus seluruh data pengguna (tabel tetap ada), lalu VACUUM agar sisa
  /// halaman lama di berkas basis data ikut dibuang.
  Future<void> wipeAll() async {
    await transaction(() async {
      for (final table in allTables.toList().reversed) {
        await delete(table).go();
      }
    });
    await customStatement('VACUUM');
  }
}

final _random = Random.secure();
const _idChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

/// ID acak 20 karakter (setara auto-ID Firestore).
String newId() => List.generate(20, (_) => _idChars[_random.nextInt(_idChars.length)]).join();
