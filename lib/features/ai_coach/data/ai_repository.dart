import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/ai_config.dart';

/// Persetujuan AI, kuota harian, dan log generasi (lokal).
class AiRepository {
  AiRepository(this._db);

  final AppDatabase _db;

  Future<bool> hasConsent() async {
    final row = await (_db.select(
      _db.consents,
    )..where((t) => t.id.equals(AiConfig.consentId))).getSingleOrNull();
    return row?.version == AiConfig.consentVersion;
  }

  Future<void> setConsent({required bool accepted, required DateTime now}) async {
    if (accepted) {
      await _db
          .into(_db.consents)
          .insertOnConflictUpdate(
            ConsentsCompanion.insert(
              id: AiConfig.consentId,
              version: AiConfig.consentVersion,
              acceptedAt: now,
            ),
          );
    } else {
      await (_db.delete(_db.consents)..where((t) => t.id.equals(AiConfig.consentId))).go();
    }
  }

  /// Jumlah pemanggilan AI sejak tengah malam (waktu lokal).
  Future<int> countToday(DateTime now) async {
    final start = DateTime(now.year, now.month, now.day);
    final count = _db.aiGenerationLogs.id.count();
    final row =
        await (_db.selectOnly(_db.aiGenerationLogs)
              ..addColumns([count])
              ..where(_db.aiGenerationLogs.createdAt.isBiggerOrEqualValue(start)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> log({
    required String kind,
    required String model,
    required String promptVersion,
    required String status,
    required int attempts,
    required int durationMs,
    required DateTime now,
    String? modelVersion,
    int? inputTokens,
    int? outputTokens,
    String? errorCode,
  }) => _db
      .into(_db.aiGenerationLogs)
      .insert(
        AiGenerationLogsCompanion.insert(
          id: newId(),
          kind: kind,
          model: model,
          modelVersion: Value(modelVersion),
          promptVersion: promptVersion,
          status: status,
          attempts: attempts,
          durationMs: durationMs,
          inputTokens: Value(inputTokens),
          outputTokens: Value(outputTokens),
          errorCode: Value(errorCode),
          createdAt: now,
        ),
      );
}
