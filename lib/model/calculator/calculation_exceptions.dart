class CalculationException implements Exception {}

class InvalidHexCharacterException implements CalculationException {}

class InvalidHexNumberException implements CalculationException {}

class InvalidExpressionException implements CalculationException {}

class PrecisionShouldNotBeOver20Exception implements CalculationException {}

class CanNotConvertIntegerOver15ToHexCharacterException implements CalculationException {}
