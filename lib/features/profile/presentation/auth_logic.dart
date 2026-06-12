import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/core/services/purchases_service.dart';
import 'package:remind_ai/features/profile/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_logic.g.dart';

/// Holds the current Firebase [User] and reacts to auth changes by syncing the
/// RevenueCat identity / entitlement. Stays inert (always signed-out) when
/// Firebase is not configured, so the app runs locally without a backend.
@Riverpod(keepAlive: true)
class AuthLogic extends _$AuthLogic {
  StreamSubscription<User?>? _sub;

  @override
  AsyncValue<User?> build() {
    final ready = ref.watch(firebaseReadyProvider);
    if (!ready) return const AsyncData(null);

    final repo = ref.read(authRepositoryProvider);
    _sub = repo.authStateChanges().listen(_handleUser);
    ref.onDispose(() => _sub?.cancel());

    final current = repo.currentUser;
    // The initial state is returned below; only the RevenueCat identity sync is
    // deferred, because it mutates accessTierLogicProvider and Riverpod forbids
    // modifying another provider during this provider's build.
    if (current != null) {
      Future.microtask(() => _syncPurchases(current));
    }
    return AsyncData(_visible(current));
  }

  /// Anonymous users back Firebase AI Logic for the free tier but are not a
  /// "real" account, so they surface as signed-out to the UI.
  User? _visible(User? user) =>
      (user == null || user.isAnonymous) ? null : user;

  void _handleUser(User? user) {
    // Defer so authStateChanges() can emit during [build] without mutating
    // accessTierLogicProvider (Riverpod forbids cross-provider writes in build).
    Future.microtask(() {
      if (!ref.mounted) return;
      state = AsyncData(_visible(user));
      _syncPurchases(user);
    });
  }

  void _syncPurchases(User? user) {
    final visible = _visible(user);
    final purchases = ref.read(purchasesServiceProvider);
    if (visible != null) {
      unawaited(purchases.onSignIn(visible.uid));
    } else {
      unawaited(purchases.onSignOut());
    }
  }

  Future<void> signInWithGoogle() async {
    if (!ref.read(firebaseReadyProvider)) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithGoogle();
      return repo.currentUser;
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    // Re-establish an anonymous session so Firebase AI Logic keeps working
    // for the free tier after the user signs out of their Google account.
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on Object catch (_) {
      // Non-fatal; interpretation surfaces a network error if it can't auth.
    }
  }
}
