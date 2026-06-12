// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dreamRemoteDatasource)
final dreamRemoteDatasourceProvider = DreamRemoteDatasourceProvider._();

final class DreamRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          DreamRemoteDatasource,
          DreamRemoteDatasource,
          DreamRemoteDatasource
        >
    with $Provider<DreamRemoteDatasource> {
  DreamRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dreamRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dreamRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<DreamRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DreamRemoteDatasource create(Ref ref) {
    return dreamRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DreamRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DreamRemoteDatasource>(value),
    );
  }
}

String _$dreamRemoteDatasourceHash() =>
    r'34a18f25575800142fadb43b8423229071f10ef9';
