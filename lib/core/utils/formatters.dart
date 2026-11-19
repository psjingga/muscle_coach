import 'package:intl/intl.dart';

/// Format angka & tanggal gaya Indonesia (koma desimal, titik ribuan).
abstract final class Fmt {
  static final _int = NumberFormat.decimalPattern('id');
  static final _one = NumberFormat('#,##0.#', 'id');
  static final _two = NumberFormat('#,##0.##', 'id');

  /// Bilangan bulat dengan pemisah ribuan: 2.450
  static String integer(num v) => _int.format(v.round());

  /// Maks. 1 desimal: 72,5
  static String one(num v) => _one.format(v);

  /// Maks. 2 desimal: 0,35
  static String two(num v) => _two.format(v);

  /// Selisih bertanda: +4 / −2,5
  static String signed(num v) => v > 0 ? '+${one(v)}' : (v < 0 ? '−${one(-v)}' : '0');

  /// 6 Mei 2027
  static String date(DateTime d) => DateFormat.yMMMMd('id').format(d);

  /// `YYYY-MM-DD` → 6 Mei 2027
  static String isoDate(String iso) {
    final d = DateTime.tryParse(iso);
    return d == null ? iso : date(d);
  }

  static String toIsoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Parse input angka pengguna ("72,5" atau "72.5"); `null` bila kosong/tidak valid.
  static double? parseDecimal(String input) {
    final s = input.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  static int? parseInt(String input) {
    final s = input.trim().replaceAll('.', '').replaceAll(' ', '');
    if (s.isEmpty) return null;
    return int.tryParse(s);
  }
}
