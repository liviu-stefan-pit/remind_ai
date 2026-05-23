import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Spawns 1–2 soft comets at a time. Each comet streaks diagonally over
/// 2.5–3.5 s then fades. Cheap, looks great, optional via [lively].
class CometField extends StatefulWidget {
  const CometField({
    super.key,
    this.lively = false,
    this.color = const Color(0xFFD4B062),
  });

  /// When true, spawns more frequently and allows up to 2 simultaneous comets.
  final bool lively;
  final Color color;

  @override
  State<CometField> createState() => _CometFieldState();
}

class _CometFieldState extends State<CometField>
    with TickerProviderStateMixin {
  final _rng = math.Random();
  final List<_Comet> _comets = [];

  Duration _nextSpawnDelay() {
    final base = widget.lively ? 4 : 9;
    final extra = widget.lively ? 6 : 9;
    return Duration(seconds: base + _rng.nextInt(extra));
  }

  @override
  void initState() {
    super.initState();
    _scheduleNext(initial: true);
  }

  void _scheduleNext({bool initial = false}) {
    final delay =
        initial ? const Duration(seconds: 2) : _nextSpawnDelay();
    Future<void>.delayed(delay, () {
      if (!mounted) return;
      _spawn();
      _scheduleNext();
    });
  }

  void _spawn() {
    if (!mounted) return;
    final maxAlive = widget.lively ? 2 : 1;
    if (_comets.length >= maxAlive) return;

    final controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2500 + _rng.nextInt(1000),
      ),
    );

    // Random start near top-right or top-left, traveling diagonally down.
    final startFromLeft = _rng.nextBool();
    final start = Offset(
      startFromLeft ? -0.1 : 1.1,
      _rng.nextDouble() * 0.4,
    );
    final end = Offset(
      startFromLeft ? 1.1 : -0.1,
      0.4 + _rng.nextDouble() * 0.5,
    );

    final comet = _Comet(
      controller: controller,
      start: start,
      end: end,
      thickness: 1.0 + _rng.nextDouble() * 1.2,
      tailLength: 90 + _rng.nextDouble() * 60,
    );
    _comets.add(comet);

    controller
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..forward().whenComplete(() {
        controller.dispose();
        if (mounted) setState(() => _comets.remove(comet));
      });
  }

  @override
  void dispose() {
    for (final c in _comets) {
      c.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CometPainter(comets: _comets, color: widget.color),
      size: Size.infinite,
    );
  }
}

class _Comet {
  _Comet({
    required this.controller,
    required this.start,
    required this.end,
    required this.thickness,
    required this.tailLength,
  });

  final AnimationController controller;
  final Offset start;
  final Offset end;
  final double thickness;
  final double tailLength;
}

class _CometPainter extends CustomPainter {
  _CometPainter({required this.comets, required this.color});

  final List<_Comet> comets;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final comet in comets) {
      final t = Curves.easeInOutCubic.transform(comet.controller.value);
      final pos = Offset(
        (comet.start.dx + (comet.end.dx - comet.start.dx) * t) * size.width,
        (comet.start.dy + (comet.end.dy - comet.start.dy) * t) * size.height,
      );

      // Direction back along the path for the tail.
      final direction = (comet.start - comet.end);
      final length = direction.distance;
      final unit = length == 0 ? Offset.zero : direction / length;
      final tailEnd = pos + unit * comet.tailLength;

      // Fade in/out across lifecycle (peak at 0.5).
      final lifeAlpha = math.sin(t * math.pi).clamp(0.0, 1.0);

      // Tail gradient line.
      final tailPaint = Paint()
        ..strokeWidth = comet.thickness
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.0),
            color.withValues(alpha: 0.45 * lifeAlpha),
          ],
        ).createShader(Rect.fromPoints(tailEnd, pos));

      canvas.drawLine(tailEnd, pos, tailPaint);

      // Head glow.
      final headPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.95 * lifeAlpha),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: pos, radius: 6));
      canvas.drawCircle(pos, 6, headPaint);

      // Bright core.
      canvas.drawCircle(
        pos,
        comet.thickness * 0.9,
        Paint()..color = Colors.white.withValues(alpha: 0.85 * lifeAlpha),
      );
    }
  }

  @override
  bool shouldRepaint(_CometPainter old) => true;
}
