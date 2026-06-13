import 'package:hive_ce/hive.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/hive/hive.dart';

/// Wipes the on-device dream journal. Used when auth is required but the user
/// is signed out so stale Hive data cannot be read from a cached old build.
Future<void> clearLocalDreams() async {
  if (!Hive.isBoxOpen(kDreamsBox)) return;
  await Hive.box<DreamEntry>(kDreamsBox).clear();
}
