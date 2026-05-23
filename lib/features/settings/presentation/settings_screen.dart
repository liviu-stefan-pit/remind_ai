import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/config/settings/settings_logic.dart';
import 'package:remind_ai/config/theme/theme_logic.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_chip.dart';
import 'package:remind_ai/design/glass/liquid_panel.dart';
import 'package:remind_ai/design/rive/rive_widgets.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/design/tokens/typography.dart';
import 'package:remind_ai/features/dreams/presentation/dream_history_logic.dart';
import 'package:remind_ai/utils/context_extensions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeLogicProvider);
    final settings = ref.watch(settingsLogicProvider);
    final isPro = ref.watch(accessTierLogicProvider).tier.isPro;
    final aurora = context.auroraTheme;
    final isDark = theme.themeMode == ThemeMode.dark ||
        (theme.themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: QuietSky(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: context.maxContentWidth),
              child: ListView(
                padding: context.contentPadding.add(
                  const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                children: [
                  _SectionLabel(AppStrings.appearance),
                  LiquidPanel(
                    padding: EdgeInsets.zero,
                    enableHoverGlow: false,
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          ListTile(
                          leading: ThemeToggleIcon(isDark: isDark),
                          title: const Text(AppStrings.theme),
                          subtitle: Text(_themeLabel(theme.themeMode)),
                          onTap: () => ref
                              .read(themeLogicProvider.notifier)
                              .toggleTheme(),
                        ),
                        Divider(height: 1, color: aurora.border),
                        SwitchListTile(
                          title: const Text(AppStrings.reduceMotion),
                          subtitle: const Text(AppStrings.reduceMotionHint),
                          value: settings.reduceMotion,
                          onChanged: ref
                              .read(settingsLogicProvider.notifier)
                              .setReduceMotion,
                        ),
                        Divider(height: 1, color: aurora.border),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.xs,
                                ),
                                child: Text(
                                  AppStrings.ambientMotion,
                                  style:
                                      context.textTheme.titleMedium,
                                ),
                              ),
                              const Gap(AppSpacing.xs),
                              Row(
                                children: [
                                  for (final lvl in AmbientLevel.values) ...[
                                    GlassChip(
                                      label: _ambientLabel(lvl),
                                      selected:
                                          settings.ambientLevel == lvl,
                                      onTap: () => ref
                                          .read(settingsLogicProvider
                                              .notifier)
                                          .setAmbientLevel(lvl),
                                    ),
                                    const Gap(AppSpacing.xs),
                                  ],
                                ],
                              ),
                              const Gap(AppSpacing.sm),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  _SectionLabel(AppStrings.account),
                  LiquidPanel(
                    enableHoverGlow: false,
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isPro ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: aurora.accent,
                      ),
                      title: Text(
                        isPro
                            ? AppStrings.proActive
                            : AppStrings.upgradeToPro,
                      ),
                      subtitle: Text(
                        isPro
                            ? AppStrings.proActiveHint
                            : AppStrings.proUpsellHint,
                      ),
                    ),
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  _SectionLabel(AppStrings.data),
                  LiquidPanel(
                    padding: EdgeInsets.zero,
                    enableHoverGlow: false,
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_sweep_outlined,
                          color: context.colorScheme.error,
                        ),
                        title: const Text(AppStrings.clearHistory),
                        onTap: () => _confirmClearHistory(context, ref),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  _SectionLabel(AppStrings.about),
                  LiquidPanel(
                    enableHoverGlow: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: context.textTheme.titleMedium,
                        ),
                        const Gap(AppSpacing.xxs),
                        Text(
                          AppStrings.versionLabel,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: aurora.textDim,
                          ),
                        ),
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
    );
  }

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.dark => AppStrings.themeDark,
        ThemeMode.light => AppStrings.themeLight,
        ThemeMode.system => AppStrings.themeSystem,
      };

  String _ambientLabel(AmbientLevel level) => switch (level) {
        AmbientLevel.off => AppStrings.ambientOff,
        AmbientLevel.calm => AppStrings.ambientCalm,
        AmbientLevel.lively => AppStrings.ambientLively,
      };

  Future<void> _confirmClearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.clearHistoryConfirmTitle),
        content: const Text(AppStrings.clearHistoryConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(settingsLogicProvider.notifier).clearHistory();
      ref.invalidate(dreamHistoryLogicProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.historyCleared)),
        );
      }
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.sectionLabel(aurora.textDim),
      ),
    );
  }
}
