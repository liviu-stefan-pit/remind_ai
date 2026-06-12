// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_quota_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(usageQuotaService)
final usageQuotaServiceProvider = UsageQuotaServiceProvider._();

final class UsageQuotaServiceProvider
    extends
        $FunctionalProvider<
          UsageQuotaService,
          UsageQuotaService,
          UsageQuotaService
        >
    with $Provider<UsageQuotaService> {
  UsageQuotaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usageQuotaServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usageQuotaServiceHash();

  @$internal
  @override
  $ProviderElement<UsageQuotaService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UsageQuotaService create(Ref ref) {
    return usageQuotaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsageQuotaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsageQuotaService>(value),
    );
  }
}

String _$usageQuotaServiceHash() => r'9e649a9832e33ce51b5376baaf139e7bef402dc8';
