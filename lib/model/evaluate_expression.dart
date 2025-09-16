import 'package:decimal/decimal.dart';
import 'package:hex_calculator/model/calculation_exceptions.dart';
import 'package:hex_calculator/model/hex_conversion.dart';

enum _Operation { addition, subtraction, multiplication, division }

const Map<String, _Operation> _operations = {
  "+": _Operation.addition,
  "-": _Operation.subtraction,
  "/": _Operation.division,
  "*": _Operation.multiplication,
};

Decimal _performOperation(Decimal initialValue, _Operation? operation, Decimal bufferValue) {
  operation = operation ?? _Operation.addition;

  switch (operation) {
    case _Operation.addition:
      return initialValue + bufferValue;
    case _Operation.subtraction:
      return initialValue - bufferValue;
    case _Operation.multiplication:
      return initialValue * bufferValue;
    case _Operation.division:
      return (initialValue / bufferValue).toDecimal(scaleOnInfinitePrecision: infiniteFractionPrecision);
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

    if ((buffer != "" || character != "-") && !isPartOfAHexNumber(character)) break;

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

    Decimal base10Value = getBase10FromBase16(buffer);
    String base10ValueString = base10Value.toString();

    int rangeStart = isPartOfAHexNumber(character) ? i - buffer.length + 1 : i - buffer.length;
    int rangeEnd = isPartOfAHexNumber(character) ? i + 1 : i;

    expression = expression.replaceRange(rangeStart, rangeEnd, base10ValueString);
    int lengthOffset = buffer.length - base10ValueString.length;
    i -= lengthOffset;
  }

  return expression;
}

Decimal _evaluateBase10Expression(String expression) {
  while (expression.contains("(")) {
    if (!expression.contains(")")) throw InvalidExpressionException();

    // finding the closing bracket that corresponds to the first opening bracket in the expression
    int outerOpeningBracketIndex = expression.indexOf("(");
    int? outerClosingBracketIndex;
    int innerOpenBrackets = 0;
    for (var i = outerOpeningBracketIndex + 1; i <= expression.lastIndexOf(")"); i++) {
      String char = expression[i];
      if (char == ")") {
        if (innerOpenBrackets == 0) {
          outerClosingBracketIndex = i;
          break;
        } else {
          innerOpenBrackets--;
        }
      } else if (char == "(") {
        innerOpenBrackets++;
      }
    }

    if (outerClosingBracketIndex == null) throw InvalidExpressionException("Failed to reach a closing outer bracket");

    if (expression.contains(")") && (outerClosingBracketIndex < outerOpeningBracketIndex)) {
      throw InvalidExpressionException("Invalid bracket placement in expression: '$expression'");
    }

    String bracketsContent = expression.substring(outerOpeningBracketIndex + 1, outerClosingBracketIndex);

    Decimal bracketsValue = _evaluateBase10Expression(bracketsContent);
    expression = expression.replaceAll("($bracketsContent)", bracketsValue.toString());
  }

  if (expression.contains(")")) throw InvalidExpressionException("Expression kept a closing bracket");

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
      String rightBuffer = _loadBuffer(expression, operatorIndex, _LoadingDirection.right);

      if (rightBuffer == "") {
        throw PostOperatorNumberMissingException("Missing a number after '$operatorSymbol' in '$expression'");
      }

      Decimal totalValue = _performOperation(
        Decimal.parse(leftBuffer),
        _operations[operatorSymbol],
        Decimal.parse(rightBuffer),
      );

      expression = expression.replaceFirst("$leftBuffer$operatorSymbol$rightBuffer", totalValue.toString());
    }
  }

  Decimal? parsedValue = Decimal.tryParse(expression);
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
  expression = expression.replaceAll(" ", "");

  String base10Expression = expressionType == ExpressionType.base10
      ? expression
      : _convertToBase10Expression(expression);
  Decimal base10Result = _evaluateBase10Expression(base10Expression);

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
