import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/motion.dart';

/// Calm glass surface — hairline border, subtle blur, no rectangular halo.
///
/// Hover: border color brightens toward accent + 2 px lift.
/// Selected: solid accent border + faint accent tint.
class LiquidPanel extends StatefulWidget {
  const LiquidPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 18,
    this.enableHoverGlow = true,
    this.selected = false,
    this.backgroundColor,
    this.blur = 12,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final bool enableHoverGlow;
  final bool selected;
  final Color? backgroundColor;
  final double blur;

  @override
  State<LiquidPanel> createState() => _LiquidPanelState();
}

class _LiquidPanelState extends State<LiquidPanel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final activeBorder = widget.selected
        ? aurora.accent
        : (_hovered && widget.enableHoverGlow
            ? aurora.accent.withValues(alpha: 0.45)
            : aurora.border);

    final tint = widget.backgroundColor ??
        (isDark
            ? aurora.bgElevated.withValues(alpha: 0.55)
            : Colors.white.withValues(alpha: 0.7));

    final selectedTint = widget.selected
        ? aurora.accent.withValues(alpha: 0.06)
        : Colors.transparent;

    return MouseRegion(
      onEnter: widget.enableHoverGlow
          ? (_) => setState(() => _hovered = true)
          : null,
      onExit: widget.enableHoverGlow
          ? (_) => setState(() => _hovered = false)
          : null,
      child: AnimatedSlide(
        duration: reduceMotion ? Duration.zero : AppMotion.quick,
        curve: AppMotion.ease,
        offset: (_hovered && widget.enableHoverGlow)
            ? const Offset(0, -0.012)
            : Offset.zero,
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : AppMotion.quick,
          curve: AppMotion.ease,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: activeBorder, width: 1),
            color: tint,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius - 1),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blur,
                sigmaY: widget.blur,
                tileMode: kIsWeb ? TileMode.clamp : TileMode.decal,
              ),
              child: Container(
                color: selectedTint,
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
