import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/colors.dart';
import 'package:remind_ai/design/tokens/typography.dart';

/// Midnight Dream / Parchment Dream themes.
abstract final class AppTheme {
  static ThemeData dark({AuroraTheme? aurora}) =>
      _build(brightness: Brightness.dark, aurora: aurora ?? AuroraTheme.dark);

  static ThemeData light({AuroraTheme? aurora}) =>
      _build(brightness: Brightness.light, aurora: aurora ?? AuroraTheme.light);

  static ThemeData _build({
    required Brightness brightness,
    required AuroraTheme aurora,
  }) {
    final isDark = brightness == Brightness.dark;
    final textTheme = AppTypography.textTheme(brightness);

    final colorScheme = isDark
        ? const ColorScheme.dark(
            surface: AuroraColors.bgDeep,
            surfaceContainerLowest: AuroraColors.bgDeep,
            surfaceContainerLow: Color(0xFF0F1422),
            surfaceContainer: AuroraColors.bgElevated,
            surfaceContainerHigh: AuroraColors.bgOverlay,
            surfaceContainerHighest: Color(0xFF222B42),
            primary: AuroraColors.accent,
            onPrimary: Color(0xFF1A1305),
            primaryContainer: Color(0xFF3A2C0F),
            onPrimaryContainer: Color(0xFFF5DFA8),
            secondary: AuroraColors.accentSoft,
            onSecondary: Color(0xFF0A1230),
            secondaryContainer: Color(0xFF243054),
            onSecondaryContainer: Color(0xFFD4DDF8),
            tertiary: AuroraColors.success,
            onSurface: AuroraColors.text,
            onSurfaceVariant: AuroraColors.textDim,
            outline: AuroraColors.borderStrong,
            outlineVariant: AuroraColors.border,
            error: AuroraColors.error,
            onError: Color(0xFF2A0A0A),
          )
        : const ColorScheme.light(
            surface: AuroraColors.lightBg,
            surfaceContainer: AuroraColors.lightBgElevated,
            surfaceContainerLow: Color(0xFFF5F2E9),
            surfaceContainerHigh: AuroraColors.lightBgElevated,
            primary: AuroraColors.lightAccent,
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFF5E6C5),
            onPrimaryContainer: Color(0xFF3A2A0A),
            secondary: Color(0xFF4A6FE5),
            onSecondary: Colors.white,
            secondaryContainer: Color(0xFFDDE6FF),
            onSecondaryContainer: Color(0xFF1A2A60),
            onSurface: AuroraColors.lightText,
            onSurfaceVariant: AuroraColors.lightTextDim,
            outline: Color(0x33000000),
            outlineVariant: AuroraColors.lightBorder,
            error: AuroraColors.error,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: aurora.bgDeep,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: [aurora],
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: isDark ? AuroraColors.text : AuroraColors.lightText,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: aurora.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AuroraColors.bgElevated.withValues(alpha: 0.6)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: aurora.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: aurora.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: aurora.accent, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: aurora.textDim),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: aurora.bgElevated,
        contentTextStyle: TextStyle(
          color: isDark ? AuroraColors.text : AuroraColors.lightText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: aurora.bgElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(color: aurora.border),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
