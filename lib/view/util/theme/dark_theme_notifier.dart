import 'dart:developer';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeNotifier extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  DarkThemeNotifier(this.sharedPreferences);

  bool get isDarkMode => sharedPreferences?.getBool("isDarkMode") ?? false;

  void setDarkMode(bool val) {
    sharedPreferences?.setBool("isDarkMode", val);
    log(
      "SharedPreferences not null: ${sharedPreferences != null}, was setting to: $val, is: $isDarkMode",
    );
    notifyListeners();
  }
}
