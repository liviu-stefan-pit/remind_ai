import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
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
    final tt = context.textTheme;
    final dateStr = DateFormat('MMM d, yyyy · HH:mm').format(entry.createdAt);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.dreamInterpretation)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                _StyleChip(style: entry.style),
              ],
            ),
            const Gap(20),
            Text(AppStrings.yourDream, style: tt.titleMedium),
            const Gap(8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                entry.dreamText,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
            const Gap(24),
            Text(AppStrings.interpretation, style: tt.titleMedium),
            const Gap(8),
            SelectableText(
              entry.interpretationText ?? '—',
              style: tt.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _StyleChip extends StatelessWidget {
  const _StyleChip({required this.style});

  final DreamStyle style;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _dreamStyleLabel(style),
        style: context.textTheme.labelSmall?.copyWith(
          color: cs.onSecondaryContainer,
        ),
      ),
    );
  }
}
