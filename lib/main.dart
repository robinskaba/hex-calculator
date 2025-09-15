import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hex_calculator/controller/calc_bloc.dart';
import 'package:hex_calculator/view/calculator_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = true;

    final ColorScheme colorSchemeLight = ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 178, 178, 178),
      onSecondary: const Color.fromARGB(255, 0, 0, 0),
      error: Colors.red,
      onError: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    );

    final ColorScheme colorSchemeDark = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: colorSchemeLight.secondary,
      onSecondary: Colors.white,
      error: colorSchemeLight.error,
      onError: colorSchemeLight.onError,
      surface: Colors.black,
      onSurface: Colors.white,
    );

    final colorScheme = isLight ? colorSchemeLight : colorSchemeDark;
    final textButtonTheme = TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: colorScheme.secondary.withAlpha(100),
        foregroundColor: colorScheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );

    final appTheme = ThemeData(
      colorScheme: colorScheme,
      textButtonTheme: textButtonTheme,
    );

    return MaterialApp(
      title: 'Hex Calculator',
      theme: appTheme,
      home: BlocProvider(create: (context) => CalcBloc(), child: const CalculatorView()),
      debugShowCheckedModeBanner: false,
    );
  }
}
