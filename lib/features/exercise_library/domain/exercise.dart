import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

/// Latihan dari katalog `exerciseCatalog` (dikurasi server, read-only).
/// Otot/pola/alat disimpan sebagai kode string agar kode baru dari server
/// tidak merusak parsing; labelnya diterjemahkan di presentation.
@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    @Default(<String>[]) List<String> aliases,
    @Default(<String>[]) List<String> primaryMuscles,
    @Default(<String>[]) List<String> secondaryMuscles,
    required String pattern,
    @Default(<String>[]) List<String> equipment,
    required String level,
    @Default(false) bool compound,
    @Default('reps') String repUnit,
    @Default('total') String loadType,
    @Default(<String>[]) List<String> instructions,
    @Default(<String>[]) List<String> mistakes,
    @Default(<String>[]) List<String> safety,
    @Default(false) bool needsSpotter,
    @Default(<String>[]) List<String> alternatives,
    String? videoUrl,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
}
