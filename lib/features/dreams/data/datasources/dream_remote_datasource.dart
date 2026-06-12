import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dream_remote_datasource.g.dart';

@Riverpod(keepAlive: true)
DreamRemoteDatasource dreamRemoteDatasource(Ref ref) {
  return DreamRemoteDatasource(FirebaseFirestore.instance);
}

/// Writes dream entries to `users/{uid}/dreams/{entryId}` in Firestore using
/// batched writes (chunked at the 500-op batch limit). One-way upload only.
class DreamRemoteDatasource {
  const DreamRemoteDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  static const _batchLimit = 500;

  Future<void> uploadBatch(String uid, List<DreamEntry> entries) async {
    if (entries.isEmpty) return;
    final dreams = _firestore.collection('users').doc(uid).collection('dreams');

    for (var i = 0; i < entries.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final entry in entries.skip(i).take(_batchLimit)) {
        batch.set(dreams.doc(entry.id), {
          ...entry.copyWith(isSynced: true).toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }
  }
}
