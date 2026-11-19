import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/failure_mapper.dart';
import '../domain/exercise.dart';

abstract interface class ExerciseRepository {
  /// Semua latihan yang dipublikasikan, urut nama.
  Future<List<Exercise>> fetchAll();
}

/// Katalog relatif statis: dibaca sekali per sesi aplikasi (provider
/// keepAlive) dan tersedia offline lewat cache Firestore.
class FirestoreExerciseRepository implements ExerciseRepository {
  FirestoreExerciseRepository(this._db);

  final FirebaseFirestore _db;

  @override
  Future<List<Exercise>> fetchAll() async {
    try {
      final snap = await _db
          .collection('exerciseCatalog')
          .where('status', isEqualTo: 'published')
          .get();
      return snap.docs.map((d) => Exercise.fromJson({...d.data(), 'id': d.id})).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      throw FailureMapper.from(e);
    }
  }
}
