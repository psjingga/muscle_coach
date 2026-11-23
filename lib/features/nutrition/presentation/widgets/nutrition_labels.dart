import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/food.dart';
import '../../domain/food_log.dart';

extension NutritionLabels on AppLocalizations {
  String meal(MealSlot slot) => switch (slot) {
    MealSlot.breakfast => breakfastLabel,
    MealSlot.lunch => lunchLabel,
    MealSlot.dinner => dinnerLabel,
    MealSlot.snack => snackLabel,
  };

  String kcal(double v) => kcalValue(Fmt.integer(v));

  /// "P 12,3 · K 40 · L 5,1"
  String macros(Nutrients n) => entryMacros(Fmt.one(n.protein), Fmt.one(n.carbs), Fmt.one(n.fat));

  /// Label kepastian data, `null` untuk data sumber.
  String? qualityBadge(NutritionQuality q) => switch (q) {
    NutritionQuality.source => null,
    NutritionQuality.inconsistent => foodInconsistentBadge,
    NutritionQuality.userLabel => entryLabel,
    NutritionQuality.manual => entryManual,
    NutritionQuality.aiEstimate => entryAiEstimate,
  };
}

/// Pembulatan tampilan gram: 150 / 72,5.
String gramsText(double g) => Fmt.one(g);
