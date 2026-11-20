import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/nutrition/data/tkpi_food_data_source.dart';
import 'package:musclecoach/features/nutrition/domain/food.dart';
import 'package:musclecoach/features/nutrition/domain/food_log.dart';
import 'package:musclecoach/features/nutrition/domain/food_search.dart';
import 'package:musclecoach/features/nutrition/domain/meal_plan.dart';
import 'package:musclecoach/features/nutrition/domain/meal_plan_candidates.dart';
import 'package:musclecoach/features/nutrition/domain/meal_plan_validator.dart';

final tkpi = TkpiAssetFoodDataSource.parse(File(TkpiAssetFoodDataSource.path).readAsStringSync());
Food byCode(String code) => tkpi.foods[Food.tkpiId(code)]!;

void main() {
  group('Katalog TKPI (aset)', () {
    test('1.144 makanan, kode unik, sumber & atribusi tercatat', () {
      expect(tkpi.foods, hasLength(1144));
      expect(tkpi.info.publisher, 'Kementerian Kesehatan Republik Indonesia');
      expect(tkpi.info.url, 'https://www.panganku.org');
      expect(tkpi.info.basis, contains('100 g'));
      final raw = jsonDecode(File(TkpiAssetFoodDataSource.path).readAsStringSync()) as Map;
      // Baris tanpa makro lengkap tidak dimasukkan (tidak ditebak).
      expect(raw['skipped'], hasLength(2));
    });

    test('angka sesuai sumber (cek acak)', () {
      final nasi = byCode('AP001');
      expect(nasi.name, 'Nasi');
      expect(nasi.per100g, const Nutrients(kcal: 180, protein: 3, carbs: 39.8, fat: 0.3));
      expect(byCode('CP077').per100g.protein, 20.8); // Tempe kedelai murni, mentah
      expect(byCode('HR002').ediblePct, 89); // Telur ayam ras: BDD 89 %
    });

    test('semua nilai tidak negatif; data tidak konsisten ditandai, bukan diubah', () {
      for (final f in tkpi.foods.values) {
        final n = f.per100g;
        expect([n.kcal, n.protein, n.carbs, n.fat].every((v) => v >= 0), isTrue, reason: f.name);
      }
      final flagged = tkpi.foods.values.where((f) => f.quality == NutritionQuality.inconsistent);
      expect(flagged, hasLength(16));
      // Contoh: Andewi tercatat 226 kcal meski makronya kecil — dibiarkan apa adanya.
      final andewi = flagged.firstWhere((f) => f.name.startsWith('Andewi'));
      expect(andewi.per100g.kcal, 226);
    });
  });

  group('Nutrients', () {
    test('per 100 g → gram, jumlah, selisih, pembulatan', () {
      const n = Nutrients(kcal: 180, protein: 3, carbs: 39.8, fat: 0.3);
      final p = n.forGrams(150);
      expect(p.kcal, 270);
      expect(p.carbs, closeTo(59.7, 1e-9));
      expect((p + n).kcal, 450);
      expect((n - p).kcal, -90);
      expect(
        const Nutrients(kcal: 1.26, protein: 1.234, carbs: 0, fat: 0).rounded(),
        const Nutrients(kcal: 1.3, protein: 1.23, carbs: 0, fat: 0),
      );
    });

    test('ringkasan hari: total, sisa, per waktu makan, ada estimasi', () {
      FoodLogEntry e(MealSlot m, double kcal, NutritionQuality q) => FoodLogEntry(
        id: '$m$kcal',
        date: '2026-11-20',
        meal: m,
        name: 'x',
        nutrients: Nutrients(kcal: kcal, protein: 10, carbs: 20, fat: 5),
        quality: q,
      );
      final day = DayNutrition([
        e(MealSlot.breakfast, 400, NutritionQuality.source),
        e(MealSlot.lunch, 700, NutritionQuality.source),
      ], target: const Nutrients(kcal: 2500, protein: 130, carbs: 300, fat: 70));
      expect(day.consumed.kcal, 1100);
      expect(day.remaining!.kcal, 1400);
      expect(day.remaining!.protein, 110);
      expect(day.forMeal(MealSlot.lunch), hasLength(1));
      expect(day.hasEstimates, isFalse);
      expect(DayNutrition([e(MealSlot.snack, 100, NutritionQuality.manual)]).hasEstimates, isTrue);
      expect(DayNutrition(const []).remaining, isNull);
    });
  });

  group('FoodSearch', () {
    final foods = tkpi.foods.values;

    test('nama yang diawali kueri lebih dulu; semua kata harus cocok', () {
      final r = FoodSearch.search(foods, 'nasi');
      expect(r.first.name, 'Nasi');
      expect(r.every((f) => FoodSearch.normalize(f.name).contains('nasi')), isTrue);
      final t = FoodSearch.search(foods, 'tempe goreng');
      expect(t.map((f) => f.code), contains('CP076'));
      expect(t.every((f) => f.name.toLowerCase().contains('goreng')), isTrue);
      expect(FoodSearch.search(foods, '   '), isEmpty);
      expect(FoodSearch.search(foods, 'zzzz-tidak-ada'), isEmpty);
    });

    test('tanda baca & huruf besar diabaikan', () {
      expect(FoodSearch.search(foods, 'BAYAM, REBUS').first.code, 'DP002');
    });

    test('makanan sendiri didahulukan pada peringkat yang sama', () {
      const mine = Food(
        id: 'custom:1',
        name: 'Nasi uduk warung',
        origin: FoodOrigin.custom,
        quality: NutritionQuality.userLabel,
        per100g: Nutrients.zero,
      );
      final r = FoodSearch.search([...foods, mine], 'nasi u');
      expect(r.first.id, 'custom:1');
    });

    test('frasa alergi/pantangan & pencocokan awal kata', () {
      final p = FoodSearch.phrases('Udang, kacang tanah; susu dan  ab');
      expect(p, ['udang', 'kacang tanah', 'susu']);
      expect(FoodSearch.matchPhrase('Udang segar', p), 'udang');
      expect(FoodSearch.matchPhrase('Kacang tanah, goreng', p), 'kacang tanah');
      // "susu" tidak boleh cocok di tengah kata lain.
      expect(FoodSearch.matchPhrase('Kesusuan', p), isNull);
    });
  });

  group('MealPlanCandidates', () {
    Iterable<String?> codes(NutritionSection n) =>
        MealPlanCandidates.select(tkpi.foods.values, n).map((f) => f.code);

    test('omnivora: tanpa data tidak konsisten & produk bayi', () {
      final c = MealPlanCandidates.select(tkpi.foods.values, const NutritionSection());
      expect(c.every((f) => f.quality == NutritionQuality.source), isTrue);
      expect(c.any((f) => FoodSearch.normalize(f.name).contains('bayi')), isFalse);
      expect(c.map((f) => f.code), contains('AP001'));
    });

    test('vegetarian tanpa daging/ikan; vegan juga tanpa telur & susu hewani', () {
      final veg = MealPlanCandidates.select(
        tkpi.foods.values,
        const NutritionSection(diet: Diet.vegetarian),
      );
      expect(
        veg.any((f) => f.category == 'Daging' || f.category == 'Ikan/Kerang/Udang dll'),
        isFalse,
      );
      expect(veg.any((f) => FoodSearch.normalize(f.name).contains('ayam goreng')), isFalse);
      expect(veg.map((f) => f.code), contains('HR002')); // telur boleh
      final vegan = codes(const NutritionSection(diet: Diet.vegan));
      expect(vegan, isNot(contains('HR002')));
      expect(vegan, isNot(contains('JR006'))); // susu sapi
      expect(vegan, contains('CP061')); // tahu
      // Susu nabati tetap boleh (CP060 di TKPI ditandai tidak konsisten, jadi pakai contoh).
      const soy = Food(
        id: 'tkpi:T1',
        code: 'T1',
        name: 'Susu kedelai bubuk',
        category: 'Kacang-Kacangan',
        origin: FoodOrigin.tkpi,
        quality: NutritionQuality.source,
        per100g: Nutrients.zero,
      );
      expect(MealPlanCandidates.select([soy], const NutritionSection(diet: Diet.vegan)), [soy]);
      expect(vegan, contains('CP077')); // tempe
    });

    test('alergi & tidak disukai dikeluarkan dari daftar', () {
      final c = MealPlanCandidates.select(
        tkpi.foods.values,
        const NutritionSection(allergies: 'udang', dislikes: 'tempe'),
      );
      expect(c.any((f) => FoodSearch.normalize(f.name).contains('udang')), isFalse);
      expect(c.any((f) => FoodSearch.normalize(f.name).startsWith('tempe')), isFalse);
    });
  });

  group('MealPlanValidator', () {
    // Target dibuat dari menu acuan agar mudah dikendalikan.
    const target = Nutrients(kcal: 1500, protein: 75, carbs: 200, fat: 45);
    final allowed = {
      for (final c in ['AP001', 'HR002', 'CP076', 'DP002', 'ER081', 'CP061']) c: byCode(c),
    };
    MealPlanContext ctx({int meals = 3, List<String> avoid = const []}) =>
        MealPlanContext(allowed: allowed, target: target, mealsPerDay: meals, avoidPhrases: avoid);

    Map<String, Object?> meal(String slot, List<(String, int)> items) => {
      'slot': slot,
      'title': 'Menu $slot',
      'items': [
        for (final (c, g) in items) {'code': c, 'grams': g},
      ],
    };

    // Total ≈ nasi 450 g (810) + telur 120 (185) + tempe goreng 100 (350) + bayam 150 (35)
    // + pisang 100 (109) = 1.489 kcal.
    Map<String, Object?> plan({List<Map<String, Object?>>? meals}) => {
      'schemaVersion': 1,
      'rationale': 'Menu sederhana.',
      'meals':
          meals ??
          [
            meal('breakfast', [('AP001', 150), ('HR002', 120)]),
            meal('lunch', [('AP001', 150), ('CP076', 100), ('DP002', 150)]),
            meal('dinner', [('AP001', 150), ('CP061', 150), ('ER081', 100)]),
          ],
    };

    MealPlanParseResult parse(Object json, [MealPlanContext? c]) =>
        MealPlanValidator.parse(json is String ? json : jsonEncode(json), c ?? ctx());

    test('menu valid: total dihitung ulang dari katalog × gram', () {
      final r = parse(plan());
      expect(r.problems, isEmpty);
      final p = r.plan!;
      expect(p.meals, hasLength(3));
      final expected = [
        byCode('AP001').per100g.forGrams(450),
        byCode('HR002').per100g.forGrams(120),
        byCode('CP076').per100g.forGrams(100),
        byCode('DP002').per100g.forGrams(150),
        byCode('CP061').per100g.forGrams(150),
        byCode('ER081').per100g.forGrams(100),
      ].fold(Nutrients.zero, (s, n) => s + n);
      expect(p.totals.kcal, closeTo(expected.kcal, 0.5));
      expect(p.meals.first.items.first.foodId, 'tkpi:AP001');
      expect(p.target, target);
    });

    test('JSON rusak / versi schema salah', () {
      expect(parse('bukan json').problems.single, startsWith('invalid_json'));
      expect(
        parse({...plan(), 'schemaVersion': 2}).problems,
        contains(startsWith('schema_version')),
      );
    });

    test('kode di luar daftar, gram di luar batas, bahan yang dihindari', () {
      final r = parse(
        plan(
          meals: [
            meal('breakfast', [('XX999', 100), ('HR002', 2)]),
            meal('lunch', [('AP001', 900)]),
            meal('dinner', [('CP061', 100)]),
          ],
        ),
        ctx(avoid: ['tahu']),
      );
      expect(r.isValid, isFalse);
      expect(r.problems, contains(contains('"XX999" tidak ada')));
      expect(r.problems.where((p) => p.contains('.grams')), hasLength(2));
      expect(r.problems, contains(contains('"tahu" yang harus dihindari')));
    });

    test('jumlah & slot waktu makan', () {
      final dup = parse(
        plan(
          meals: [
            meal('lunch', [('AP001', 300)]),
            meal('lunch', [('AP001', 300)]),
            meal('snack', [('ER081', 100)]),
          ],
        ),
      );
      expect(dup.problems, contains(contains('lebih dari sekali')));
      expect(dup.problems, contains(contains('wajib ada breakfast, lunch, dan dinner')));
      expect(parse(plan(), ctx(meals: 4)).problems, contains(contains('tepat 4 waktu makan')));
    });

    test('total jauh dari target → masalah berisi angka hitungan aplikasi', () {
      final r = parse(
        plan(
          meals: [
            meal('breakfast', [('DP002', 100)]),
            meal('lunch', [('DP002', 100)]),
            meal('dinner', [('DP002', 100)]),
          ],
        ),
      );
      expect(r.problems, contains(allOf(startsWith('total_kcal'), contains('69 kcal'))));
      expect(r.problems, contains(startsWith('total_protein')));
    });

    test('bahan dengan data tidak konsisten memberi peringatan', () {
      final andewi = tkpi.foods.values.firstWhere((f) => f.name.startsWith('Andewi'));
      final r = parse(
        plan(
          meals: [
            meal('breakfast', [('AP001', 150), ('HR002', 120)]),
            meal('lunch', [('AP001', 150), ('CP076', 100), (andewi.code!, 15)]),
            meal('dinner', [('AP001', 150), ('CP061', 150), ('ER081', 100)]),
          ],
        ),
        MealPlanContext(
          allowed: {...allowed, andewi.code!: andewi},
          target: target,
          mealsPerDay: 3,
        ),
      );
      expect(r.problems, isEmpty);
      expect(r.plan!.warnings, [MealPlanWarning.inconsistentData]);
    });

    test('MealPlan toJson/fromJson bolak-balik', () {
      final p = parse(plan()).plan!;
      final back = MealPlan.fromJson(jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>);
      expect(back.meals.length, 3);
      expect(back.totals.kcal, closeTo(p.totals.kcal, 1e-9));
      expect(back.meals[1].items[1].quality, NutritionQuality.source);
    });
  });
}
