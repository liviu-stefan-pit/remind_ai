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

  CollectionReference<Map<String, dynamic>> _dreams(String uid) =>
      _firestore.collection('users').doc(uid).collection('dreams');

  Future<void> uploadBatch(String uid, List<DreamEntry> entries) async {
    if (entries.isEmpty) return;
    final dreams = _dreams(uid);

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

  Future<void> deleteEntry(String uid, String entryId) async {
    await _dreams(uid).doc(entryId).delete();
  }

  Future<void> deleteAll(String uid) async {
    final snap = await _dreams(uid).get();
    if (snap.docs.isEmpty) return;

    for (var i = 0; i < snap.docs.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final doc in snap.docs.skip(i).take(_batchLimit)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }
}
