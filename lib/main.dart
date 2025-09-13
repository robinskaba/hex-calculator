import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hex_calculator/controller/calculator/calc_bloc.dart';
import 'package:hex_calculator/controller/calculator/calc_state.dart';
import 'package:hex_calculator/view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonTheme = ButtonThemeData(buttonColor: Colors.grey, hoverColor: Colors.red);

    final appTheme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: Colors.blueGrey,
        error: Colors.red,
        onError: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(alignment: AlignmentGeometry.center),
      ),
      buttonTheme: buttonTheme,
    );

    return MaterialApp(
      title: 'Hex Calculator',
      theme: appTheme,
      home: BlocProvider(create: (context) => CalcBloc(), child: const HomeView()),
      debugShowCheckedModeBanner: false,
    );
  }
}
