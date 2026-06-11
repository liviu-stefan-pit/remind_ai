// ignore_for_file: cast_nullable_to_non_nullable

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_ai/config/theme/theme_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_logic.g.dart';

@riverpod
class ThemeLogic extends _$ThemeLogic {
  @override
  ThemeUiModel build() {
    ThemeMode themeMode = ThemeMode.system;
    final Box<String> prefsBox = Hive.box<String>('prefs');
    final String mode =
        prefsBox.get('themeMode', defaultValue: ThemeMode.dark.toString())
            as String;
    switch (mode) {
      case 'ThemeMode.dark':
        themeMode = ThemeMode.dark;
      case 'ThemeMode.light':
        themeMode = ThemeMode.light;
      case 'ThemeMode.system':
        themeMode = ThemeMode.system;
    }
    return ThemeUiModel(themeMode: themeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await Hive.box<String>('prefs').put('themeMode', mode.toString());
  }

  void toggleTheme() {
    if (state.themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}
