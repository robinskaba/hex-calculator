class CalculationException implements Exception {}

// can not convert a certain character to a hex character (is not 0-F)
class InvalidHexCharacterException implements CalculationException {}

// hex number is not valid 
class InvalidHexNumberException implements CalculationException {}

// expression contains formatting errors
class InvalidExpressionException implements CalculationException {}

// safety
class FractionalPlacesShouldNotBeOver20Exception implements CalculationException {}

// numbers above 15 can not be converted to a single hex digit
class CanNotConvertIntegerOver15ToHexCharacterException implements CalculationException {}

// missing number after an operator: "42+"
class PostOperatorNumberMissingException implements CalculationException {}

// expression is "" or contains "()"
class EmptyBracketException implements CalculationException {}
