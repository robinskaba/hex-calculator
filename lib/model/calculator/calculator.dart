import "dart:developer" as devtools show log;
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
  return hexNumbers[character] != null;
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

/// Evaluates an expression that only has addition or subtraction.
num _evaluateSimpleExpression(String expression) {
  if (expression.contains("*") || expression.contains("/")) {
    throw SimpleExpressionIsNotSimpleException();
  }

  num value = 0;

  String loadingBuffer = "";
  Operation? operationForBuffer;

  for (var i = 0; i < expression.length; i++) {
    String character = expression[i];

    if (_isHexCharacter(character) || _isOperator(character)) {
      bool isOperator = _isOperator(character);
      if (!isOperator) {
        loadingBuffer += character;
      }

      if (isOperator || i == expression.length - 1) {
        // set value to the performed operation (setting because multiplication and division requires knowing the value)
        num bufferValue = getBase10FromBase16(loadingBuffer);
        value = _performOperation(value, operationForBuffer, bufferValue);
        loadingBuffer = "";
        operationForBuffer = _operations[character];
      }
    }
  }

  return value;
}

// String simplifyExpression(String expression) {
//   int openingBracketIndex = expression.indexOf("(");
//   if (openingBracketIndex == -1) return expression;

//   int closingBracketIndex = expression.lastIndexOf(")");
//   if (closingBracketIndex == -1) throw InvalidExpressionException();

//   String bracketsContent = expression.substring(openingBracketIndex + 1, closingBracketIndex);
//   String simplifiedExpression = expression.replaceFirst("($bracketsContent)", bracketsContent); // basically just removing the brackets this is retarded

//   return simplifyExpression(simplifiedExpression);
// }

String encapsulatePriorityOperations(String expression) {
  int? firstArgumentStartingIndex;
  int? operatorIndex;

  for (var i = 0; i < expression.length; i++) {
    String character = expression[i];
    bool isPriorityOperator = character == "*" || character == "/";
    bool isAtEnd = i == expression.length - 1;

    if (_isOperator(character) || isAtEnd) {
      if (operatorIndex != null) {
        // Got to the operator after the second argument of the priority expression
        String priorityExpression = expression.substring(firstArgumentStartingIndex!, i);
        expression = expression.replaceFirst(priorityExpression, "($priorityExpression)");
      } else if (isPriorityOperator) {
        operatorIndex = i;
      }
    }

    if (_isHexCharacter(character)) {
      firstArgumentStartingIndex ??= i;
    }
  }

  return expression;
}

num evaluateExpression(String expression) {
  num value = 0;

  String loadingBuffer = "";
  Operation? operationForBuffer;

  for (var i = 0; i < expression.length; i++) {
    String character = expression[i];
    devtools.log(
      "Evaluating index $i, character: $character, value so far: $value, loadingBuffer: <$loadingBuffer>, operation for buffer: $operationForBuffer",
    );

    if (_isHexCharacter(character) || _isOperator(character)) {
      bool isOperator = _isOperator(character);
      if (!isOperator) {
        loadingBuffer += character;
      }

      if (isOperator || i == expression.length - 1) {
        // set value to the performed operation (setting because multiplication and division requires knowing the value)
        num bufferValue = getBase10FromBase16(loadingBuffer);
        value = _performOperation(value, operationForBuffer, bufferValue);
        loadingBuffer = "";
        operationForBuffer = _operations[character];
      }
    } else if (_isBracket(character)) {
      if (character == ")") continue; // skipping over ) signs cause they have no meaning

      // recursively calculating the insides of the brackets contents
      int openingBracketIndex = i;
      int closingBracketIndex = expression.lastIndexOf(")");

      if (openingBracketIndex == expression.length - 1) {
        throw InvalidExpressionException(); // nothing follows the bracket
      }
      if (closingBracketIndex == -1) {
        throw InvalidExpressionException(); // must have a closing bracket if an opening bracket is present
      }
      if (loadingBuffer != "") {
        throw InvalidExpressionException(); // there should not be any number infront of the bracket like 56(..
      }

      String expressionInBrackets = expression.substring(
        openingBracketIndex + 1,
        closingBracketIndex,
      );
      num valueOfExpressionInBrackets = evaluateExpression(expressionInBrackets);
      value = _performOperation(value, operationForBuffer, valueOfExpressionInBrackets);
      i = closingBracketIndex; // skipping over everything inside the brackets
    }
  }

  return value;
}
