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
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

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
      title: 'Four lenses to explore your dream',
      body:
          'Standard, Psychological, Mythic, Creative — pick a style for fun '
          'and reflection, not professional advice.',
    ),
    _OnboardPage(
      icon: Icons.lock_outline_rounded,
      kicker: 'YOUR DATA',
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
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
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
                              Icon(p.icon, size: 56, color: aurora.accent),
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
                          margin: const EdgeInsets.symmetric(horizontal: 3),
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
                            const Gap(AppSpacing.sm),
                            _OnboardingLegalLinks(aurora: aurora),
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
                                ? () async {
                                    if (!isLast) {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 280,
                                        ),
                                        curve: Curves.easeOutCubic,
                                      );
                                    } else {
                                      await ref
                                          .read(settingsLogicProvider.notifier)
                                          .markOnboardingSeen();
                                      if (!context.mounted) return;
                                      final isAuthenticated = ref
                                              .read(authLogicProvider)
                                              .asData
                                              ?.value !=
                                          null;
                                      context.go(
                                        isAuthenticated
                                            ? AppRoute.home.route
                                            : AppRoute.signIn.route,
                                      );
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

class _OnboardingLegalLinks extends StatelessWidget {
  const _OnboardingLegalLinks({required this.aurora});

  final AuroraTheme aurora;

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textTheme.bodySmall?.copyWith(
      color: aurora.textDim,
      height: 1.45,
    );
    final linkStyle = baseStyle?.copyWith(color: aurora.accent);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('By continuing, you agree to our ', style: baseStyle),
        InkWell(
          onTap: () => _open(AppUrls.termsOfService),
          child: Text(
            AppStrings.termsOfService,
            style: linkStyle?.copyWith(decoration: TextDecoration.underline),
          ),
        ),
        Text(' and ', style: baseStyle),
        InkWell(
          onTap: () => _open(AppUrls.privacyPolicy),
          child: Text(
            AppStrings.privacyPolicy,
            style: linkStyle?.copyWith(decoration: TextDecoration.underline),
          ),
        ),
        Text('.', style: baseStyle),
      ],
    );
  }
}
