class CalculationException implements Exception {}

// can not convert a certain character to a hex character (is not 0-F)
class NotAHexDigitException extends CalculationException {}

// expression contains formatting errors
class InvalidExpressionException extends CalculationException {
  final String? message;
  InvalidExpressionException([this.message]);
  @override
  String toString() {
    return "InvalidExpressionException${message != null ? ": $message" : ""}";
  }
}

// hex number is not valid
class InvalidHexNumberException extends InvalidExpressionException {
  InvalidHexNumberException([super.message]);
}

// expression is "" or contains "()"
class EmptyBracketException extends InvalidExpressionException {
  EmptyBracketException([super.message]);
}

// missing number after an operator: "42+"
class PostOperatorNumberMissingException extends InvalidExpressionException {
  PostOperatorNumberMissingException([super.message]);
}

// safety
class FractionalPlacesShouldNotBeOver20Exception extends CalculationException {}
