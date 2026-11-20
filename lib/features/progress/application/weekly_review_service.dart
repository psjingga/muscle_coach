import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../ai_coach/application/ai_plan_service.dart';
import '../../ai_coach/data/ai_repository.dart';
import '../../ai_coach/domain/ai_client.dart';
import '../../ai_coach/domain/ai_config.dart';
import '../../ai_coach/domain/prompts/weekly_review_v1.dart';
import '../../goals/domain/entities/goal.dart';
import '../data/progress_repository.dart';
import '../domain/progress_math.dart';

/// Ringkasan mingguan oleh Gemini: hanya teks dari statistik agregat yang
/// sudah tersimpan. Pola sama dengan generator lain (key/consent/kuota →
/// validasi → maks. 1 retry → simpan → log tanpa data pribadi).
class WeeklyReviewService {
  WeeklyReviewService({
    required this.progress,
    required this.ai,
    required this.client,
    required this.keys,
    required this.clock,
    required this.model,
  });

  final ProgressRepository progress;
  final AiRepository ai;
  final AiClient client;
  final AiKeyStore keys;
  final DateTime Function() clock;
  final Future<String> Function() model;

  Future<void> generate(String weekStart, {required Goal goal}) async {
    final key = await keys.read();
    if (key == null || key.isEmpty) throw const AiPlanException(AiPlanError.noKey);
    if (!await ai.hasConsent()) throw const AiPlanException(AiPlanError.noConsent);
    if (await ai.countToday(clock()) >= AiConfig.dailyGenerationLimit) {
      throw const AiPlanException(AiPlanError.quotaReached);
    }
    final review = await progress.watchReview(weekStart).first;
    if (review == null) {
      throw const AppFailure(FailureKind.notFound, debugMessage: 'review-missing');
    }

    final base = WeeklyReviewPromptV1.userContent(
      review,
      goal: goal.primaryGoal,
      level: goal.level.name,
      expectedKgPerWeek: ProgressMath.expectedRate(goal),
    );
    final modelName = await model();
    final stopwatch = Stopwatch()..start();
    var content = base;
    var attempts = 0;
    int? inTokens;
    int? outTokens;
    String? modelVersion;
    Future<void> log(String status, {String? error}) => ai.log(
      kind: 'weekly_review',
      model: modelName,
      modelVersion: modelVersion,
      promptVersion: WeeklyReviewPromptV1.version,
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
          systemInstruction: WeeklyReviewPromptV1.systemInstruction,
          userContent: content,
          responseSchema: WeeklyReviewPromptV1.responseSchema,
        );
        modelVersion = res.modelVersion ?? modelVersion;
        inTokens = (inTokens ?? 0) + (res.inputTokens ?? 0);
        outTokens = (outTokens ?? 0) + (res.outputTokens ?? 0);
        final parsed = WeeklyReviewPromptV1.parse(res.text);
        if (parsed.summary != null) {
          await progress.saveAiSummary(
            weekStart,
            parsed.summary!,
            model: modelVersion ?? modelName,
            promptVersion: WeeklyReviewPromptV1.version,
          );
          await log('success');
          return;
        }
        content = WeeklyReviewPromptV1.repairContent(base, parsed.problems.take(12).toList());
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
