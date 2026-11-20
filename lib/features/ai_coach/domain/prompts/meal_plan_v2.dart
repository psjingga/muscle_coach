import 'dart:convert';

import '../../../assessment/domain/entities/assessment_data.dart';
import '../../../nutrition/domain/food.dart';
import '../../../nutrition/domain/meal_plan_validator.dart';

/// Prompt penyusunan contoh menu harian, versi 2 (v2: katalog dipersingkat,
/// porsi disesuaikan aplikasi — model cukup memilih bahan & perkiraan gram). Ubah [version] bila isi
/// prompt atau schema berubah — versi tercatat di menu & log generasi.
abstract final class MealPlanPromptV2 {
  static const version = 'meal_plan.v2';

  static const systemInstruction = '''
Anda adalah penyusun DRAFT contoh menu harian yang bersifat edukatif untuk aplikasi Muscle Coach — bukan dokter atau ahli gizi.
Tugas: susun satu hari menu makanan Indonesia yang realistis, mudah ditemukan, dan sesuai target energi & makro pengguna.

Aturan wajib:
1. HANYA gunakan bahan dari "katalog" (Tabel Komposisi Pangan Indonesia). Rujuk dengan "code". Jangan mengarang makanan atau kode.
2. Kolom katalog: code|nama|kcal|protein|lemak|karbohidrat — per 100 g bagian yang dapat dimakan. Salin "code" persis dari katalog.
3. Pilih bahan yang komposisinya cocok dengan "target" (cukup protein, lemak tidak berlebihan) dan perkirakan gramnya. Aplikasi menghitung ulang total dan menyesuaikan porsi; angka buatan Anda tidak dipakai.
4. Buat tepat "jumlahWaktuMakan" waktu makan. slot: breakfast, lunch, dinner masing-masing maksimal sekali; snack boleh lebih dari sekali. Bila jumlahnya ≥ 3, wajib ada breakfast, lunch, dan dinner.
5. Patuhi "polaMakan". Jangan gunakan bahan yang disebut di "alergi" atau "tidakDisukai"; ikuti "preferensi" dan "pantangan/catatan" bila masuk akal.
6. Pertimbangkan "anggaranHarianRp" dan "aksesMemasak" (catering: pilih masakan jadi yang umum dijual).
7. Gram harus porsi wajar (bilangan bulat). Utamakan makanan jadi/olahan (mis. "Nasi", "Tempe goreng") daripada bahan mentah agar porsi mudah diikuti.
8. "title" = nama hidangan singkat dalam Bahasa Indonesia. "rationale" = alasan singkat (maks. 2 kalimat), tanpa klaim kesehatan atau janji hasil.
Keluaran: JSON saja sesuai schema.''';

  /// Konteks minimum: target harian & preferensi makan. Tanpa nama, umur,
  /// berat/tinggi, jenis kelamin, atau kondisi medis.
  static String userContent(
    NutritionSection n, {
    required Nutrients target,
    required List<Food> catalog,
  }) {
    String? t(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
    String r(double v) => v.round().toString();
    String d(double v) => v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(1);
    final payload = {
      'target': {
        'kcal': target.kcal.round(),
        'proteinG': target.protein.round(),
        'karbohidratG': target.carbs.round(),
        'lemakG': target.fat.round(),
      },
      'jumlahWaktuMakan': n.mealsPerDay ?? 3,
      'polaMakan': n.diet?.name,
      'alergi': t(n.allergies),
      'tidakDisukai': t(n.dislikes),
      'preferensi': t(n.preferences),
      'anggaranHarianRp': n.dailyBudgetIdr,
      'aksesMemasak': n.cooking?.name,
      'catatan': t(n.notes),
      'negara': n.country,
      'batas': {
        'kcal': [
          r(target.kcal * (1 - MealPlanRules.kcalTolerance)),
          r(target.kcal * (1 + MealPlanRules.kcalTolerance)),
        ],
        'proteinG': [
          r(target.protein * MealPlanRules.proteinMin),
          r(target.protein * MealPlanRules.proteinMax),
        ],
        'gramPerBahan': [MealPlanRules.minItemGrams.round(), MealPlanRules.maxItemGrams.round()],
        'bahanPerWaktuMakan': MealPlanRules.maxItemsPerMeal,
      },
      'katalog': [
        for (final f in catalog)
          '${f.code}|${_shortName(f.name)}|${d(f.per100g.kcal)}|'
              '${d(f.per100g.protein)}|${d(f.per100g.fat)}|${d(f.per100g.carbs)}',
      ],
    };
    return jsonEncode(payload);
  }

  /// Nama tanpa terjemahan Inggris di akhir — menghemat token.
  static String _shortName(String name) =>
      name.replaceFirst(RegExp(r'\s*\([^)]*\)\s*$'), '').trim();

  /// Instruksi perbaikan untuk retry (berisi kode masalah validator).
  static String repairContent(String previousUserContent, List<String> problems) =>
      '$previousUserContent\n\nOutput sebelumnya TIDAK VALID. Perbaiki masalah berikut lalu '
      'kirim ulang JSON lengkap sesuai schema:\n- ${problems.join('\n- ')}';

  /// JSON schema respons (subset OpenAPI yang didukung Gemini). Kode bahan
  /// tidak dibuat enum (>1.000 nilai) — divalidasi aplikasi.
  static const Map<String, Object?> responseSchema = {
    'type': 'OBJECT',
    'properties': {
      'schemaVersion': {'type': 'INTEGER'},
      'rationale': {'type': 'STRING'},
      'meals': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'slot': {
              'type': 'STRING',
              'enum': ['breakfast', 'lunch', 'dinner', 'snack'],
            },
            'title': {'type': 'STRING'},
            'items': {
              'type': 'ARRAY',
              'items': {
                'type': 'OBJECT',
                'properties': {
                  'code': {'type': 'STRING'},
                  'grams': {'type': 'INTEGER'},
                },
                'required': ['code', 'grams'],
              },
            },
          },
          'required': ['slot', 'title', 'items'],
        },
      },
    },
    'required': ['schemaVersion', 'rationale', 'meals'],
  };
}
