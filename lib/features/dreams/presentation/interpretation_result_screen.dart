import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/glass/glass_chip.dart';
import 'package:remind_ai/design/glass/liquid_panel.dart';
import 'package:remind_ai/design/motion/enter_effects.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/design/tokens/typography.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';

String _dreamStyleLabel(DreamStyle style) => switch (style) {
      DreamStyle.standard => 'Standard',
      DreamStyle.psychological => 'Psychological',
      DreamStyle.mythic => 'Mythic',
      DreamStyle.creative => 'Creative',
    };

class InterpretationResultScreen extends StatelessWidget {
  const InterpretationResultScreen({required this.entry, super.key});

  final DreamEntry entry;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final aurora = context.auroraTheme;
    final dateStr = DateFormat('MMM d, yyyy · HH:mm').format(entry.createdAt);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text(AppStrings.dreamInterpretation)),
      body: QuietSky(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: context.maxContentWidth),
              child: SingleChildScrollView(
                padding: context.contentPadding.add(
                  const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateStr,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: aurora.textDim,
                          ),
                        ),
                        GlassChip(
                          label: _dreamStyleLabel(entry.style),
                          selected: true,
                        ),
                      ],
                    ).animateFade(key: const ValueKey('result-meta')),
                    const Gap(AppSpacing.lg),
                    Text(
                      AppStrings.yourDream,
                      style: AppTypography.sectionLabel(aurora.textDim),
                    ),
                    const Gap(AppSpacing.sm),
                    LiquidPanel(
                      borderRadius: 16,
                      enableHoverGlow: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          entry.dreamText,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: aurora.textDim,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ).animateRise(
                      key: const ValueKey('result-dream'),
                      delay: const Duration(milliseconds: 60),
                    ),
                    const Gap(AppSpacing.lg),
                    Text(
                      AppStrings.interpretation,
                      style: AppTypography.sectionLabel(aurora.textDim),
                    ),
                    const Gap(AppSpacing.sm),
                    LiquidPanel(
                      borderRadius: 16,
                      enableHoverGlow: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: SelectableText(
                          entry.interpretationText ?? '—',
                          style: AppTypography.serifBody(cs.onSurface),
                        ),
                      ),
                    ).animateRise(
                      key: const ValueKey('result-body'),
                      delay: const Duration(milliseconds: 120),
                    ),
                    const Gap(AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: GlassButton(
                            compact: true,
                            outlined: true,
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: entry.interpretationText ?? '',
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.copy_outlined, size: 16),
                                Gap(6),
                                Text(AppStrings.share),
                              ],
                            ),
                          ),
                        ),
                        const Gap(AppSpacing.sm),
                        Expanded(
                          child: GlassButton(
                            compact: true,
                            onPressed: () => context.pushReplacement(
                              AppRoute.dreamInput.route,
                            ),
                            child: const Text(AppStrings.newDream),
                          ),
                        ),
                      ],
                    ).animateRise(
                      key: const ValueKey('result-actions'),
                      delay: const Duration(milliseconds: 200),
                    ),
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
