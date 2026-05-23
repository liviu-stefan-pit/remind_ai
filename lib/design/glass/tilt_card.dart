import 'package:flutter/material.dart';
import 'package:remind_ai/design/glass/hover_lift.dart';
import 'package:remind_ai/design/glass/liquid_panel.dart';

/// Glass card with a subtle hover lift (replaces flutter_tilt-based card).
///
/// Kept under the same name so existing screens don't need to change imports.
class TiltCard extends StatelessWidget {
  const TiltCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 18,
    this.selected = false,
    this.enableTilt = true,
    this.enableHoverGlow = true,
    this.backgroundColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final bool selected;
  final bool enableTilt;
  final bool enableHoverGlow;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final panel = LiquidPanel(
      padding: padding,
      borderRadius: borderRadius,
      selected: selected,
      enableHoverGlow: enableHoverGlow,
      backgroundColor: backgroundColor,
      child: child,
    );

    if (!enableTilt) {
      return onTap != null
          ? GestureDetector(onTap: onTap, child: panel)
          : panel;
    }

    return HoverLift(onTap: onTap, child: panel);
  }
}
