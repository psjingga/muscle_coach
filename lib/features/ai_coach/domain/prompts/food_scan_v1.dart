import 'dart:convert';

import '../../../nutrition/domain/food.dart';

/// Prompt scan makanan dari foto, versi 1. Pendekatan gabungan: Gemini
/// mengenali makanan & memperkirakan gram, memilih padanan dari katalog TKPI
/// bila ada (gizi lalu dihitung aplikasi dari TKPI), dan selalu memberi
/// perkiraan gizi porsi sebagai cadangan bila tidak ada padanan. Ubah
/// [version] bila isi prompt atau schema berubah.
abstract final class FoodScanPromptV1 {
  static const version = 'food_scan.v1';

  static const systemInstruction = '''
Anda membantu aplikasi Muscle Coach memperkirakan isi makanan dari SATU foto, sebagai DRAFT edukatif — bukan ahli gizi.
Tugas: kenali makanan/minuman yang terlihat dan perkirakan beratnya.

Aturan wajib:
1. Bila foto tidak berisi makanan/minuman, kembalikan isFood=false dan items kosong.
2. Pecah hidangan campuran menjadi komponen yang bisa ditimbang (mis. nasi goreng → nasi putih, telur, minyak, kecap; soto → kuah, daging, bihun, telur). Maksimal 12 item; gabungkan bahan yang sangat kecil.
3. "grams" = perkiraan berat bagian yang dapat dimakan dalam foto (bilangan bulat, gram). Gunakan petunjuk ukuran piring/sendok/tangan bila ada. Jangan melebih-lebihkan.
4. "tkpiCode": salin PERSIS kode dari "katalog" (Tabel Komposisi Pangan Indonesia, format code|nama) bila ada bahan yang benar-benar sepadan (pilih bentuk yang sesuai: mentah vs matang/goreng). Bila tidak ada yang sepadan, isi null. Jangan mengarang kode.
5. Selalu isi perkiraan gizi UNTUK PORSI item tersebut: kcal, protein, carbs (karbohidrat), fat (lemak) dalam gram. Pastikan kcal ≈ 4×protein + 4×carbs + 9×fat.
6. "name" dan "dishName" dalam Bahasa Indonesia, singkat. "notes" = catatan singkat ketidakpastian (mis. minyak/santan tidak terlihat), maks. 2 kalimat, tanpa klaim kesehatan.
Keluaran: JSON saja sesuai schema.''';

  /// Katalog ringkas `code|nama` (tanpa angka gizi — aplikasi yang menghitung).
  static String userContent({required List<Food> catalog}) {
    final lines = [
      for (final f in catalog)
        if (f.code != null) '${f.code}|${f.name}',
    ];
    return jsonEncode({'instruksi': 'Analisis foto makanan terlampir.', 'katalog': lines});
  }

  static String repairContent(String base, List<String> problems) => jsonEncode({
    'sebelumnya_tidak_valid': problems,
    'perbaiki': 'Ulangi analisis foto yang sama dan patuhi semua aturan serta schema.',
    'konteks': jsonDecode(base),
  });

  static const responseSchema = <String, Object?>{
    'type': 'OBJECT',
    'properties': {
      'isFood': {'type': 'BOOLEAN'},
      'dishName': {'type': 'STRING'},
      'items': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'name': {'type': 'STRING'},
            'grams': {'type': 'NUMBER'},
            'tkpiCode': {'type': 'STRING', 'nullable': true},
            'kcal': {'type': 'NUMBER'},
            'protein': {'type': 'NUMBER'},
            'carbs': {'type': 'NUMBER'},
            'fat': {'type': 'NUMBER'},
          },
          'required': ['name', 'grams', 'kcal', 'protein', 'carbs', 'fat'],
        },
      },
      'notes': {'type': 'STRING'},
    },
    'required': ['isFood', 'dishName', 'items'],
  };
}
