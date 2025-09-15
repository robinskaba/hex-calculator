import 'dart:math';
import 'package:hex_calculator/model/calculation_exceptions.dart';

const _hexLetters = ["A", "B", "C", "D", "E", "F"];

bool isPartOfAHexNumber(String character) {
  return (character.length == 1 && int.tryParse(character) != null) ||
      _hexLetters.contains(character) ||
      character == ".";
}

int getIntFromHexCharacter(String character) {
  int? fromCharacter = int.tryParse(character);
  if (fromCharacter == null && !_hexLetters.contains(character)) {
    throw InvalidHexCharacterException();
  }
  return fromCharacter ?? 10 + _hexLetters.indexOf(character);
}

String getHexCharacterFromInt(num simpleNumber) {
  if (simpleNumber >= 16) throw CanNotConvertIntegerOver15ToHexCharacterException();
  String hexCharacter = simpleNumber < 10
      ? simpleNumber.toString()
      : _hexLetters[(simpleNumber as int) - 10];
  return hexCharacter;
}

num getBase10FromBase16(String base16Number) {
  num total = 0;

  final int indexOfDecimalDot = base16Number.indexOf(".");
  if (indexOfDecimalDot != base16Number.lastIndexOf(".")) {
    throw InvalidHexNumberException(); // two dots in a number is not a valid number
  }

  final bool hasDecimalPlaces = indexOfDecimalDot != -1;
  final int beforeDecimalPlaces = hasDecimalPlaces
      ? indexOfDecimalDot
      : base16Number.length;

  int power = beforeDecimalPlaces - 1;
  for (var i = 0; i < base16Number.length; i++) {
    final String base16Character = base16Number[i];
    if (base16Character == ".") continue;

    late final int base10Number;
    try {
      base10Number = getIntFromHexCharacter(base16Character);
    } on InvalidHexCharacterException {
      throw InvalidHexNumberException();
    }

    num addition = base10Number * pow(16, power);
    total += addition;

    power--;
  }

  return total;
}

String getBase16FromBase10(num base10Number, int precision) {
  if (precision > 20) throw FractionalPlacesShouldNotBeOver20Exception();

  String sign = base10Number < 0 ? "-" : "";
  base10Number = base10Number.abs();

  String hexNumber = "";
  int wholePart = base10Number.floor();
  num decimalPart = base10Number - wholePart;

  int wholeDivision = wholePart;
  while (wholeDivision != 0) {
    bool isFinal = wholeDivision < 16;

    int remainder = wholeDivision % 16;
    wholeDivision = (wholeDivision / 16).floor();

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
  num fraction = decimalPart;
  while (decimalCounter < precision && fraction != 0) {
    num multiplied = fraction * 16;
    int whole = multiplied.floor();
    String hexCharacter = getHexCharacterFromInt(whole);
    hexNumber += hexCharacter;
    fraction = multiplied - whole;

    decimalCounter++;
  }

  return hexNumber;
}
