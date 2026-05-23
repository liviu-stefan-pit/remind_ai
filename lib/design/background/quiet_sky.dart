import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind_ai/config/settings/settings_logic.dart';
import 'package:remind_ai/design/background/comet_field.dart';
import 'package:remind_ai/design/background/star_field.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';

/// "Quiet Sky" — calm ambient backdrop: radial gradient + twinkling stars
/// + slow drifting dust + occasional comets. Smooth on every platform.
class QuietSky extends ConsumerWidget {
  const QuietSky({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aurora = context.auroraTheme;
    final ambient = ref.watch(
      settingsLogicProvider.select((s) => s.ambientLevel),
    );
    final reduceMotion = ref.watch(
      settingsLogicProvider.select((s) => s.reduceMotion),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final animate = !reduceMotion && ambient != AmbientLevel.off;
    final lively = ambient == AmbientLevel.lively;

    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.2,
                colors: [aurora.bgDeep, aurora.bgEdge],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
        if (isDark) ...[
          RepaintBoundary(
            child: StarField(
              count: lively ? 140 : 90,
              animate: animate,
              color: aurora.accentSoft.withValues(alpha: 0.85),
            ),
          ),
          RepaintBoundary(
            child: _DustDriftLayer(
              animate: animate,
              color: aurora.accentSoft,
            ),
          ),
          if (animate)
            RepaintBoundary(
              child: CometField(
                lively: lively,
                color: aurora.accent,
              ),
            ),
        ] else if (animate)
          // Light theme: gentle warm light rays drifting horizontally.
          RepaintBoundary(
            child: _DustDriftLayer(
              animate: animate,
              color: aurora.accent,
              count: lively ? 18 : 10,
              opacity: 0.10,
            ),
          ),
        child,
      ],
    );
  }
}

/// Slow drifting soft glows — adds depth without distraction.
class _DustDriftLayer extends StatefulWidget {
  const _DustDriftLayer({
    required this.animate,
    required this.color,
    this.count = 16,
    this.opacity = 0.08,
  });

  final bool animate;
  final Color color;
  final int count;
  final double opacity;

  @override
  State<_DustDriftLayer> createState() => _DustDriftLayerState();
}

class _DustDriftLayerState extends State<_DustDriftLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Dust> _dust;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(7);
    _dust = List.generate(
      widget.count,
      (i) => _Dust(
        startX: rng.nextDouble(),
        startY: rng.nextDouble(),
        radius: 12 + rng.nextDouble() * 32,
        speed: 0.4 + rng.nextDouble() * 0.6,
        phase: rng.nextDouble() * math.pi * 2,
        angle: (rng.nextDouble() - 0.5) * math.pi * 0.4,
      ),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(_DustDriftLayer old) {
    super.didUpdateWidget(old);
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        painter: _DustPainter(
          dust: _dust,
          t: _controller.value,
          color: widget.color,
          opacity: widget.opacity,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _Dust {
  const _Dust({
    required this.startX,
    required this.startY,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.angle,
  });

  final double startX;
  final double startY;
  final double radius;
  final double speed;
  final double phase;
  final double angle;
}

class _DustPainter extends CustomPainter {
  _DustPainter({
    required this.dust,
    required this.t,
    required this.color,
    required this.opacity,
  });

  final List<_Dust> dust;
  final double t;
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final d in dust) {
      final progress = (t * d.speed + d.phase / (2 * math.pi)) % 1.0;
      final x = (d.startX + math.cos(d.angle) * progress * 0.4) % 1.2 - 0.1;
      final y = (d.startY + math.sin(d.angle) * progress * 0.4) % 1.2 - 0.1;
      final fade = math.sin(progress * math.pi);
      paint.shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity * fade),
          color.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(x * size.width, y * size.height),
          radius: d.radius,
        ),
      );
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        d.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DustPainter old) => old.t != t;
}
