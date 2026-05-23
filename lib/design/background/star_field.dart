import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Calm twinkling star field. Stars are fixed in place; only opacity pulses.
class StarField extends StatefulWidget {
  const StarField({
    super.key,
    this.count = 90,
    this.animate = true,
    this.color = const Color(0xFFF2EEE5),
  });

  final int count;
  final bool animate;
  final Color color;

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = _generate(widget.count);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );
    if (widget.animate) _controller.repeat();
  }

  List<_Star> _generate(int n) {
    final rng = math.Random(31);
    return List.generate(
      n,
      (i) => _Star(
        dx: rng.nextDouble(),
        dy: rng.nextDouble(),
        radius: 0.4 + rng.nextDouble() * 1.4,
        baseOpacity: 0.20 + rng.nextDouble() * 0.55,
        twinklePhase: rng.nextDouble() * math.pi * 2,
        twinkleSpeed: 0.6 + rng.nextDouble() * 0.9,
      ),
    );
  }

  @override
  void didUpdateWidget(StarField old) {
    super.didUpdateWidget(old);
    if (widget.count != old.count) {
      _stars = _generate(widget.count);
    }
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
        painter: _StarPainter(
          stars: _stars,
          t: _controller.value,
          color: widget.color,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _Star {
  const _Star({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.baseOpacity,
    required this.twinklePhase,
    required this.twinkleSpeed,
  });

  final double dx;
  final double dy;
  final double radius;
  final double baseOpacity;
  final double twinklePhase;
  final double twinkleSpeed;
}

class _StarPainter extends CustomPainter {
  _StarPainter({
    required this.stars,
    required this.t,
    required this.color,
  });

  final List<_Star> stars;
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final base = t * 2 * math.pi;
    for (final s in stars) {
      final opacity = (s.baseOpacity +
              math.sin(base * s.twinkleSpeed + s.twinklePhase) * 0.22)
          .clamp(0.05, 1.0);
      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(s.dx * size.width, s.dy * size.height),
        s.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.t != t;
}
