import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';
import 'package:remind_ai/utils/cosmic_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            style: context.textTheme.titleLarge?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: 'REM',
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      color: cs.primary.withValues(alpha: 0.75),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              const TextSpan(text: 'ind-Ai'),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppStrings.dreamHistory,
            onPressed: () => context.push(AppRoute.history.route),
          ),
        ],
      ),
      body: CosmicBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: Padding(
                padding: context.contentPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.35),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_stories_outlined,
                        size: context.isDesktop ? 88 : 72,
                        color: cs.primary,
                      ),
                    ),
                    const Gap(28),
                    Text(
                      AppStrings.homeTagline,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                        shadows: [
                          Shadow(
                            color: cs.primary.withValues(alpha: 0.45),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    Text(
                      AppStrings.homeBody,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.homeCtaHint,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            context.push(AppRoute.dreamInput.route),
                        icon: const Icon(Icons.auto_stories),
                        label: const Text(AppStrings.interpretDream),
                      ),
                    ),
                    const Gap(32),
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
