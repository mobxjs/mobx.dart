import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> loaded;

  PreferencesService() {
    loaded = _loadPreferences();
  }

  static const String _useDarkModeKey = 'useDarkMode';
  SharedPreferences _sharedPreferences;

  set useDarkMode(bool useDarkMode) {
    _sharedPreferences.setBool(_useDarkModeKey, useDarkMode);
  }

  bool get useDarkMode => _sharedPreferences.getBool(_useDarkModeKey) ?? false;

  Future<void> _loadPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
