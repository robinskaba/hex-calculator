class CalculationException implements Exception {}

// can not convert a certain character to a hex character (is not 0-F)
class NotAHexDigitException implements CalculationException {}

// expression contains formatting errors
class InvalidExpressionException implements CalculationException {}

// hex number is not valid
class InvalidHexNumberException implements InvalidExpressionException {}

// expression is "" or contains "()"
class EmptyBracketException implements InvalidExpressionException {}

// missing number after an operator: "42+"
class PostOperatorNumberMissingException implements InvalidExpressionException {}

// safety
class FractionalPlacesShouldNotBeOver20Exception implements CalculationException {}
