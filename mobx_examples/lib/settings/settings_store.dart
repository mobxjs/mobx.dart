import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/settings/preferences_service.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStore with _$SettingsStore;

abstract class _SettingsStore with Store {
  _SettingsStore(this._preferencesService) {
    _setup();
  }

  PreferencesService _preferencesService;

  @observable
  bool useDarkMode = false;

  @action
  Future<void> setDarkMode({@required bool value}) async {
    await _preferencesService.loaded;
    _preferencesService.useDarkMode = value;
    useDarkMode = value;
  }

  Future<void> _setup() async {
    await _preferencesService.loaded;
    useDarkMode = _preferencesService.useDarkMode;
  }
}
