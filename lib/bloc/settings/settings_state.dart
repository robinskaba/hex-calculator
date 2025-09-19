import 'package:flutter/foundation.dart' show immutable;

@immutable
class SettingsState {
  final String? error;
  const SettingsState(this.error);
}