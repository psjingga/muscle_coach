import '../../../core/errors/failure_mapper.dart';
import '../../ai_coach/application/ai_plan_service.dart';
import '../../ai_coach/data/ai_repository.dart';
import '../../ai_coach/domain/ai_client.dart';
import '../../ai_coach/domain/ai_config.dart';
import '../../ai_coach/domain/prompts/meal_plan_v1.dart';
import '../data/nutrition_repository.dart';
import '../domain/meal_plan.dart';
import '../domain/meal_plan_candidates.dart';
import '../domain/meal_plan_validator.dart';

/// Orkestrasi contoh menu harian oleh Gemini — pola sama dengan program
/// latihan: cek key/consent/kuota → prompt → validasi & hitung ulang total
/// dari katalog → maks. 1 retry dengan umpan balik → simpan sebagai DRAFT →
/// log tanpa data pribadi. Menu dipakai setelah pengguna menyetujui.
class MealPlanService {
  MealPlanService({
    required this.nutrition,
    required this.ai,
    required this.client,
    required this.keys,
    required this.clock,
    required this.model,
  });

  final NutritionRepository nutrition;
  final AiRepository ai;
  final AiClient client;
  final AiKeyStore keys;
  final DateTime Function() clock;
  final Future<String> Function() model;

  /// ID draft menu. Melempar [AiPlanException] / `AppFailure`.
  Future<String> generate() async {
    final key = await keys.read();
    if (key == null || key.isEmpty) throw const AiPlanException(AiPlanError.noKey);
    if (!await ai.hasConsent()) throw const AiPlanException(AiPlanError.noConsent);
    if (await ai.countToday(clock()) >= AiConfig.dailyGenerationLimit) {
      throw const AiPlanException(AiPlanError.quotaReached);
    }

    final ctx = await nutrition.mealPlanningContext();
    final info = await nutrition.sourceInfo();
    final candidates = MealPlanCandidates.select((await nutrition.catalog()).values, ctx.prefs)
      ..sort((a, b) => a.code!.compareTo(b.code!));
    final validation = MealPlanContext(
      allowed: {for (final f in candidates) f.code!: f},
      target: ctx.target,
      mealsPerDay: ctx.prefs.mealsPerDay ?? 3,
      avoidPhrases: MealPlanCandidates.avoidPhrases(ctx.prefs),
    );
    final baseContent = MealPlanPromptV1.userContent(
      ctx.prefs,
      target: ctx.target,
      catalog: candidates,
    );
    final modelName = await model();

    final stopwatch = Stopwatch()..start();
    var content = baseContent;
    var attempts = 0;
    int? inTokens;
    int? outTokens;
    String? modelVersion;
    Future<void> log(String status, {String? error}) => ai.log(
      kind: 'meal_plan',
      model: modelName,
      modelVersion: modelVersion,
      promptVersion: MealPlanPromptV1.version,
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
          systemInstruction: MealPlanPromptV1.systemInstruction,
          userContent: content,
          responseSchema: MealPlanPromptV1.responseSchema,
        );
        modelVersion = res.modelVersion ?? modelVersion;
        inTokens = (inTokens ?? 0) + (res.inputTokens ?? 0);
        outTokens = (outTokens ?? 0) + (res.outputTokens ?? 0);

        final parsed = MealPlanValidator.parse(res.text, validation);
        if (parsed.isValid) {
          final plan = parsed.plan!;
          final draft = MealPlan(
            meals: plan.meals,
            target: plan.target,
            rationale: plan.rationale,
            warnings: [
              ...plan.warnings,
              if (ctx.eatingDisorderHistory) MealPlanWarning.eatingDisorder,
              if ((ctx.prefs.allergies ?? '').trim().isNotEmpty) MealPlanWarning.allergyCheck,
            ],
            promptVersion: MealPlanPromptV1.version,
            catalogVersion: info.version,
          );
          final id = await nutrition.saveDraftMealPlan(draft, model: modelVersion ?? modelName);
          await log('success');
          return id;
        }
        content = MealPlanPromptV1.repairContent(baseContent, parsed.problems.take(12).toList());
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
