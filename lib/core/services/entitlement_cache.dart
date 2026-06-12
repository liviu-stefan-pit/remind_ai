import 'package:hive_ce/hive.dart';
import 'package:remind_ai/config/access_tier/access_tier.dart';
import 'package:remind_ai/hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entitlement_cache.g.dart';

const _kTierKey = 'accessTier';
const _kExpiryKey = 'entitlementExpiry';

/// Persists the resolved access tier (and, for subscriptions, its expiry) in
/// the encrypted `prefs` box so Pro keeps working offline between entitlement
/// validations. The remote services (RevenueCat SDK / REST) are the source of
/// truth; this is only a local mirror for fast, offline startup.
@Riverpod(keepAlive: true)
EntitlementCache entitlementCache(Ref ref) {
  return EntitlementCache(Hive.box<String>(kPrefsBox));
}

class EntitlementCache {
  const EntitlementCache(this._box);

  final Box<String> _box;

  /// The cached tier, downgraded to free if the cached subscription expired.
  AccessTier readTier() {
    final raw = _box.get(_kTierKey);
    if (raw != AccessTier.pro.name) return AccessTier.free;
    final expiry = readExpiry();
    if (expiry != null && expiry.isBefore(DateTime.now())) {
      return AccessTier.free;
    }
    return AccessTier.pro;
  }

  DateTime? readExpiry() {
    final raw = _box.get(_kExpiryKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> write({required AccessTier tier, DateTime? expiry}) async {
    await _box.put(_kTierKey, tier.name);
    if (expiry != null) {
      await _box.put(_kExpiryKey, expiry.toIso8601String());
    } else {
      await _box.delete(_kExpiryKey);
    }
  }

  Future<void> clear() async {
    await _box.delete(_kTierKey);
    await _box.delete(_kExpiryKey);
  }
}
