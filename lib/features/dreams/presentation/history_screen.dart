import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/dreams/presentation/dream_history_logic.dart';
import 'package:remind_ai/router/app_router.dart';
import 'package:remind_ai/utils/context_extensions.dart';

IconData _dreamStyleIcon(DreamStyle style) => switch (style) {
  DreamStyle.standard => Icons.book_outlined,
  DreamStyle.psychological => Icons.psychology_outlined,
  DreamStyle.mythic => Icons.auto_awesome_outlined,
  DreamStyle.creative => Icons.edit_outlined,
};

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

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.dreamHistory)),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    size: 64,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const Gap(16),
                  Text(
                    AppStrings.noHistoryYet,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final entry = entries[i];
                return _DreamHistoryTile(
                  entry: entry,
                  onTap: () =>
                      context.push(AppRoute.result.route, extra: entry),
                  onDeleteConfirmed: () => ref
                      .read(dreamHistoryLogicProvider.notifier)
                      .delete(entry.id),
                );
              },
            ),
    );
  }
}

class _DreamHistoryTile extends StatelessWidget {
  const _DreamHistoryTile({
    required this.entry,
    required this.onTap,
    required this.onDeleteConfirmed,
  });

  final DreamEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDeleteConfirmed;

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
    if (confirmed == true) onDeleteConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final dateStr = DateFormat('MMM d, yyyy').format(entry.createdAt);
    final styleLabel = _dreamStyleLabel(entry.style);
    final styleIcon = _dreamStyleIcon(entry.style);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: cs.secondaryContainer,
        child: Icon(styleIcon, size: 20, color: cs.onSecondaryContainer),
      ),
      title: Text(
        entry.dreamText.trim(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: tt.bodyMedium,
      ),
      subtitle: Text(
        '$dateStr · $styleLabel',
        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        color: cs.onSurfaceVariant,
        onPressed: () => _confirmDelete(context),
      ),
    );
  }
}
