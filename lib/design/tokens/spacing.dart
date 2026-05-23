import 'package:flutter/material.dart';

/// Consistent spacing scale (4px base).
abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  static const insetScreen = EdgeInsets.symmetric(horizontal: md);
  static const cardPadding = EdgeInsets.all(md);
  static const chipPadding = EdgeInsets.symmetric(horizontal: sm, vertical: xxs);
}
