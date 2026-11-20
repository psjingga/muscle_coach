import '../../../core/errors/failure_mapper.dart';
import '../../goals/domain/goal_planner.dart';
import '../../workout/data/workout_repository.dart';
import '../data/ai_repository.dart';
import '../domain/ai_client.dart';
import '../domain/ai_config.dart';
import '../domain/ai_plan_parser.dart';
import '../domain/prompts/workout_plan_v1.dart';

/// Kode alasan kegagalan generasi (diterjemahkan di UI).
enum AiPlanError { noKey, noConsent, quotaReached, invalidOutput }

class AiPlanException implements Exception {
  const AiPlanException(this.error);

  final AiPlanError error;

  @override
  String toString() => 'AiPlanException(${error.name})';
}

/// Orkestrasi penyusunan program oleh Gemini:
/// cek key/consent/kuota → prompt → panggil → parse & validasi → (maks. 1
/// retry dengan umpan balik) → simpan sebagai DRAFT → catat log tanpa data
/// pribadi. Program baru aktif setelah pengguna menyetujui.
class AiPlanService {
  AiPlanService({
    required this.workouts,
    required this.ai,
    required this.client,
    required this.keys,
    required this.clock,
    required this.model,
  });

  final WorkoutRepository workouts;
  final AiRepository ai;
  final AiClient client;
  final AiKeyStore keys;
  final DateTime Function() clock;

  /// Model terpilih (dibaca saat generasi).
  final Future<String> Function() model;

  /// Mengembalikan ID draft program. Melempar [AiPlanException] / `AppFailure`.
  Future<String> generateWorkoutPlan() async {
    final key = await keys.read();
    if (key == null || key.isEmpty) throw const AiPlanException(AiPlanError.noKey);
    if (!await ai.hasConsent()) throw const AiPlanException(AiPlanError.noConsent);
    final now = clock();
    if (await ai.countToday(now) >= AiConfig.dailyGenerationLimit) {
      throw const AiPlanException(AiPlanError.quotaReached);
    }

    final ctx = await workouts.planningContext();
    final modelName = await model();
    final conservative = GoalPlanner.buildProposal(ctx.assessment, now).safety.conservative;
    final allowed = AiPlanParser.allowedExercises(ctx.assessment, ctx.catalog);
    final schema = WorkoutPlanPromptV1.responseSchema([for (final e in allowed) e.id]);
    final baseContent = WorkoutPlanPromptV1.userContent(
      ctx.assessment,
      allowedExercises: allowed,
      conservative: conservative,
    );

    final stopwatch = Stopwatch()..start();
    var content = baseContent;
    var attempts = 0;
    int? inTokens;
    int? outTokens;
    String? modelVersion;
    Future<void> log(String status, {String? error}) => ai.log(
      kind: 'workout_plan',
      model: modelName,
      modelVersion: modelVersion,
      promptVersion: WorkoutPlanPromptV1.version,
      status: status,
      attempts: attempts,
      durationMs: stopwatch.elapsedMilliseconds,
      inputTokens: inTokens,
      outputTokens: outTokens,
      errorCode: error,
      now: clock(),
    );

    try {
      while (attempts < AiConfig.maxAttempts) {
        attempts++;
        final res = await client.generateJson(
          apiKey: key,
          model: modelName,
          systemInstruction: WorkoutPlanPromptV1.systemInstruction,
          userContent: content,
          responseSchema: schema,
        );
        modelVersion = res.modelVersion ?? modelVersion;
        inTokens = (inTokens ?? 0) + (res.inputTokens ?? 0);
        outTokens = (outTokens ?? 0) + (res.outputTokens ?? 0);

        final parsed = AiPlanParser.parse(
          res.text,
          assessment: ctx.assessment,
          catalog: ctx.catalog,
        );
        if (parsed.isValid) {
          final planId = await workouts.saveDraftPlan(
            parsed.draft!,
            source: 'ai_generated',
            generatorVersion: WorkoutPlanPromptV1.version,
            rationale: parsed.rationale,
            model: modelVersion ?? modelName,
          );
          await log('success');
          return planId;
        }
        // Retry terkontrol dengan umpan balik kode masalah (maks. 12).
        content = WorkoutPlanPromptV1.repairContent(baseContent, parsed.problems.take(12).toList());
      }
      await log('invalid', error: 'invalid_output');
      throw const AiPlanException(AiPlanError.invalidOutput);
    } on AiPlanException {
      rethrow;
    } catch (e) {
      final failure = FailureMapper.from(e);
      await log('error', error: failure.debugMessage ?? failure.kind.name);
      throw failure;
    }
  }
}
