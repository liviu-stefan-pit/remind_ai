import 'package:flutter/material.dart';
import 'package:remind_ai/design/glass/liquid_panel.dart';

/// Glass-wrapped form field surface.
class GlassField extends StatelessWidget {
  const GlassField({
    super.key,
    required this.child,
    this.focused = false,
  });

  final Widget child;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return LiquidPanel(
      padding: EdgeInsets.zero,
      borderRadius: 16,
      selected: focused,
      enableHoverGlow: !focused,
      child: child,
    );
  }
}
