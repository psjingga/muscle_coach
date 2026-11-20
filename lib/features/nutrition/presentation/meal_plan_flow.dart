import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/utils/context_x.dart';
import '../../ai_coach/application/ai_plan_service.dart';
import 'providers/nutrition_providers.dart';

/// Susun menu dengan AI sambil menampilkan dialog progres; buka pratinjau
/// draft bila berhasil, atau jelaskan kegagalan.
Future<void> generateMealPlan(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
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
                    Text(l.mealPlanGenerating, style: Theme.of(ctx).textTheme.titleMedium),
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
  final id = await ref.read(mealPlanGeneratorProvider.notifier).generate();
  navigator.pop();
  if (!context.mounted) return;
  if (id != null) {
    await context.push(Routes.mealPlanPath(id));
    return;
  }

  final error = ref.read(mealPlanGeneratorProvider).error;
  final setupProblem =
      error is AiPlanException &&
      (error.error == AiPlanError.noKey || error.error == AiPlanError.noConsent);
  final message = switch (error) {
    AiPlanException(error: AiPlanError.noKey || AiPlanError.noConsent) => l.aiErrorSetup,
    AiPlanException(error: AiPlanError.quotaReached) => l.mealPlanErrorQuota,
    AiPlanException(error: AiPlanError.invalidOutput) => l.mealPlanErrorInvalid,
    null => l.errorUnknown,
    _ => failureMessage(l, error),
  };
  final action = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.auto_awesome),
      title: Text(l.mealPlanErrorTitle),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.close)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
          onPressed: () => Navigator.pop(ctx, setupProblem ? 'settings' : 'retry'),
          child: Text(setupProblem ? l.openAiSettings : l.retry),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  switch (action) {
    case 'settings':
      await context.push(Routes.aiSettings);
    case 'retry':
      await generateMealPlan(context, ref);
  }
}
