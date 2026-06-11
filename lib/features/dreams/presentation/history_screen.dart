import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/design/background/quiet_sky.dart';
import 'package:remind_ai/design/glass/glass_button.dart';
import 'package:remind_ai/design/glass/hover_lift.dart';
import 'package:remind_ai/design/motion/enter_effects.dart';
import 'package:remind_ai/design/rive/rive_widgets.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/design/tokens/spacing.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/dreams/presentation/dream_history_logic.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';

Color _dreamStyleColor(DreamStyle style, BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return switch (style) {
    DreamStyle.standard => cs.primary,
    DreamStyle.psychological => cs.secondary,
    DreamStyle.mythic => cs.tertiary,
    // Avoid the error color (reads as "delete"); use the soft accent instead.
    DreamStyle.creative => context.auroraTheme.accentSoft,
  };
}

String _dreamStyleLabel(DreamStyle style) => switch (style) {
      DreamStyle.standard => 'Standard',
      DreamStyle.psychological => 'Psychological',
      DreamStyle.mythic => 'Mythic',
      DreamStyle.creative => 'Creative',
    };

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(dreamHistoryLogicProvider);
    final aurora = context.auroraTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text(AppStrings.dreamHistory)),
      body: QuietSky(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: context.maxContentWidth),
              child: entries.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const EmptyHistoryIllustration(),
                        const Gap(AppSpacing.lg),
                        Text(
                          AppStrings.noHistoryYet,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: aurora.textDim,
                          ),
                        ).animateFade(key: const ValueKey('history-empty')),
                        const Gap(AppSpacing.xl),
                        Padding(
                          padding: context.contentPadding,
                          child: GlassButton(
                            onPressed: () =>
                                context.push(AppRoute.dreamInput.route),
                            child: const Text(AppStrings.historyEmptyCta),
                          ),
                        ).animateFade(
                          key: const ValueKey('history-empty-cta'),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: context.contentPadding.add(
                        const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg),
                      ),
                      itemCount: entries.length,
                      separatorBuilder: (_, __) =>
                          const Gap(AppSpacing.xs),
                      itemBuilder: (_, i) {
                        final entry = entries[i];
                        return _DreamHistoryTile(
                          entry: entry,
                          index: i,
                          onTap: () => context.push(
                            AppRoute.result.route,
                            extra: entry,
                          ),
                          onDelete: () => ref
                              .read(dreamHistoryLogicProvider.notifier)
                              .delete(entry.id),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DreamHistoryTile extends StatelessWidget {
  const _DreamHistoryTile({
    required this.entry,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  final DreamEntry entry;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteConfirmMessage),
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
    if (confirmed == true) onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final aurora = context.auroraTheme;
    final dateStr = DateFormat('MMM d, yyyy').format(entry.createdAt);
    final styleColor = _dreamStyleColor(entry.style, context);

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cs.error.withValues(alpha: 0.18),
        ),
        child: Icon(Icons.delete_outline, color: cs.error),
      ),
      child: HoverLift(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: aurora.bgElevated.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: aurora.border, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: styleColor,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.dreamText.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '$dateStr · ${_dreamStyleLabel(entry.style)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: aurora.textDim,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: aurora.textDim,
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ).animateStagger(index, key: ValueKey('history-${entry.id}')),
    );
  }
}
