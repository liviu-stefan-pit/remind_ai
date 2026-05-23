import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/typography.dart';

/// Brand title — Fraunces italic + hairline gold underline. Static.
class LogoBreathing extends StatelessWidget {
  const LogoBreathing({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final aurora = context.auroraTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REMind-Ai',
          style: AppTypography.brandStyle(cs.onSurface, size: size),
        ),
        const SizedBox(height: 4),
        Container(
          width: size * 1.5,
          height: 1.5,
          color: aurora.accent.withValues(alpha: 0.7),
        ),
      ],
    );
  }
}

/// Dream loader — thin spinner / check / cross.
enum DreamLoaderState { idle, thinking, success, error }

class DreamLoader extends StatelessWidget {
  const DreamLoader({
    super.key,
    required this.state,
    this.size = 36,
  });

  final DreamLoaderState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final aurora = context.auroraTheme;

    return SizedBox(
      width: size,
      height: size,
      child: switch (state) {
        DreamLoaderState.thinking => CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(aurora.accent),
          ),
        DreamLoaderState.success => Icon(
            Icons.check_rounded,
            color: aurora.accent,
            size: size,
          ).animate().fadeIn(duration: 200.ms).scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1, 1),
                curve: Curves.easeOutCubic,
              ),
        DreamLoaderState.error => Icon(
            Icons.error_outline_rounded,
            color: cs.error,
            size: size,
          ).animate().fadeIn(duration: 200.ms),
        DreamLoaderState.idle => Icon(
            Icons.nights_stay_outlined,
            color: aurora.accent,
            size: size,
          ),
      },
    );
  }
}

/// Empty history — calm crescent moon, no animation loop.
class EmptyHistoryIllustration extends StatelessWidget {
  const EmptyHistoryIllustration({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return Icon(
      Icons.nightlight_round,
      size: size,
      color: aurora.accent.withValues(alpha: 0.55),
    );
  }
}

/// Sun/moon morph for the theme toggle.
class ThemeToggleIcon extends StatelessWidget {
  const ThemeToggleIcon({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, animation) => RotationTransition(
        turns: Tween<double>(begin: 0.7, end: 1).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: Icon(
        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        key: ValueKey(isDark),
        color: aurora.accent,
      ),
    );
  }
}

/// Splash logo — quick fade in, hold.
class SplashIntroAnimation extends StatelessWidget {
  const SplashIntroAnimation({super.key, this.size = 80});

  final double size;

  @override
  Widget build(BuildContext context) {
    return LogoBreathing(size: size).animate().fadeIn(duration: 600.ms);
  }
}
