import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../goals/domain/goal_planner.dart';
import '../../profile/data/local_profile_repository.dart';
import '../domain/consent.dart';
import '../domain/entities/assessment_data.dart';
import '../domain/repositories/assessment_repository.dart';
import '../domain/validators/assessment_validator.dart';

/// Assessment disimpan lokal. `submit` memvalidasi penuh, menghitung usulan
/// goal (GoalPlanner) dan menyimpannya dalam satu transaksi.
class LocalAssessmentRepository implements AssessmentRepository {
  LocalAssessmentRepository(this._db, this._clock);

  final AppDatabase _db;
  final DateTime Function() _clock;

  Future<AssessmentRow?> _row(String id) =>
      (_db.select(_db.assessments)..where((t) => t.id.equals(id))).getSingleOrNull();

  static AssessmentData? _decode(String json) {
    try {
      return AssessmentData.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null; // skema lama/rusak → abaikan
    }
  }

  @override
  Future<AssessmentDraft?> loadDraft() async {
    final row = await _row(assessmentDraftId);
    final data = row == null ? null : _decode(row.data);
    return data == null ? null : (data: data, step: row!.step);
  }

  @override
  Future<AssessmentData?> loadAssessment(String id) async {
    final row = await _row(id);
    return row == null ? null : _decode(row.data);
  }

  @override
  Future<void> saveDraft(AssessmentData data, int step) async {
    final now = _clock();
    await _db
        .into(_db.assessments)
        .insertOnConflictUpdate(
          AssessmentsCompanion.insert(
            id: assessmentDraftId,
            status: 'draft',
            step: Value(step),
            data: jsonEncode(data.toJson()),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<String> submit(AssessmentData data) async {
    final now = _clock();
    // Validasi ulang di lapisan data (bukan hanya di UI).
    if (AssessmentValidator.firstInvalidStep(data, now: now, consentGiven: true) != null) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'assessment-invalid');
    }
    final clean = AssessmentData.fromJson(assessmentPayload(normalizeAssessment(data)));
    final goal = GoalPlanner.buildProposal(clean, now);
    final assessmentId = newId();
    final goalId = newId();

    await _db.transaction(() async {
      await _db
          .into(_db.assessments)
          .insert(
            AssessmentsCompanion.insert(
              id: assessmentId,
              status: 'final',
              data: jsonEncode(clean.toJson()),
              consentVersion: const Value(assessmentConsentVersion),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await (_db.delete(_db.assessments)..where((t) => t.id.equals(assessmentDraftId))).go();
      await _db
          .into(_db.consents)
          .insertOnConflictUpdate(
            ConsentsCompanion.insert(
              id: 'assessment_health_data',
              version: assessmentConsentVersion,
              acceptedAt: now,
            ),
          );
      // Usulan lama yang belum dikonfirmasi diganti.
      await (_db.delete(_db.goals)..where((t) => t.status.equals('proposed'))).go();
      await _db
          .into(_db.goals)
          .insert(
            GoalsCompanion.insert(
              id: goalId,
              status: 'proposed',
              assessmentId: assessmentId,
              data: jsonEncode(goal.toJson()),
              createdAt: now,
            ),
          );
      final nickname = clean.profile.nickname;
      await updateProfile(
        _db,
        ProfileStateCompanion(
          latestAssessmentId: Value(assessmentId),
          displayName: nickname == null ? const Value.absent() : Value(nickname),
        ),
        now,
      );
    });
    return goalId;
  }
}
