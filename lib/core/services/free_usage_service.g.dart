// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_usage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(freeUsageService)
final freeUsageServiceProvider = FreeUsageServiceProvider._();

final class FreeUsageServiceProvider
    extends
        $FunctionalProvider<
          FreeUsageService,
          FreeUsageService,
          FreeUsageService
        >
    with $Provider<FreeUsageService> {
  FreeUsageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'freeUsageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$freeUsageServiceHash();

  @$internal
  @override
  $ProviderElement<FreeUsageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FreeUsageService create(Ref ref) {
    return freeUsageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FreeUsageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FreeUsageService>(value),
    );
  }
}

String _$freeUsageServiceHash() => r'9a26d9de07593d788d108d87e3d653ef753a9e7f';
