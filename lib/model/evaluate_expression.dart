import 'package:hex_calculator/model/calculation_exceptions.dart';
import 'package:hex_calculator/model/hex_conversion.dart';

enum _Operation { addition, subtraction, multiplication, division }

const Map<String, _Operation> _operations = {
  "+": _Operation.addition,
  "-": _Operation.subtraction,
  "/": _Operation.division,
  "*": _Operation.multiplication,
};

num _performOperation(num initialValue, _Operation? operation, num bufferValue) {
  operation = operation ?? _Operation.addition;

  switch (operation) {
    case _Operation.addition:
      return initialValue + bufferValue;
    case _Operation.subtraction:
      return initialValue - bufferValue;
    case _Operation.multiplication:
      return initialValue * bufferValue;
    case _Operation.division:
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
      break;
    }

    if (direction == _LoadingDirection.right) {
      buffer += character;
    } else {
      buffer = character + buffer;
    }

    i += sign;
  }

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
  while (expression.contains("(")) {
    if (!expression.contains(")")) throw InvalidExpressionException();
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

      String leftBuffer = _loadBuffer(expression, operatorIndex, _LoadingDirection.left);
      String rightBuffer = _loadBuffer(
        expression,
        operatorIndex,
        _LoadingDirection.right,
      );

      if (rightBuffer == "") throw PostOperatorNumberMissingException();

      num totalValue = _performOperation(
        num.parse(leftBuffer),
        _operations[operatorSymbol],
        num.parse(rightBuffer),
      );

      expression = expression.replaceFirst(
        "$leftBuffer$operatorSymbol$rightBuffer",
        totalValue.toString(),
      );
    }
  }

  num? parsedValue = num.tryParse(expression);
  if (parsedValue == null) throw EmptyBracketException();

  return parsedValue;
}

enum ExpressionType { base10, base16 }

String evaluateExpression({
  required String expression,
  required ExpressionType expressionType,
  required ExpressionType returnType,
  int fractionalPlaces = 20,
}) {
  String base10Expression = expressionType == ExpressionType.base10
      ? expression
      : _convertToBase10Expression(expression);
  num base10Result = _evaluateBase10Expression(base10Expression);

  switch (returnType) {
    case ExpressionType.base10:
      String result = base10Result.toStringAsFixed(fractionalPlaces);
      if (result.contains('.')) {
        result = result.replaceFirst(RegExp(r'\.?0*$'), '');
      }
      return result;
    case ExpressionType.base16:
      return getBase16FromBase10(base10Result, fractionalPlaces);
  }
}
