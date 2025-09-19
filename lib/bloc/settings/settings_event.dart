import 'package:flutter/foundation.dart' show immutable;

@immutable
class SettingsEvent {
  const SettingsEvent();
}

class SettingsUpdatedEvent extends SettingsEvent {
  final String key;
  final String value;

  const SettingsUpdatedEvent(this.key, this.value);
}