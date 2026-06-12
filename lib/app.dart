import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:remind_ai/config/settings/settings_logic.dart';
import 'package:remind_ai/config/theme/theme_logic.dart';
import 'package:remind_ai/config/theme/theme_ui_model.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/core/services/cloud_sync_service.dart';
import 'package:remind_ai/core/services/purchases_service.dart';
import 'package:remind_ai/design/theme/app_theme.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/features/profile/presentation/auth_logic.dart';
import 'package:remind_ai/router/app_router.dart';

class RemindAiApp extends ConsumerWidget {
  const RemindAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeUiModel currentTheme = ref.watch(themeLogicProvider);
    final SettingsState settings = ref.watch(settingsLogicProvider);
    final GoRouter router = ref.watch(appRouterProvider);

    // Keep the cross-cutting backend services alive for the whole app session:
    // auth drives entitlement + identity, purchases configures RevenueCat, and
    // sync backs up entries for signed-in Pro users.
    ref.watch(authLogicProvider);
    ref.watch(purchasesServiceProvider);
    ref.watch(syncLogicProvider);

    final auroraDark = AuroraTheme.dark.copyWith(
      reduceMotion: settings.reduceMotion,
      ambientLevel: settings.ambientLevel,
    );
    final auroraLight = AuroraTheme.light.copyWith(
      reduceMotion: settings.reduceMotion,
      ambientLevel: settings.ambientLevel,
    );

    return MaterialApp.router(
      routerConfig: router,
      title: AppStrings.appName,
      theme: AppTheme.light(aurora: auroraLight),
      darkTheme: AppTheme.dark(aurora: auroraDark),
      themeMode: currentTheme.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
