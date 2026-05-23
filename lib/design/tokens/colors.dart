import 'package:flutter/material.dart';

/// Midnight Dream palette tokens.
abstract final class AuroraColors {
  // Dark — Midnight Dream
  static const bgDeep = Color(0xFF0A0E1A);
  static const bgEdge = Color(0xFF06080F);
  static const bgElevated = Color(0xFF131826);
  static const bgOverlay = Color(0xFF1B2236);
  static const border = Color(0x10FFFFFF);
  static const borderStrong = Color(0x26FFFFFF);

  static const accent = Color(0xFFD4B062);
  static const accentSoft = Color(0xFF6B8AFF);
  static const text = Color(0xFFF2EEE5);
  static const textDim = Color(0xFF8B92A8);

  static const success = Color(0xFF7FD6A8);
  static const error = Color(0xFFE07579);

  // Light — Parchment Dream
  static const lightBg = Color(0xFFFAF7F0);
  static const lightBgElevated = Color(0xFFFFFFFF);
  static const lightBorder = Color(0x14000000);
  static const lightAccent = Color(0xFFB0832F);
  static const lightText = Color(0xFF1A1F2E);
  static const lightTextDim = Color(0xFF6B7280);

  static Color glassTintFor(Brightness brightness) =>
      brightness == Brightness.dark
          ? const Color(0x80131826)
          : const Color(0xCCFFFFFF);
}
