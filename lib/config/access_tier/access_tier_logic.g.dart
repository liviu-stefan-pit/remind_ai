// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_tier_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccessTierLogic)
final accessTierLogicProvider = AccessTierLogicProvider._();

final class AccessTierLogicProvider
    extends $NotifierProvider<AccessTierLogic, AccessTierState> {
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

String _$accessTierLogicHash() => r'd468b9498b39c6a10b601efff427ae936eeddb27';

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
