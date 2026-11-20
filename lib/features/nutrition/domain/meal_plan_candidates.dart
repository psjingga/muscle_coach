import '../../assessment/domain/entities/assessment_data.dart';
import 'food.dart';
import 'food_search.dart';

/// Pilih bahan katalog yang boleh dipakai AI untuk menyusun menu, secara
/// deterministik (bukan diserahkan ke AI): pola makan, alergi, makanan yang
/// tidak disukai, produk bayi, dan data sumber yang tidak konsisten.
abstract final class MealPlanCandidates {
  static const _meatCategories = {'Daging', 'Ikan/Kerang/Udang dll'};
  static const _animalProductCategories = {'Telur', 'Susu'};

  static const _meatWords = [
    'daging',
    'ayam',
    'sapi',
    'kambing',
    'kerbau',
    'bebek',
    'itik',
    'ikan',
    'udang',
    'cumi',
    'kepiting',
    'kerang',
    'abon',
    'hati',
    'babat',
    'usus',
    'sosis',
    'kornet',
  ];
  static const _animalProductWords = ['telur', 'keju', 'mentega', 'yoghurt', 'yogurt', 'madu'];
  static final _excluded = RegExp(r'\b(bayi|asi)\b');

  /// Frasa yang harus dihindari (alergi + tidak disukai).
  static List<String> avoidPhrases(NutritionSection n) => [
    ...FoodSearch.phrases(n.allergies),
    ...FoodSearch.phrases(n.dislikes),
  ];

  static List<Food> select(Iterable<Food> catalog, NutritionSection n) {
    final avoid = avoidPhrases(n);
    final vegetarian = n.diet == Diet.vegetarian || n.diet == Diet.vegan;
    final vegan = n.diet == Diet.vegan;
    bool hasWord(String name, List<String> words) =>
        words.any((w) => RegExp('\\b$w').hasMatch(name));
    return [
      for (final f in catalog)
        if (f.origin == FoodOrigin.tkpi && f.code != null)
          if (f.quality == NutritionQuality.source)
            if (!_excluded.hasMatch(FoodSearch.normalize(f.name)))
              if (!vegetarian ||
                  (!_meatCategories.contains(f.category) &&
                      // "Telur ayam" / produk susu bukan daging.
                      (_animalProductCategories.contains(f.category) ||
                          !hasWord(FoodSearch.normalize(f.name), _meatWords))))
                if (!vegan ||
                    (!_animalProductCategories.contains(f.category) &&
                        !hasWord(FoodSearch.normalize(f.name), _animalProductWords) &&
                        !(FoodSearch.normalize(f.name).contains('susu') &&
                            !FoodSearch.normalize(f.name).contains('kedelai'))))
                  if (FoodSearch.matchPhrase(f.name, avoid) == null) f,
    ];
  }
}
