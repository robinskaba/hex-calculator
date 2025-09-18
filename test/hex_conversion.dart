import 'package:hex_calculator/model/calculation_exceptions.dart';
import 'package:hex_calculator/model/hex_conversion.dart';
import 'package:test/test.dart';

void main() {
  group("Hex conversion checks", () {
    test("Won't convert a non-hex digit", () {
      expect(() => getIntFromHexCharacter("Z"), throwsA(isA<NotAHexDigitException>()));
    });

    test("Won't convert to a non-hex digit", () {
      expect(() => getHexCharacterFromInt(17), throwsA(isA<NotAHexDigitException>()));
    });

    test("Won't convert an invalid format hex number", () {
      expect(() => getBase10FromBase16("ASDZ"), throwsA(isA<InvalidHexNumberException>()));
      expect(() => getBase10FromBase16("AD.Z"), throwsA(isA<InvalidHexNumberException>()));
      expect(() => getBase10FromBase16("A.A.F"), throwsA(isA<InvalidHexNumberException>()));
      expect(() => getBase10FromBase16("A#F"), throwsA(isA<InvalidHexNumberException>()));
    });
  });
}