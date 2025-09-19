enum SettingsKey {
  fractionalPlaces("fractional_places"),
  isDarkMode("is_dark_mode");

  final String key;

  const SettingsKey(this.key);

  static SettingsKey? fromKey(String otherKey) => SettingsKey.values.firstWhere((settings) => settings.key == otherKey);
}
