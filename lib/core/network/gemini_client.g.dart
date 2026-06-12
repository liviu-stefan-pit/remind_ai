// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geminiClient)
final geminiClientProvider = GeminiClientProvider._();

final class GeminiClientProvider
    extends $FunctionalProvider<GeminiClient, GeminiClient, GeminiClient>
    with $Provider<GeminiClient> {
  GeminiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiClientHash();

  @$internal
  @override
  $ProviderElement<GeminiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GeminiClient create(Ref ref) {
    return geminiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeminiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeminiClient>(value),
    );
  }
}

String _$geminiClientHash() => r'a2768a46d2377a794c3ba75a691dad98396602d9';
