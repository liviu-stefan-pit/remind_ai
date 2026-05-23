import 'package:flutter/material.dart';
import 'package:remind_ai/design/tokens/colors.dart';

/// Custom theme tokens exposed via [ThemeExtension].
@immutable
class AuroraTheme extends ThemeExtension<AuroraTheme> {
  const AuroraTheme({
    required this.bgDeep,
    required this.bgEdge,
    required this.bgElevated,
    required this.border,
    required this.borderStrong,
    required this.accent,
    required this.accentSoft,
    required this.textDim,
    required this.ambientLevel,
    required this.reduceMotion,
  });

  final Color bgDeep;
  final Color bgEdge;
  final Color bgElevated;
  final Color border;
  final Color borderStrong;
  final Color accent;
  final Color accentSoft;
  final Color textDim;
  final AmbientLevel ambientLevel;
  final bool reduceMotion;

  static const dark = AuroraTheme(
    bgDeep: AuroraColors.bgDeep,
    bgEdge: AuroraColors.bgEdge,
    bgElevated: AuroraColors.bgElevated,
    border: AuroraColors.border,
    borderStrong: AuroraColors.borderStrong,
    accent: AuroraColors.accent,
    accentSoft: AuroraColors.accentSoft,
    textDim: AuroraColors.textDim,
    ambientLevel: AmbientLevel.calm,
    reduceMotion: false,
  );

  static const light = AuroraTheme(
    bgDeep: AuroraColors.lightBg,
    bgEdge: Color(0xFFEFEAE0),
    bgElevated: AuroraColors.lightBgElevated,
    border: AuroraColors.lightBorder,
    borderStrong: Color(0x33000000),
    accent: AuroraColors.lightAccent,
    accentSoft: Color(0xFF4A6FE5),
    textDim: AuroraColors.lightTextDim,
    ambientLevel: AmbientLevel.calm,
    reduceMotion: false,
  );

  @override
  AuroraTheme copyWith({
    Color? bgDeep,
    Color? bgEdge,
    Color? bgElevated,
    Color? border,
    Color? borderStrong,
    Color? accent,
    Color? accentSoft,
    Color? textDim,
    AmbientLevel? ambientLevel,
    bool? reduceMotion,
  }) =>
      AuroraTheme(
        bgDeep: bgDeep ?? this.bgDeep,
        bgEdge: bgEdge ?? this.bgEdge,
        bgElevated: bgElevated ?? this.bgElevated,
        border: border ?? this.border,
        borderStrong: borderStrong ?? this.borderStrong,
        accent: accent ?? this.accent,
        accentSoft: accentSoft ?? this.accentSoft,
        textDim: textDim ?? this.textDim,
        ambientLevel: ambientLevel ?? this.ambientLevel,
        reduceMotion: reduceMotion ?? this.reduceMotion,
      );

  @override
  AuroraTheme lerp(AuroraTheme? other, double t) {
    if (other == null) return this;
    return AuroraTheme(
      bgDeep: Color.lerp(bgDeep, other.bgDeep, t)!,
      bgEdge: Color.lerp(bgEdge, other.bgEdge, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      ambientLevel: t < 0.5 ? ambientLevel : other.ambientLevel,
      reduceMotion: t < 0.5 ? reduceMotion : other.reduceMotion,
    );
  }
}

enum AmbientLevel { off, calm, lively }

extension AuroraThemeX on BuildContext {
  AuroraTheme get auroraTheme =>
      Theme.of(this).extension<AuroraTheme>() ?? AuroraTheme.dark;
}
