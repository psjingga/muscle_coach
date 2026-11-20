import 'dart:math' as math;

import 'food.dart';

/// Menyesuaikan gram bahan menu agar total mendekati target — deterministik,
/// oleh aplikasi (AI memilih bahan & perkiraan porsi; model bahasa tidak
/// andal menghitung gram × gizi).
///
/// Bahan dikelompokkan menurut makro penyumbang energi terbesar (protein /
/// karbohidrat / lemak). Tiap kelompok mendapat satu faktor skala yang dicari
/// dengan *coordinate descent* (kuadrat terkecil, galat relatif kcal &
/// makro), dibatasi [minScale]–[maxScale] agar porsi tetap wajar. Gram lalu
/// dibulatkan ke [step] g dan dibatasi [minGrams]–[maxGrams].
abstract final class PortionFitter {
  static const minScale = 0.4;
  static const maxScale = 2.5;
  static const step = 5.0;
  static const minGrams = 5.0;
  static const maxGrams = 600.0;

  /// Kelompok makro dominan sebuah bahan (0 protein, 1 karbo, 2 lemak).
  static int groupOf(Nutrients per100g) {
    final p = per100g.protein * 4;
    final c = per100g.carbs * 4;
    final f = per100g.fat * 9;
    if (p >= c && p >= f) return 0;
    return c >= f ? 1 : 2;
  }

  /// [items]: (per 100 g, gram awal). Mengembalikan gram baru (urutan sama).
  static List<double> fit(List<({Nutrients per100g, double grams})> items, Nutrients target) {
    if (items.isEmpty) return const [];
    // Kontribusi tiap kelompok pada gram awal.
    final group = [for (final i in items) groupOf(i.per100g)];
    final contrib = List.generate(3, (_) => Nutrients.zero);
    for (final (k, i) in items.indexed) {
      contrib[group[k]] = contrib[group[k]] + i.per100g.forGrams(i.grams);
    }
    List<double> vec(Nutrients n) => [n.kcal, n.protein, n.carbs, n.fat];
    final t = vec(target);
    // Bobot galat relatif: kalori (batas utama ±10 %) & protein lebih penting.
    const importance = [6.0, 3.0, 1.0, 1.0];
    final w = [for (final (m, x) in t.indexed) x <= 0 ? 0.0 : importance[m] / (x * x)];
    final a = [for (final c in contrib) vec(c)];
    final s = [1.0, 1.0, 1.0];
    for (var iter = 0; iter < 200; iter++) {
      for (var g = 0; g < 3; g++) {
        if (a[g].every((v) => v == 0)) continue;
        // Residual tanpa kelompok g; s_g optimal = Σ w·a_g·r / Σ w·a_g².
        var num = 0.0;
        var den = 0.0;
        for (var m = 0; m < 4; m++) {
          var others = 0.0;
          for (var h = 0; h < 3; h++) {
            if (h != g) others += s[h] * a[h][m];
          }
          num += w[m] * a[g][m] * (t[m] - others);
          den += w[m] * a[g][m] * a[g][m];
        }
        if (den > 0) s[g] = (num / den).clamp(minScale, maxScale);
      }
    }
    return [
      for (final (k, i) in items.indexed)
        ((i.grams * s[group[k]] / step).round() * step).clamp(minGrams, maxGrams).toDouble(),
    ];
  }

  /// `true` bila ada porsi yang berubah lebih dari 10 %.
  static bool changed(List<double> before, List<double> after) {
    for (var i = 0; i < before.length; i++) {
      if ((after[i] - before[i]).abs() > math.max(5, before[i] * 0.1)) return true;
    }
    return false;
  }
}
