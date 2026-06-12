// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_history_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DreamHistoryLogic)
final dreamHistoryLogicProvider = DreamHistoryLogicProvider._();

final class DreamHistoryLogicProvider
    extends $NotifierProvider<DreamHistoryLogic, List<DreamEntry>> {
  DreamHistoryLogicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dreamHistoryLogicProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dreamHistoryLogicHash();

  @$internal
  @override
  DreamHistoryLogic create() => DreamHistoryLogic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DreamEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DreamEntry>>(value),
    );
  }
}

String _$dreamHistoryLogicHash() => r'b44f047ee744962618daf2442a6abc78728c0099';

abstract class _$DreamHistoryLogic extends $Notifier<List<DreamEntry>> {
  List<DreamEntry> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<DreamEntry>, List<DreamEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DreamEntry>, List<DreamEntry>>,
              List<DreamEntry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
