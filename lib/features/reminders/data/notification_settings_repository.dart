import 'dart:convert';

import '../../../core/database/app_database.dart';
import '../domain/notification_settings.dart';

/// Preferensi notifikasi di tabel `app_settings` (JSON).
class NotificationSettingsRepository {
  NotificationSettingsRepository(this._db, this._clock);

  final AppDatabase _db;
  final DateTime Function() _clock;

  static const _key = 'notifications';

  static NotificationSettings _decode(AppSettingRow? row) {
    if (row == null) return const NotificationSettings();
    try {
      return NotificationSettings.fromJson(jsonDecode(row.value) as Map<String, dynamic>);
    } catch (_) {
      return const NotificationSettings();
    }
  }

  Stream<NotificationSettings> watch() => (_db.select(
    _db.appSettings,
  )..where((t) => t.key.equals(_key))).watchSingleOrNull().map(_decode);

  Future<NotificationSettings> read() async => _decode(
    await (_db.select(_db.appSettings)..where((t) => t.key.equals(_key))).getSingleOrNull(),
  );

  Future<void> save(NotificationSettings settings) async {
    final problems = validateNotificationSettings(settings);
    if (problems.isNotEmpty) throw ArgumentError(problems.join('; '));
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: _key,
            value: jsonEncode(settings.toJson()),
            updatedAt: _clock(),
          ),
        );
  }
}
