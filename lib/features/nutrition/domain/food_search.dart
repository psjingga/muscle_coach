import 'food.dart';

/// Pencarian katalog makanan (lokal, tanpa jaringan).
abstract final class FoodSearch {
  static final _nonWord = RegExp(r'[^a-z0-9]+');

  /// Huruf kecil, tanda baca → spasi.
  static String normalize(String s) => s.toLowerCase().replaceAll(_nonWord, ' ').trim();

  /// Semua kata kueri harus muncul di nama. Urutan: nama diawali kueri →
  /// ada kata yang diawali kata pertama → sisanya; lalu makanan sendiri,
  /// nama terpendek, alfabet.
  static List<Food> search(Iterable<Food> foods, String query, {int limit = 60}) {
    final q = normalize(query);
    if (q.isEmpty) return const [];
    final tokens = q.split(' ');
    final scored = <(int, Food)>[];
    for (final f in foods) {
      final name = normalize(f.name);
      if (!tokens.every(name.contains)) continue;
      final words = name.split(' ');
      final rank = name.startsWith(q)
          ? 0
          : words.any((w) => w.startsWith(tokens.first))
          ? 1
          : 2;
      scored.add((rank, f));
    }
    scored.sort((a, b) {
      final r = a.$1.compareTo(b.$1);
      if (r != 0) return r;
      final o = a.$2.origin.index.compareTo(b.$2.origin.index) * -1;
      if (o != 0) return o;
      final l = a.$2.name.length.compareTo(b.$2.name.length);
      return l != 0 ? l : a.$2.name.compareTo(b.$2.name);
    });
    return [for (final s in scored.take(limit)) s.$2];
  }

  /// Frasa dari teks bebas (mis. alergi "udang, kacang tanah; susu").
  static List<String> phrases(String? text) => [
    for (final p in (text ?? '').toLowerCase().split(RegExp(r'[,;/\n]|\bdan\b')))
      if (normalize(p).length >= 3) normalize(p),
  ];

  /// Frasa pertama yang muncul di nama makanan, atau `null`.
  static String? matchPhrase(String foodName, List<String> phrases) {
    final name = ' ${normalize(foodName)} ';
    for (final p in phrases) {
      if (name.contains(' $p')) return p;
    }
    return null;
  }
}
