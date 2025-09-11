import 'dart:developer';

import 'package:hex_calculator/model/calculator/hex_conversion.dart';

enum Operation { addition, subtraction, multiplication, division }

const Map<String, Operation> _operations = {
  "+": Operation.addition,
  "-": Operation.subtraction,
  "/": Operation.division,
  "*": Operation.multiplication,
};

num _performOperation(num initialValue, Operation? operation, num bufferValue) {
  operation = operation ?? Operation.addition;

  switch (operation) {
    case Operation.addition:
      return initialValue + bufferValue;
    case Operation.subtraction:
      return initialValue - bufferValue;
    case Operation.multiplication:
      return initialValue * bufferValue;
    case Operation.division:
      return initialValue / bufferValue;
  }
}

enum _LoadingDirection { left, right }

String _loadBuffer(String expression, int origin, _LoadingDirection direction) {
  int sign = direction == _LoadingDirection.right ? 1 : -1;

  bool isOriginHex = isPartOfAHexNumber(expression[origin]);
  int i = isOriginHex ? origin : origin + sign;

  String buffer = "";
  while (i >= 0 && i < expression.length) {
    String character = expression[i];

    if (!isPartOfAHexNumber(character)) {
      log("Character '$character' isn't part of a hex number -> breaking");
      break;
    }

    if (direction == _LoadingDirection.right) {
      buffer += character;
    } else {
      buffer = character + buffer;
    }

    i += sign;
  }

  log("Buffer returning as <$buffer>");
  return buffer;
}

String _convertToBase10Expression(String expression) {
  for (var i = 0; i < expression.length; i++) {
    String character = expression[i];
    if (isPartOfAHexNumber(character) && i != expression.length - 1) continue;

    String buffer = _loadBuffer(expression, i, _LoadingDirection.left);
    if (buffer == "") continue;

    num base10Value = getBase10FromBase16(buffer);
    String base10ValueString = base10Value.toString();

    int rangeStart = isPartOfAHexNumber(character)
        ? i - buffer.length + 1
        : i - buffer.length;
    int rangeEnd = isPartOfAHexNumber(character) ? i + 1 : i;

    expression = expression.replaceRange(rangeStart, rangeEnd, base10ValueString);
    int lengthOffset = buffer.length - base10ValueString.length;
    i -= lengthOffset;
  }

  return expression;
}

num _evaluateBase10Expression(String expression) {
  num value = 0;

  while (expression.contains("(")) {
    String bracketsContent = expression.substring(
      expression.indexOf("(") + 1,
      expression.lastIndexOf(")"),
    );

    num bracketsValue = _evaluateBase10Expression(bracketsContent);
    expression = expression.replaceAll("($bracketsContent)", bracketsValue.toString());
  }

  const prioritizedOperators = ["*", "/", "+", "-"];
  for (String operatorSymbol in prioritizedOperators) {
    while (expression.contains(operatorSymbol)) {
      int operatorIndex = expression.indexOf(operatorSymbol);
      if (operatorIndex == 0 && operatorSymbol == "-") {
        if (expression.lastIndexOf(operatorSymbol) == operatorIndex) {
          break; // only one "-" remains
        }
      }

      log("Loading buffer in expression '$expression' from $operatorIndex");
      String leftBuffer = _loadBuffer(expression, operatorIndex, _LoadingDirection.left);
      String rightBuffer = _loadBuffer(
        expression,
        operatorIndex,
        _LoadingDirection.right,
      );
      log("Buffers loaded as L<$leftBuffer> R<$rightBuffer>");

      num totalValue = _performOperation(
        num.parse(leftBuffer),
        _operations[operatorSymbol],
        num.parse(rightBuffer),
      );

      log("Before replacing expression '$expression'");
      expression = expression.replaceFirst(
        "$leftBuffer$operatorSymbol$rightBuffer",
        totalValue.toString(),
      );
      log(
        "Operation: '$operatorSymbol' was performed on $leftBuffer and $rightBuffer (after replacing expression '$expression')",
      );
    }
  }

  value = num.parse(expression);

  return value;
}

enum ExpressionType { base10, base16 }

String evaluateExpression({
  required String expression,
  required ExpressionType expressionType,
  required ExpressionType returnType,
  int precision = 21,
}) {
  String base10Expression = expressionType == ExpressionType.base10
      ? expression
      : _convertToBase10Expression(expression);
  num base10Result = _evaluateBase10Expression(base10Expression);

  switch (returnType) {
    case ExpressionType.base10:
      return base10Result.toStringAsPrecision(precision);
    case ExpressionType.base16:
      return getBase16FromBase10(base10Result, precision);
  }
}

void test() {
  String expression = "30.75-28.75";
  int operatorIndex = expression.indexOf("-");
  String leftBuffer = _loadBuffer(expression, operatorIndex, _LoadingDirection.left);
  String rightBuffer = _loadBuffer(expression, operatorIndex, _LoadingDirection.right);
  log("Test: L<$leftBuffer> R<$rightBuffer>");
}
