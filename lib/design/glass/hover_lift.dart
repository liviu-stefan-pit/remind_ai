import 'package:flutter/material.dart';
import 'package:remind_ai/design/tokens/motion.dart';

/// Replacement for flutter_tilt — clean cross-platform hover lift.
///
/// On pointer enter: scale 1.012 + lift 2 px. No rectangular shadow.
class HoverLift extends StatefulWidget {
  const HoverLift({
    super.key,
    required this.child,
    this.scale = 1.012,
    this.lift = 2.0,
    this.onTap,
  });

  final Widget child;
  final double scale;
  final double lift;
  final VoidCallback? onTap;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final body = AnimatedScale(
      duration: reduceMotion ? Duration.zero : AppMotion.quick,
      curve: AppMotion.ease,
      scale: _hovered ? widget.scale : 1.0,
      child: AnimatedSlide(
        duration: reduceMotion ? Duration.zero : AppMotion.quick,
        curve: AppMotion.ease,
        offset: _hovered ? Offset(0, -widget.lift / 100) : Offset.zero,
        child: widget.child,
      ),
    );

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.onTap != null
          ? GestureDetector(onTap: widget.onTap, child: body)
          : body,
    );
  }
}
