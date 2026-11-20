// Uji live menu harian & ringkasan mingguan ke Gemini (opsional). Memakai
// layanan aplikasi yang sama (validasi, retry, simpan draft) dengan basis data
// di memori. Key hanya dari environment — TIDAK pernah ditulis ke file/repo:
//   GEMINI_API_KEY=... fvm flutter test test/live --tags live
@Tags(['live'])
library;

import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/features/ai_coach/data/ai_repository.dart';
import 'package:musclecoach/features/ai_coach/data/gemini_client.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_client.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_config.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/goals/domain/goal_planner.dart';
import 'package:musclecoach/features/nutrition/application/meal_plan_service.dart';
import 'package:musclecoach/features/nutrition/data/nutrition_repository.dart';
import 'package:musclecoach/features/nutrition/domain/meal_plan_candidates.dart';
import 'package:musclecoach/features/nutrition/domain/meal_plan_validator.dart';
import 'package:musclecoach/features/progress/application/weekly_review_service.dart';
import 'package:musclecoach/features/progress/data/progress_repository.dart';
import 'package:musclecoach/features/progress/domain/progress_math.dart';

import '../features/ai_coach/ai_coach_test.dart' show MemoryKeyStore;
import '../features/nutrition/nutrition_repository_test.dart' show ContextRepo, foodSource;
import '../fixtures/sample_assessment.dart';

// ignore: avoid_print
void log(Object o) => print(o);

/// Meneruskan ke Gemini dan menyimpan teks respons untuk diagnosis.
class RecordingClient implements AiClient {
  RecordingClient(this.inner);

  final AiClient inner;
  final responses = <String>[];

  @override
  Future<AiResponse> generateJson({
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String userContent,
    required Map<String, Object?> responseSchema,
  }) async {
    final r = await inner.generateJson(
      apiKey: apiKey,
      model: model,
      systemInstruction: systemInstruction,
      userContent: userContent,
      responseSchema: responseSchema,
    );
    responses.add(r.text);
    return r;
  }

  @override
  Future<void> verifyKey(String apiKey) => inner.verifyKey(apiKey);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final key = Platform.environment['GEMINI_API_KEY'] ?? '';
  final skip = key.isEmpty ? 'GEMINI_API_KEY tidak diset' : null;
  final model = Platform.environment['MODEL'] ?? AiConfig.defaultModel;
  final goal = GoalPlanner.buildProposal(sample, now);
  final target = LocalNutritionRepository.targetOf(goal.nutrition);

  late AppDatabase db;
  late AiRepository ai;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    ai = AiRepository(db);
    await ai.setConsent(accepted: true, now: now);
  });
  tearDown(() => db.close());

  Future<void> logRuns(String label, Stopwatch sw) async {
    final rows = await db.select(db.aiGenerationLogs).get();
    for (final r in rows) {
      log(
        '[$label] ${sw.elapsedMilliseconds} ms · ${r.modelVersion ?? r.model} · ${r.status} · '
        'percobaan ${r.attempts} · in ${r.inputTokens} out ${r.outputTokens}'
        '${r.errorCode == null ? '' : ' · ${r.errorCode}'}',
      );
    }
  }

  Future<void> menu(String label, NutritionSection prefs) async {
    final repo = ContextRepo(db, () => now, foodSource, (
      prefs: prefs,
      target: target,
      eatingDisorderHistory: false,
    ));
    final client = RecordingClient(GeminiClient());
    final service = MealPlanService(
      nutrition: repo,
      ai: ai,
      client: client,
      keys: MemoryKeyStore(key),
      clock: () => now,
      model: () async => model,
    );
    final sw = Stopwatch()..start();
    try {
      final id = await service.generate();
      final plan = (await repo.watchMealPlan(id).first)!;
      final t = plan.totals;
      log(
        '[$label] target ${target.kcal.round()} kcal P${target.protein.round()} '
        'K${target.carbs.round()} L${target.fat.round()} → menu ${t.kcal.round()} kcal '
        'P${t.protein.round()} K${t.carbs.round()} L${t.fat.round()}',
      );
      log('  alasan: ${plan.rationale}');
      for (final m in plan.meals) {
        log(
          '  ${m.slot.name} · ${m.title} (${m.totals.kcal.round()} kcal): '
          '${m.items.map((i) => '${i.name} ${i.grams.round()} g').join('; ')}',
        );
      }
    } finally {
      await logRuns(label, sw);
      // Diagnosis: hasil validator per percobaan (sama dengan aplikasi: porsi disesuaikan).
      final foods = await repo.catalog();
      final allowed = MealPlanCandidates.select(foods.values, prefs);
      final ctx = MealPlanContext(
        allowed: {for (final f in allowed) f.code!: f},
        target: target,
        mealsPerDay: prefs.mealsPerDay ?? 3,
        avoidPhrases: MealPlanCandidates.avoidPhrases(prefs),
        fitPortions: true,
      );
      for (final (i, r) in client.responses.indexed) {
        final p = MealPlanValidator.parse(r, ctx);
        log('  percobaan ${i + 1}: ${p.isValid ? 'VALID' : p.problems}');
      }
    }
  }

  test(
    'menu: omnivora, 3× makan, campuran',
    () => menu('menu-omnivora', sample.nutrition),
    skip: skip,
    timeout: const Timeout(Duration(minutes: 6)),
  );

  test(
    'menu: vegetarian, 4× makan, alergi udang, tidak suka pare, katering',
    () => menu(
      'menu-vegetarian',
      const NutritionSection(
        diet: Diet.vegetarian,
        mealsPerDay: 4,
        allergies: 'udang',
        dislikes: 'pare',
        cooking: Cooking.catering,
        dailyBudgetIdr: 75000,
      ),
    ),
    skip: skip,
    timeout: const Timeout(Duration(minutes: 6)),
  );

  test(
    'ringkasan mingguan dari statistik agregat',
    () async {
      final progress = LocalProgressRepository(db, () => now);
      await progress.saveReviewStats(
        const WeekSummary(
          weekStart: '2026-11-09',
          weighIns: 3,
          avgWeightKg: 70.4,
          prevAvgWeightKg: 70.2,
          sessionsCompleted: 2,
          sessionsPlanned: 3,
          volumeKg: 5200,
          prevVolumeKg: 4800,
          setsDone: 34,
          loggedDays: 4,
          avgKcal: 2350,
          avgProtein: 105,
          targetKcal: 2550,
          targetProtein: 125,
          checkIns: 5,
          avgSleepHours: 6.2,
          avgEnergy: 3.2,
          discomfortDays: 1,
        ),
        goalStatus: GoalProgressStatus.onTrack,
      );
      final service = WeeklyReviewService(
        progress: progress,
        ai: ai,
        client: GeminiClient(),
        keys: MemoryKeyStore(key),
        clock: () => now,
        model: () async => model,
      );
      final sw = Stopwatch()..start();
      try {
        await service.generate('2026-11-09', goal: goal);
        final r = (await progress.watchReview('2026-11-09').first)!.aiSummary!;
        log('[ringkasan] ${r.summary}');
        log('  baik: ${r.wentWell}');
        log('  hambatan: ${r.obstacles}');
        log('  saran: ${r.suggestions}');
      } finally {
        await logRuns('ringkasan', sw);
      }
    },
    skip: skip,
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
