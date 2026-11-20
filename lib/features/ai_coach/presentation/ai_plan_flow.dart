import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/utils/context_x.dart';
import '../../workout/presentation/screens/workout_screen.dart';
import '../application/ai_plan_service.dart';
import 'providers/ai_providers.dart';

/// Tampilkan pilihan pembuat program (AI / template).
Future<void> chooseAndCreatePlan(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final choice = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(l.chooseGenerator, style: Theme.of(ctx).textTheme.titleMedium)),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: Text(l.generateWithAi),
            onTap: () => Navigator.pop(ctx, 'ai'),
          ),
          ListTile(
            leading: const Icon(Icons.rule),
            title: Text(l.generateTemplate),
            onTap: () => Navigator.pop(ctx, 'template'),
          ),
        ],
      ),
    ),
  );
  if (!context.mounted || choice == null) return;
  if (choice == 'ai') {
    await generateAiPlan(context, ref);
  } else {
    await createAndOpenStarterPlan(context, ref);
  }
}

/// Susun program dengan AI sambil menampilkan dialog progres; buka pratinjau
/// draft bila berhasil, atau jelaskan kegagalan + tawarkan template.
Future<void> generateAiPlan(BuildContext context, WidgetRef ref) async {
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
                    Text(l.aiGenerating, style: Theme.of(ctx).textTheme.titleMedium),
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
  final planId = await ref.read(aiPlanGeneratorProvider.notifier).generate();
  navigator.pop();
  if (!context.mounted) return;
  if (planId != null) {
    await context.push(Routes.planPath(planId));
    return;
  }

  final error = ref.read(aiPlanGeneratorProvider).error;
  final setupProblem =
      error is AiPlanException &&
      (error.error == AiPlanError.noKey || error.error == AiPlanError.noConsent);
  final message = switch (error) {
    AiPlanException(error: AiPlanError.noKey || AiPlanError.noConsent) => l.aiErrorSetup,
    AiPlanException(error: AiPlanError.quotaReached) => l.aiErrorQuota,
    AiPlanException(error: AiPlanError.invalidOutput) => l.aiErrorInvalid,
    null => l.errorUnknown,
    _ => failureMessage(l, error),
  };
  final action = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.auto_awesome),
      title: Text(l.aiErrorTitle),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.close)),
        if (setupProblem)
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            onPressed: () => Navigator.pop(ctx, 'settings'),
            child: Text(l.openAiSettings),
          )
        else ...[
          TextButton(onPressed: () => Navigator.pop(ctx, 'template'), child: Text(l.useTemplate)),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            onPressed: () => Navigator.pop(ctx, 'retry'),
            child: Text(l.retry),
          ),
        ],
      ],
    ),
  );
  if (!context.mounted) return;
  switch (action) {
    case 'settings':
      await context.push(Routes.aiSettings);
    case 'template':
      await createAndOpenStarterPlan(context, ref);
    case 'retry':
      await generateAiPlan(context, ref);
  }
}
