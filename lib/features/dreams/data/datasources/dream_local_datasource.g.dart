// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dreamLocalDatasource)
final dreamLocalDatasourceProvider = DreamLocalDatasourceProvider._();

final class DreamLocalDatasourceProvider
    extends
        $FunctionalProvider<
          DreamLocalDatasource,
          DreamLocalDatasource,
          DreamLocalDatasource
        >
    with $Provider<DreamLocalDatasource> {
  DreamLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dreamLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dreamLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<DreamLocalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DreamLocalDatasource create(Ref ref) {
    return dreamLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DreamLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DreamLocalDatasource>(value),
    );
  }
}

String _$dreamLocalDatasourceHash() =>
    r'666dbe93624308b6df59e5d9fcdf4d72d306d42d';
