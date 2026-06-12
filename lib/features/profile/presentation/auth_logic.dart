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
    if (current != null) _handleUser(current);
    return AsyncData(current);
  }

  void _handleUser(User? user) {
    state = AsyncData(user);
    final purchases = ref.read(purchasesServiceProvider);
    if (user != null) {
      unawaited(purchases.onSignIn(user.uid));
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
  }
}
