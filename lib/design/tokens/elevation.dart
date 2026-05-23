import 'package:flutter/material.dart';

/// Minimal elevation — just a couple of soft shadow presets.
abstract final class AppElevation {
  static List<BoxShadow> soft(Color shadow) => [
        BoxShadow(
          color: shadow.withValues(alpha: 0.18),
          blurRadius: 18,
          offset: const Offset(0, 4),
        ),
      ];

  static const List<BoxShadow> none = <BoxShadow>[];
}
