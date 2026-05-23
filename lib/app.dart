import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:remind_ai/config/theme/theme_logic.dart';
import 'package:remind_ai/config/theme/theme_ui_model.dart';
import 'package:remind_ai/constants/app_strings.dart';
import 'package:remind_ai/router/app_router.dart';

class RemindAiApp extends ConsumerWidget {
  const RemindAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeUiModel currentTheme = ref.watch(themeLogicProvider);
    final GoRouter router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: AppStrings.appName,
      theme: FlexThemeData.light(
        scheme: FlexScheme.indigo,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        swapLegacyOnMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.indigo,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        swapLegacyOnMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      themeMode: currentTheme.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
