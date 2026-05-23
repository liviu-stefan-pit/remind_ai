import 'dart:math' as math;

import 'package:flutter/material.dart';

class CosmicBackground extends StatelessWidget {
  const CosmicBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF14123A),
                  Color(0xFF0E0C28),
                  Color(0xFF0B0A1C),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: _StarPainter())),
        child,
      ],
    );
  }
}

class _Star {
  const _Star({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.opacity,
  });

  final double dx;
  final double dy;
  final double radius;
  final double opacity;
}

class _StarPainter extends CustomPainter {
  _StarPainter() : _stars = _generate();

  final List<_Star> _stars;

  static List<_Star> _generate() {
    final rng = math.Random(42);
    return List.generate(
      120,
      (_) => _Star(
        dx: rng.nextDouble(),
        dy: rng.nextDouble(),
        radius: 0.5 + rng.nextDouble() * 1.5,
        opacity: 0.1 + rng.nextDouble() * 0.5,
      ),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in _stars) {
      canvas.drawCircle(
        Offset(star.dx * size.width, star.dy * size.height),
        star.radius,
        Paint()
          ..color = const Color(0xFFE8E0F5).withValues(alpha: star.opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => false;
}
