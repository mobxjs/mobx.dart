import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/settings/preferences_service.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStore with _$SettingsStore;

abstract class _SettingsStore with Store {
  _SettingsStore(this._preferencesService) {
    useDarkMode = _preferencesService.useDarkMode;
  }

  final PreferencesService _preferencesService;

  @observable
  bool useDarkMode = false;

  @action
  Future<void> setDarkMode({@required bool value}) async {
    _preferencesService.useDarkMode = value;
    useDarkMode = value;
  }
}
