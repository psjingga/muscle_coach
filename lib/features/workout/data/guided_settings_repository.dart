import 'dart:convert';

import '../../../core/database/app_database.dart';
import '../domain/guided_settings.dart';

/// Preferensi Mode Panduan di tabel `app_settings` (JSON).
class GuidedSettingsRepository {
  GuidedSettingsRepository(this._db, this._clock);

  final AppDatabase _db;
  final DateTime Function() _clock;

  static const key = 'guided_mode';

  static GuidedSettings _decode(AppSettingRow? row) {
    if (row == null) return const GuidedSettings();
    try {
      return GuidedSettings.fromJson(jsonDecode(row.value) as Map<String, dynamic>);
    } catch (_) {
      return const GuidedSettings();
    }
  }

  Stream<GuidedSettings> watch() => (_db.select(
    _db.appSettings,
  )..where((t) => t.key.equals(key))).watchSingleOrNull().map(_decode);

  Future<void> save(GuidedSettings settings) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(
          key: key,
          value: jsonEncode(settings.toJson()),
          updatedAt: _clock(),
        ),
      );
}
