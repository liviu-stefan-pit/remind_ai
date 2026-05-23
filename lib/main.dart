import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:remind_ai/app.dart';
import 'package:remind_ai/hive/hive.dart';

Future<void> main() async {
  await bootstrap();
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runApp(const ProviderScope(child: RemindAiApp()));
}
