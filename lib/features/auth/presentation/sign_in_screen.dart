import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/design/tokens/typography.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:remind_ai/utils/context_extensions.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aurora = context.auroraTheme;
    final firebaseReady = ref.watch(firebaseReadyProvider);
    final authState = ref.watch(authLogicProvider);
    final isLoading = authState.isLoading;

    ref.listen(authLogicProvider, (_, next) {
      if (next.hasError) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(content: Text(AppStrings.signInFailed)),
        );
      }
    });

    return Scaffold(
      body: QuietSky(
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
                    Icon(
                      Icons.nights_stay_outlined,
                      size: 64,
                      color: aurora.accent,
                    ),
                    const Gap(AppSpacing.xl),
                    Text(
                      AppStrings.appName,
                      style: context.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(AppSpacing.md),
                    Text(
                      AppStrings.signInTagline,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: aurora.textDim,
                        height: 1.55,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.signInQuotaNotice,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: aurora.textDim,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(AppSpacing.lg),
                    GlassButton(
                      onPressed: (!firebaseReady || isLoading)
                          ? null
                          : () => ref
                                .read(authLogicProvider.notifier)
                                .signInWithGoogle(),
                      isLoading: isLoading,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _GoogleG(),
                          Gap(AppSpacing.sm),
                          Text(AppStrings.signInWithGoogle),
                        ],
                      ),
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

/// Minimal Google "G" badge — white background, Google-blue letter.
/// Used instead of a raster asset so no PNG needs to be shipped.
class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}
