import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/logging/app_logger.dart';
import '../../domain/guided_set.dart';

/// Isyarat Mode Panduan: getar + bunyi bip, dan menjaga layar tetap menyala
/// selama set. Interface agar tes bisa memakai versi diam.
abstract class GuidedCuePlayer {
  Future<void> play(GuidedCue cue);

  /// Layar tidak mati selama set berjalan.
  Future<void> keepAwake(bool on);

  /// Lepas sumber daya (pemutar suara, wakelock).
  Future<void> dispose();
}

Future<void> _haptic(GuidedCue cue) => switch (cue) {
  GuidedCue.countdownTick || GuidedCue.phaseChange => HapticFeedback.lightImpact(),
  GuidedCue.go || GuidedCue.repComplete => HapticFeedback.mediumImpact(),
  GuidedCue.setComplete => HapticFeedback.heavyImpact(),
};

/// Getar saja (tanpa bunyi & tanpa wakelock).
class HapticCuePlayer implements GuidedCuePlayer {
  const HapticCuePlayer();

  @override
  Future<void> play(GuidedCue cue) => _haptic(cue);

  @override
  Future<void> keepAwake(bool on) async {}

  @override
  Future<void> dispose() async {}
}

/// Getar + bip dari `assets/sounds/` + wakelock. Bunyi diputar bercampur
/// dengan musik pengguna (tidak menghentikan Spotify/YouTube Music).
class DeviceCuePlayer implements GuidedCuePlayer {
  DeviceCuePlayer({this.sound = true});

  /// Bip aktif; getar selalu aktif.
  final bool sound;

  static const _files = {
    GuidedCue.countdownTick: 'sounds/tick.wav',
    GuidedCue.go: 'sounds/go.wav',
    GuidedCue.phaseChange: 'sounds/phase.wav',
    GuidedCue.repComplete: 'sounds/rep.wav',
    GuidedCue.setComplete: 'sounds/set.wav',
  };

  final _pools = <GuidedCue, Future<AudioPool?>>{};
  bool _awake = false;

  /// Tanpa fokus audio (Android) / mixWithOthers (iOS): bip tidak menjeda
  /// musik. Diberikan ke tiap pemutar agar tidak bergantung pada urutan
  /// pemuatan.
  static final _context = AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build();

  Future<AudioPool?> _pool(GuidedCue cue) => _pools.putIfAbsent(cue, () async {
    try {
      return await AudioPool.create(
        source: AssetSource(_files[cue]!),
        maxPlayers: 2,
        playerMode: PlayerMode.lowLatency,
        audioContext: _context,
      );
    } catch (e) {
      appLogger.w('Bunyi panduan tidak bisa dimuat: ${e.runtimeType}');
      return null;
    }
  });

  /// Muat semua bunyi lebih awal agar bip pertama tidak terlambat.
  void preload() {
    if (!sound) return;
    for (final c in GuidedCue.values) {
      unawaited(_pool(c));
    }
  }

  @override
  Future<void> play(GuidedCue cue) async {
    unawaited(_haptic(cue));
    if (!sound) return;
    try {
      await (await _pool(cue))?.start();
    } catch (e) {
      appLogger.w('Bunyi panduan gagal diputar: ${e.runtimeType}');
    }
  }

  @override
  Future<void> keepAwake(bool on) async {
    if (on == _awake) return;
    _awake = on;
    try {
      await (on ? WakelockPlus.enable() : WakelockPlus.disable());
    } catch (e) {
      appLogger.w('Wakelock gagal: ${e.runtimeType}');
    }
  }

  @override
  Future<void> dispose() async {
    await keepAwake(false);
    for (final p in _pools.values) {
      try {
        await (await p)?.dispose();
      } catch (_) {}
    }
    _pools.clear();
  }
}

/// Pembuat pemutar isyarat; tiap layar Mode Panduan membuat miliknya
/// sendiri lalu melepasnya saat ditutup. [sound] = bip aktif.
typedef GuidedCuePlayerFactory = GuidedCuePlayer Function({required bool sound});

final guidedCuePlayerFactoryProvider = Provider<GuidedCuePlayerFactory>(
  (ref) =>
      ({required bool sound}) => DeviceCuePlayer(sound: sound)..preload(),
);
