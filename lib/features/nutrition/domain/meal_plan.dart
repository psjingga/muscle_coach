import 'food.dart';
import 'food_log.dart';

enum MealPlanStatus { draft, active, archived }

/// Satu bahan dalam menu. Nilai gizi dihitung aplikasi dari katalog × gram.
class PlannedFood {
  const PlannedFood({
    required this.foodId,
    required this.name,
    required this.grams,
    required this.nutrients,
    required this.quality,
  });

  final String foodId;
  final String name;
  final double grams;
  final Nutrients nutrients;
  final NutritionQuality quality;

  factory PlannedFood.fromJson(Map<String, dynamic> j) => PlannedFood(
    foodId: j['foodId'] as String,
    name: j['name'] as String,
    grams: (j['grams'] as num).toDouble(),
    nutrients: Nutrients.fromJson(j['nutrients'] as Map<String, dynamic>),
    quality: NutritionQuality.values.byName(j['quality'] as String),
  );

  Map<String, dynamic> toJson() => {
    'foodId': foodId,
    'name': name,
    'grams': grams,
    'nutrients': nutrients.toJson(),
    'quality': quality.name,
  };
}

class PlannedMeal {
  const PlannedMeal({required this.slot, required this.title, required this.items});

  final MealSlot slot;
  final String title;
  final List<PlannedFood> items;

  Nutrients get totals => items.fold(Nutrients.zero, (s, i) => s + i.nutrients);

  factory PlannedMeal.fromJson(Map<String, dynamic> j) => PlannedMeal(
    slot: MealSlot.values.byName(j['slot'] as String),
    title: j['title'] as String,
    items: [
      for (final i in j['items'] as List<dynamic>) PlannedFood.fromJson(i as Map<String, dynamic>),
    ],
  );

  Map<String, dynamic> toJson() => {
    'slot': slot.name,
    'title': title,
    'items': [for (final i in items) i.toJson()],
  };
}

/// Menu harian (contoh) hasil AI yang sudah divalidasi aplikasi.
class MealPlan {
  const MealPlan({
    this.id = '',
    this.status = MealPlanStatus.draft,
    required this.meals,
    required this.target,
    required this.rationale,
    this.warnings = const [],
    this.model,
    this.promptVersion,
    this.catalogVersion,
  });

  final String id;
  final MealPlanStatus status;
  final List<PlannedMeal> meals;

  /// Salinan target saat menu disusun.
  final Nutrients target;
  final String rationale;

  /// Kode peringatan (lihat `MealPlanWarning`).
  final List<String> warnings;
  final String? model;
  final String? promptVersion;
  final String? catalogVersion;

  Nutrients get totals => meals.fold(Nutrients.zero, (s, m) => s + m.totals);

  MealPlan copyWith({String? id, MealPlanStatus? status}) => MealPlan(
    id: id ?? this.id,
    status: status ?? this.status,
    meals: meals,
    target: target,
    rationale: rationale,
    warnings: warnings,
    model: model,
    promptVersion: promptVersion,
    catalogVersion: catalogVersion,
  );

  factory MealPlan.fromJson(Map<String, dynamic> j) => MealPlan(
    meals: [
      for (final m in j['meals'] as List<dynamic>) PlannedMeal.fromJson(m as Map<String, dynamic>),
    ],
    target: Nutrients.fromJson(j['target'] as Map<String, dynamic>),
    rationale: j['rationale'] as String? ?? '',
    warnings: [for (final w in j['warnings'] as List<dynamic>? ?? const []) w as String],
  );

  /// Isi kolom `data` (metadata disimpan di kolom terpisah).
  Map<String, dynamic> toJson() => {
    'schemaVersion': 1,
    'meals': [for (final m in meals) m.toJson()],
    'target': target.toJson(),
    'rationale': rationale,
    'warnings': warnings,
  };
}

/// Kode peringatan pada menu.
abstract final class MealPlanWarning {
  /// Pengguna punya riwayat gangguan makan → sarankan pendampingan profesional.
  static const eatingDisorder = 'eating_disorder_history';

  /// Ada alergi tercatat; pengecekan aplikasi hanya berdasarkan nama bahan.
  static const allergyCheck = 'allergy_name_check_only';

  /// Ada bahan yang angka sumbernya tidak konsisten.
  static const inconsistentData = 'inconsistent_source_data';
}
