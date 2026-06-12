import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_ai/core/services/cloud_deletion.dart';
import 'package:remind_ai/design/theme/theme_extension.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_logic.g.dart';

@riverpod
class SettingsLogic extends _$SettingsLogic {
  static const _reduceMotionKey = 'reduceMotion';
  static const _ambientKey = 'ambientLevel';
  static const _onboardingSeenKey = 'onboardingSeen';
  static const _ageConfirmedKey = 'ageConfirmed';

  Box<String> get _prefs => Hive.box<String>(kPrefsBox);

  @override
  SettingsState build() {
    final reduceMotion = _prefs.get(_reduceMotionKey) == 'true';
    final ambientName = _prefs.get(_ambientKey, defaultValue: 'calm')!;
    final onboardingSeen = _prefs.get(_onboardingSeenKey) == 'true';
    final ageConfirmed = _prefs.get(_ageConfirmedKey) == 'true';

    return SettingsState(
      reduceMotion: reduceMotion,
      ambientLevel: _parseAmbient(ambientName),
      onboardingSeen: onboardingSeen,
      ageConfirmed: ageConfirmed,
    );
  }

  AmbientLevel _parseAmbient(String name) => switch (name) {
        'off' => AmbientLevel.off,
        'lively' => AmbientLevel.lively,
        _ => AmbientLevel.calm,
      };

  Future<void> setReduceMotion(bool value) async {
    state = state.copyWith(reduceMotion: value);
    await _prefs.put(_reduceMotionKey, value.toString());
  }

  Future<void> setAmbientLevel(AmbientLevel level) async {
    state = state.copyWith(ambientLevel: level);
    await _prefs.put(_ambientKey, level.name);
  }

  Future<void> markOnboardingSeen() async {
    state = state.copyWith(onboardingSeen: true);
    await _prefs.put(_onboardingSeenKey, 'true');
  }

  Future<void> setAgeConfirmed(bool value) async {
    state = state.copyWith(ageConfirmed: value);
    await _prefs.put(_ageConfirmedKey, value.toString());
  }

  Future<void> clearHistory() async {
    await deleteCloudDreams(ref);
    await Hive.box<DreamEntry>(kDreamsBox).clear();
  }
}

@immutable
class SettingsState {
  const SettingsState({
    required this.reduceMotion,
    required this.ambientLevel,
    required this.onboardingSeen,
    required this.ageConfirmed,
  });

  final bool reduceMotion;
  final AmbientLevel ambientLevel;
  final bool onboardingSeen;
  final bool ageConfirmed;

  SettingsState copyWith({
    bool? reduceMotion,
    AmbientLevel? ambientLevel,
    bool? onboardingSeen,
    bool? ageConfirmed,
  }) =>
      SettingsState(
        reduceMotion: reduceMotion ?? this.reduceMotion,
        ambientLevel: ambientLevel ?? this.ambientLevel,
        onboardingSeen: onboardingSeen ?? this.onboardingSeen,
        ageConfirmed: ageConfirmed ?? this.ageConfirmed,
      );
}
