import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hex_calculator/controller/calc_bloc.dart';
import 'package:hex_calculator/service/settings/settings_service.dart';
import 'package:hex_calculator/view/calculator_view.dart';
import 'package:hex_calculator/view/config/routes.dart';
import 'package:hex_calculator/view/config/themes.dart';
import 'package:hex_calculator/view/settings_view.dart';
import 'package:hex_calculator/view/util/theme/dark_theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
            {
              SharedPreferences? prefs = asyncSnapshot.data;
              SettingsService().instantiate(prefs);
              
              return ChangeNotifierProvider<DarkThemeNotifier>.value(
                value: DarkThemeNotifier(asyncSnapshot.data),
                child: HexCalculatorApp(),
              );
            }
          default:
            return Container(color: Colors.black);
        }
      },
    );
  }
}

class HexCalculatorApp extends StatelessWidget {
  const HexCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hex Calculator',
      themeMode: ThemeMode.system,
      // darkTheme: setDarkTheme, // seems to force dark mode
      theme: Provider.of<DarkThemeNotifier>(context).isDarkMode ? setDarkTheme : setLightTheme,
      home: BlocProvider(create: (context) => CalcBloc(), child: const CalculatorView()),
      // home: BlocProvider(create: (context) => CalcBloc(), child: const SettingsView()),
      debugShowCheckedModeBanner: false,
      routes: {settingsRoute: (context) => SettingsView()},
    );
  }
}
