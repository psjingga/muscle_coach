import '../../../core/errors/failure_mapper.dart';
import '../../ai_coach/application/ai_plan_service.dart';
import '../../ai_coach/data/ai_repository.dart';
import '../../ai_coach/domain/ai_client.dart';
import '../../ai_coach/domain/ai_config.dart';
import '../../ai_coach/domain/prompts/food_scan_v1.dart';
import '../data/nutrition_repository.dart';
import '../domain/food.dart';
import '../domain/food_scan.dart';

/// Scan makanan dari foto oleh Gemini — pola sama dengan fitur AI lain:
/// cek key/consent/kuota → foto + katalog TKPI → validasi (kode TKPI
/// diperiksa, gizi dihitung aplikasi) → maks. 1 retry → log tanpa data
/// pribadi/foto. Hasil berupa DRAFT; dicatat setelah pengguna meninjau.
class FoodScanService {
  FoodScanService({
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

  /// Batas ukuran foto yang dikirim (setelah diperkecil oleh pemilih foto).
  static const maxImageBytes = 4 * 1024 * 1024;

  /// Melempar [AiPlanException] / `AppFailure`.
  Future<FoodScanResult> scan(AiImage image) async {
    final key = await keys.read();
    if (key == null || key.isEmpty) throw const AiPlanException(AiPlanError.noKey);
    if (!await ai.hasConsent()) throw const AiPlanException(AiPlanError.noConsent);
    if (await ai.countToday(clock()) >= AiConfig.dailyGenerationLimit) {
      throw const AiPlanException(AiPlanError.quotaReached);
    }

    final catalog = (await nutrition.catalog()).values.where((f) => f.code != null).toList()
      ..sort((a, b) => a.code!.compareTo(b.code!));
    final byCode = {for (final Food f in catalog) f.code!: f};
    final baseContent = FoodScanPromptV1.userContent(catalog: catalog);
    final modelName = await model();

    final stopwatch = Stopwatch()..start();
    var content = baseContent;
    var attempts = 0;
    int? inTokens;
    int? outTokens;
    String? modelVersion;
    Future<void> log(String status, {String? error}) => ai.log(
      kind: 'food_scan',
      model: modelName,
      modelVersion: modelVersion,
      promptVersion: FoodScanPromptV1.version,
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
          systemInstruction: FoodScanPromptV1.systemInstruction,
          userContent: content,
          responseSchema: FoodScanPromptV1.responseSchema,
          images: [image],
        );
        modelVersion = res.modelVersion ?? modelVersion;
        inTokens = (inTokens ?? 0) + (res.inputTokens ?? 0);
        outTokens = (outTokens ?? 0) + (res.outputTokens ?? 0);

        final parsed = FoodScanValidator.parse(res.text, byCode);
        if (parsed.isValid) {
          await log('success');
          return FoodScanResult(
            dishName: parsed.dishName ?? '',
            items: parsed.items,
            notes: parsed.notes,
            notFood: parsed.notFood,
            promptVersion: FoodScanPromptV1.version,
            model: modelVersion ?? modelName,
          );
        }
        content = FoodScanPromptV1.repairContent(baseContent, parsed.problems.take(12).toList());
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
