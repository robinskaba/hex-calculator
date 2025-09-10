import "dart:developer" as devtools show log;
import 'dart:developer';
import 'package:hex_calculator/model/calculator/calculator_exceptions.dart';
import 'package:hex_calculator/model/calculator/hex_conversion.dart';

enum Operation { addition, subtraction, multiplication, division }

const Map<String, Operation> _operations = {
  "+": Operation.addition,
  "-": Operation.subtraction,
  "/": Operation.division,
  "*": Operation.multiplication,
};

bool _isHexCharacter(String character) {
  return hexNumbers[character] != null || character == ".";
}

bool _isOperator(String character) {
  return _operations[character] != null;
}

bool _isBracket(String character) {
  return character == "(" || character == ")";
}

num _performOperation(num initialValue, Operation? operation, num bufferValue) {
  operation = operation ?? Operation.addition;

  devtools.log(
    "Performing operation of $operation: $initialValue $operation $bufferValue",
  );
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

enum LoadingDirection { left, right }

String _loadBuffer(String expression, int origin, LoadingDirection direction) {
  int sign = direction == LoadingDirection.right ? 1 : -1;
  int i = origin != expression.length - 1 ? origin + sign : origin;

  String buffer = "";
  while (i >= 0 && i < expression.length) {
    String character = expression[i];
    if (!_isHexCharacter(character)) break;

    if (direction == LoadingDirection.right) {
      buffer += character;
    } else {
      buffer = character + buffer;
    }

    i += sign;
  }

  return buffer;
}

String convertToBase10Expression(String expression) {
  for (var i = 0; i < expression.length; i++) {
    String character = expression[i];
    bool isOperator = _isOperator(character);
    if (!isOperator && i != expression.length - 1) continue;

    print("before buffer");
    String buffer = _loadBuffer(expression, i, LoadingDirection.left);
    num base10Value = getBase10FromBase16(buffer);
    String base10ValueString = base10Value.toString();

    print("after convert");
    int rangeStart = i + 1 - buffer.length;
    int rangeEnd = i != expression.length - 1 ? i - 1 : i;

    expression = expression.replaceRange(rangeStart, rangeEnd, base10ValueString);
    int lengthOffset = buffer.length - base10ValueString.length;
    i -= lengthOffset + 1;

    print("Expression $expression, i: $i");
  }

  return expression;
}

// String evaluateExpression(String expression) {
//   num value = 0;

//   while (expression.contains("(")) {
//     String bracketsContent = expression.substring(
//       expression.indexOf("(") + 1,
//       expression.lastIndexOf(")"),
//     );

//     value += evaluateExpression(bracketsContent);
//     expression.replaceAll("($bracketsContent)", value.toString());
//   }

// }
