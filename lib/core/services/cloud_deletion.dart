import 'package:flutter/foundation.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/features/dreams/data/datasources/dream_remote_datasource.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Best-effort deletion of cloud copies for signed-in Google users.
/// Failures are logged; local deletion should still proceed.
Future<void> deleteCloudDreams(Ref ref, {String? entryId}) async {
  if (!ref.read(firebaseReadyProvider)) return;
  final user = ref.read(authLogicProvider).value;
  if (user == null) return;

  try {
    final remote = ref.read(dreamRemoteDatasourceProvider);
    if (entryId != null) {
      await remote.deleteEntry(user.uid, entryId);
    } else {
      await remote.deleteAll(user.uid);
    }
  } on Object catch (error) {
    debugPrint('Cloud deletion failed ($error). Local data was still removed.');
  }
}
