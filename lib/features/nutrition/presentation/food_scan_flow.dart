import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_palette.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/utils/context_x.dart';
import '../../ai_coach/application/ai_plan_service.dart';
import '../../progress/data/photo_picker.dart';
import '../../progress/presentation/providers/progress_providers.dart';
import '../domain/food_log.dart';
import 'providers/food_scan_providers.dart';
import 'widgets/nutrition_labels.dart';

/// Waktu makan bawaan menurut jam.
MealSlot mealForHour(int hour) => hour < 10
    ? MealSlot.breakfast
    : hour < 15
    ? MealSlot.lunch
    : hour < 18
    ? MealSlot.snack
    : MealSlot.dinner;

/// Scan makanan: pilih sumber foto & waktu makan → analisis Gemini (dialog
/// progres) → layar tinjauan. Tidak ada yang dicatat sebelum pengguna
/// menekan simpan di layar tinjauan.
Future<void> scanFood(
  BuildContext context,
  WidgetRef ref, {
  required String date,
  MealSlot? meal,
}) async {
  final l = context.l10n;
  final hour = ref.read(clockProvider)().hour;
  final choice = await showModalBottomSheet<({PhotoSource source, MealSlot meal})>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _ScanSourceSheet(initialMeal: meal ?? mealForHour(hour)),
  );
  if (choice == null || !context.mounted) return;

  final String? path;
  try {
    path = await ref.read(photoPickerProvider).pick(choice.source);
  } catch (_) {
    if (context.mounted) context.showSnack(l.photoFailed);
    return;
  }
  if (path == null || !context.mounted) return;

  final navigator = Navigator.of(context, rootNavigator: true);
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.scanAnalyzing, style: Theme.of(ctx).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(l.aiGeneratingHint, style: Theme.of(ctx).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  final ok = await ref
      .read(foodScannerProvider.notifier)
      .analyze(path: path, date: date, meal: choice.meal);
  navigator.pop();
  if (!context.mounted) return;

  if (ok) {
    final draft = ref.read(foodScanDraftControllerProvider);
    if (draft == null) return;
    if (draft.result.notFood || draft.items.isEmpty) {
      await ref.read(foodScanDraftControllerProvider.notifier).discard();
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.no_food_outlined),
          title: Text(l.scanNotFoodTitle),
          content: Text(l.scanNotFoodBody),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.close))],
        ),
      );
      return;
    }
    await context.push(Routes.foodScan);
    return;
  }

  final error = ref.read(foodScannerProvider).error;
  final setupProblem =
      error is AiPlanException &&
      (error.error == AiPlanError.noKey || error.error == AiPlanError.noConsent);
  final message = switch (error) {
    AiPlanException(error: AiPlanError.noKey || AiPlanError.noConsent) => l.aiErrorSetup,
    AiPlanException(error: AiPlanError.quotaReached) => l.scanErrorQuota,
    AiPlanException(error: AiPlanError.invalidOutput) => l.scanErrorInvalid,
    null => l.errorUnknown,
    _ => failureMessage(l, error),
  };
  final action = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.photo_camera_outlined),
      title: Text(l.scanErrorTitle),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.close)),
        if (setupProblem)
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            onPressed: () => Navigator.pop(ctx, 'settings'),
            child: Text(l.openAiSettings),
          ),
      ],
    ),
  );
  if (action == 'settings' && context.mounted) await context.push(Routes.aiSettings);
}

class _ScanSourceSheet extends StatefulWidget {
  const _ScanSourceSheet({required this.initialMeal});

  final MealSlot initialMeal;

  @override
  State<_ScanSourceSheet> createState() => _ScanSourceSheetState();
}

class _ScanSourceSheetState extends State<_ScanSourceSheet> {
  late MealSlot _meal = widget.initialMeal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    void pick(PhotoSource s) => Navigator.pop(context, (source: s, meal: _meal));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(l.scanSheetTitle, style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 8),
            Text(l.scanSheetBody, style: TextStyle(fontSize: 13, color: palette.muted)),
            const SizedBox(height: 16),
            Text(l.scanMealLabel, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in MealSlot.values)
                  ChoiceChip(
                    key: Key('scan-meal-${m.name}'),
                    label: Text(l.meal(m)),
                    selected: _meal == m,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: _meal == m ? theme.colorScheme.onPrimary : null,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _meal = m),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    key: const Key('scan-camera'),
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
                    onPressed: () => pick(PhotoSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(l.photoCamera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('scan-gallery'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                    onPressed: () => pick(PhotoSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l.photoGallery),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
