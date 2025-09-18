import 'package:flutter/material.dart';
import 'package:hex_calculator/service/settings/settings_service.dart';
import 'package:hex_calculator/view/util/theme/dark_theme_notifier.dart';
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
    fractionalPlacesController = TextEditingController();
    fractionalPlacesController.text = SettingsService().getFractionalPlaces().toString();

    super.initState();
  }

  @override
  void dispose() {
    fractionalPlacesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Provider.of<DarkThemeNotifier>(context).isDarkMode ? Icons.brightness_high : Icons.brightness_low,
            ),
            onPressed: () {
              bool setDarkMode = Provider.of<DarkThemeNotifier>(context, listen: false).isDarkMode ? false : true;
              Provider.of<DarkThemeNotifier>(context, listen: false).setDarkMode(setDarkMode);
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                    ),
                    onChanged: (value) async {
                      int? places = int.tryParse(value);
                      if (places != null && places >= 0 && places < 21) {
                        await SettingsService().setFractionalPlaces(places);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
