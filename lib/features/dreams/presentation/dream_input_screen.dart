import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/glass/glass_field.dart';
import 'package:remind_ai/design/motion/enter_effects.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/design/tokens/typography.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/dreams/presentation/submit_dream_logic.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';

class DreamInputScreen extends ConsumerStatefulWidget {
  const DreamInputScreen({super.key});

  @override
  ConsumerState<DreamInputScreen> createState() => _DreamInputScreenState();
}

class _DreamInputScreenState extends ConsumerState<DreamInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  DreamStyle _selectedStyle = DreamStyle.standard;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(accessTierLogicProvider).tier.isPro;
    final submitState = ref.watch(submitDreamLogicProvider);
    final isLoading = submitState is AsyncLoading;
    final aurora = context.auroraTheme;

    ref.listen<AsyncValue<DreamEntry?>>(submitDreamLogicProvider, (_, next) {
      next.when(
        data: (value) {
          if (value != null) {
            context.pushReplacement(AppRoute.result.route, extra: value);
          }
        },
        loading: () {},
        error: (error, _) {
          final message = error is DailyLimitException
              ? AppStrings.dailyLimitReached
              : AppStrings.unexpectedError;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text(AppStrings.interpretDream)),
      body: QuietSky(
        child: SafeArea(
          child: Form(
            key: _formKey,
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
                      Text(
                        AppStrings.describeDreamLabel,
                        style: context.textTheme.headlineSmall,
                      ).animateRise(key: const ValueKey('input-label')),
                      const Gap(AppSpacing.md),
                      CallbackShortcuts(
                        bindings: {
                          const SingleActivator(
                            LogicalKeyboardKey.enter,
                            control: true,
                          ): _submit,
                          const SingleActivator(
                            LogicalKeyboardKey.enter,
                            meta: true,
                          ): _submit,
                        },
                        child: GlassField(
                        focused: _focusNode.hasFocus,
                        child: TextFormField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: _autofocusInput(context),
                          minLines: 6,
                          maxLines: 14,
                          maxLength: AppStrings.dreamMaxChars,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              AppStrings.dreamMaxChars,
                            ),
                          ],
                          textInputAction: TextInputAction.newline,
                          style: AppTypography.serifBody(
                            context.colorScheme.onSurface,
                            size: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: AppStrings.describeDreamHint,
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              color: aurora.textDim,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.length < 20) {
                              return AppStrings.minCharsError;
                            }
                            if (trimmed.length > AppStrings.dreamMaxChars) {
                              return AppStrings.maxCharsError;
                            }
                            return null;
                          },
                        ),
                        ),
                      ).animateRise(
                        key: const ValueKey('input-field'),
                        delay: const Duration(milliseconds: 80),
                      ),
                      const Gap(AppSpacing.xl),
                      Text(
                        AppStrings.interpretationStyle,
                        style: AppTypography.sectionLabel(aurora.textDim),
                      ).animateFade(key: const ValueKey('input-style-label')),
                      const Gap(AppSpacing.sm),
                      _buildStyleGrid(isPro: isPro),
                      const Gap(AppSpacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: GlassButton(
                          onPressed: _submit,
                          isLoading: isLoading,
                          child: const Text(AppStrings.interpret),
                        ),
                      ).animateRise(
                        key: const ValueKey('input-cta'),
                        delay: const Duration(milliseconds: 160),
                      ),
                      const Gap(AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyleGrid({required bool isPro}) {
    bool isLocked(DreamStyle s) => !isPro && s != DreamStyle.standard;
    Widget card(DreamStyle style, int index) => _StyleTile(
          style: style,
          isSelected: _selectedStyle == style,
          isLocked: isLocked(style),
          onTap: () {
            if (isLocked(style)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppStrings.upgradeToPro} ${_StyleTile.labelFor(style)}.',
                  ),
                ),
              );
            } else {
              setState(() => _selectedStyle = style);
            }
          },
        );

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.6,
      children: [
        card(DreamStyle.standard, 0),
        card(DreamStyle.psychological, 1),
        card(DreamStyle.mythic, 2),
        card(DreamStyle.creative, 3),
      ],
    );
  }

  /// Autofocus the dream field only on desktop, where a popped-up software
  /// keyboard isn't a concern and keyboard-first entry is expected.
  bool _autofocusInput(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(submitDreamLogicProvider.notifier).submit(
          dreamText: _controller.text.trim(),
          style: _selectedStyle,
        );
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({
    required this.style,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  final DreamStyle style;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  static IconData _iconFor(DreamStyle s) => switch (s) {
        DreamStyle.standard => Icons.book_outlined,
        DreamStyle.psychological => Icons.psychology_outlined,
        DreamStyle.mythic => Icons.auto_awesome_outlined,
        DreamStyle.creative => Icons.edit_outlined,
      };

  static String labelFor(DreamStyle s) => switch (s) {
        DreamStyle.standard => 'Standard',
        DreamStyle.psychological => 'Psychological',
        DreamStyle.mythic => 'Mythic',
        DreamStyle.creative => 'Creative',
      };

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final aurora = context.auroraTheme;

    final borderColor = isSelected
        ? aurora.accent
        : aurora.border;
    final fg = isLocked
        ? aurora.textDim
        : (isSelected ? aurora.accent : cs.onSurface);

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: !isLocked,
      label: labelFor(style),
      child: MouseRegion(
      cursor: isLocked
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? aurora.accent.withValues(alpha: 0.06)
                : aurora.bgElevated.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Icon(_iconFor(style), size: 18, color: fg),
              const Gap(AppSpacing.sm),
              Expanded(
                child: Text(
                  labelFor(style),
                  style: context.textTheme.titleSmall?.copyWith(color: fg),
                ),
              ),
              if (isLocked)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: aurora.accent.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
