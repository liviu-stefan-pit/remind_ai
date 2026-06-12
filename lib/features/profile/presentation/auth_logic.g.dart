// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the current Firebase [User] and reacts to auth changes by syncing the
/// RevenueCat identity / entitlement. Stays inert (always signed-out) when
/// Firebase is not configured, so the app runs locally without a backend.

@ProviderFor(AuthLogic)
final authLogicProvider = AuthLogicProvider._();

/// Holds the current Firebase [User] and reacts to auth changes by syncing the
/// RevenueCat identity / entitlement. Stays inert (always signed-out) when
/// Firebase is not configured, so the app runs locally without a backend.
final class AuthLogicProvider
    extends $NotifierProvider<AuthLogic, AsyncValue<User?>> {
  /// Holds the current Firebase [User] and reacts to auth changes by syncing the
  /// RevenueCat identity / entitlement. Stays inert (always signed-out) when
  /// Firebase is not configured, so the app runs locally without a backend.
  AuthLogicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLogicProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLogicHash();

  @$internal
  @override
  AuthLogic create() => AuthLogic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<User?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<User?>>(value),
    );
  }
}

String _$authLogicHash() => r'99965ff92fd30a2a06e3beac9cd8dd52d25b51c6';

/// Holds the current Firebase [User] and reacts to auth changes by syncing the
/// RevenueCat identity / entitlement. Stays inert (always signed-out) when
/// Firebase is not configured, so the app runs locally without a backend.

abstract class _$AuthLogic extends $Notifier<AsyncValue<User?>> {
  AsyncValue<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, AsyncValue<User?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, AsyncValue<User?>>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
