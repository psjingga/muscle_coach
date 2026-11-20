import 'dart:convert';

import 'food.dart';
import 'food_log.dart';
import 'food_search.dart';
import 'meal_plan.dart';
import 'portion_fitter.dart';

/// Batas validasi menu (dapat diubah tanpa menyentuh UI).
abstract final class MealPlanRules {
  static const schemaVersion = 1;
  static const minItemGrams = 5.0;
  static const maxItemGrams = 600.0;
  static const maxItemsPerMeal = 8;
  static const maxTitle = 80;
  static const maxRationale = 400;

  /// Total kalori menu harus dalam ±10 % target.
  static const kcalTolerance = 0.10;

  /// Protein minimal 90 % target, maksimal 130 %.
  static const proteinMin = 0.90;
  static const proteinMax = 1.30;

  /// Lemak & karbohidrat ±30 % target.
  static const macroTolerance = 0.30;
}

/// Konteks validasi: katalog yang boleh dipakai & preferensi pengguna.
class MealPlanContext {
  const MealPlanContext({
    required this.allowed,
    required this.target,
    required this.mealsPerDay,
    this.avoidPhrases = const [],
    this.fitPortions = false,
  });

  /// Makanan yang boleh dipakai, kunci = kode TKPI.
  final Map<String, Food> allowed;
  final Nutrients target;
  final int mealsPerDay;

  /// Frasa alergi/pantangan yang tidak boleh muncul di nama bahan.
  final List<String> avoidPhrases;

  /// Sesuaikan gram dengan [PortionFitter] sebelum total dibandingkan.
  final bool fitPortions;
}

class MealPlanParseResult {
  const MealPlanParseResult.ok(MealPlan this.plan) : problems = const [];
  const MealPlanParseResult.invalid(this.problems) : plan = null;

  final MealPlan? plan;
  final List<String> problems;

  bool get isValid => plan != null;
}

/// Parse & validasi output AI. Angka gizi dari AI TIDAK dipakai — total
/// dihitung ulang dari katalog × gram, lalu dibandingkan dengan target.
abstract final class MealPlanValidator {
  static const _mainSlots = {MealSlot.breakfast, MealSlot.lunch, MealSlot.dinner};

  static String _clip(String? s, int max) {
    final t = (s ?? '').trim();
    return t.length <= max ? t : '${t.substring(0, max - 1)}…';
  }

  static MealPlanParseResult parse(String raw, MealPlanContext ctx) {
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return const MealPlanParseResult.invalid([
        'invalid_json: keluaran bukan JSON objek yang valid',
      ]);
    }
    final problems = <String>[];
    if (json['schemaVersion'] != MealPlanRules.schemaVersion) {
      problems.add('schema_version: schemaVersion harus ${MealPlanRules.schemaVersion}');
    }
    final rawMeals = json['meals'];
    if (rawMeals is! List || rawMeals.isEmpty) {
      return MealPlanParseResult.invalid([...problems, 'meals: minimal satu waktu makan']);
    }
    if (rawMeals.length != ctx.mealsPerDay) {
      problems.add('meals: harus tepat ${ctx.mealsPerDay} waktu makan, bukan ${rawMeals.length}');
    }

    var meals = <PlannedMeal>[];
    final mealFoods = <List<Food>>[];
    final usedMain = <MealSlot>{};
    for (final (i, m) in rawMeals.indexed) {
      if (m is! Map<String, dynamic>) {
        problems.add('meals[$i]: format tidak valid');
        continue;
      }
      final slot = MealSlot.values.asNameMap()[m['slot']];
      if (slot == null) {
        problems.add('meals[$i].slot: "${m['slot']}" tidak dikenal');
        continue;
      }
      if (_mainSlots.contains(slot) && !usedMain.add(slot)) {
        problems.add(
          'meals[$i].slot: ${slot.name} muncul lebih dari sekali (hanya snack boleh berulang)',
        );
      }
      final title = _clip(m['title'] as String?, MealPlanRules.maxTitle);
      if (title.isEmpty) problems.add('meals[$i].title: wajib diisi');
      final rawItems = m['items'];
      if (rawItems is! List || rawItems.isEmpty) {
        problems.add('meals[$i].items: minimal satu bahan');
        continue;
      }
      if (rawItems.length > MealPlanRules.maxItemsPerMeal) {
        problems.add('meals[$i].items: maksimal ${MealPlanRules.maxItemsPerMeal} bahan');
      }
      final items = <PlannedFood>[];
      final foods = <Food>[];
      for (final (j, it) in rawItems.indexed) {
        final where = 'meals[$i].items[$j]';
        if (it is! Map<String, dynamic>) {
          problems.add('$where: format tidak valid');
          continue;
        }
        final code = it['code'];
        final food = code is String ? ctx.allowed[code] : null;
        if (food == null) {
          problems.add('$where.code: "$code" tidak ada di daftar katalog yang diizinkan');
          continue;
        }
        final avoided = FoodSearch.matchPhrase(food.name, ctx.avoidPhrases);
        if (avoided != null) {
          problems.add('$where: "${food.name}" mengandung "$avoided" yang harus dihindari');
        }
        final grams = it['grams'];
        if (grams is! num ||
            grams < MealPlanRules.minItemGrams ||
            grams > MealPlanRules.maxItemGrams) {
          problems.add(
            '$where.grams: harus ${MealPlanRules.minItemGrams.round()}–'
            '${MealPlanRules.maxItemGrams.round()} g',
          );
          continue;
        }
        final g = grams.roundToDouble();
        foods.add(food);
        items.add(
          PlannedFood(
            foodId: food.id,
            name: food.name,
            grams: g,
            nutrients: food.per100g.forGrams(g).rounded(),
            quality: food.quality,
          ),
        );
      }
      meals.add(PlannedMeal(slot: slot, title: title, items: items));
      mealFoods.add(foods);
    }
    if (ctx.mealsPerDay >= 3 && !usedMain.containsAll(_mainSlots)) {
      problems.add('meals: wajib ada breakfast, lunch, dan dinner');
    }

    var adjusted = false;
    if (problems.isEmpty && ctx.fitPortions) {
      final flat = [
        for (final (i, m) in meals.indexed)
          for (final (j, item) in m.items.indexed)
            (per100g: mealFoods[i][j].per100g, grams: item.grams),
      ];
      final fitted = PortionFitter.fit(flat, ctx.target);
      adjusted = PortionFitter.changed([for (final f in flat) f.grams], fitted);
      var k = 0;
      meals = [
        for (final (i, m) in meals.indexed)
          PlannedMeal(
            slot: m.slot,
            title: m.title,
            items: [
              for (final (j, item) in m.items.indexed)
                () {
                  final g = fitted[k++];
                  return PlannedFood(
                    foodId: item.foodId,
                    name: item.name,
                    grams: g,
                    nutrients: mealFoods[i][j].per100g.forGrams(g).rounded(),
                    quality: item.quality,
                  );
                }(),
            ],
          ),
      ];
    }
    if (problems.isEmpty) {
      final totalProblems = _checkTotals(
        meals.fold(Nutrients.zero, (s, m) => s + m.totals),
        ctx.target,
      );
      if (totalProblems.isNotEmpty && ctx.fitPortions) {
        problems
          ..addAll(totalProblems)
          ..add(
            'komposisi: total masih di luar batas meski porsi sudah disesuaikan aplikasi '
            '(skala ${PortionFitter.minScale}–${PortionFitter.maxScale}×). Ubah PILIHAN bahan: '
            'kurangi bahan tinggi lemak bila lemak berlebih, tambah sumber protein/karbohidrat '
            'yang kurang.',
          );
      } else {
        problems.addAll(totalProblems);
      }
    }
    if (problems.isNotEmpty) return MealPlanParseResult.invalid(problems);

    final hasInconsistent = meals.any(
      (m) => m.items.any((i) => i.quality == NutritionQuality.inconsistent),
    );
    return MealPlanParseResult.ok(
      MealPlan(
        meals: meals,
        target: ctx.target,
        rationale: _clip(json['rationale'] as String?, MealPlanRules.maxRationale),
        warnings: [
          if (hasInconsistent) MealPlanWarning.inconsistentData,
          if (adjusted) MealPlanWarning.portionsAdjusted,
        ],
      ),
    );
  }

  /// Bandingkan total (dihitung aplikasi) dengan target.
  static List<String> _checkTotals(Nutrients total, Nutrients target) {
    final p = <String>[];
    String n(double v) => v.round().toString();
    final kcalLo = target.kcal * (1 - MealPlanRules.kcalTolerance);
    final kcalHi = target.kcal * (1 + MealPlanRules.kcalTolerance);
    if (total.kcal < kcalLo || total.kcal > kcalHi) {
      p.add(
        'total_kcal: total ${n(total.kcal)} kcal (dihitung dari katalog × gram) harus '
        '${n(kcalLo)}–${n(kcalHi)} kcal; sesuaikan gram',
      );
    }
    final pLo = target.protein * MealPlanRules.proteinMin;
    final pHi = target.protein * MealPlanRules.proteinMax;
    if (total.protein < pLo || total.protein > pHi) {
      p.add('total_protein: ${n(total.protein)} g harus ${n(pLo)}–${n(pHi)} g');
    }
    for (final (name, got, want) in [
      ('total_fat', total.fat, target.fat),
      ('total_carbs', total.carbs, target.carbs),
    ]) {
      final lo = want * (1 - MealPlanRules.macroTolerance);
      final hi = want * (1 + MealPlanRules.macroTolerance);
      if (got < lo || got > hi) p.add('$name: ${n(got)} g harus ${n(lo)}–${n(hi)} g');
    }
    return p;
  }
}
