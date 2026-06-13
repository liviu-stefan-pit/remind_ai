import 'package:flutter/foundation.dart';
import 'package:remind_ai/config/access_tier/access_tier.dart';
import 'package:remind_ai/config/access_tier/access_tier_state.dart';
import 'package:remind_ai/core/services/entitlement_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_tier_logic.g.dart';

/// Single source of truth for the user's tier, consumed by every UI gate.
///
/// The tier is only ever written by the entitlement services (RevenueCat SDK
/// listener on Android/Web, REST poll on Windows) via [applyEntitlement]; the
/// UI never sets it directly. On startup it hydrates from [EntitlementCache] so
/// Pro survives offline launches until the next remote validation.
@Riverpod(keepAlive: true)
class AccessTierLogic extends _$AccessTierLogic {
  @override
  AccessTierState build() {
    final cache = ref.read(entitlementCacheProvider);
    return AccessTierState(tier: cache.readTier(), expiry: cache.readExpiry());
  }

  /// Applies a freshly validated entitlement and mirrors it to the local cache.
  void applyEntitlement({required bool isActive, DateTime? expiry}) {
    final tier = isActive ? AccessTier.pro : AccessTier.free;
    state = state.copyWith(tier: tier, expiry: isActive ? expiry : null);
    ref
        .read(entitlementCacheProvider)
        .write(tier: tier, expiry: isActive ? expiry : null);
  }

  void setTier(AccessTier tier, {DateTime? expiry}) =>
      applyEntitlement(isActive: tier.isPro, expiry: expiry);

  /// Dev/test helper to flip the tier without a real purchase.
  /// Only available in debug builds — stripped from release/profile builds.
  void toggle() {
    assert(kDebugMode, 'toggle() must not be called in release builds.');
    if (!kDebugMode) return;
    setTier(state.tier.isPro ? AccessTier.free : AccessTier.pro);
  }
}
