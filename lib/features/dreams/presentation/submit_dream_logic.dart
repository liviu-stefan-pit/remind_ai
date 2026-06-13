import 'dart:async';

import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/constants/app_prompts.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:remind_ai/core/network/gemini_client.dart';
import 'package:remind_ai/core/services/cloud_sync_service.dart';
import 'package:remind_ai/core/services/usage_quota_service.dart';
import 'package:remind_ai/features/dreams/data/datasources/dream_local_datasource.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';
import 'package:remind_ai/features/dreams/presentation/dream_history_logic.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
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
    final quota = ref.read(usageQuotaServiceProvider);
    final uid = ref.read(authLogicProvider).asData?.value?.uid;

    // Gate: Pro-only styles require an active Pro entitlement. The UI already
    // locks these, but enforce here so the network call can't be triggered by
    // a stale/forged UI state.
    if (style.isPro && !tier.isPro) {
      state = AsyncError(const ProRequiredException(), StackTrace.current);
      return;
    }

    // Gate: light throttle against rapid-fire scripted submissions.
    if (quota.isThrottled()) {
      state = AsyncError(const RateLimitException(), StackTrace.current);
      return;
    }

    // Guard: uid must be non-null here because the router auth gate blocks
    // unauthenticated navigation to this screen. A null uid at this point means
    // the auth state somehow disappeared mid-session — treat it as an auth error
    // rather than falling back to a bypassable local counter.
    if (uid == null) {
      state = AsyncError(
        const AuthException('Not signed in. Please sign in to continue.'),
        StackTrace.current,
      );
      return;
    }

    // Gate: per-tier daily cap — checked against Firestore (server-side source
    // of truth) so incognito / cleared-storage sessions cannot bypass the limit.
    // Falls back to local Hive counter only when Firestore is transiently
    // unavailable (e.g. offline); permission errors are always a hard deny.
    if (!await quota.canSubmitFromServer(uid, tier)) {
      state = AsyncError(const DailyLimitException(), StackTrace.current);
      return;
    }

    // Count this attempt toward the throttle window before awaiting so even
    // in-flight/failed requests space out subsequent taps.
    await quota.markSubmitAttempt();

    state = await AsyncValue.guard(() async {
      final interpretation = await ref
          .read(geminiClientProvider)
          .generate(
            prompt: dreamText,
            systemInstruction: _promptFor(style),
            model: style.model,
            maxOutputTokens: style.maxOutputTokens,
          );

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

      // Best-effort cloud backup (no-op unless a Pro user is signed in).
      unawaited(ref.read(syncLogicProvider.notifier).syncNow());

      // Record usage after a successful save so a failed request or write
      // never silently consumes the daily quota. Applies to all tiers.
      await quota.recordUsage();
      unawaited(quota.recordUsageToServer(uid));

      return entry;
    });
  }

  String _promptFor(DreamStyle style) {
    return switch (style) {
      DreamStyle.standard => AppPrompts.standard,
      DreamStyle.psychological => AppPrompts.psychological,
      DreamStyle.mythic => AppPrompts.mythic,
      DreamStyle.creative => AppPrompts.creative,
    };
  }
}
