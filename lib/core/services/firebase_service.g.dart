// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// True only after [initFirebase] has successfully connected to a real
/// project. While `firebase_options.dart` still holds placeholder values (or
/// initialization fails), this stays false and every Firebase-backed feature
/// (auth, cloud sync) degrades gracefully instead of crashing.

@ProviderFor(firebaseReady)
final firebaseReadyProvider = FirebaseReadyProvider._();

/// True only after [initFirebase] has successfully connected to a real
/// project. While `firebase_options.dart` still holds placeholder values (or
/// initialization fails), this stays false and every Firebase-backed feature
/// (auth, cloud sync) degrades gracefully instead of crashing.

final class FirebaseReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// True only after [initFirebase] has successfully connected to a real
  /// project. While `firebase_options.dart` still holds placeholder values (or
  /// initialization fails), this stays false and every Firebase-backed feature
  /// (auth, cloud sync) degrades gracefully instead of crashing.
  FirebaseReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseReadyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return firebaseReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$firebaseReadyHash() => r'796115fd67333b7baa8f83fc7b0048d18b4c620b';
