import 'package:decimal/decimal.dart';
import 'package:hex_calculator/model/calculation_exceptions.dart';

const _hexLetters = ["A", "B", "C", "D", "E", "F"];
const _scaleOnInfinitePrecision = 10;
int get infiniteFractionPrecision => _scaleOnInfinitePrecision;

Decimal _powDecimal(Decimal base, int exp) {
  return exp >= 0
      ? base.pow(exp).toDecimal(scaleOnInfinitePrecision: infiniteFractionPrecision)
      : (Decimal.one / base.pow(-exp).toDecimal(scaleOnInfinitePrecision: infiniteFractionPrecision)).toDecimal(
          scaleOnInfinitePrecision: infiniteFractionPrecision,
        );
}

bool isPartOfAHexNumber(String character) {
  return (character.length == 1 && int.tryParse(character) != null) ||
      _hexLetters.contains(character) ||
      character == ".";
}

int getIntFromHexCharacter(String character) {
  int? fromCharacter = int.tryParse(character);
  if (fromCharacter == null && !_hexLetters.contains(character)) {
    throw NotAHexDigitException();
  }
  return fromCharacter ?? 10 + _hexLetters.indexOf(character);
}

String getHexCharacterFromInt(num simpleNumber) {
  if (simpleNumber >= 16) throw NotAHexDigitException();
  String hexCharacter = simpleNumber < 10 ? simpleNumber.toString() : _hexLetters[(simpleNumber as int) - 10];
  return hexCharacter;
}

Decimal getBase10FromBase16(String base16Number) {
  Decimal total = Decimal.fromInt(0);

  final int indexOfDecimalDot = base16Number.indexOf(".");
  if (indexOfDecimalDot != base16Number.lastIndexOf(".")) {
    throw InvalidHexNumberException(); // two dots in a number is not a valid number
  }

  final bool hasDecimalPlaces = indexOfDecimalDot != -1;
  final int beforeDecimalPlaces = hasDecimalPlaces ? indexOfDecimalDot : base16Number.length;

  int power = beforeDecimalPlaces - 1;
  for (var i = 0; i < base16Number.length; i++) {
    final String base16Character = base16Number[i];
    if (base16Character == ".") continue;

    late final int base10Number;
    try {
      base10Number = getIntFromHexCharacter(base16Character);
    } on NotAHexDigitException {
      throw InvalidHexNumberException();
    }

    Decimal addition = Decimal.fromInt(base10Number) * _powDecimal(Decimal.fromInt(16), power);
    total += addition;

    power--;
  }

  return total;
}

String getBase16FromBase10(Decimal base10Number, int precision) {
  if (precision > 20) throw FractionalPlacesShouldNotBeOver20Exception();

  String sign = base10Number.sign == -1 ? "-" : "";
  base10Number = base10Number.abs();

  String hexNumber = "";
  Decimal wholePart = base10Number.floor();
  Decimal decimalPart = base10Number - wholePart;

  Decimal wholeDivision = wholePart;
  final Decimal decimal16 = Decimal.fromInt(16);
  while (wholeDivision != Decimal.zero) {
    bool isFinal = wholeDivision < decimal16;

    int remainder = int.parse(wholeDivision.remainder(decimal16).floor().toString());
    wholeDivision = (wholeDivision / decimal16).toDecimal(scaleOnInfinitePrecision: infiniteFractionPrecision);

    String hexCharacter = getHexCharacterFromInt(remainder);
    hexNumber = hexCharacter + hexNumber;

    if (isFinal) break;
  }

  hexNumber = hexNumber != "" ? hexNumber : "0";
  hexNumber = sign + hexNumber;

  if (base10Number == wholePart) return hexNumber;

  // decimal section
  hexNumber += ".";
  int decimalCounter = 0;
  Decimal fraction = decimalPart;
  while (decimalCounter < precision && fraction != Decimal.zero) {
    Decimal multiplied = fraction * decimal16;

    Decimal whole = multiplied.floor();
    String hexCharacter = getHexCharacterFromInt(int.parse(whole.toString()));
    hexNumber += hexCharacter;
    fraction = multiplied - whole;

    decimalCounter++;
  }

  return hexNumber;
}
