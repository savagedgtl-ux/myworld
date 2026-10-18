import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class AppTheme {
  static const _font = 'Inter';

  static TextTheme _text(Color primary, Color secondary) => TextTheme(
        // Screen titles
        headlineMedium: TextStyle(fontFamily: _font, fontSize: 26, fontWeight: FontWeight.w700, color: primary, height: 1.2, letterSpacing: -0.3),
        headlineSmall: TextStyle(fontFamily: _font, fontSize: 22, fontWeight: FontWeight.w700, color: primary, height: 1.25),
        // Card titles
        titleLarge: TextStyle(fontFamily: _font, fontSize: 18, fontWeight: FontWeight.w600, color: primary, height: 1.3),
        titleMedium: TextStyle(fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600, color: primary, height: 1.3),
        titleSmall: TextStyle(fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w600, color: primary),
        // Body
        bodyLarge: TextStyle(fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w400, color: primary, height: 1.45),
        bodyMedium: TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w400, color: primary, height: 1.45),
        // Helper text
        bodySmall: TextStyle(fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w400, color: secondary, height: 1.4),
        // Buttons & field labels
        labelLarge: TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w600, color: primary),
        labelMedium: TextStyle(fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w500, color: secondary),
        labelSmall: TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
      );

  static ThemeData light() => _build(
        brightness: Brightness.light,
        bg: AppColors.background,
        card: AppColors.card,
        text: AppColors.textPrimary,
        text2: AppColors.textSecondary,
        divider: AppColors.divider,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        bg: AppColors.darkBackground,
        card: AppColors.darkCard,
        text: AppColors.darkTextPrimary,
        text2: AppColors.darkTextSecondary,
        divider: AppColors.darkDivider,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color card,
    required Color text,
    required Color text2,
    required Color divider,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.secondary : AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: card,
      onSurface: text,
      onSurfaceVariant: text2,
      surfaceContainerHighest: isDark ? const Color(0xFF203241) : AppColors.surfaceTint,
      outline: divider,
      outlineVariant: divider,
    );
    final textTheme = _text(text, text2);
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radii.sm),
      borderSide: BorderSide(color: divider),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: _font,
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      dividerColor: divider,
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 14),
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(borderSide: BorderSide(color: scheme.secondary, width: 2)),
        errorBorder: fieldBorder.copyWith(borderSide: const BorderSide(color: AppColors.error)),
        labelStyle: textTheme.labelMedium,
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(kMinTouch, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(kMinTouch, 52),
          side: BorderSide(color: divider),
          foregroundColor: text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(kMinTouch, kMinTouch), textStyle: textTheme.labelLarge),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: isDark ? const Color(0xFF203241) : AppColors.surfaceTint,
        side: BorderSide(color: divider),
        labelStyle: textTheme.labelMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl))),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 10,
        iconColor: text2,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall,
      ),
      focusColor: AppColors.secondary.withValues(alpha: 0.25),
    );
  }
}
