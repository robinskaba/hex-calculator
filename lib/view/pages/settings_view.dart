import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_calculator/bloc/settings/settings_bloc.dart';
import 'package:hex_calculator/bloc/settings/settings_event.dart';
import 'package:hex_calculator/bloc/settings/settings_state.dart';
import 'package:hex_calculator/view/util/theme/dark_theme_notifier.dart';
import 'package:hex_calculator/view/util/toast/show_info_toast.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final TextEditingController fractionalPlacesController;

  @override
  void initState() {
    final currentValues = context.read<SettingsBloc>().state.currentValues;

    fractionalPlacesController = TextEditingController();
    fractionalPlacesController.text = currentValues["fractional_places"] ?? "3";

    super.initState();
  }

  @override
  void dispose() {
    fractionalPlacesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.error != null) {
          showInfoToast(context: context, message: state.error!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Provider.of<DarkThemeNotifier>(context).isDarkMode ? Icons.brightness_high : Icons.brightness_low,
                ),
                onPressed: () {
                  DarkThemeNotifier notifier = Provider.of<DarkThemeNotifier>(context, listen: false);
                  notifier.refreshDarkMode();
                  context.read<SettingsBloc>().add(
                    SettingsUpdatedEvent("is_dark_mode", (!notifier.isDarkMode).toString()),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Row(
                  children: [
                    Expanded(flex: 3, child: Text("Fractional places", style: Theme.of(context).textTheme.labelLarge)),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: fractionalPlacesController,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "0..20",
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondaryContainer,
                          counterText: "",
                          contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(SettingsUpdatedEvent("fractional_places", value));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
