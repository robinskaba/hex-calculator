import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _fractionalKey = "fractional_places";
  static const _isDarkModeKey = "is_dark_mode";

  static final SettingsService _shared = SettingsService._sharedInstance();
  factory SettingsService() => _shared;
  SettingsService._sharedInstance();

  static SharedPreferences? _prefs;

  void instantiate(SharedPreferences? prefs) {
    _prefs = prefs;
  }

  Future<void> setFractionalPlaces(int places) async {
    await _prefs?.setInt(_fractionalKey, places);
  }

  int getFractionalPlaces() {
    return _prefs?.getInt(_fractionalKey) ?? 2;
  }

  Future<void> setIsDarkMode(bool value) async {
    await _prefs?.setBool(_isDarkModeKey, value);
  }

  bool getIsDarkMode() {
    return _prefs?.getBool(_isDarkModeKey) ?? false;
  }
}
