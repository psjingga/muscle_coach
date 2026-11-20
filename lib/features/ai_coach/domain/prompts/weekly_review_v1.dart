import 'dart:convert';

import '../../../assessment/domain/entities/assessment_data.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../progress/data/progress_repository.dart';

/// Prompt ringkasan mingguan, versi 1. AI hanya menulis ringkasan teks;
/// angka & usulan target dihitung aplikasi.
abstract final class WeeklyReviewPromptV1 {
  static const version = 'weekly_review.v1';

  static const maxSummary = 400;
  static const maxItem = 200;
  static const maxItems = 3;

  static const systemInstruction = '''
Anda adalah pendamping latihan yang menulis RINGKASAN MINGGUAN edukatif untuk aplikasi Muscle Coach — bukan dokter, ahli gizi, atau fisioterapis.
Data berisi statistik agregat satu minggu yang sudah dihitung aplikasi.

Aturan wajib:
1. Gunakan hanya data yang diberikan. Bila data kosong/null, katakan datanya belum cukup — jangan menebak.
2. Berat badan BUKAN massa otot. Jangan menyimpulkan otot bertambah/berkurang dari berat badan.
3. Evaluasi tren, bukan satu angka; data 1 minggu belum cukup untuk menyimpulkan kegagalan.
4. JANGAN menyebut angka kalori, gram, atau perubahan target makan — perubahan target dihitung dan diusulkan aplikasi, lalu diputuskan pengguna.
5. Jangan mendiagnosis atau menyarankan obat. Bila "hariAdaKeluhanNyeri" > 0, sarankan mengurangi beban/menghentikan gerakan yang memicu nyeri dan berkonsultasi dengan tenaga kesehatan bila berlanjut.
6. Saran kecil, spesifik, dan bisa dilakukan minggu depan (mis. tidur, konsistensi mencatat makan, menyelesaikan sesi). Tanpa janji hasil.
7. Bahasa Indonesia yang ramah dan ringkas: "summary" maks. 3 kalimat; "wentWell", "obstacles", "suggestions" masing-masing maks. 3 butir pendek.
Keluaran: JSON saja sesuai schema.''';

  /// Statistik agregat saja — tanpa nama, umur, tinggi, berat absolut,
  /// kondisi medis, atau isi catatan bebas.
  static String userContent(
    StoredWeeklyReview review, {
    required PrimaryGoal goal,
    required String level,
    required NumRange expectedKgPerWeek,
  }) {
    final s = review.stats;
    double? r1(double? v) => v == null ? null : (v * 10).round() / 10;
    int? pct(double? v) => v == null ? null : (v * 100).round();
    final payload = {
      'tujuan': goal.name,
      'level': level,
      'statusTarget': review.goalStatus.name,
      'berat': {
        'jumlahPenimbangan': s.weighIns,
        'perubahanRataRataKgDariMingguLalu': r1(s.weightChangeKg),
        'lajuDiharapkanKgPerMinggu': [r1(expectedKgPerWeek.min), r1(expectedKgPerWeek.max)],
      },
      'latihan': {
        'sesiSelesai': s.sessionsCompleted,
        'sesiDirencanakan': s.sessionsPlanned,
        'setSelesai': s.setsDone,
        'perubahanVolumePersen': s.prevVolumeKg == null || s.prevVolumeKg == 0
            ? null
            : ((s.volumeKg / s.prevVolumeKg! - 1) * 100).round(),
      },
      'makan': {
        'hariTercatat': s.loggedDays,
        'rataRataEnergiPersenTarget': pct(s.intakeRatio),
        'rataRataProteinPersenTarget': s.avgProtein == null || (s.targetProtein ?? 0) == 0
            ? null
            : (s.avgProtein! / s.targetProtein! * 100).round(),
      },
      'pemulihan': {
        'checkIn': s.checkIns,
        'rataRataTidurJam': r1(s.avgSleepHours),
        'rataRataEnergi1sd5': r1(s.avgEnergy),
        'hariAdaKeluhanNyeri': s.discomfortDays,
      },
      'usulanAplikasi': review.proposal == null
          ? null
          : (review.proposal!.deltaKcal > 0 ? 'naikkan_sedikit' : 'turunkan_sedikit'),
    };
    return jsonEncode(payload);
  }

  static String repairContent(String previousUserContent, List<String> problems) =>
      '$previousUserContent\n\nOutput sebelumnya TIDAK VALID. Perbaiki masalah berikut lalu '
      'kirim ulang JSON lengkap sesuai schema:\n- ${problems.join('\n- ')}';

  static const Map<String, Object?> responseSchema = {
    'type': 'OBJECT',
    'properties': {
      'schemaVersion': {'type': 'INTEGER'},
      'summary': {'type': 'STRING'},
      'wentWell': {
        'type': 'ARRAY',
        'items': {'type': 'STRING'},
      },
      'obstacles': {
        'type': 'ARRAY',
        'items': {'type': 'STRING'},
      },
      'suggestions': {
        'type': 'ARRAY',
        'items': {'type': 'STRING'},
      },
    },
    'required': ['schemaVersion', 'summary', 'wentWell', 'obstacles', 'suggestions'],
  };

  static final _numbersWithUnits = RegExp(
    r'\d+([.,]\d+)?\s*(kcal|kkal|kalori|gram|gr|g)\b',
    caseSensitive: false,
  );
  static final _medical = RegExp(
    r'\b(diagnosis|didiagnosis|mendiagnosis|resep obat|obat)\b',
    caseSensitive: false,
  );

  /// Parse & validasi. Mengembalikan ringkasan atau daftar masalah.
  static ({WeeklyAiSummary? summary, List<String> problems}) parse(String raw) {
    final Map<String, dynamic> j;
    try {
      j = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return (
        summary: null,
        problems: const ['invalid_json: keluaran bukan JSON objek yang valid'],
      );
    }
    final p = <String>[];
    if (j['schemaVersion'] != 1) p.add('schema_version: schemaVersion harus 1');
    final summary = (j['summary'] as String? ?? '').trim();
    if (summary.isEmpty || summary.length > maxSummary) {
      p.add('summary: wajib, maks. $maxSummary karakter');
    }
    List<String> list(String key, {bool required = false}) {
      final v = j[key];
      if (v is! List) {
        p.add('$key: harus array');
        return const [];
      }
      final items = [
        for (final x in v)
          if (x is String && x.trim().isNotEmpty) x.trim(),
      ];
      if (items.length > maxItems) p.add('$key: maks. $maxItems butir');
      if (required && items.isEmpty) p.add('$key: minimal 1 butir');
      if (items.any((x) => x.length > maxItem)) p.add('$key: tiap butir maks. $maxItem karakter');
      return items.take(maxItems).toList();
    }

    final wentWell = list('wentWell');
    final obstacles = list('obstacles');
    final suggestions = list('suggestions', required: true);
    final all = [summary, ...wentWell, ...obstacles, ...suggestions];
    if (all.any(_numbersWithUnits.hasMatch)) {
      p.add('angka_target: jangan menyebut angka kalori/gram; perubahan target dihitung aplikasi');
    }
    if (all.any(_medical.hasMatch)) {
      p.add('medis: jangan mendiagnosis atau menyebut obat');
    }
    if (p.isNotEmpty) return (summary: null, problems: p);
    return (
      summary: WeeklyAiSummary(
        summary: summary,
        wentWell: wentWell,
        obstacles: obstacles,
        suggestions: suggestions,
      ),
      problems: const <String>[],
    );
  }
}
