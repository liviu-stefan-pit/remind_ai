import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/hive/hive_registrar.g.dart';

const _kHiveKeyName = 'hive_aes_key_v1';
const kPrefsBox = 'prefs';
const kDreamsBox = 'dreams';

/// Current on-disk schema version. Bump this whenever a stored model changes
/// in a way that needs data migration, then add a case to [_runMigrations].
///
/// Hive CE migration rules for this codebase:
///   - Only ever APPEND fields (use the next free index in
///     `hive_adapters.g.yaml`); never reorder or reuse field indexes.
///   - Never reorder `DreamStyle` enum values (byte index is persisted).
///   - Never reuse a `typeId`.
const _kSchemaVersion = 1;
const _kSchemaVersionKey = 'schemaVersion';

const _kSecureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

/// Initializes Hive and opens the encrypted boxes the app relies on.
///
/// Box open failures (corruption, a rotated/missing encryption key, an
/// interrupted write) are recovered automatically by deleting the affected
/// box from disk and reopening it empty, so a single bad box can never
/// white-screen the whole app at startup. Recovered data is unrecoverable by
/// design — the boxes are AES-encrypted and a lost key makes the old bytes
/// permanently unreadable.
Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapters();

  final cipher = HiveAesCipher(await _getOrCreateHiveKey());

  final prefs = await _openBoxSafely<String>(kPrefsBox, cipher);
  await _openBoxSafely<DreamEntry>(kDreamsBox, cipher);

  await _runMigrations(prefs);
}

/// Applies any pending schema migrations and records the current version.
Future<void> _runMigrations(Box<String> prefs) async {
  final stored = int.tryParse(prefs.get(_kSchemaVersionKey) ?? '') ?? 0;
  if (stored == _kSchemaVersion) return;

  // Migration steps run in order, e.g.:
  //   if (stored < 2) { ...migrate v1 -> v2... }
  // No migrations are needed yet (v0/v1 are compatible).

  await prefs.put(_kSchemaVersionKey, _kSchemaVersion.toString());
}

/// Opens [name]; on any failure, deletes the box from disk and retries once
/// with a fresh empty box. Rethrows if even the empty reopen fails.
Future<Box<T>> _openBoxSafely<T>(String name, HiveAesCipher cipher) async {
  try {
    return await Hive.openBox<T>(name, encryptionCipher: cipher);
  } catch (error, stackTrace) {
    debugPrint('Hive: failed to open "$name" ($error). Resetting box.');
    if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
    try {
      await Hive.deleteBoxFromDisk(name);
    } catch (_) {
      // Best effort: if the file is locked we still attempt a clean reopen.
    }
    return Hive.openBox<T>(name, encryptionCipher: cipher);
  }
}

Future<List<int>> _getOrCreateHiveKey() async {
  final existing = await _kSecureStorage.read(key: _kHiveKeyName);
  if (existing != null) {
    return base64Decode(existing);
  }
  final key = _generateAes256Key();
  await _kSecureStorage.write(
    key: _kHiveKeyName,
    value: base64Encode(key),
  );
  return key;
}

List<int> _generateAes256Key() {
  final random = Random.secure();
  return List<int>.generate(32, (_) => random.nextInt(256));
}
