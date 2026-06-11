import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/settings/settings_logic.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/design/tokens/typography.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  static const _pages = <_OnboardPage>[
    _OnboardPage(
      icon: Icons.nights_stay_outlined,
      kicker: 'WELCOME',
      title: 'Catch your dreams before they fade',
      body: 'A quiet space for nocturnal notes — the moment you wake, write.',
    ),
    _OnboardPage(
      icon: Icons.auto_awesome_outlined,
      kicker: 'INTERPRET',
      title: 'Four ways to read the meaning',
      body: 'Standard, Psychological, Mythic, Creative. Pick the lens you need.',
    ),
    _OnboardPage(
      icon: Icons.lock_outline_rounded,
      kicker: 'PRIVATE',
      title: AppStrings.onboardingPrivacyTitle,
      body: AppStrings.onboardingPrivacyBody,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    final isLast = _page == _pages.length - 1;
    final ageConfirmed = ref.watch(
      settingsLogicProvider.select((s) => s.ageConfirmed),
    );
    final canFinish = !isLast || ageConfirmed;

    return Scaffold(
      body: QuietSky(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: context.maxContentWidth),
              child: Padding(
                padding: context.contentPadding,
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 340,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _pages.length,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemBuilder: (_, i) {
                          final p = _pages[i];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                p.icon,
                                size: 56,
                                color: aurora.accent,
                              ),
                              const Gap(AppSpacing.xl),
                              Text(
                                p.kicker,
                                style: AppTypography.sectionLabel(
                                  aurora.accent,
                                ),
                              ),
                              const Gap(AppSpacing.md),
                              Text(
                                p.title,
                                textAlign: TextAlign.center,
                                style: context.textTheme.headlineMedium,
                              ),
                              const Gap(AppSpacing.md),
                              Text(
                                p.body,
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: aurora.textDim,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          margin:
                              const EdgeInsets.symmetric(horizontal: 3),
                          width: _page == i ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: _page == i
                                ? aurora.accent
                                : aurora.borderStrong,
                          ),
                        ),
                      ),
                    ),
                    const Gap(AppSpacing.xl),
                    if (isLast)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => ref
                                  .read(settingsLogicProvider.notifier)
                                  .setAgeConfirmed(!ageConfirmed),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.xs,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: ageConfirmed,
                                      onChanged: (v) => ref
                                          .read(settingsLogicProvider.notifier)
                                          .setAgeConfirmed(v ?? false),
                                    ),
                                    Expanded(
                                      child: Text(
                                        AppStrings.ageGateLabel,
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!ageConfirmed)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.xs,
                                  top: AppSpacing.xxs,
                                ),
                                child: Text(
                                  AppStrings.ageGateRequired,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: aurora.textDim,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        if (!isLast)
                          Expanded(
                            child: GlassButton(
                              outlined: true,
                              onPressed: () {
                                _pageController.animateToPage(
                                  _pages.length - 1,
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                              child: const Text('Skip'),
                            ),
                          ),
                        if (!isLast) const Gap(AppSpacing.sm),
                        Expanded(
                          child: GlassButton(
                            onPressed: canFinish
                                ? () {
                                    if (!isLast) {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 280),
                                        curve: Curves.easeOutCubic,
                                      );
                                    } else {
                                      ref
                                          .read(settingsLogicProvider.notifier)
                                          .markOnboardingSeen();
                                      context.go(AppRoute.home.route);
                                    }
                                  }
                                : null,
                            child: Text(
                              isLast ? AppStrings.onboardingBegin : 'Continue',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.xl),
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

class _OnboardPage {
  const _OnboardPage({
    required this.icon,
    required this.kicker,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String kicker;
  final String title;
  final String body;
}
