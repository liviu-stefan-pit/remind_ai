import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/config/purchases/purchases_config.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/core/services/purchases_service.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/glass/liquid_panel.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:remind_ai/utils/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _purchasing = false;
  bool _waitingForWindows = false;
  Timer? _pollTimer;

  bool get _isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseReady = ref.watch(firebaseReadyProvider);
    final authState = ref.watch(authLogicProvider);
    final isPro = ref.watch(accessTierLogicProvider).tier.isPro;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: QuietSky(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: ListView(
                padding: context.contentPadding.add(
                  const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                children: [
                  if (!firebaseReady) _backendNotice(context),
                  authState.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => _SignedOut(
                      onSignIn: _signIn,
                      enabled: firebaseReady,
                    ),
                    data: (user) => user == null
                        ? _SignedOut(
                            onSignIn: _signIn,
                            enabled: firebaseReady,
                          )
                        : _SignedIn(
                            user: user,
                            isPro: isPro,
                            purchasing: _purchasing,
                            waitingForWindows: _waitingForWindows,
                            isWindows: _isWindows,
                            onUpgrade: () => _upgrade(user),
                            onRefresh: () => _refresh(user),
                            onSignOut: _signOut,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backendNotice(BuildContext context) {
    final aurora = context.auroraTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: LiquidPanel(
        enableHoverGlow: false,
        child: Row(
          children: [
            Icon(Icons.cloud_off_rounded, color: aurora.textDim, size: 20),
            const Gap(AppSpacing.sm),
            Expanded(
              child: Text(
                AppStrings.backendNotConfigured,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: aurora.textDim),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    await ref.read(authLogicProvider.notifier).signInWithGoogle();
    final err = ref.read(authLogicProvider);
    if (err is AsyncError && mounted) {
      _snack(AppStrings.signInFailed);
    }
  }

  Future<void> _signOut() async {
    _pollTimer?.cancel();
    if (mounted) setState(() => _waitingForWindows = false);
    await ref.read(authLogicProvider.notifier).signOut();
  }

  Future<void> _upgrade(User user) async {
    final purchases = ref.read(purchasesServiceProvider);

    if (_isWindows) {
      final url = purchases.webPurchaseUrl(user.uid);
      if (url == null) {
        _snack(AppStrings.purchaseNotConfigured);
        return;
      }
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (mounted) setState(() => _waitingForWindows = true);
      _startWindowsPolling(user.uid);
      return;
    }

    setState(() => _purchasing = true);
    try {
      await purchases.purchasePro();
    } on AppException catch (e) {
      if (mounted) _snack(e.message);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _refresh(User user) async {
    try {
      final active =
          await ref.read(purchasesServiceProvider).refreshViaRest(user.uid);
      if (!active && mounted) _snack(AppStrings.stillNotPro);
    } on AppException catch (e) {
      if (mounted) _snack(e.message);
    }
  }

  void _startWindowsPolling(String uid) {
    _pollTimer?.cancel();
    var attempts = 0;
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      attempts++;
      bool active = false;
      try {
        active = await ref.read(purchasesServiceProvider).refreshViaRest(uid);
      } catch (_) {
        // keep polling; transient network errors are expected
      }
      if (active || attempts >= 24) {
        timer.cancel();
        if (mounted) setState(() => _waitingForWindows = false);
      }
    });
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut({required this.onSignIn, required this.enabled});

  final VoidCallback onSignIn;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ProPitch(),
        const Gap(AppSpacing.lg),
        if (PurchasesConfig.proPurchasable)
          GlassButton(
            onPressed: enabled ? onSignIn : null,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login_rounded, size: 18),
                Gap(AppSpacing.sm),
                Text(AppStrings.signInWithGoogle),
              ],
            ),
          )
        else
          const _ComingSoonNotice(),
      ],
    );
  }
}

class _SignedIn extends StatelessWidget {
  const _SignedIn({
    required this.user,
    required this.isPro,
    required this.purchasing,
    required this.waitingForWindows,
    required this.isWindows,
    required this.onUpgrade,
    required this.onRefresh,
    required this.onSignOut,
  });

  final User user;
  final bool isPro;
  final bool purchasing;
  final bool waitingForWindows;
  final bool isWindows;
  final VoidCallback onUpgrade;
  final VoidCallback onRefresh;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LiquidPanel(
          enableHoverGlow: false,
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: aurora.accent.withValues(alpha: 0.15),
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null
                    ? Icon(Icons.person_rounded, color: aurora.accent)
                    : null,
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? AppStrings.dreamer,
                      style: context.textTheme.titleMedium,
                    ),
                    if (user.email != null)
                      Text(
                        user.email!,
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: aurora.textDim),
                      ),
                  ],
                ),
              ),
              _TierBadge(isPro: isPro),
            ],
          ),
        ),
        const Gap(AppSpacing.lg),
        if (isPro)
          _ProStatusCard(user: user, onSignOut: onSignOut)
        else ...[
          const _ProPitch(),
          const Gap(AppSpacing.lg),
          if (PurchasesConfig.proPurchasable) ...[
            if (waitingForWindows) ...[
              _WaitingCard(onRefresh: onRefresh),
              const Gap(AppSpacing.md),
            ],
            GlassButton(
              onPressed: purchasing ? null : onUpgrade,
              isLoading: purchasing,
              child: const Text(AppStrings.upgradeCta),
            ),
          ] else ...[
            const _ComingSoonNotice(),
          ],
          const Gap(AppSpacing.md),
          GlassButton(
            outlined: true,
            onPressed: onSignOut,
            child: const Text(AppStrings.signOut),
          ),
        ],
      ],
    );
  }
}

class _ProStatusCard extends ConsumerWidget {
  const _ProStatusCard({required this.user, required this.onSignOut});

  final User user;
  final VoidCallback onSignOut;

  Future<void> _openManagement(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final url = await ref.read(purchasesServiceProvider).managementUrl(user.uid);
    if (url == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.manageUnavailable)),
      );
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aurora = context.auroraTheme;
    final expiry = ref.watch(accessTierLogicProvider).expiry;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LiquidPanel(
          enableHoverGlow: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded, color: aurora.accent),
                  const Gap(AppSpacing.sm),
                  Text(
                    AppStrings.proActive,
                    style: context.textTheme.titleMedium,
                  ),
                ],
              ),
              const Gap(AppSpacing.sm),
              Text(
                expiry != null
                    ? '${AppStrings.renewsOn} ${DateFormat.yMMMMd().format(expiry.toLocal())}'
                    : AppStrings.proActiveHint,
                style:
                    context.textTheme.bodySmall?.copyWith(color: aurora.textDim),
              ),
              const Gap(AppSpacing.sm),
              Text(
                AppStrings.manageSubscriptionHint,
                style:
                    context.textTheme.bodySmall?.copyWith(color: aurora.textDim),
              ),
            ],
          ),
        ),
        const Gap(AppSpacing.md),
        GlassButton(
          onPressed: () => _openManagement(context, ref),
          child: const Text(AppStrings.manageSubscription),
        ),
        const Gap(AppSpacing.md),
        GlassButton(
          outlined: true,
          onPressed: onSignOut,
          child: const Text(AppStrings.signOut),
        ),
      ],
    );
  }
}

class _WaitingCard extends StatelessWidget {
  const _WaitingCard({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return LiquidPanel(
      enableHoverGlow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: Text(
                  AppStrings.waitingForPayment,
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            AppStrings.waitingForPaymentHint,
            style: context.textTheme.bodySmall?.copyWith(color: aurora.textDim),
          ),
          const Gap(AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(AppStrings.refreshStatus),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.isPro});

  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPro
            ? aurora.accent.withValues(alpha: 0.15)
            : aurora.bgElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPro ? aurora.accent : aurora.border,
          width: 1,
        ),
      ),
      child: Text(
        isPro ? AppStrings.tierPro : AppStrings.tierFree,
        style: context.textTheme.labelSmall?.copyWith(
          color: isPro ? aurora.accent : aurora.textDim,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProPitch extends StatelessWidget {
  const _ProPitch();

  static const _features = <(IconData, String, String)>[
    (
      Icons.psychology_outlined,
      'Advanced interpretation styles',
      'Psychological, Mythic, and Creative personas.',
    ),
    (
      Icons.all_inclusive_rounded,
      'Unlimited interpretations',
      'No daily limit on dream readings.',
    ),
    (
      Icons.cloud_done_outlined,
      'Cloud backup',
      'Your journal syncs securely across devices.',
    ),
    (
      Icons.insights_rounded,
      'Insights dashboard',
      'Visualize your recurring themes and styles.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return LiquidPanel(
      enableHoverGlow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.proPitchTitle, style: context.textTheme.titleLarge),
          const Gap(AppSpacing.xs),
          Text(
            AppStrings.proPitchPrice,
            style: context.textTheme.titleMedium?.copyWith(color: aurora.accent),
          ),
          const Gap(AppSpacing.md),
          for (final (icon, title, body) in _features)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: aurora.accent),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.textTheme.titleSmall),
                        Text(
                          body,
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: aurora.textDim),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Phase-1 placeholder shown wherever the Pro upgrade/sign-in CTA would appear
/// while purchasing is disabled. Communicates that Pro is on the way without
/// dead-ending the user on a non-functional button.
class _ComingSoonNotice extends StatelessWidget {
  const _ComingSoonNotice();

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return LiquidPanel(
      enableHoverGlow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule_rounded, size: 20, color: aurora.accent),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.proComingSoon,
                  style: context.textTheme.titleSmall,
                ),
                const Gap(AppSpacing.xs),
                Text(
                  AppStrings.proComingSoonNotice,
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: aurora.textDim),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
