import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/hive/hive_registrar.g.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<String>('prefs');
  await Hive.openBox<DreamEntry>('dreams');
}
