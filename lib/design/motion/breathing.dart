import 'package:flutter/material.dart';

/// No-op pass-through (kept for source compatibility).
/// Breathing animations were removed in v2 — they made interactive elements
/// feel distracting.
class BreathingWidget extends StatelessWidget {
  const BreathingWidget({
    super.key,
    required this.child,
    this.minScale = 1,
    this.maxScale = 1,
  });

  final Widget child;
  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) => child;
}
