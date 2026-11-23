import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/storage/photo_store.dart';
import '../domain/progress_models.dart';

/// Lingkar badan & foto progres. Foto tidak pernah dikirim ke AI.
abstract interface class BodyRepository {
  Stream<List<BodyMeasurement>> watchMeasurements();

  /// Simpan/ganti ukuran pada tanggal itu; tanpa ukuran = hapus baris.
  Future<void> saveMeasurement(BodyMeasurement m);
  Future<void> deleteMeasurement(String date);

  Stream<List<ProgressPhoto>> watchPhotos();

  /// Salin foto dari [sourcePath] ke folder privat lalu catat.
  Future<void> addPhoto({
    required String date,
    required PhotoPose pose,
    required String sourcePath,
  });
  Future<void> deletePhoto(String id);
}

class LocalBodyRepository implements BodyRepository {
  LocalBodyRepository(this._db, this._photos, this._clock);

  final AppDatabase _db;
  final PhotoStore _photos;
  final DateTime Function() _clock;

  static const minCm = 10.0;
  static const maxCm = 250.0;

  static void _checkDate(String date) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) || DateTime.tryParse(date) == null) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'date');
    }
  }

  static BodyMeasurement _measurement(BodyMeasurementRow r) => BodyMeasurement(
    date: r.date,
    cm: {
      BodySite.waist: ?r.waistCm,
      BodySite.chest: ?r.chestCm,
      BodySite.arm: ?r.armCm,
      BodySite.thigh: ?r.thighCm,
      BodySite.hip: ?r.hipCm,
    },
  );

  @override
  Stream<List<BodyMeasurement>> watchMeasurements() =>
      (_db.select(_db.bodyMeasurements)..orderBy([(t) => OrderingTerm.asc(t.date)])).watch().map(
        (rows) => [for (final r in rows) _measurement(r)],
      );

  @override
  Future<void> saveMeasurement(BodyMeasurement m) async {
    _checkDate(m.date);
    if (m.cm.values.any((v) => v < minCm || v > maxCm)) {
      throw const AppFailure(FailureKind.invalidInput, debugMessage: 'measurement-range');
    }
    if (m.isEmpty) return deleteMeasurement(m.date);
    final now = _clock();
    Value<double?> v(BodySite s) => Value(m.of(s));
    await _db
        .into(_db.bodyMeasurements)
        .insert(
          BodyMeasurementsCompanion.insert(
            date: m.date,
            waistCm: v(BodySite.waist),
            chestCm: v(BodySite.chest),
            armCm: v(BodySite.arm),
            thighCm: v(BodySite.thigh),
            hipCm: v(BodySite.hip),
            createdAt: now,
            updatedAt: now,
          ),
          onConflict: DoUpdate(
            (_) => BodyMeasurementsCompanion(
              waistCm: v(BodySite.waist),
              chestCm: v(BodySite.chest),
              armCm: v(BodySite.arm),
              thighCm: v(BodySite.thigh),
              hipCm: v(BodySite.hip),
              updatedAt: Value(now),
            ),
          ),
        );
  }

  @override
  Future<void> deleteMeasurement(String date) =>
      (_db.delete(_db.bodyMeasurements)..where((t) => t.date.equals(date))).go();

  @override
  Stream<List<ProgressPhoto>> watchPhotos() =>
      (_db.select(_db.progressPhotos)
            ..orderBy([(t) => OrderingTerm.asc(t.date), (t) => OrderingTerm.asc(t.createdAt)]))
          .watch()
          .map(
            (rows) => [
              for (final r in rows)
                if (PhotoPose.values.asNameMap()[r.pose] case final pose?)
                  ProgressPhoto(id: r.id, date: r.date, pose: pose, fileName: r.fileName),
            ],
          );

  @override
  Future<void> addPhoto({
    required String date,
    required PhotoPose pose,
    required String sourcePath,
  }) async {
    _checkDate(date);
    final fileName = await _photos.import(sourcePath);
    try {
      await _db
          .into(_db.progressPhotos)
          .insert(
            ProgressPhotosCompanion.insert(
              id: newId(),
              date: date,
              pose: pose.name,
              fileName: fileName,
              createdAt: _clock(),
            ),
          );
    } catch (_) {
      await _photos.delete(fileName);
      rethrow;
    }
  }

  @override
  Future<void> deletePhoto(String id) async {
    final row = await (_db.select(
      _db.progressPhotos,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    await (_db.delete(_db.progressPhotos)..where((t) => t.id.equals(id))).go();
    await _photos.delete(row.fileName);
  }
}
