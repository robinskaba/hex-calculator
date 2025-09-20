import 'package:bloc/bloc.dart';
import 'package:hex_calculator/model/settings/settings_keys.dart';
import 'package:hex_calculator/services/settings/settings_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

Map<String, String> _loadCurrentValues() {
  final service = SettingsService();
  Map<String, String> currentValues = {};

  for (var settingsKey in SettingsKey.values) {
    switch (settingsKey) {
      case SettingsKey.fractionalPlaces:
        currentValues[settingsKey.key] = service.getFractionalPlaces().toString();
        break;
      case SettingsKey.isDarkMode:
        currentValues[settingsKey.key] = service.getIsDarkMode().toString();
        break;
    }
  }

  return currentValues;
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(null, _loadCurrentValues())) {
    on<SettingsUpdatedEvent>((event, emit) {
      SettingsKey? settingsKey = SettingsKey.fromKey(event.key);
      SettingsService settingsService = SettingsService();
      String? error;
      switch (settingsKey) {
        case SettingsKey.fractionalPlaces:
          {
            int? places = int.tryParse(event.value);
            if (places != null && places >= 0 && places < 21) {
              settingsService.setFractionalPlaces(places);
            } else if (event.value != "") {
              error = "Fractional places must be between 0 and 20";
            }
          }
        case SettingsKey.isDarkMode:
          {
            bool isDarkMode = bool.tryParse(event.value) ?? false;
            settingsService.setIsDarkMode(isDarkMode);
          }
        default:
          {}
      }
      emit(SettingsState(error, _loadCurrentValues()));
    });
  }
}
