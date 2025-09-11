import 'dart:math';
import 'package:hex_calculator/model/calculator/calculator_exceptions.dart';

const Map<String, int> hexNumbers = {
  "0": 0,
  "1": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "A": 10,
  "B": 11,
  "C": 12,
  "D": 13,
  "E": 14,
  "F": 15,
};

int getIntFromHexCharacter(String character) {
  int? intValue = hexNumbers[character.toUpperCase()];
  if (intValue == null) throw InvalidHexCharacterException();
  return intValue;
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

String getBase16FromBase10(num base10Number) {
  String getSingleHexCharacter(num simpleNumber) {
    String hexCharacter = simpleNumber.toString();
    hexCharacter = hexCharacter.length == 1 ? hexCharacter : ["A", "B", "C", "D", "E", "F"][(hexCharacter as int) - 10];
    return hexCharacter;
  }

  String hexNumber = "";
  int wholePart = base10Number.floor();
  num decimalPart = base10Number - wholePart;

  int wholeDivision = wholePart;
  while (wholeDivision != 0) {
    int remainder = wholeDivision % 16;
    wholeDivision = (wholeDivision / 16).floor();

    String hexCharacter = getSingleHexCharacter(remainder);
    hexNumber = hexCharacter + hexNumber;
  }

  hexNumber = hexNumber != "" ? hexNumber : "0";

  if (base10Number == wholePart) return hexNumber;

  // decimal section
  hexNumber += ".";
  int precision = 0;
  num fraction = decimalPart;
  while (precision <= 21 && fraction != 0) {
    num multiplied = fraction * 16;
    int whole = multiplied.floor();
    String hexCharacter = getSingleHexCharacter(whole);
    hexNumber += hexCharacter;
    fraction = multiplied - whole;

    precision++;
  }

  return hexNumber;
}