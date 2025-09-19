import 'package:bloc/bloc.dart';
import 'package:hex_calculator/model/settings/settings_keys.dart';
import 'package:hex_calculator/services/settings/settings_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(null)) {
    on<SettingsUpdatedEvent>((event, emit) {
      SettingsKey? settingsKey = SettingsKey.fromKey(event.key);
      SettingsService settingsService = SettingsService();
      String? error;
      switch (settingsKey) {
        case SettingsKey.fractionalPlaces: {
          int? places = int.tryParse(event.value);
          if (places != null && places >= 0 && places < 21) {
            settingsService.setFractionalPlaces(places);
          } else {
            error = "Fractional places must be between 0 and 20";
          }
        } 
        case SettingsKey.isDarkMode: {
          bool isDarkMode = bool.tryParse(event.value) ?? false;
          settingsService.setIsDarkMode(isDarkMode);
        }
        default: {}
      } 
      emit(SettingsState(error));
    });
  }
}
