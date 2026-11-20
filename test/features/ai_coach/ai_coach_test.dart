import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/features/ai_coach/application/ai_plan_service.dart';
import 'package:musclecoach/features/ai_coach/data/ai_repository.dart';
import 'package:musclecoach/features/ai_coach/data/gemini_client.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_client.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_config.dart';
import 'package:musclecoach/features/ai_coach/domain/ai_plan_parser.dart';
import 'package:musclecoach/features/ai_coach/domain/prompts/workout_plan_v1.dart';
import 'package:musclecoach/features/assessment/data/local_assessment_repository.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/exercise_library/data/exercise_repository.dart';
import 'package:musclecoach/features/goals/data/local_goal_repository.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/features/workout/domain/template_planner.dart';

import '../../fixtures/sample_assessment.dart';

final catalog = {
  for (final e in AssetExerciseRepository.parse(
    File(AssetExerciseRepository.path).readAsStringSync(),
  ).exercises)
    e.id: e,
};

/// Output AI yang valid: dibentuk dari program template (lolos validasi).
String validAiJson(AssessmentData a, {int? rirMin, int? weekdayOverride, int extraDays = 0}) {
  final plan = TemplatePlanner.build(a, catalog);
  return jsonEncode({
    'schemaVersion': 1,
    'split': plan.split,
    'rationale': 'Full body 3x seminggu cocok untuk pemula.',
    'days': [
      for (final (i, d) in plan.days.indexed)
        {
          'weekday': i == 0 && weekdayOverride != null ? weekdayOverride : d.weekday,
          'focus': d.focus,
          'exercises': [
            for (final p in d.exercises)
              {
                'exerciseId': p.exerciseId,
                'sets': p.sets,
                'repMin': p.repMin,
                'repMax': p.repMax,
                'restSec': p.restSec,
                'rirMin': rirMin ?? p.rirMin,
                'rirMax': p.rirMax,
                'rationale': 'Pola gerak dasar.',
              },
          ],
        },
      for (var k = 0; k < extraDays; k++)
        {'weekday': 7 - k, 'focus': 'full_body_a', 'exercises': <Object>[]},
    ],
  });
}

class FakeAiClient implements AiClient {
  FakeAiClient(this.responses);

  /// Tiap elemen: String (teks JSON) atau Object (dilempar).
  final List<Object> responses;
  final requests = <String>[];

  @override
  Future<AiResponse> generateJson({
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String userContent,
    required Map<String, Object?> responseSchema,
  }) async {
    requests.add(userContent);
    final next = responses.removeAt(0);
    if (next is String) {
      return AiResponse(
        text: next,
        modelVersion: 'gemini-test',
        inputTokens: 100,
        outputTokens: 50,
      );
    }
    throw next;
  }

  @override
  Future<void> verifyKey(String apiKey) async {}
}

class MemoryKeyStore implements AiKeyStore {
  MemoryKeyStore([this.key]);

  String? key;
  String? model;

  @override
  Future<String?> read() async => key;
  @override
  Future<void> write(String k) async => key = k;
  @override
  Future<void> delete() async => key = model = null;
  @override
  Future<String?> readModel() async => model;
  @override
  Future<void> writeModel(String m) async => model = m;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('GeminiClient', () {
    test('parseResponse: abaikan bagian thought, ambil token & versi model', () {
      final r = GeminiClient.parseResponse({
        'candidates': [
          {
            'finishReason': 'STOP',
            'content': {
              'parts': [
                {'text': 'pikiran', 'thought': true},
                {'text': '{"a":1}', 'thoughtSignature': 'xyz'},
              ],
            },
          },
        ],
        'usageMetadata': {
          'promptTokenCount': 33,
          'candidatesTokenCount': 27,
          'thoughtsTokenCount': 265,
        },
        'modelVersion': 'gemini-3.6-flash',
      });
      expect(r.text, '{"a":1}');
      expect(r.inputTokens, 33);
      expect(r.outputTokens, 292);
      expect(r.modelVersion, 'gemini-3.6-flash');
    });

    test('parseResponse: kosong / diblokir → AppFailure', () {
      expect(
        () => GeminiClient.parseResponse({
          'candidates': [
            {
              'finishReason': 'SAFETY',
              'content': {'parts': <Object>[]},
            },
          ],
        }),
        throwsA(isA<AppFailure>().having((f) => f.kind, 'kind', FailureKind.invalidInput)),
      );
      expect(
        () => GeminiClient.parseResponse({}),
        throwsA(isA<AppFailure>().having((f) => f.kind, 'kind', FailureKind.unavailable)),
      );
    });

    test('mapError: status HTTP → jenis kegagalan stabil', () {
      AppFailure map(int status, [Object? data]) => GeminiClient.mapError(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: RequestOptions(), statusCode: status, data: data),
        ),
      );
      expect(
        map(400, {
          'error': {
            'status': 'INVALID_ARGUMENT',
            'details': [
              {'reason': 'API_KEY_INVALID'},
            ],
          },
        }).kind,
        FailureKind.unauthenticated,
      );
      expect(map(403).kind, FailureKind.permissionDenied);
      expect(map(429).kind, FailureKind.quotaExceeded);
      expect(map(503).kind, FailureKind.unavailable);
      expect(
        map(400, {
          'error': {'status': 'INVALID_ARGUMENT'},
        }).kind,
        FailureKind.invalidInput,
      );
      expect(
        GeminiClient.mapError(
          DioException(requestOptions: RequestOptions(), type: DioExceptionType.receiveTimeout),
        ).kind,
        FailureKind.timeout,
      );
      expect(
        GeminiClient.mapError(
          DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError),
        ).kind,
        FailureKind.network,
      );
    });
  });

  group('prompt workout_plan.v1', () {
    final a = sample.copyWith(
      profile: sample.profile.copyWith(nickname: 'Budi'),
      safety: const SafetySection(
        injuries: 'Bahu kanan',
        medicalFlags: [MedicalFlag.chronicCondition],
      ),
    );
    final allowed = AiPlanParser.allowedExercises(a, catalog);
    final content = WorkoutPlanPromptV1.userContent(
      a,
      allowedExercises: allowed,
      conservative: true,
    );
    final payload = jsonDecode(content) as Map<String, dynamic>;

    test('data diminimalkan: tanpa identitas, umur, berat/tinggi, atau jenis kondisi medis', () {
      for (final secret in ['Budi', '1996-05-10', '175', '"70', 'chronic', 'male']) {
        expect(content, isNot(contains(secret)), reason: secret);
      }
      expect(payload.keys, isNot(contains('profil')));
      expect(payload['keselamatan'], {
        'modeKonservatif': true,
        'catatanCedera': 'Bahu kanan',
        'gerakanDihindari': null,
      });
    });

    test('hanya latihan yang alat & levelnya sesuai; schema membatasi ID', () {
      final ids = [for (final e in payload['katalog'] as List<dynamic>) (e as Map)['id']];
      expect(ids, isNot(contains('barbell_back_squat'))); // butuh rack & level menengah
      expect(ids, contains('goblet_squat'));
      final schema = WorkoutPlanPromptV1.responseSchema(ids.cast<String>());
      final exEnum =
          ((((schema['properties']! as Map)['days']! as Map)['items']! as Map)['properties']!
                  as Map)['exercises']!
              as Map;
      expect(((exEnum['items']! as Map)['properties']! as Map)['exerciseId'], {
        'type': 'STRING',
        'enum': ids,
      });
      expect(payload['hariTersedia'], [1, 3, 5]);
      expect(payload['maksHariLatihan'], 4);
      expect((payload['batas'] as Map)['rir'], [2, 5]); // pemula
    });
  });

  group('AiPlanParser', () {
    AiPlanResult parse(String raw, [AssessmentData a = sample]) =>
        AiPlanParser.parse(raw, assessment: a, catalog: catalog);

    test('output valid → draft dengan nama, satuan, prioritas & alasan dari katalog', () {
      final r = parse(validAiJson(sample));
      expect(r.isValid, isTrue, reason: r.problems.join('\n'));
      expect(r.rationale, contains('pemula'));
      final first = r.draft!.days.first.exercises.first;
      expect(first.name, catalog[first.exerciseId]!.name);
      expect(first.rationale, 'Pola gerak dasar.');
      expect(r.draft!.days.map((d) => d.weekday), [1, 3, 5]);
    });

    test('bukan JSON / schemaVersion salah / hari kosong → tidak valid', () {
      expect(parse('bukan json').problems.single, startsWith('invalid_json'));
      final wrongVersion = (jsonDecode(validAiJson(sample)) as Map<String, dynamic>)
        ..['schemaVersion'] = 2;
      expect(parse(jsonEncode(wrongVersion)).problems, contains(startsWith('schema_version')));
      expect(
        parse(jsonEncode({'schemaVersion': 1, 'split': 'full_body', 'rationale': '', 'days': []}))
            .isValid,
        isFalse,
      );
    });

    test('hari di luar ketersediaan, terlalu banyak hari, RIR pemula < 2 → tidak valid', () {
      expect(
        parse(validAiJson(sample, weekdayOverride: 2)).problems,
        contains(contains('bukan hari yang tersedia')),
      );
      expect(parse(validAiJson(sample, rirMin: 0)).problems, contains(contains('rirMin ≥ 2')));
      final many = parse(validAiJson(sample, extraDays: 2));
      expect(many.isValid, isFalse);
    });

    test('alat tidak tersedia & ID di luar katalog ditolak (pertahanan berlapis)', () {
      final json = jsonDecode(validAiJson(sample)) as Map<String, dynamic>;
      final ex = ((json['days'] as List).first as Map)['exercises'] as List;
      (ex[0] as Map)['exerciseId'] = 'barbell_back_squat'; // butuh rack
      (ex[1] as Map)['exerciseId'] = 'kettlebell_swing';
      final r = parse(jsonEncode(json));
      expect(r.problems, contains(contains('equipment_missing')));
      expect(r.problems, contains(contains('tidak ada di katalog')));
    });

    test('sesi jauh melebihi durasi → tidak valid', () {
      final json = jsonDecode(validAiJson(sample)) as Map<String, dynamic>;
      for (final e in ((json['days'] as List).first as Map)['exercises'] as List) {
        (e as Map)['sets'] = 5;
        e['restSec'] = 300;
      }
      expect(parse(jsonEncode(json)).problems, contains(contains('melebihi durasi sesi')));
    });
  });

  group('AiPlanService', () {
    late AppDatabase db;
    late LocalWorkoutRepository workouts;
    late AiRepository aiRepo;
    late MemoryKeyStore keys;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      DateTime clock() => now;
      workouts = LocalWorkoutRepository(db, clock, () async => catalog);
      aiRepo = AiRepository(db);
      keys = MemoryKeyStore('kunci-uji');
      final goalId = await LocalAssessmentRepository(db, clock).submit(sample);
      await LocalGoalRepository(db, clock).confirm(goalId, acknowledgedWarnings: true);
      await aiRepo.setConsent(accepted: true, now: now);
    });

    tearDown(() => db.close());

    AiPlanService service(FakeAiClient client) => AiPlanService(
      workouts: workouts,
      ai: aiRepo,
      client: client,
      keys: keys,
      clock: () => now,
      model: () async => AiConfig.defaultModel,
    );

    Future<List<AiLogRow>> logs() => db.select(db.aiGenerationLogs).get();

    test('sukses: draft AI tersimpan dengan alasan & model; log tanpa isi data', () async {
      final client = FakeAiClient([validAiJson(sample)]);
      final planId = await service(client).generateWorkoutPlan();
      final plan = (await workouts.watchPlan(planId).first)!;
      expect(plan.status, PlanStatus.draft);
      expect(plan.isAiGenerated, isTrue);
      expect(plan.model, 'gemini-test');
      expect(plan.rationale, isNotEmpty);
      final log = (await logs()).single;
      expect(log.status, 'success');
      expect(log.attempts, 1);
      expect(log.promptVersion, WorkoutPlanPromptV1.version);
      expect(log.inputTokens, 100);
    });

    test('output tidak valid → 1 retry dengan umpan balik, lalu sukses', () async {
      final client = FakeAiClient([validAiJson(sample, rirMin: 0), validAiJson(sample)]);
      final planId = await service(client).generateWorkoutPlan();
      expect(planId, isNotEmpty);
      expect(client.requests, hasLength(2));
      expect(client.requests.last, contains('TIDAK VALID'));
      expect(client.requests.last, contains('rirMin ≥ 2'));
      expect((await logs()).single.attempts, 2);
    });

    test('tetap tidak valid setelah retry → tidak ada yang disimpan', () async {
      final client = FakeAiClient(['{}', 'bukan json']);
      await expectLater(
        service(client).generateWorkoutPlan(),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'error', AiPlanError.invalidOutput)),
      );
      expect(await db.select(db.workoutPlans).get(), isEmpty);
      expect((await logs()).single.status, 'invalid');
    });

    test('error jaringan/kuota API → AppFailure + log error', () async {
      final client = FakeAiClient([
        const AppFailure(FailureKind.quotaExceeded, debugMessage: 'gemini-429'),
      ]);
      await expectLater(
        service(client).generateWorkoutPlan(),
        throwsA(isA<AppFailure>().having((f) => f.kind, 'kind', FailureKind.quotaExceeded)),
      );
      final log = (await logs()).single;
      expect(log.status, 'error');
      expect(log.errorCode, 'gemini-429');
    });

    test('tanpa key / tanpa persetujuan / kuota harian habis → tidak memanggil AI', () async {
      final client = FakeAiClient([]);
      keys.key = null;
      await expectLater(
        service(client).generateWorkoutPlan(),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'e', AiPlanError.noKey)),
      );
      keys.key = 'kunci-uji';
      await aiRepo.setConsent(accepted: false, now: now);
      await expectLater(
        service(client).generateWorkoutPlan(),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'e', AiPlanError.noConsent)),
      );
      await aiRepo.setConsent(accepted: true, now: now);
      for (var i = 0; i < AiConfig.dailyGenerationLimit; i++) {
        await aiRepo.log(
          kind: 'workout_plan',
          model: 'm',
          promptVersion: 'v',
          status: 'success',
          attempts: 1,
          durationMs: 1,
          now: now,
        );
      }
      expect(await aiRepo.countToday(now), AiConfig.dailyGenerationLimit);
      expect(await aiRepo.countToday(now.add(const Duration(days: 1))), 0);
      await expectLater(
        service(client).generateWorkoutPlan(),
        throwsA(isA<AiPlanException>().having((e) => e.error, 'e', AiPlanError.quotaReached)),
      );
      expect(client.requests, isEmpty);
    });
  });
}
