import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../ai_coach/application/ai_plan_service.dart';
import '../../../ai_coach/domain/ai_client.dart';
import '../../../ai_coach/domain/ai_config.dart';
import '../../../ai_coach/presentation/providers/ai_providers.dart';
import '../../application/food_scan_service.dart';
import '../../domain/food.dart';
import '../../domain/food_log.dart';
import '../../domain/food_scan.dart';
import 'nutrition_providers.dart';

part 'food_scan_providers.g.dart';

@Riverpod(keepAlive: true)
FoodScanService foodScanService(Ref ref) {
  final keys = ref.watch(aiKeyStoreProvider);
  return FoodScanService(
    nutrition: ref.watch(nutritionRepositoryProvider),
    ai: ref.watch(aiRepositoryProvider),
    client: ref.watch(aiClientProvider),
    keys: keys,
    clock: ref.watch(clockProvider),
    model: () async => await keys.readModel() ?? AiConfig.defaultModel,
  );
}

/// Draft hasil scan yang sedang ditinjau (belum dicatat).
class FoodScanDraft {
  const FoodScanDraft({
    required this.date,
    required this.meal,
    required this.result,
    required this.items,
    required this.imagePath,
  });

  final String date;
  final MealSlot meal;
  final FoodScanResult result;
  final List<FoodScanItem> items;

  /// Foto sementara (dihapus setelah disimpan/dibatalkan).
  final String imagePath;

  Nutrients get totals => items.fold(Nutrients.zero, (s, i) => s + i.nutrients);

  FoodScanDraft copyWith({MealSlot? meal, List<FoodScanItem>? items}) => FoodScanDraft(
    date: date,
    meal: meal ?? this.meal,
    result: result,
    items: items ?? this.items,
    imagePath: imagePath,
  );
}

/// Status scan terakhir (`AsyncError` berisi [AiPlanException]/`AppFailure`).
@Riverpod(keepAlive: true)
class FoodScanner extends _$FoodScanner {
  @override
  FutureOr<void> build() {}

  /// Analisis foto di [path] (sudah dipilih & diperkecil oleh pemilih foto).
  /// `true` bila draft siap; `false` bila gagal (lihat `state`).
  Future<bool> analyze({required String path, required String date, required MealSlot meal}) async {
    state = const AsyncLoading();
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      if (bytes.length > FoodScanService.maxImageBytes) {
        throw StateError('image-too-large');
      }
      final mime = path.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
      final result = await ref
          .read(foodScanServiceProvider)
          .scan(AiImage(bytes: bytes, mimeType: mime));
      ref
          .read(foodScanDraftControllerProvider.notifier)
          .set(
            FoodScanDraft(
              date: date,
              meal: meal,
              result: result,
              items: result.items,
              imagePath: path,
            ),
          );
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } on AiPlanException catch (e, st) {
      await _deleteQuietly(path);
      if (ref.mounted) state = AsyncError(e, st);
      return false;
    } catch (e, st) {
      await _deleteQuietly(path);
      if (ref.mounted) state = AsyncError(FailureMapper.from(e), st);
      return false;
    }
  }
}

Future<void> _deleteQuietly(String path) async {
  try {
    final f = File(path);
    if (await f.exists()) await f.delete();
  } catch (_) {}
}

/// Draft yang ditinjau di layar hasil scan.
@Riverpod(keepAlive: true)
class FoodScanDraftController extends _$FoodScanDraftController {
  @override
  FoodScanDraft? build() => null;

  void set(FoodScanDraft draft) => state = draft;

  void setMeal(MealSlot meal) => state = state?.copyWith(meal: meal);

  void setGrams(int index, double grams) {
    final d = state;
    if (d == null || index >= d.items.length) return;
    final g = grams.clamp(FoodScanValidator.minGrams, FoodScanValidator.maxGrams).toDouble();
    state = d.copyWith(items: [...d.items]..[index] = d.items[index].withGrams(g));
  }

  void remove(int index) {
    final d = state;
    if (d == null || index >= d.items.length) return;
    state = d.copyWith(items: [...d.items]..removeAt(index));
  }

  /// Catat semua item ke log makan (TKPI via katalog, sisanya estimasi AI).
  Future<int> save() async {
    final d = state;
    if (d == null) return 0;
    final repo = ref.read(nutritionRepositoryProvider);
    var saved = 0;
    for (final item in d.items) {
      final food = item.food;
      if (food != null) {
        await repo.logFood(date: d.date, meal: d.meal, food: food, grams: item.grams);
      } else {
        await repo.logManual(
          date: d.date,
          meal: d.meal,
          name: item.name,
          nutrients: item.nutrients,
          quality: NutritionQuality.aiEstimate,
        );
      }
      saved++;
    }
    await discard();
    return saved;
  }

  /// Batalkan draft & hapus foto sementara.
  Future<void> discard() async {
    final path = state?.imagePath;
    state = null;
    if (path != null) await _deleteQuietly(path);
  }
}
