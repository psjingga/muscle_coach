import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/exercise.dart';

abstract interface class ExerciseRepository {
  /// Semua latihan katalog, urut nama.
  Future<List<Exercise>> fetchAll();
}

/// Katalog terkurasi dibundel sebagai aset (`assets/catalog/exercises.json`).
class AssetExerciseRepository implements ExerciseRepository {
  AssetExerciseRepository(this._bundle);

  final AssetBundle _bundle;

  static const path = 'assets/catalog/exercises.json';

  /// Parse isi file katalog (dipakai juga oleh test).
  static ({String version, List<Exercise> exercises}) parse(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = [
      for (final e in json['exercises'] as List<dynamic>)
        Exercise.fromJson(e as Map<String, dynamic>),
    ]..sort((a, b) => a.name.compareTo(b.name));
    return (version: json['version'] as String, exercises: list);
  }

  @override
  Future<List<Exercise>> fetchAll() async => parse(await _bundle.loadString(path)).exercises;
}
