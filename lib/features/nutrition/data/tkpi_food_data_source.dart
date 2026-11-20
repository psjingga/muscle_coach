import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/food.dart';

/// Informasi sumber katalog (ditampilkan sebagai atribusi).
class FoodSourceInfo {
  const FoodSourceInfo({
    required this.version,
    required this.name,
    required this.publisher,
    required this.url,
    required this.retrieved,
    required this.basis,
  });

  final String version;
  final String name;
  final String publisher;
  final String url;
  final String retrieved;
  final String basis;
}

/// Abstraksi sumber data makanan (brief §8): kelak bisa diganti/ditambah
/// database lain tanpa mengubah UI.
abstract interface class FoodDataSource {
  Future<FoodSourceInfo> info();

  /// Semua makanan, kunci = `Food.id`.
  Future<Map<String, Food>> foods();
}

/// Katalog TKPI (Kemenkes RI, via panganku.org) yang dibundel sebagai aset.
/// Dibangun ulang dengan `tool/food_catalog/build_tkpi_catalog.py`.
class TkpiAssetFoodDataSource implements FoodDataSource {
  TkpiAssetFoodDataSource(this._bundle);

  final AssetBundle _bundle;
  Future<({FoodSourceInfo info, Map<String, Food> foods})>? _cache;

  static const path = 'assets/catalog/foods_tkpi.json';

  /// Parse isi file katalog (dipakai juga oleh test).
  static ({FoodSourceInfo info, Map<String, Food> foods}) parse(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final s = json['source'] as Map<String, dynamic>;
    final info = FoodSourceInfo(
      version: json['version'] as String,
      name: s['name'] as String,
      publisher: s['publisher'] as String,
      url: s['url'] as String,
      retrieved: s['retrieved'] as String,
      basis: s['basis'] as String,
    );
    double? d(Object? v) => (v as num?)?.toDouble();
    final foods = <String, Food>{};
    for (final f in json['foods'] as List<dynamic>) {
      final m = f as Map<String, dynamic>;
      final code = m['code'] as String;
      final food = Food(
        id: Food.tkpiId(code),
        code: code,
        name: m['name'] as String,
        origin: FoodOrigin.tkpi,
        category: m['category'] as String?,
        raw: m['form'] == 'raw',
        note: m['note'] as String?,
        region: m['origin'] as String?,
        fiber: d(m['fiber']),
        ediblePct: d(m['ediblePct']),
        quality: m['quality'] == 'inconsistent'
            ? NutritionQuality.inconsistent
            : NutritionQuality.source,
        per100g: Nutrients(
          kcal: d(m['kcal'])!,
          protein: d(m['protein'])!,
          carbs: d(m['carbs'])!,
          fat: d(m['fat'])!,
        ),
      );
      foods[food.id] = food;
    }
    return (info: info, foods: foods);
  }

  Future<({FoodSourceInfo info, Map<String, Food> foods})> _load() =>
      _cache ??= _bundle.loadString(path).then(parse);

  @override
  Future<FoodSourceInfo> info() async => (await _load()).info;

  @override
  Future<Map<String, Food>> foods() async => (await _load()).foods;
}
