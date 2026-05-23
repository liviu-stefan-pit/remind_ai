import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_logic.g.dart';

@riverpod
class SettingsLogic extends _$SettingsLogic {
  static const _reduceMotionKey = 'reduceMotion';
  static const _ambientKey = 'ambientLevel';
  static const _onboardingSeenKey = 'onboardingSeen';

  Box<String> get _prefs => Hive.box<String>('prefs');

  @override
  SettingsState build() {
    final reduceMotion = _prefs.get(_reduceMotionKey) == 'true';
    final ambientName = _prefs.get(_ambientKey, defaultValue: 'calm')!;
    final onboardingSeen = _prefs.get(_onboardingSeenKey) == 'true';

    return SettingsState(
      reduceMotion: reduceMotion,
      ambientLevel: _parseAmbient(ambientName),
      onboardingSeen: onboardingSeen,
    );
  }

  AmbientLevel _parseAmbient(String name) => switch (name) {
        'off' => AmbientLevel.off,
        'lively' => AmbientLevel.lively,
        _ => AmbientLevel.calm,
      };

  void setReduceMotion(bool value) {
    _prefs.put(_reduceMotionKey, value.toString());
    state = state.copyWith(reduceMotion: value);
  }

  void setAmbientLevel(AmbientLevel level) {
    _prefs.put(_ambientKey, level.name);
    state = state.copyWith(ambientLevel: level);
  }

  void markOnboardingSeen() {
    _prefs.put(_onboardingSeenKey, 'true');
    state = state.copyWith(onboardingSeen: true);
  }

  void clearHistory() {
    Hive.box<DreamEntry>('dreams').clear();
  }
}

@immutable
class SettingsState {
  const SettingsState({
    required this.reduceMotion,
    required this.ambientLevel,
    required this.onboardingSeen,
  });

  final bool reduceMotion;
  final AmbientLevel ambientLevel;
  final bool onboardingSeen;

  SettingsState copyWith({
    bool? reduceMotion,
    AmbientLevel? ambientLevel,
    bool? onboardingSeen,
  }) =>
      SettingsState(
        reduceMotion: reduceMotion ?? this.reduceMotion,
        ambientLevel: ambientLevel ?? this.ambientLevel,
        onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      );
}
