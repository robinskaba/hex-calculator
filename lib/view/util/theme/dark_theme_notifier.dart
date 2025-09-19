import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:hex_calculator/services/settings/settings_service.dart';

class DarkThemeNotifier extends ChangeNotifier {
  DarkThemeNotifier();

  bool get isDarkMode => SettingsService().getIsDarkMode();

  void refreshDarkMode() {
    notifyListeners();
  }
}
