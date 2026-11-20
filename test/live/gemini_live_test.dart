// Uji live ke Gemini (opsional). Dilewati bila GEMINI_API_KEY tidak ada di
// environment — key TIDAK pernah ditulis ke file/repo:
//   GEMINI_API_KEY=... fvm flutter test test/live
@Tags(['live'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/ai_coach/data/gemini_client.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_config.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_plan_parser.dart';
import 'package:musclecoach/features/ai_coach/domain/prompts/workout_plan_v1.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';

import '../fixtures/sample_assessment.dart';

void main() {
  final key = Platform.environment['GEMINI_API_KEY'] ?? '';
  final catalog = {
    for (final e in AssetExerciseRepository.parse(
      File(AssetExerciseRepository.path).readAsStringSync(),
    ).exercises)
      e.id: e,
  };

  Future<void> run(String label, AssessmentData a, {bool conservative = false}) async {
    final allowed = AiPlanParser.allowedExercises(a, catalog);
    final sw = Stopwatch()..start();
    final thinking = Platform.environment['THINKING'];
    final res = await GeminiClient(null, thinking == null || thinking.isEmpty ? null : thinking)
        .generateJson(
          apiKey: key,
          model: Platform.environment['MODEL'] ?? AiConfig.defaultModel,
          systemInstruction: WorkoutPlanPromptV1.systemInstruction,
          userContent: WorkoutPlanPromptV1.userContent(
            a,
            allowedExercises: allowed,
            conservative: conservative,
          ),
          responseSchema: WorkoutPlanPromptV1.responseSchema([for (final e in allowed) e.id]),
        );
    final parsed = AiPlanParser.parse(res.text, assessment: a, catalog: catalog);
    // ignore: avoid_print
    print(
      '[$label] ${sw.elapsedMilliseconds} ms · ${res.modelVersion} · in ${res.inputTokens} out ${res.outputTokens} · '
      '${parsed.isValid ? 'VALID' : 'INVALID ${parsed.problems}'}',
    );
    if (parsed.isValid) {
      for (final d in parsed.draft!.days) {
        // ignore: avoid_print
        print(
          '  hari ${d.weekday} ${d.focus} ~${d.estimatedMinutes}m: '
          '${d.exercises.map((e) => '${e.exerciseId} ${e.sets}x${e.repMin}-${e.repMax} RIR${e.rirMin}').join(', ')}',
        );
      }
    }
    expect(parsed.problems, isEmpty);
  }

  test(
    'pemula, dumbbell+barbell+bench, 3 hari 60 menit',
    () => run('pemula', sample),
    skip: key.isEmpty ? 'GEMINI_API_KEY tidak diset' : null,
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'menengah, alat lengkap, 4 hari 75 menit, cedera bahu',
    () => run(
      'menengah',
      sample.copyWith(
        experience: sample.experience.copyWith(level: ExperienceLevel.intermediate),
        safety: const SafetySection(injuries: 'Bahu kanan nyeri saat press di atas kepala'),
        availability: sample.availability.copyWith(
          trainingDays: [1, 2, 4, 5],
          sessionMinutes: 75,
          equipment: const EquipmentSelection(
            dumbbell: true,
            barbell: true,
            bench: true,
            rack: true,
            pullUpBar: true,
          ),
        ),
      ),
    ),
    skip: key.isEmpty ? 'GEMINI_API_KEY tidak diset' : null,
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
