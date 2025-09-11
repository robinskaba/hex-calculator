import 'dart:developer';

import 'package:flutter/material.dart';
import "dart:developer" as devtools show log;

import 'package:hex_calculator/model/calculator/evaluate_expression.dart';
import 'package:hex_calculator/model/calculator/hex_conversion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // String expression = "8AB/B78";
    // num value = evaluateBase16Expression(expression);
    // devtools.log("$expression=$value");

    num decimalNumber = 10.625;
    String hex = getBase16FromBase10(decimalNumber);
    devtools.log("$decimalNumber=$hex");

    return MaterialApp(
      title: 'Hex Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
