import 'package:flutter/foundation.dart' show immutable;

@immutable
class SettingsState {
  final String? error;
  final Map<String, String> currentValues;

  const SettingsState(this.error, this.currentValues);
}