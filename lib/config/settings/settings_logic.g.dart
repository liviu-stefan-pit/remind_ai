// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsLogic)
final settingsLogicProvider = SettingsLogicProvider._();

final class SettingsLogicProvider
    extends $NotifierProvider<SettingsLogic, SettingsState> {
  SettingsLogicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsLogicProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsLogicHash();

  @$internal
  @override
  SettingsLogic create() => SettingsLogic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsState>(value),
    );
  }
}

String _$settingsLogicHash() => r'c7a36a392d44ac9dd6cfeceacb6b06be7adf7c88';

abstract class _$SettingsLogic extends $Notifier<SettingsState> {
  SettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SettingsState, SettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsState, SettingsState>,
              SettingsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
