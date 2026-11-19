import '../entities/assessment_data.dart';

/// Draft tersimpan beserta langkah terakhir yang dibuka.
typedef AssessmentDraft = ({AssessmentData data, int step});

abstract interface class AssessmentRepository {
  Future<AssessmentDraft?> loadDraft();

  /// Assessment final (untuk mengisi ulang wizard saat assessment diulang).
  Future<AssessmentData?> loadAssessment(String id);

  Future<void> saveDraft(AssessmentData data, int step);

  /// Kirim assessment + consent; server membuat usulan goal. Mengembalikan ID goal.
  Future<String> submit(AssessmentData data);
}
