import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/functions_client.dart';
import '../domain/entities/assessment_data.dart';
import '../domain/repositories/assessment_repository.dart';

/// Versi teks persetujuan; harus sama dengan `CONSENT_VERSION` di server.
const consentVersion = '2026-11-v1';

/// Draft ditulis langsung ke Firestore (dibatasi Security Rules); assessment
/// final dikirim lewat callable `submitAssessment` yang memvalidasi penuh.
class FirestoreAssessmentRepository implements AssessmentRepository {
  FirestoreAssessmentRepository(this._db, this._functions, this._uid);

  final FirebaseFirestore _db;
  final FunctionsClient _functions;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('users/$_uid/assessments');

  @override
  Future<AssessmentDraft?> loadDraft() async {
    try {
      final snap = await _col.doc('draft').get();
      final json = snap.data();
      if (json == null) return null;
      final data = AssessmentData.fromJson(Map<String, dynamic>.from(json['data'] as Map));
      return (data: data, step: (json['step'] as num?)?.toInt() ?? 0);
    } on FirebaseException catch (e) {
      throw FailureMapper.from(e);
    } catch (e) {
      // Draft dari versi skema lama/rusak: abaikan, mulai dari awal.
      appLogger.w('Draft assessment tidak bisa dibaca: ${e.runtimeType}');
      return null;
    }
  }

  @override
  Future<AssessmentData?> loadAssessment(String id) async {
    try {
      final json = (await _col.doc(id).get()).data();
      return json == null ? null : AssessmentData.fromJson(json);
    } on FirebaseException catch (e) {
      throw FailureMapper.from(e);
    } catch (e) {
      appLogger.w('Assessment lama tidak bisa dibaca: ${e.runtimeType}');
      return null;
    }
  }

  @override
  Future<void> saveDraft(AssessmentData data, int step) async {
    try {
      await _col.doc('draft').set({
        'status': 'draft',
        'schemaVersion': 1,
        'step': step,
        'data': data.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FailureMapper.from(e);
    }
  }

  @override
  Future<String> submit(AssessmentData data) async {
    final result = await _functions.call(
      'submitAssessment',
      data: {
        'assessment': assessmentPayload(data),
        'consent': {'version': consentVersion, 'disclaimer': true, 'healthData': true},
      },
    );
    final goalId = result['goalId'];
    if (goalId is! String) throw const AppFailure(FailureKind.unknown, debugMessage: 'no goalId');
    return goalId;
  }
}
