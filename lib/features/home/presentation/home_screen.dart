import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/motion/enter_effects.dart';
import 'package:remind_ai/design/rive/rive_widgets.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/design/tokens/typography.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final aurora = context.auroraTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const LogoBreathing(size: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_rounded),
            color: aurora.textDim,
            tooltip: AppStrings.insights,
            onPressed: () => context.push(AppRoute.insights.route),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            color: aurora.textDim,
            tooltip: AppStrings.dreamHistory,
            onPressed: () => context.push(AppRoute.history.route),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            color: aurora.textDim,
            tooltip: AppStrings.profile,
            onPressed: () => context.push(AppRoute.profile.route),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: aurora.textDim,
            tooltip: AppStrings.settings,
            onPressed: () => context.push(AppRoute.settings.route),
          ),
          const Gap(AppSpacing.xs),
        ],
      ),
      body: QuietSky(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: Padding(
                padding: context.contentPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      AppStrings.homeKicker,
                      style: AppTypography.sectionLabel(aurora.accent),
                    ).animateFade(key: const ValueKey('home-kicker')),
                    const Gap(AppSpacing.md),
                    Text(
                      AppStrings.homeTagline,
                      style: context.textTheme.displaySmall?.copyWith(
                        color: cs.onSurface,
                        height: 1.1,
                      ),
                    ).animateRise(key: const ValueKey('home-tagline')),
                    const Gap(AppSpacing.md),
                    Text(
                      AppStrings.homeBody,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: aurora.textDim,
                        height: 1.55,
                      ),
                    ).animateRise(
                      key: const ValueKey('home-body'),
                      delay: const Duration(milliseconds: 80),
                    ),
                    const Gap(AppSpacing.xxl),
                    Row(
                      children: [
                        Expanded(
                          child: GlassButton(
                            onPressed: () =>
                                context.push(AppRoute.dreamInput.route),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppStrings.interpretDream),
                                Gap(8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animateRise(
                      key: const ValueKey('home-cta'),
                      delay: const Duration(milliseconds: 160),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
