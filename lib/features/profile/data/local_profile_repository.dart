import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/user_profile.dart';
import '../domain/profile_repository.dart';

/// Profil disimpan sebagai satu baris dengan id tetap.
const _profileId = 1;

class LocalProfileRepository implements ProfileRepository {
  LocalProfileRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<UserProfile?> watch() =>
      (_db.select(_db.profileState)..where((t) => t.id.equals(_profileId))).watchSingleOrNull().map(
        (r) => r == null
            ? null
            : UserProfile(
                displayName: r.displayName,
                onboardingCompleted: r.onboardingCompleted,
                activeGoalId: r.activeGoalId,
                activeNutritionTargetId: r.activeNutritionTargetId,
                latestAssessmentId: r.latestAssessmentId,
                activeWorkoutPlanId: r.activeWorkoutPlanId,
              ),
      );

  @override
  Future<void> wipeAllData() => _db.wipeAll();
}

/// Perbarui baris profil tunggal (dibuat bila belum ada).
Future<void> updateProfile(AppDatabase db, ProfileStateCompanion changes, DateTime now) async {
  await db
      .into(db.profileState)
      .insert(
        ProfileStateCompanion.insert(id: const Value(_profileId), updatedAt: now),
        mode: InsertMode.insertOrIgnore,
      );
  await (db.update(
    db.profileState,
  )..where((t) => t.id.equals(_profileId))).write(changes.copyWith(updatedAt: Value(now)));
}

/// Baca profil sekali (untuk aturan bisnis di repository lain).
Future<ProfileRow?> readProfile(AppDatabase db) =>
    (db.select(db.profileState)..where((t) => t.id.equals(_profileId))).getSingleOrNull();
