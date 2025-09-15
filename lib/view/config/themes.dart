import 'package:flutter/material.dart';

final ThemeData setLightTheme = _buildLightTheme();
final ThemeData setDarkTheme = _buildDarkTheme();

AppBarTheme _appBarThemeFrom(ColorScheme scheme) =>
    AppBarTheme(backgroundColor: scheme.surface, foregroundColor: scheme.primary);

TextButtonThemeData _textButtonThemeFrom(ColorScheme scheme) => TextButtonThemeData(
  style: TextButton.styleFrom(
    backgroundColor: scheme.secondary,
    foregroundColor: scheme.onSecondary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  ),
);

ThemeData _buildLightTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: const Color.fromARGB(255, 206, 206, 206),
    onSecondary: const Color.fromARGB(255, 0, 0, 0),
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  return ThemeData(
    colorScheme: colorScheme,
    appBarTheme: _appBarThemeFrom(colorScheme),
    textButtonTheme: _textButtonThemeFrom(colorScheme),
  );
}

ThemeData _buildDarkTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: const Color.fromARGB(255, 110, 110, 110),
    onSecondary: const Color.fromARGB(255, 255, 255, 255),
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.black,
    onSurface: Colors.white,
  );

  return ThemeData(
    colorScheme: colorScheme,
    appBarTheme: _appBarThemeFrom(colorScheme),
    textButtonTheme: _textButtonThemeFrom(colorScheme),
  );
}
