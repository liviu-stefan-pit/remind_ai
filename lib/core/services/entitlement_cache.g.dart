// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_cache.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persists the resolved access tier (and, for subscriptions, its expiry) in
/// the encrypted `prefs` box so Pro keeps working offline between entitlement
/// validations. The remote services (RevenueCat SDK / REST) are the source of
/// truth; this is only a local mirror for fast, offline startup.

@ProviderFor(entitlementCache)
final entitlementCacheProvider = EntitlementCacheProvider._();

/// Persists the resolved access tier (and, for subscriptions, its expiry) in
/// the encrypted `prefs` box so Pro keeps working offline between entitlement
/// validations. The remote services (RevenueCat SDK / REST) are the source of
/// truth; this is only a local mirror for fast, offline startup.

final class EntitlementCacheProvider
    extends
        $FunctionalProvider<
          EntitlementCache,
          EntitlementCache,
          EntitlementCache
        >
    with $Provider<EntitlementCache> {
  /// Persists the resolved access tier (and, for subscriptions, its expiry) in
  /// the encrypted `prefs` box so Pro keeps working offline between entitlement
  /// validations. The remote services (RevenueCat SDK / REST) are the source of
  /// truth; this is only a local mirror for fast, offline startup.
  EntitlementCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementCacheHash();

  @$internal
  @override
  $ProviderElement<EntitlementCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EntitlementCache create(Ref ref) {
    return entitlementCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntitlementCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntitlementCache>(value),
    );
  }
}

String _$entitlementCacheHash() => r'b9b5f06583dbf80ebb1bc62960743fef0e7811ba';
