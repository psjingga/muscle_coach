import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Tema "gelap dulu" dengan satu aksen volt (lihat `.superdesign/design-system.md`).
/// Target sentuh dibuat besar (≥ 52 px) agar nyaman dipakai di gym dengan
/// tangan berkeringat. Kartu datar dengan garis tepi 1 px, tanpa bayangan.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static const radius = 14.0;
  static const cardRadius = 20.0;
  static const minTouchHeight = 52.0;
  static const fontFamily = 'Inter';

  /// Untuk tombol di dalam Row/ListTile: tema bawaan memakai lebar minimum
  /// tak terbatas (tombol penuh di kolom) yang tidak valid di sumbu horizontal.
  static const compactButtonSize = Size(64, minTouchHeight);

  static ColorScheme _scheme(Brightness b) => b == Brightness.dark
      ? const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFB6F23E),
          onPrimary: Color(0xFF0B0D0C),
          primaryContainer: Color(0xFF26330E),
          onPrimaryContainer: Color(0xFFD8FA94),
          secondary: Color(0xFFB6F23E),
          onSecondary: Color(0xFF0B0D0C),
          secondaryContainer: Color(0xFF26330E),
          onSecondaryContainer: Color(0xFFD8FA94),
          tertiary: Color(0xFFFFB547),
          onTertiary: Color(0xFF0B0D0C),
          tertiaryContainer: Color(0xFF3A2A10),
          onTertiaryContainer: Color(0xFFFFD9A1),
          error: Color(0xFFFF5A5A),
          onError: Color(0xFF0B0D0C),
          errorContainer: Color(0xFF4A1616),
          onErrorContainer: Color(0xFFFFC9C9),
          surface: Color(0xFF0B0D0C),
          onSurface: Color(0xFFF2F5F3),
          onSurfaceVariant: Color(0xFFA3ACA8),
          surfaceContainerLowest: Color(0xFF080A09),
          surfaceContainerLow: Color(0xFF151918),
          surfaceContainer: Color(0xFF151918),
          surfaceContainerHigh: Color(0xFF1E2321),
          surfaceContainerHighest: Color(0xFF252B28),
          outline: Color(0xFF4A524F),
          outlineVariant: Color(0xFF2A302E),
          inverseSurface: Color(0xFFF2F5F3),
          onInverseSurface: Color(0xFF0B0D0C),
          inversePrimary: Color(0xFF4E8A00),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
        )
      : const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF4E8A00),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFDDF5B5),
          onPrimaryContainer: Color(0xFF1E3500),
          secondary: Color(0xFF4E8A00),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFDDF5B5),
          onSecondaryContainer: Color(0xFF1E3500),
          tertiary: Color(0xFFB36B00),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFE6C2),
          onTertiaryContainer: Color(0xFF3D2500),
          error: Color(0xFFC62828),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
          surface: Color(0xFFF4F6F3),
          onSurface: Color(0xFF111413),
          onSurfaceVariant: Color(0xFF5D6662),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFFFFFFF),
          surfaceContainer: Color(0xFFFFFFFF),
          surfaceContainerHigh: Color(0xFFEEF1ED),
          surfaceContainerHighest: Color(0xFFE5E9E4),
          outline: Color(0xFFA5ADA8),
          outlineVariant: Color(0xFFDDE2DC),
          inverseSurface: Color(0xFF111413),
          onInverseSurface: Color(0xFFF4F6F3),
          inversePrimary: Color(0xFFB6F23E),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
        );

  static TextTheme _text(TextTheme base) => base
      .apply(fontFamily: fontFamily)
      .copyWith(
        headlineSmall: base.headlineSmall?.copyWith(
          fontFamily: fontFamily,
          fontSize: 28,
          height: 32 / 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 26 / 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: base.titleSmall?.copyWith(fontFamily: fontFamily, fontWeight: FontWeight.w600),
        bodyLarge: base.bodyLarge?.copyWith(fontFamily: fontFamily, fontSize: 15, height: 22 / 15),
        bodyMedium: base.bodyMedium?.copyWith(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 20 / 14,
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontFamily: fontFamily,
          fontSize: 13,
          height: 18 / 13,
          fontWeight: FontWeight.w600,
        ),
      );

  static ThemeData _build(Brightness brightness) {
    final scheme = _scheme(brightness);
    final palette = brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    const buttonSize = Size.fromHeight(minTouchHeight);
    const buttonText = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w700);
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: fontFamily,
      textTheme: _text(base.textTheme),
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      extensions: [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.accentSoft,
        height: 72,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? scheme.primary : palette.muted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500,
            color: s.contains(WidgetState.selected) ? scheme.onSurface : palette.muted,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: buttonSize, shape: shape, textStyle: buttonText),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: shape,
          textStyle: buttonText,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surface2,
        selectedColor: scheme.primary,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: TextStyle(fontFamily: fontFamily, color: scheme.onSurface),
        secondaryLabelStyle: TextStyle(fontFamily: fontFamily, color: scheme.onPrimary),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: palette.surface2,
        circularTrackColor: palette.surface2,
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
