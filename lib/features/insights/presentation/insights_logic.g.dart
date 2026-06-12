// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(insights)
final insightsProvider = InsightsProvider._();

final class InsightsProvider
    extends $FunctionalProvider<InsightsData, InsightsData, InsightsData>
    with $Provider<InsightsData> {
  InsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsHash();

  @$internal
  @override
  $ProviderElement<InsightsData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InsightsData create(Ref ref) {
    return insights(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InsightsData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InsightsData>(value),
    );
  }
}

String _$insightsHash() => r'fe579af9c124a8c219703ba344f9d2c429123e8d';
