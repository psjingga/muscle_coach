import 'dart:convert';
import 'dart:math' as math;

import 'food.dart';

/// Satu makanan/bahan yang dikenali dari foto.
///
/// Gizi dihitung aplikasi: dari katalog TKPI bila [food] ada (pendekatan
/// gabungan), atau dari perkiraan Gemini per 100 g ([aiPer100g]) bila tidak
/// ada padanan — keduanya diskalakan ke [grams] yang bisa diubah pengguna.
class FoodScanItem {
  const FoodScanItem({required this.name, required this.grams, this.food, this.aiPer100g})
    : assert(food != null || aiPer100g != null);

  /// Nama dari Gemini (Bahasa Indonesia).
  final String name;
  final double grams;

  /// Padanan TKPI (null = estimasi AI).
  final Food? food;
  final Nutrients? aiPer100g;

  bool get isTkpi => food != null;

  /// Nama yang dicatat: nama TKPI bila cocok.
  String get displayName => food?.name ?? name;

  Nutrients get nutrients => (food?.per100g ?? aiPer100g!).forGrams(grams);

  FoodScanItem withGrams(double g) =>
      FoodScanItem(name: name, grams: g, food: food, aiPer100g: aiPer100g);
}

/// Hasil analisis satu foto (belum disimpan).
class FoodScanResult {
  const FoodScanResult({
    required this.dishName,
    required this.items,
    this.notes,
    required this.promptVersion,
    this.model,
    this.notFood = false,
  });

  /// Model menyatakan foto bukan makanan.
  final bool notFood;

  final String dishName;
  final List<FoodScanItem> items;
  final String? notes;
  final String promptVersion;
  final String? model;

  bool get isEmpty => items.isEmpty;

  Nutrients get totals => items.fold(Nutrients.zero, (s, i) => s + i.nutrients);
}

/// Hasil validasi keluaran model.
class FoodScanParse {
  const FoodScanParse({
    this.dishName,
    this.items = const [],
    this.notes,
    this.notFood = false,
    this.problems = const [],
  });

  final String? dishName;
  final List<FoodScanItem> items;
  final String? notes;

  /// Model menyatakan foto bukan makanan.
  final bool notFood;
  final List<String> problems;

  bool get isValid => problems.isEmpty;
}

/// Validasi & normalisasi JSON keluaran Gemini untuk scan makanan.
abstract final class FoodScanValidator {
  static const maxItems = 12;
  static const minGrams = 1.0;
  static const maxGrams = 2000.0;
  static const maxKcalPerItem = 5000.0;
  static const maxNameLength = 80;

  /// Toleransi kalori vs 4/4/9 × makro sebelum dihitung ulang.
  static const kcalTolerance = 0.25;

  /// [catalogByCode]: katalog TKPI per kode (mis. `AP001`).
  static FoodScanParse parse(String text, Map<String, Food> catalogByCode) {
    final Object? decoded;
    try {
      decoded = jsonDecode(text);
    } catch (_) {
      return const FoodScanParse(problems: ['Keluaran bukan JSON yang valid.']);
    }
    if (decoded is! Map<String, dynamic>) {
      return const FoodScanParse(problems: ['Keluaran harus berupa objek JSON.']);
    }
    final problems = <String>[];
    if (decoded['isFood'] == false) {
      return const FoodScanParse(notFood: true);
    }
    final dish = (decoded['dishName'] as String?)?.trim();
    final rawItems = decoded['items'];
    if (rawItems is! List || rawItems.isEmpty) {
      return const FoodScanParse(problems: ['"items" wajib berisi minimal satu makanan.']);
    }
    if (rawItems.length > maxItems) {
      problems.add('Maksimal $maxItems item; gabungkan bahan kecil.');
    }
    final items = <FoodScanItem>[];
    for (final (i, raw) in rawItems.take(maxItems).indexed) {
      final label = 'items[$i]';
      if (raw is! Map<String, dynamic>) {
        problems.add('$label bukan objek.');
        continue;
      }
      final name = (raw['name'] as String?)?.trim() ?? '';
      if (name.isEmpty || name.length > maxNameLength) {
        problems.add('$label.name wajib diisi (maks. $maxNameLength karakter).');
        continue;
      }
      final grams = (raw['grams'] as num?)?.toDouble();
      if (grams == null || grams < minGrams || grams > maxGrams) {
        problems.add('$label.grams harus $minGrams–$maxGrams.');
        continue;
      }
      final code = (raw['tkpiCode'] as String?)?.trim();
      // Kode yang tidak ada di katalog diabaikan → jatuh ke estimasi AI.
      final food = code == null || code.isEmpty ? null : catalogByCode[code];
      final estimate = _estimate(raw);
      if (food == null && estimate == null) {
        problems.add('$label: tanpa kode TKPI yang valid, kcal/protein/carbs/fat wajib wajar.');
        continue;
      }
      final g = grams.roundToDouble();
      items.add(
        FoodScanItem(name: name, grams: g, food: food, aiPer100g: estimate?.scale(100 / grams)),
      );
    }
    final notes = (decoded['notes'] as String?)?.trim();
    return FoodScanParse(
      dishName: dish == null || dish.isEmpty ? null : dish,
      items: items,
      notes: notes == null || notes.isEmpty ? null : notes,
      problems: problems,
    );
  }

  /// Perkiraan gizi untuk porsi item; kcal dihitung ulang dari makro bila
  /// selisihnya > [kcalTolerance]. `null` bila tidak lengkap/tidak wajar.
  static Nutrients? _estimate(Map<String, dynamic> raw) {
    double? n(String k) => (raw[k] as num?)?.toDouble();
    final kcal = n('kcal');
    final p = n('protein');
    final c = n('carbs');
    final f = n('fat');
    if (kcal == null || p == null || c == null || f == null) return null;
    if ([kcal, p, c, f].any((v) => v < 0) || kcal > maxKcalPerItem) return null;
    final fromMacros = 4 * p + 4 * c + 9 * f;
    final consistent = fromMacros == 0
        ? kcal < 5
        : (kcal - fromMacros).abs() <= kcalTolerance * math.max(kcal, fromMacros);
    return Nutrients(kcal: consistent ? kcal : fromMacros, protein: p, carbs: c, fat: f);
  }
}
