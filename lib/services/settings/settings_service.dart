import 'package:hex_calculator/model/settings/settings_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _shared = SettingsService._sharedInstance();
  factory SettingsService() => _shared;
  SettingsService._sharedInstance();

  static SharedPreferences? _prefs;

  void instantiate(SharedPreferences? prefs) {
    _prefs = prefs;
  }

  Future<void> setFractionalPlaces(int places) async {
    await _prefs?.setInt(SettingsKey.fractionalPlaces.key, places);
  }

  int getFractionalPlaces() {
    return _prefs?.getInt(SettingsKey.fractionalPlaces.key) ?? 2;
  }

  Future<void> setIsDarkMode(bool value) async {
    await _prefs?.setBool(SettingsKey.isDarkMode.key, value);
  }

  bool getIsDarkMode() {
    return _prefs?.getBool(SettingsKey.isDarkMode.key) ?? false;
  }
}
