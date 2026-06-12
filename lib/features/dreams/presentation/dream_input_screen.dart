import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/config/purchases/purchases_config.dart';
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
          final message = switch (error) {
            DailyLimitException() => AppStrings.dailyLimitReached,
            ProRequiredException() => AppStrings.proRequired,
            RateLimitException() => AppStrings.rateLimited,
            _ => AppStrings.unexpectedError,
          };
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
    bool isLocked(DreamStyle s) => !isPro && s.isPro;
    Widget card(DreamStyle style) => _StyleTile(
          style: style,
          isSelected: _selectedStyle == style,
          isLocked: isLocked(style),
          onTap: () {
            if (isLocked(style)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    PurchasesConfig.proPurchasable
                        ? '${AppStrings.upgradeToPro} '
                            '${_StyleTile.labelFor(style)}.'
                        : AppStrings.proComingSoonStyle,
                  ),
                ),
              );
            } else {
              setState(() => _selectedStyle = style);
            }
          },
        );

    const styles = DreamStyle.values;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Two columns normally; collapse to one on very narrow viewports so
        // the title + description never gets clipped.
        final crossAxisCount = constraints.maxWidth < 360 ? 1 : 2;
        final aspectRatio = crossAxisCount == 1 ? 3.6 : 1.45;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: aspectRatio,
          children: [for (final style in styles) card(style)],
        );
      },
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

class _StyleTile extends StatefulWidget {
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
        DreamStyle.standard => AppStrings.styleStandardName,
        DreamStyle.psychological => AppStrings.stylePsychologicalName,
        DreamStyle.mythic => AppStrings.styleMythicName,
        DreamStyle.creative => AppStrings.styleCreativeName,
      };

  static String descFor(DreamStyle s) => switch (s) {
        DreamStyle.standard => AppStrings.styleStandardDesc,
        DreamStyle.psychological => AppStrings.stylePsychologicalDesc,
        DreamStyle.mythic => AppStrings.styleMythicDesc,
        DreamStyle.creative => AppStrings.styleCreativeDesc,
      };

  @override
  State<_StyleTile> createState() => _StyleTileState();
}

class _StyleTileState extends State<_StyleTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final aurora = context.auroraTheme;

    final isSelected = widget.isSelected;
    final isLocked = widget.isLocked;
    final active = isSelected || _hovered;

    final borderColor = isSelected
        ? aurora.accent
        : (_hovered ? aurora.borderStrong : aurora.border);
    final fg = isLocked
        ? aurora.textDim
        : (isSelected ? aurora.accent : cs.onSurface);
    final bg = isSelected
        ? aurora.accent.withValues(alpha: 0.08)
        : aurora.bgElevated.withValues(alpha: _hovered ? 0.55 : 0.4);

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: !isLocked,
      label: '${_StyleTile.labelFor(widget.style)}. '
          '${_StyleTile.descFor(widget.style)}'
          '${widget.style.isPro ? ' Pro style.' : ''}',
      child: Tooltip(
        message: _StyleTile.descFor(widget.style),
        waitDuration: const Duration(milliseconds: 400),
        child: MouseRegion(
          cursor: isLocked
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor,
                  width: active ? 1.4 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_StyleTile._iconFor(widget.style),
                          size: 20, color: fg),
                      const Gap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _StyleTile.labelFor(widget.style),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall
                              ?.copyWith(color: fg),
                        ),
                      ),
                      if (widget.style.isPro) _ProBadge(locked: isLocked),
                    ],
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      _StyleTile.descFor(widget.style),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: aurora.textDim,
                        height: 1.25,
                      ),
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
}

/// Small gold "PRO" pill shown on Pro-only style cards. Dimmed while locked.
class _ProBadge extends StatelessWidget {
  const _ProBadge({required this.locked});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    final aurora = context.auroraTheme;
    final accent = aurora.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: locked ? 0.12 : 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (locked) ...[
            Icon(Icons.lock_outline, size: 10, color: accent),
            const Gap(3),
          ],
          Text(
            AppStrings.tierPro,
            style: context.textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
