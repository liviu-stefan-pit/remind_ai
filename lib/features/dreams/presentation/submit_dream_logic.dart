import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/constants/app_prompts.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:remind_ai/core/network/gemini_client.dart';
import 'package:remind_ai/core/services/free_usage_service.dart';
import 'package:remind_ai/features/dreams/data/datasources/dream_local_datasource.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/dreams/presentation/dream_history_logic.dart';
import 'package:remind_ai/utils/id_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_dream_logic.g.dart';

@riverpod
class SubmitDreamLogic extends _$SubmitDreamLogic {
  @override
  AsyncValue<DreamEntry?> build() => const AsyncData(null);

  Future<void> submit({
    required String dreamText,
    required DreamStyle style,
  }) async {
    state = const AsyncLoading();

    // Snapshot tier before any await so it can't change mid-flight.
    final tier = ref.read(accessTierLogicProvider).tier;
    final freeUsage = ref.read(freeUsageServiceProvider);

    // Gate: free users are limited to one request per calendar day.
    if (!tier.isPro && !freeUsage.canUseFreeRequest()) {
      state = AsyncError(const DailyLimitException(), StackTrace.current);
      return;
    }

    state = await AsyncValue.guard(() async {
      final interpretation = await ref
          .read(geminiClientProvider)
          .generate(prompt: dreamText, systemInstruction: _promptFor(style));

      final entry = DreamEntry(
        id: generateId(),
        dreamText: dreamText,
        style: style,
        createdAt: DateTime.now(),
        interpretationText: interpretation,
      );

      await ref.read(dreamLocalDatasourceProvider).save(entry);

      // Ensure the history provider rebuilds with the new entry on next access.
      ref.invalidate(dreamHistoryLogicProvider);

      // Record usage after a successful save so a failed write never
      // silently consumes the daily quota.
      if (!tier.isPro) {
        await freeUsage.recordFreeUsage();
      }

      return entry;
    });
  }

  String _promptFor(DreamStyle style) {
    return switch (style) {
      DreamStyle.standard => AppPrompts.standard,
      DreamStyle.psychological => AppPrompts.standard,
      DreamStyle.mythic => AppPrompts.standard,
      DreamStyle.creative => AppPrompts.standard,
    };
  }
}
