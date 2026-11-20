import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/ai_config.dart';
import '../providers/ai_providers.dart';

/// Pengaturan Gemini: API key (terenkripsi), model, dan persetujuan data.
class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  final _key = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action, {String? success}) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && success != null) context.showSnack(success);
    } catch (e) {
      if (mounted) context.showSnack(failureMessage(context.l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final async = ref.watch(aiSettingsControllerProvider);
    final controller = ref.read(aiSettingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.aiSettingsTitle)),
      body: switch (async) {
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l.aiSettingsIntro),
            const SizedBox(height: 12),
            Card(
              color: value.ready
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.secondaryContainer,
              child: ListTile(
                leading: Icon(value.ready ? Icons.check_circle : Icons.info_outline),
                title: Text(value.ready ? l.aiStatusReady : l.aiStatusNotReady),
                subtitle: value.hasKey ? Text(l.aiKeySaved(value.keySuffix!)) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('ai-key'),
              controller: _key,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l.aiKeyLabel,
                hintText: l.aiKeyHint,
                prefixIcon: const Icon(Icons.key_outlined),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _busy
                        ? null
                        : () => _run(() async {
                            if (_key.text.trim().isEmpty) return;
                            await controller.saveKey(_key.text);
                            _key.clear();
                          }, success: l.aiKeyVerified),
                    child: _busy
                        ? const SizedBox.square(
                            dimension: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(l.aiSaveKey),
                  ),
                ),
                if (value.hasKey) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _busy
                          ? null
                          : () => _run(controller.deleteKey, success: l.aiKeyDeleted),
                      child: Text(l.aiDeleteKey),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: AiConfig.models.contains(value.model)
                  ? value.model
                  : AiConfig.defaultModel,
              decoration: InputDecoration(labelText: l.aiModelLabel),
              items: [for (final m in AiConfig.models) DropdownMenuItem(value: m, child: Text(m))],
              onChanged: _busy
                  ? null
                  : (m) => m == null ? null : _run(() => controller.setModel(m)),
            ),
            const SizedBox(height: 24),
            Text(l.aiConsentTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(l.aiConsentBody),
            const SizedBox(height: 8),
            Text(
              l.aiFreeTierNote,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            CheckboxListTile(
              key: const ValueKey('ai-consent'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: value.consent,
              title: Text(l.aiConsentCheckbox),
              onChanged: _busy ? null : (v) => _run(() => controller.setConsent(v ?? false)),
            ),
            Text(
              l.aiQuotaNote(AiConfig.dailyGenerationLimit),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        AsyncValue(:final error?) => EmptyState(
          icon: Icons.error_outline,
          title: failureMessage(l, error),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
