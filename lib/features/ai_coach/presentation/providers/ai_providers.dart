import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../workout/presentation/providers/workout_providers.dart';
import '../../application/ai_plan_service.dart';
import '../../data/ai_repository.dart';
import '../../data/gemini_client.dart';
import '../../data/secure_key_store.dart';
import '../../domain/ai_client.dart';
import '../../domain/ai_config.dart';

part 'ai_providers.freezed.dart';
part 'ai_providers.g.dart';

@Riverpod(keepAlive: true)
AiKeyStore aiKeyStore(Ref ref) => SecureAiKeyStore();

@Riverpod(keepAlive: true)
AiClient aiClient(Ref ref) => GeminiClient();

@Riverpod(keepAlive: true)
AiRepository aiRepository(Ref ref) => AiRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
AiPlanService aiPlanService(Ref ref) {
  final keys = ref.watch(aiKeyStoreProvider);
  return AiPlanService(
    workouts: ref.watch(workoutRepositoryProvider),
    ai: ref.watch(aiRepositoryProvider),
    client: ref.watch(aiClientProvider),
    keys: keys,
    clock: ref.watch(clockProvider),
    model: () async => await keys.readModel() ?? AiConfig.defaultModel,
  );
}

@freezed
abstract class AiSettings with _$AiSettings {
  const factory AiSettings({
    /// 4 karakter terakhir key (untuk ditampilkan), `null` bila belum ada.
    String? keySuffix,
    required String model,
    required bool consent,
  }) = _AiSettings;

  const AiSettings._();

  bool get hasKey => keySuffix != null;
  bool get ready => hasKey && consent;
}

/// Pengaturan AI. Key tidak pernah disimpan di state (hanya akhiran).
@Riverpod(keepAlive: true)
class AiSettingsController extends _$AiSettingsController {
  AiKeyStore get _keys => ref.read(aiKeyStoreProvider);

  @override
  Future<AiSettings> build() async {
    final key = await ref.watch(aiKeyStoreProvider).read();
    return AiSettings(
      keySuffix: key == null || key.isEmpty ? null : _suffix(key),
      model: await ref.watch(aiKeyStoreProvider).readModel() ?? AiConfig.defaultModel,
      consent: await ref.watch(aiRepositoryProvider).hasConsent(),
    );
  }

  static String _suffix(String key) => key.length <= 4 ? key : key.substring(key.length - 4);

  /// Verifikasi key ke Gemini lalu simpan. Melempar `AppFailure` bila gagal.
  Future<void> saveKey(String key) async {
    final trimmed = key.trim();
    await ref.read(aiClientProvider).verifyKey(trimmed);
    await _keys.write(trimmed);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteKey() async {
    await _keys.delete();
    ref.invalidateSelf();
    await future;
  }

  Future<void> setModel(String model) async {
    await _keys.writeModel(model);
    ref.invalidateSelf();
    await future;
  }

  Future<void> setConsent(bool accepted) async {
    await ref
        .read(aiRepositoryProvider)
        .setConsent(accepted: accepted, now: ref.read(clockProvider)());
    ref.invalidateSelf();
    await future;
  }
}

/// Aksi "Susun program dengan AI"; `state` = status aksi terakhir.
@riverpod
class AiPlanGenerator extends _$AiPlanGenerator {
  @override
  FutureOr<void> build() {}

  /// ID draft program, atau `null` bila gagal (error di `state`).
  Future<String?> generate() async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(aiPlanServiceProvider).generateWorkoutPlan();
      if (ref.mounted) state = const AsyncData(null);
      return id;
    } on AiPlanException catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
      return null;
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(FailureMapper.from(e), st);
      return null;
    }
  }
}
