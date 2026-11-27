import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/context_x.dart';
import '../../data/guided_settings_repository.dart';
import '../../domain/guided_set.dart';
import '../../domain/guided_settings.dart';

final guidedSettingsRepositoryProvider = Provider<GuidedSettingsRepository>(
  (ref) => GuidedSettingsRepository(ref.watch(appDatabaseProvider), ref.watch(clockProvider)),
);

final guidedSettingsProvider = StreamProvider<GuidedSettings>(
  (ref) => ref.watch(guidedSettingsRepositoryProvider).watch(),
);

/// Lembar pengaturan Mode Panduan (tempo, aba-aba, bunyi). Tersimpan
/// langsung setiap kali diubah.
Future<void> showGuidedSettingsSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _GuidedSettingsSheet(),
);

class _GuidedSettingsSheet extends ConsumerWidget {
  const _GuidedSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final palette = context.palette;
    final theme = Theme.of(context);
    final s = ref.watch(guidedSettingsProvider).value ?? const GuidedSettings();
    void save(GuidedSettings next) =>
        unawaited(ref.read(guidedSettingsRepositoryProvider).save(next));
    final t = s.tempo;

    Widget stepper(
      String label,
      String keyName,
      int value,
      ({int min, int max}) range,
      Tempo Function(int) apply,
    ) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
          IconButton.filledTonal(
            key: Key('guided-$keyName-minus'),
            onPressed: value > range.min ? () => save(s.copyWith(tempo: apply(value - 1))) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 56,
            child: Text(
              '$value ${l.guidedSecShort}',
              key: Key('guided-$keyName-value'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFeatures: tabular,
              ),
            ),
          ),
          IconButton.filledTonal(
            key: Key('guided-$keyName-plus'),
            onPressed: value < range.max ? () => save(s.copyWith(tempo: apply(value + 1))) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.guidedSettingsTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              l.guidedSettingsTempoHint(t.label, t.total),
              style: TextStyle(fontSize: 13, color: palette.muted),
            ),
            const SizedBox(height: 12),
            stepper(
              l.guidedSettingsEccentric,
              'eccentric',
              t.eccentric,
              GuidedSettings.eccentricRange,
              (v) => Tempo(eccentric: v, pause: t.pause, concentric: t.concentric),
            ),
            stepper(
              l.guidedSettingsPause,
              'pause',
              t.pause,
              GuidedSettings.pauseRange,
              (v) => Tempo(eccentric: t.eccentric, pause: v, concentric: t.concentric),
            ),
            stepper(
              l.guidedSettingsConcentric,
              'concentric',
              t.concentric,
              GuidedSettings.concentricRange,
              (v) => Tempo(eccentric: t.eccentric, pause: t.pause, concentric: v),
            ),
            const SizedBox(height: 16),
            Text(l.guidedSettingsCountdown, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                for (final c in GuidedSettings.countdownOptions)
                  ButtonSegment(
                    value: c,
                    label: Text(c == 0 ? l.guidedSettingsNoCountdown : '$c ${l.guidedSecShort}'),
                  ),
              ],
              selected: {s.countdownSeconds},
              onSelectionChanged: (v) => save(s.copyWith(countdownSeconds: v.first)),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              key: const Key('guided-sound'),
              contentPadding: EdgeInsets.zero,
              title: Text(l.guidedSettingsSound),
              subtitle: Text(l.guidedSettingsSoundHint),
              value: s.sound,
              onChanged: (v) => save(s.copyWith(sound: v)),
            ),
            if (s != const GuidedSettings())
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  key: const Key('guided-reset'),
                  onPressed: () => save(const GuidedSettings()),
                  child: Text(l.guidedSettingsReset),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
