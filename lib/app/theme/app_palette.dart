import 'package:flutter/material.dart';

/// Token warna di luar ColorScheme Material (lihat `.superdesign/design-system.md`):
/// permukaan kedua, teks redup, aksen lembut, dan warna makro.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.surface2,
    required this.muted,
    required this.accentSoft,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.warning,
  });

  /// Kartu bersarang, input, chip tidak aktif.
  final Color surface2;

  /// Label & teks sekunder.
  final Color muted;

  /// Latar bertint aksen (baris set selesai, pill).
  final Color accentSoft;
  final Color protein;
  final Color carbs;
  final Color fat;
  final Color warning;

  static const dark = AppPalette(
    surface2: Color(0xFF1E2321),
    muted: Color(0xFFA3ACA8),
    accentSoft: Color(0x24B6F23E),
    protein: Color(0xFF5CC8FF),
    carbs: Color(0xFFFFB547),
    fat: Color(0xFFFF7A93),
    warning: Color(0xFFFFB547),
  );

  static const light = AppPalette(
    surface2: Color(0xFFEEF1ED),
    muted: Color(0xFF5D6662),
    accentSoft: Color(0x1F4E8A00),
    protein: Color(0xFF1E8FC4),
    carbs: Color(0xFFC77E12),
    fat: Color(0xFFD1445F),
    warning: Color(0xFFB36B00),
  );

  @override
  AppPalette copyWith({
    Color? surface2,
    Color? muted,
    Color? accentSoft,
    Color? protein,
    Color? carbs,
    Color? fat,
    Color? warning,
  }) => AppPalette(
    surface2: surface2 ?? this.surface2,
    muted: muted ?? this.muted,
    accentSoft: accentSoft ?? this.accentSoft,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    warning: warning ?? this.warning,
  );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      surface2: Color.lerp(surface2, other.surface2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      protein: Color.lerp(protein, other.protein, t)!,
      carbs: Color.lerp(carbs, other.carbs, t)!,
      fat: Color.lerp(fat, other.fat, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

/// Angka tabular tebal (berat, repetisi, kalori, timer).
const tabular = [FontFeature.tabularFigures()];
