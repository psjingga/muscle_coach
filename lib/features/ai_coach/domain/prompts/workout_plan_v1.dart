import 'dart:convert';

import '../../../assessment/domain/entities/assessment_data.dart';
import '../../../exercise_library/domain/exercise.dart';
import '../../../workout/domain/plan_validator.dart';
import '../../../workout/domain/template_planner.dart';

/// Prompt penyusunan program latihan, versi 1. Ubah [version] bila isi prompt
/// atau schema berubah — versi tercatat di program & log generasi.
abstract final class WorkoutPlanPromptV1 {
  static const version = 'workout_plan.v1';

  static const focusCodes = [
    'full_body_a',
    'full_body_b',
    'full_body_c',
    'upper_a',
    'upper_b',
    'lower_a',
    'lower_b',
  ];

  static const systemInstruction = '''
Anda adalah penyusun DRAFT program latihan beban yang bersifat edukatif untuk aplikasi Muscle Coach — bukan dokter, ahli gizi, atau fisioterapis.
Tugas: susun program mingguan untuk hipertrofi/kekuatan dengan dumbbell/barbell berdasarkan data JSON pengguna.

Aturan wajib:
1. HANYA gunakan exerciseId dari daftar "katalog". Jangan mengarang gerakan.
2. Hanya gunakan hari dari "hariTersedia" (1=Senin … 7=Minggu), maksimal "maksHariLatihan" hari. Sisakan hari istirahat.
3. Setiap sesi harus muat dalam "durasiSesiMenit" termasuk pemanasan ±8 menit dan waktu istirahat antar set.
4. Hindari melatih otot yang sama secara berat pada hari berurutan. Untuk ≤3 hari tidak berurutan, full body umumnya tepat; selain itu upper/lower.
5. Volume konservatif untuk pemula (2–3 set per gerakan, 3–6 gerakan per sesi). Jangan sampai gagal di setiap set: pemula RIR minimal 2.
6. Patuhi batas angka di "batas". Untuk gerakan dengan satuan "seconds", repMin/repMax berarti detik.
7. Bila "keselamatan.modeKonservatif" true atau ada catatan cedera/gerakan dihindari: pilih variasi yang lebih aman, hindari pola gerak terkait, dan jangan sekadar mengganti nama gerakan.
8. Jangan menganggap ada alat yang tidak tercantum di "alat".
9. Prioritaskan "ototPrioritas" dengan sedikit volume tambahan, tanpa mengorbankan keseimbangan.
10. Jangan mengarang data yang tidak ada. Tulis "rationale" singkat (Bahasa Indonesia, maks. 2 kalimat) untuk program dan tiap gerakan, tanpa janji hasil.
Keluaran: JSON saja sesuai schema.''';

  /// Konteks minimum (tanpa nama, umur, berat, tanggal lahir, kontak).
  static String userContent(
    AssessmentData a, {
    required List<Exercise> allowedExercises,
    required bool conservative,
  }) {
    final level = a.experience.level!.name;
    String? t(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
    final payload = {
      'tujuan': switch (a.goal.primary!) {
        PrimaryGoal.muscleGain => 'muscle_gain',
        PrimaryGoal.strength => 'strength',
        PrimaryGoal.recomposition => 'recomposition',
      },
      'level': level,
      'lamaLatihan': a.experience.trainingAge?.name,
      'frekuensiSaatIniPerMinggu': a.experience.currentSessionsPerWeek,
      'gerakanDikuasai': t(a.experience.knownExercises),
      'hariTersedia': [...a.availability.trainingDays]..sort(),
      'maksHariLatihan': TemplatePlanner.maxDaysFor(level),
      'durasiSesiMenit': a.availability.sessionMinutes,
      'lokasi': a.availability.location?.name,
      'alat': TemplatePlanner.equipmentOf(a).toList()..sort(),
      'bebanMaksKg': {
        'dumbbellPerTangan': a.availability.dumbbellMaxKg,
        'barbellTotal': a.availability.barbellMaxKg,
      },
      'ototPrioritas': [for (final m in a.goal.priorityMuscles) m.name],
      'preferensiLatihan': t(a.availability.preferences),
      'keselamatan': {
        'modeKonservatif': conservative,
        'catatanCedera': t(a.safety.injuries),
        'gerakanDihindari': t(a.safety.avoidedMovements),
      },
      'batas': {
        'sets': [PlanValidator.setsRange.min, 5],
        'repetisi': [PlanValidator.repsRange.min, PlanValidator.repsRange.max],
        'detik': [PlanValidator.secondsRange.min, PlanValidator.secondsRange.max],
        'istirahatDetik': [PlanValidator.restRange.min, PlanValidator.restRange.max],
        'rir': [level == 'beginner' ? 2 : 1, PlanValidator.rirRange.max],
        'gerakanPerSesi': [3, 8],
      },
      'katalog': [
        for (final e in allowedExercises)
          {
            'id': e.id,
            'nama': e.name,
            'pola': e.pattern,
            'ototUtama': e.primaryMuscles,
            'compound': e.compound,
            'satuan': e.repUnit,
            'butuhSpotter': e.needsSpotter,
          },
      ],
    };
    return jsonEncode(payload);
  }

  /// Instruksi perbaikan untuk retry (berisi kode error validator).
  static String repairContent(String previousUserContent, List<String> problems) =>
      '$previousUserContent\n\nOutput sebelumnya TIDAK VALID. Perbaiki masalah berikut lalu '
      'kirim ulang JSON lengkap sesuai schema:\n- ${problems.join('\n- ')}';

  /// JSON schema respons (subset OpenAPI yang didukung Gemini).
  static Map<String, Object?> responseSchema(List<String> exerciseIds) => {
    'type': 'OBJECT',
    'properties': {
      'schemaVersion': {'type': 'INTEGER'},
      'split': {
        'type': 'STRING',
        'enum': ['full_body', 'upper_lower'],
      },
      'rationale': {'type': 'STRING'},
      'days': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'weekday': {'type': 'INTEGER'},
            'focus': {'type': 'STRING', 'enum': focusCodes},
            'exercises': {
              'type': 'ARRAY',
              'items': {
                'type': 'OBJECT',
                'properties': {
                  'exerciseId': {'type': 'STRING', 'enum': exerciseIds},
                  'sets': {'type': 'INTEGER'},
                  'repMin': {'type': 'INTEGER'},
                  'repMax': {'type': 'INTEGER'},
                  'restSec': {'type': 'INTEGER'},
                  'rirMin': {'type': 'INTEGER'},
                  'rirMax': {'type': 'INTEGER'},
                  'rationale': {'type': 'STRING'},
                },
                'required': [
                  'exerciseId',
                  'sets',
                  'repMin',
                  'repMax',
                  'restSec',
                  'rirMin',
                  'rirMax',
                  'rationale',
                ],
              },
            },
          },
          'required': ['weekday', 'focus', 'exercises'],
        },
      },
    },
    'required': ['schemaVersion', 'split', 'rationale', 'days'],
  };
}
