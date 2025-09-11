import 'dart:developer';

import 'package:flutter/material.dart';
import "dart:developer" as devtools show log;
import 'package:hex_calculator/model/calculator/evaluate_expression.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String base10Expression = "(10.5+(30.75-28.75)*2/4)";
    // Calculation:
    // (30.75 - 28.75) = 2.0
    // 2.0 * 2 = 4.0
    // 4.0 / 4 = 1.0
    // 10.5 + 1.0 = 11.5
    // So, base10Expression = 11.5

    String base16Expression = "(A.5+(1E.C-1C.C)*2/4)";
    // Hexadecimal to decimal:
    // A.5 = 10.5
    // 1E.C = 30.75
    // 1C.C = 28.75
    // (1E.C - 1C.C) = (30.75 - 28.75) = 2.0
    // 2.0 * 2 = 4.0
    // 4.0 / 4 = 1.0
    // 10.5 + 1.0 = 11.5
    // So, base16Expression = 11.5 (decimal) or B.8 (hexadecimal)

    String base10ExpressionResultInBase10 = evaluateExpression(
      expression: base10Expression,
      expressionType: ExpressionType.base10,
      returnType: ExpressionType.base10,
    );
    String base10ExpressionResultInBase16 = evaluateExpression(
      expression: base10Expression,
      expressionType: ExpressionType.base10,
      returnType: ExpressionType.base16,
    );
    String base16ExpressionResultInBase10 = evaluateExpression(
      expression: base16Expression,
      expressionType: ExpressionType.base16,
      returnType: ExpressionType.base10,
    );
    String base16ExpressionResultInBase16 = evaluateExpression(
      expression: base16Expression,
      expressionType: ExpressionType.base16,
      returnType: ExpressionType.base16,
    );

    devtools.log(
      "$base10Expression=$base10ExpressionResultInBase10 (0x$base10ExpressionResultInBase16)",
    );

    // TODO base16 expression has rounding errors that make a significant difference in the final result
    devtools.log(
      "$base16Expression=0x$base16ExpressionResultInBase16 ($base16ExpressionResultInBase10)",
    );

    // String test = evaluateExpression(
    //   expression: "(30.75-28.75)",
    //   expressionType: ExpressionType.base10,
    //   returnType: ExpressionType.base10,
    // );
    // devtools.log("Final: $test");

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
