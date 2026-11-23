/// Energi & makro. Satuan: kcal dan gram.
class Nutrients {
  const Nutrients({
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  static const zero = Nutrients(kcal: 0, protein: 0, carbs: 0, fat: 0);

  final double kcal;
  final double protein;
  final double carbs;
  final double fat;

  /// Nilai per 100 g → nilai untuk [grams].
  Nutrients forGrams(double grams) => scale(grams / 100);

  Nutrients scale(double factor) => Nutrients(
    kcal: kcal * factor,
    protein: protein * factor,
    carbs: carbs * factor,
    fat: fat * factor,
  );

  Nutrients operator +(Nutrients o) => Nutrients(
    kcal: kcal + o.kcal,
    protein: protein + o.protein,
    carbs: carbs + o.carbs,
    fat: fat + o.fat,
  );

  Nutrients operator -(Nutrients o) => this + o.scale(-1);

  /// Pembulatan untuk disimpan: kcal 0,1; makro 0,01.
  Nutrients rounded() => Nutrients(
    kcal: _r(kcal, 10),
    protein: _r(protein, 100),
    carbs: _r(carbs, 100),
    fat: _r(fat, 100),
  );

  static double _r(double v, int f) => (v * f).roundToDouble() / f;

  factory Nutrients.fromJson(Map<String, dynamic> json) => Nutrients(
    kcal: (json['kcal'] as num).toDouble(),
    protein: (json['protein'] as num).toDouble(),
    carbs: (json['carbs'] as num).toDouble(),
    fat: (json['fat'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {'kcal': kcal, 'protein': protein, 'carbs': carbs, 'fat': fat};

  @override
  bool operator ==(Object other) =>
      other is Nutrients &&
      other.kcal == kcal &&
      other.protein == protein &&
      other.carbs == carbs &&
      other.fat == fat;

  @override
  int get hashCode => Object.hash(kcal, protein, carbs, fat);

  @override
  String toString() => 'Nutrients($kcal kcal, P $protein, C $carbs, F $fat)';
}

/// Asal data makanan.
enum FoodOrigin { tkpi, custom }

/// Tingkat kepastian angka gizi (brief: simpan sumber & tingkat kepastian).
enum NutritionQuality {
  /// Angka apa adanya dari sumber tepercaya (TKPI).
  source,

  /// Dari sumber, tetapi energi tidak konsisten dengan 4/4/9 × makro.
  inconsistent,

  /// Dimasukkan pengguna dari label kemasan.
  userLabel,

  /// Angka kalori/makro dicatat langsung oleh pengguna.
  manual,

  /// Perkiraan Gemini dari foto (tidak ada padanan TKPI) — kasar.
  aiEstimate,
}

/// Makanan dari katalog. Nilai gizi selalu **per 100 g bagian yang dapat
/// dimakan**; nilai per porsi dihitung dari gram oleh aplikasi.
class Food {
  const Food({
    required this.id,
    required this.name,
    required this.origin,
    required this.per100g,
    required this.quality,
    this.code,
    this.category,
    this.raw,
    this.note,
    this.region,
    this.fiber,
    this.ediblePct,
    this.defaultGrams,
  });

  /// `tkpi:<kode>` atau `custom:<id>`.
  final String id;
  final String name;
  final FoodOrigin origin;
  final Nutrients per100g;
  final NutritionQuality quality;

  /// Kode TKPI (mis. `AP001`).
  final String? code;
  final String? category;

  /// `true` mentah, `false` olahan/masakan, `null` tidak diketahui.
  final bool? raw;
  final String? note;
  final String? region;
  final double? fiber;

  /// Bagian dapat dimakan (%) — mis. pisang 75: kulit tidak dihitung.
  final double? ediblePct;

  /// Porsi bawaan dari label (makanan sendiri).
  final double? defaultGrams;

  static String tkpiId(String code) => 'tkpi:$code';
  static String customId(String id) => 'custom:$id';
}
