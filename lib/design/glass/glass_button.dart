import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/motion.dart';

/// Solid accent button with a clean press scale — no breathing, no jelly.
class GlassButton extends StatefulWidget {
  const GlassButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.compact = false,
    this.outlined = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool compact;

  /// Secondary style: transparent fill + accent border.
  final bool outlined;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  static const _shortcuts = <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
  };

  void _activate() {
    if (_enabled) widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final aurora = context.auroraTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final bg = widget.outlined
        ? Colors.transparent
        : (_enabled
            ? aurora.accent
            : cs.onSurface.withValues(alpha: 0.10));
    final fg = widget.outlined
        ? aurora.accent
        : (_enabled ? const Color(0xFF1A1305) : cs.onSurface.withValues(alpha: 0.4));
    final highlighted = (_hovered || _focused) && _enabled;
    final border = widget.outlined
        ? BorderSide(
            color: highlighted ? aurora.accent : aurora.borderStrong,
            width: 1,
          )
        : (_focused && _enabled
            ? BorderSide(color: aurora.accent, width: 2)
            : BorderSide.none);

    final scale = !_enabled
        ? 1.0
        : _pressed
            ? 0.97
            : (highlighted ? 1.01 : 1.0);

    return Semantics(
      button: true,
      enabled: _enabled,
      child: FocusableActionDetector(
        enabled: _enabled,
        shortcuts: _shortcuts,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
        },
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        child: GestureDetector(
          onTap: _enabled ? widget.onPressed : null,
          onTapDown:
              _enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel:
              _enabled ? () => setState(() => _pressed = false) : null,
          child: AnimatedScale(
            duration: reduceMotion ? Duration.zero : AppMotion.quick,
            curve: AppMotion.ease,
            scale: scale,
            child: AnimatedContainer(
              duration: reduceMotion ? Duration.zero : AppMotion.quick,
              curve: AppMotion.ease,
              height: widget.compact ? 40 : 52,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.fromBorderSide(border),
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                  child: IconTheme(
                    data: IconThemeData(color: fg, size: 20),
                    child: widget.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation(fg),
                            ),
                          )
                        : widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
