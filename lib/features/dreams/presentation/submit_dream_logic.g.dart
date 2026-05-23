// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_dream_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubmitDreamLogic)
final submitDreamLogicProvider = SubmitDreamLogicProvider._();

final class SubmitDreamLogicProvider
    extends $NotifierProvider<SubmitDreamLogic, AsyncValue<DreamEntry?>> {
  SubmitDreamLogicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitDreamLogicProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitDreamLogicHash();

  @$internal
  @override
  SubmitDreamLogic create() => SubmitDreamLogic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<DreamEntry?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<DreamEntry?>>(value),
    );
  }
}

String _$submitDreamLogicHash() => r'5af156c0a831bebfecc4f0e932c2dcbe1c3e830b';

abstract class _$SubmitDreamLogic extends $Notifier<AsyncValue<DreamEntry?>> {
  AsyncValue<DreamEntry?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DreamEntry?>, AsyncValue<DreamEntry?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DreamEntry?>, AsyncValue<DreamEntry?>>,
              AsyncValue<DreamEntry?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
