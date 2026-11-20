import 'food.dart';

/// Waktu makan (urutan = urutan tampil).
enum MealSlot { breakfast, lunch, dinner, snack }

/// Satu catatan makanan. Nilai gizi adalah **salinan** saat dicatat sehingga
/// riwayat tidak berubah bila katalog diperbarui.
class FoodLogEntry {
  const FoodLogEntry({
    required this.id,
    required this.date,
    required this.meal,
    required this.name,
    required this.nutrients,
    required this.quality,
    this.foodId,
    this.grams,
    this.planRef,
  });

  final String id;

  /// Tanggal lokal `YYYY-MM-DD`.
  final String date;
  final MealSlot meal;
  final String name;
  final Nutrients nutrients;
  final NutritionQuality quality;

  /// `null` untuk catatan manual (hanya kalori/makro).
  final String? foodId;
  final double? grams;

  /// `<mealPlanId>:<indeks waktu makan>` bila dicatat dari menu.
  final String? planRef;

  bool get isEstimate => quality != NutritionQuality.source;
}

/// Ringkasan satu hari terhadap target.
class DayNutrition {
  DayNutrition(this.entries, {this.target});

  final List<FoodLogEntry> entries;
  final Nutrients? target;

  late final Nutrients consumed = entries.fold(Nutrients.zero, (s, e) => s + e.nutrients);

  /// Sisa target (negatif = melebihi), `null` bila belum ada target.
  Nutrients? get remaining => target == null ? null : target! - consumed;

  List<FoodLogEntry> forMeal(MealSlot slot) => [
    for (final e in entries)
      if (e.meal == slot) e,
  ];

  bool get hasEstimates => entries.any((e) => e.isEstimate);
}
