import 'guided_set.dart';

/// Preferensi Mode Panduan: tempo per fase, panjang aba-aba, bunyi bip.
class GuidedSettings {
  const GuidedSettings({this.tempo = Tempo.standard, this.countdownSeconds = 3, this.sound = true});

  final Tempo tempo;

  /// 0 = tanpa aba-aba.
  final int countdownSeconds;

  /// Bunyi bip; getar selalu aktif.
  final bool sound;

  static const countdownOptions = [0, 3, 5];
  static const eccentricRange = (min: 1, max: 6);
  static const pauseRange = (min: 0, max: 3);
  static const concentricRange = (min: 1, max: 4);

  GuidedSettings copyWith({Tempo? tempo, int? countdownSeconds, bool? sound}) => GuidedSettings(
    tempo: tempo ?? this.tempo,
    countdownSeconds: countdownSeconds ?? this.countdownSeconds,
    sound: sound ?? this.sound,
  );

  Map<String, Object> toJson() => {
    'eccentric': tempo.eccentric,
    'pause': tempo.pause,
    'concentric': tempo.concentric,
    'countdown': countdownSeconds,
    'sound': sound,
  };

  /// Nilai rusak/di luar rentang kembali ke bawaan (data lokal bisa saja
  /// berasal dari versi lama atau cadangan).
  factory GuidedSettings.fromJson(Map<String, dynamic> json) {
    int pick(String key, ({int min, int max}) r, int fallback) {
      final v = json[key];
      return v is int && v >= r.min && v <= r.max ? v : fallback;
    }

    const d = GuidedSettings();
    final countdown = json['countdown'];
    return GuidedSettings(
      tempo: Tempo(
        eccentric: pick('eccentric', eccentricRange, d.tempo.eccentric),
        pause: pick('pause', pauseRange, d.tempo.pause),
        concentric: pick('concentric', concentricRange, d.tempo.concentric),
      ),
      countdownSeconds: countdown is int && countdownOptions.contains(countdown)
          ? countdown
          : d.countdownSeconds,
      sound: json['sound'] is bool ? json['sound'] as bool : d.sound,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GuidedSettings &&
      other.tempo.eccentric == tempo.eccentric &&
      other.tempo.pause == tempo.pause &&
      other.tempo.concentric == tempo.concentric &&
      other.countdownSeconds == countdownSeconds &&
      other.sound == sound;

  @override
  int get hashCode =>
      Object.hash(tempo.eccentric, tempo.pause, tempo.concentric, countdownSeconds, sound);
}
