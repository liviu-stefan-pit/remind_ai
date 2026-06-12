// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Invisible background worker. Whenever a Pro user is signed in (and Firebase
/// is configured), it batch-uploads every local entry with `isSynced == false`
/// to Firestore and flips the local flag. One-way, best-effort: failures are
/// logged and retried on the next trigger.

@ProviderFor(SyncLogic)
final syncLogicProvider = SyncLogicProvider._();

/// Invisible background worker. Whenever a Pro user is signed in (and Firebase
/// is configured), it batch-uploads every local entry with `isSynced == false`
/// to Firestore and flips the local flag. One-way, best-effort: failures are
/// logged and retried on the next trigger.
final class SyncLogicProvider extends $AsyncNotifierProvider<SyncLogic, void> {
  /// Invisible background worker. Whenever a Pro user is signed in (and Firebase
  /// is configured), it batch-uploads every local entry with `isSynced == false`
  /// to Firestore and flips the local flag. One-way, best-effort: failures are
  /// logged and retried on the next trigger.
  SyncLogicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncLogicProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncLogicHash();

  @$internal
  @override
  SyncLogic create() => SyncLogic();
}

String _$syncLogicHash() => r'b155525c8818f9022670b9788adcae9b55bd1468';

/// Invisible background worker. Whenever a Pro user is signed in (and Firebase
/// is configured), it batch-uploads every local entry with `isSynced == false`
/// to Firestore and flips the local flag. One-way, best-effort: failures are
/// logged and retried on the next trigger.

abstract class _$SyncLogic extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
