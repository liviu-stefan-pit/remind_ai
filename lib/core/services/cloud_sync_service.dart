import 'package:flutter/foundation.dart';
import 'package:remind_ai/config/access_tier/access_tier_logic.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/features/dreams/data/datasources/dream_local_datasource.dart';
import 'package:remind_ai/features/dreams/data/datasources/dream_remote_datasource.dart';
import 'package:remind_ai/features/dreams/presentation/dream_history_logic.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cloud_sync_service.g.dart';

/// Invisible background worker. Whenever a Pro user is signed in (and Firebase
/// is configured), it batch-uploads every local entry with `isSynced == false`
/// to Firestore and flips the local flag. One-way, best-effort: failures are
/// logged and retried on the next trigger.
@Riverpod(keepAlive: true)
class SyncLogic extends _$SyncLogic {
  @override
  Future<void> build() async {
    final ready = ref.watch(firebaseReadyProvider);
    final user = ref.watch(authLogicProvider).value;
    final isPro = ref.watch(accessTierLogicProvider).tier.isPro;

    if (!ready || user == null || !isPro) return;
    await _syncPending(user.uid);
  }

  /// Manual trigger (e.g. right after saving a new dream).
  Future<void> syncNow() async {
    if (!ref.read(firebaseReadyProvider)) return;
    final user = ref.read(authLogicProvider).value;
    if (user == null) return;
    if (!ref.read(accessTierLogicProvider).tier.isPro) return;
    await _syncPending(user.uid);
  }

  Future<void> _syncPending(String uid) async {
    final local = ref.read(dreamLocalDatasourceProvider);
    final pending = local.getAll().where((e) => !e.isSynced).toList();
    if (pending.isEmpty) return;

    try {
      await ref.read(dreamRemoteDatasourceProvider).uploadBatch(uid, pending);
      for (final entry in pending) {
        await local.update(entry.copyWith(isSynced: true));
      }
      ref.invalidate(dreamHistoryLogicProvider);
    } catch (error) {
      debugPrint('Cloud sync failed ($error). Will retry on next trigger.');
    }
  }
}
