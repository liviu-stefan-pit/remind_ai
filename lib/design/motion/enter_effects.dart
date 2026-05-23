import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remind_ai/design/tokens/motion.dart';

/// Entrance animation presets — short, single-curve, no replay.
abstract final class EnterEffects {
  static List<Effect<dynamic>> rise({Duration? duration}) => [
        FadeEffect(
          duration: duration ?? AppMotion.standard,
          curve: AppMotion.ease,
        ),
        SlideEffect(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
          duration: duration ?? AppMotion.standard,
          curve: AppMotion.ease,
        ),
      ];

  static List<Effect<dynamic>> fade({Duration? duration}) => [
        FadeEffect(
          duration: duration ?? AppMotion.quick,
          curve: AppMotion.ease,
        ),
      ];
}

extension AnimateEntrance on Widget {
  /// Plays once on first mount. Wrap with stable key to prevent replay
  /// on parent rebuilds.
  Widget animateRise({Duration? delay, Key? key}) => Animate(
        key: key,
        effects: EnterEffects.rise(),
        delay: delay,
        child: this,
      );

  Widget animateFade({Duration? delay, Key? key}) => Animate(
        key: key,
        effects: EnterEffects.fade(),
        delay: delay,
        child: this,
      );

  /// Staggered with a hard cap so long lists don't crawl.
  Widget animateStagger(
    int index, {
    Duration baseDelay = Duration.zero,
    Key? key,
  }) {
    final stagger = Duration(milliseconds: (60 * index).clamp(0, 240));
    return Animate(
      key: key,
      effects: EnterEffects.rise(),
      delay: baseDelay + stagger,
      child: this,
    );
  }
}
