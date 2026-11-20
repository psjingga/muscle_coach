import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

/// Versi katalog di `assets/catalog/exercises.json` (dicatat pada program).
const catalogVersion = '2026-11-v1';

/// Latihan dari katalog terkurasi (aset, read-only). Otot/pola/alat disimpan
/// sebagai kode string agar kode baru di katalog tidak merusak parsing;
/// labelnya diterjemahkan di presentation.
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

    /// Foto gerakan (path aset), urut posisi awal → akhir. Kosong bila belum
    /// ada; UI lalu hanya menampilkan peta otot.
    @Default(<String>[]) List<String> images,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
}
