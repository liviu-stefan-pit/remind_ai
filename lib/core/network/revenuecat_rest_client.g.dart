// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenuecat_rest_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(revenueCatRestClient)
final revenueCatRestClientProvider = RevenueCatRestClientProvider._();

final class RevenueCatRestClientProvider
    extends
        $FunctionalProvider<
          RevenueCatRestClient,
          RevenueCatRestClient,
          RevenueCatRestClient
        >
    with $Provider<RevenueCatRestClient> {
  RevenueCatRestClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueCatRestClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueCatRestClientHash();

  @$internal
  @override
  $ProviderElement<RevenueCatRestClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RevenueCatRestClient create(Ref ref) {
    return revenueCatRestClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevenueCatRestClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevenueCatRestClient>(value),
    );
  }
}

String _$revenueCatRestClientHash() =>
    r'53f42eb4a77ef86f7e8f1b4bab02c6281e400708';
