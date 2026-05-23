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
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: currentTheme.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0B0A1C),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF13122B),
    surfaceContainer: Color(0xFF1C1A38),
    surfaceContainerLow: Color(0xFF17162F),
    surfaceContainerHighest: Color(0xFF252345),
    primary: Color(0xFFC4B5FD),
    primaryContainer: Color(0xFF3D3060),
    onPrimary: Color(0xFF1A0A3C),
    onPrimaryContainer: Color(0xFFE2D9FF),
    secondary: Color(0xFF89D8D3),
    secondaryContainer: Color(0xFF1C3D3C),
    onSecondary: Color(0xFF0A2423),
    onSecondaryContainer: Color(0xFFB2E8E5),
    tertiary: Color(0xFFE891C0),
    onSurface: Color(0xFFE8E0F5),
    onSurfaceVariant: Color(0xFFA69FBF),
    outline: Color(0xFF4A4568),
    outlineVariant: Color(0xFF2E2A50),
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF2A0A0A),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: Color(0xFFE8E0F5),
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF1C1A38),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    elevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1C1A38),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2E2A50)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2E2A50)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFC4B5FD), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(color: Color(0xFF6B6485)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF252345),
    contentTextStyle: TextStyle(color: Color(0xFFE8E0F5)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1C1A38),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFF2E2A50)),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
);

final _lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFF7C5CDD),
  textTheme: GoogleFonts.interTextTheme(),
);
