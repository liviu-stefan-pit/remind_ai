import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/dreams/presentation/submit_dream_logic.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';
import 'package:remind_ai/utils/cosmic_background.dart';

class DreamInputScreen extends ConsumerStatefulWidget {
  const DreamInputScreen({super.key});

  @override
  ConsumerState<DreamInputScreen> createState() => _DreamInputScreenState();
}

class _DreamInputScreenState extends ConsumerState<DreamInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  DreamStyle _selectedStyle = DreamStyle.standard;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(accessTierLogicProvider).tier.isPro;
    final isLoading = ref.watch(submitDreamLogicProvider) is AsyncLoading;

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.interpretDream)),
      body: CosmicBackground(
        child: Form(
          key: _formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: SingleChildScrollView(
                padding: context.contentPadding.add(
                  const EdgeInsets.symmetric(vertical: 20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.describeDreamLabel,
                      style: context.textTheme.titleMedium,
                    ),
                    const Gap(8),
                    TextFormField(
                      controller: _controller,
                      minLines: 5,
                      maxLines: 12,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText: AppStrings.describeDreamHint,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final trimmed = value?.trim() ?? '';
                        if (trimmed.length < 20)
                          return AppStrings.minCharsError;
                        return null;
                      },
                    ),
                    const Gap(24),
                    Text(
                      AppStrings.interpretationStyle,
                      style: context.textTheme.titleMedium,
                    ),
                    const Gap(12),
                    _buildStyleGrid(isPro: isPro),
                    const Gap(32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : const Text(AppStrings.interpret),
                      ),
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

  Widget _buildStyleGrid({required bool isPro}) {
    bool isLocked(DreamStyle style) => !isPro && style != DreamStyle.standard;

    Widget card(DreamStyle style) => _StyleCard(
      style: style,
      isSelected: _selectedStyle == style,
      isLocked: isLocked(style),
      onTap: () {
        if (isLocked(style)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppStrings.upgradeToPro} ${_StyleCard.labelFor(style)}.',
              ),
            ),
          );
        } else {
          setState(() => _selectedStyle = style);
        }
      },
    );

    if (!context.isMobile) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: card(DreamStyle.standard)),
            const Gap(12),
            Expanded(child: card(DreamStyle.psychological)),
            const Gap(12),
            Expanded(child: card(DreamStyle.mythic)),
            const Gap(12),
            Expanded(child: card(DreamStyle.creative)),
          ],
        ),
      );
    }

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: card(DreamStyle.standard)),
              const Gap(12),
              Expanded(child: card(DreamStyle.psychological)),
            ],
          ),
        ),
        const Gap(12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: card(DreamStyle.mythic)),
              const Gap(12),
              Expanded(child: card(DreamStyle.creative)),
            ],
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(submitDreamLogicProvider.notifier)
        .submit(dreamText: _controller.text.trim(), style: _selectedStyle);
  }
}

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.style,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  final DreamStyle style;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  static IconData _iconFor(DreamStyle style) => switch (style) {
    DreamStyle.standard => Icons.book_outlined,
    DreamStyle.psychological => Icons.psychology_outlined,
    DreamStyle.mythic => Icons.auto_awesome_outlined,
    DreamStyle.creative => Icons.edit_outlined,
  };

  static String labelFor(DreamStyle style) => switch (style) {
    DreamStyle.standard => 'Standard',
    DreamStyle.psychological => 'Psychological',
    DreamStyle.mythic => 'Mythic',
    DreamStyle.creative => 'Creative',
  };

  static String _subtitleFor(DreamStyle style) => switch (style) {
    DreamStyle.standard => 'Classic symbol decoder',
    DreamStyle.psychological => 'What Jung would say',
    DreamStyle.mythic => 'Ancient archetypes',
    DreamStyle.creative => 'Poetic reimagining',
  };

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    final dimColor = cs.onSurface.withValues(alpha: 0.38);
    final iconColor = isLocked
        ? dimColor
        : isSelected
        ? cs.primary
        : cs.onSurfaceVariant;
    final bgColor = isLocked
        ? cs.surfaceContainerHighest
        : isSelected
        ? cs.primaryContainer
        : cs.surfaceContainerLow;
    final borderColor = isSelected && !isLocked
        ? cs.primary
        : cs.outlineVariant;
    final borderWidth = isSelected && !isLocked ? 2.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(_iconFor(style), size: 22, color: iconColor),
                if (isLocked)
                  Icon(Icons.lock_outline, size: 16, color: dimColor),
              ],
            ),
            const Gap(8),
            Text(
              labelFor(style),
              style: tt.titleSmall?.copyWith(color: isLocked ? dimColor : null),
            ),
            const Gap(2),
            Text(
              _subtitleFor(style),
              style: tt.bodySmall?.copyWith(
                color: isLocked ? dimColor : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
