// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_tier_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single source of truth for the user's tier, consumed by every UI gate.
///
/// The tier is only ever written by the entitlement services (RevenueCat SDK
/// listener on Android/Web, REST poll on Windows) via [applyEntitlement]; the
/// UI never sets it directly. On startup it hydrates from [EntitlementCache] so
/// Pro survives offline launches until the next remote validation.

@ProviderFor(AccessTierLogic)
final accessTierLogicProvider = AccessTierLogicProvider._();

/// Single source of truth for the user's tier, consumed by every UI gate.
///
/// The tier is only ever written by the entitlement services (RevenueCat SDK
/// listener on Android/Web, REST poll on Windows) via [applyEntitlement]; the
/// UI never sets it directly. On startup it hydrates from [EntitlementCache] so
/// Pro survives offline launches until the next remote validation.
final class AccessTierLogicProvider
    extends $NotifierProvider<AccessTierLogic, AccessTierState> {
  /// Single source of truth for the user's tier, consumed by every UI gate.
  ///
  /// The tier is only ever written by the entitlement services (RevenueCat SDK
  /// listener on Android/Web, REST poll on Windows) via [applyEntitlement]; the
  /// UI never sets it directly. On startup it hydrates from [EntitlementCache] so
  /// Pro survives offline launches until the next remote validation.
  AccessTierLogicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessTierLogicProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessTierLogicHash();

  @$internal
  @override
  AccessTierLogic create() => AccessTierLogic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccessTierState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccessTierState>(value),
    );
  }
}

String _$accessTierLogicHash() => r'e28376814937aeae17dcf0080ab13f8adb751894';

/// Single source of truth for the user's tier, consumed by every UI gate.
///
/// The tier is only ever written by the entitlement services (RevenueCat SDK
/// listener on Android/Web, REST poll on Windows) via [applyEntitlement]; the
/// UI never sets it directly. On startup it hydrates from [EntitlementCache] so
/// Pro survives offline launches until the next remote validation.

abstract class _$AccessTierLogic extends $Notifier<AccessTierState> {
  AccessTierState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AccessTierState, AccessTierState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccessTierState, AccessTierState>,
              AccessTierState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
