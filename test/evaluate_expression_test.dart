import 'package:flutter/foundation.dart';
import 'package:hex_calculator/model/calculation_exceptions.dart';
import 'package:hex_calculator/model/evaluate_expression.dart';
import 'package:hex_calculator/model/hex_conversion.dart';
import 'package:test/test.dart';

@immutable
class TestSample {
  final String expression;
  final String expectedSolutionInBase16;
  final String expectedSolutionInBase10;
  final int? precision;

  const TestSample({
    required this.expression,
    required this.expectedSolutionInBase16,
    required this.expectedSolutionInBase10,
    this.precision,
  });

  @override
  String toString() {
    return "Test: Expecting that $expression=0x$expectedSolutionInBase16 ($expectedSolutionInBase10)";
  }
}

void main() {
  group("Evaluation tests", () {
    const testSamples = [
      TestSample(expression: "A+C", expectedSolutionInBase16: "16", expectedSolutionInBase10: "22"),
      TestSample(expression: "F+1", expectedSolutionInBase16: "10", expectedSolutionInBase10: "16"),
      TestSample(expression: "5-A", expectedSolutionInBase16: "-5", expectedSolutionInBase10: "-5"),
      TestSample(expression: "3*4", expectedSolutionInBase16: "C", expectedSolutionInBase10: "12"),
      TestSample(expression: "A/B", expectedSolutionInBase16: "0.E8B", expectedSolutionInBase10: "0.909", precision: 3),
      TestSample(expression: "7/2", expectedSolutionInBase16: "3.8", expectedSolutionInBase10: "3.5", precision: 2),
      TestSample(expression: "A+B-7*2", expectedSolutionInBase16: "7", expectedSolutionInBase10: "7"),
      TestSample(expression: "(A+B)*(C-2)", expectedSolutionInBase16: "D2", expectedSolutionInBase10: "210"),
      TestSample(
        expression: "(C/4+3)*(2+A)",
        expectedSolutionInBase16: "48",
        expectedSolutionInBase10: "72",
        precision: 4,
      ),
      TestSample(expression: "(F-5)*(2+(A/2))", expectedSolutionInBase16: "46", expectedSolutionInBase10: "70"),
      TestSample(
        expression: "1/3",
        expectedSolutionInBase16: "0.5555",
        expectedSolutionInBase10: "0.3333",
        precision: 4,
      ),
      TestSample(
        expression: "((A+B)/(C-3))+D",
        expectedSolutionInBase16: "F.55",
        expectedSolutionInBase10: "15.33",
        precision: 2,
      ),
    ];

    for (final sample in testSamples) {
      test(sample.toString(), () {
        String solutionInBase16 = evaluateExpression(
          expression: sample.expression,
          expressionType: ExpressionType.base16,
          returnType: ExpressionType.base16,
          fractionalPlaces: sample.precision ?? 2,
        );
        expect(solutionInBase16, equals(sample.expectedSolutionInBase16), reason: "Expected Base16 solution to match");

        String solutionInBase10 = evaluateExpression(
          expression: sample.expression,
          expressionType: ExpressionType.base16,
          returnType: ExpressionType.base10,
          fractionalPlaces: sample.precision ?? 2,
        );
        expect(solutionInBase10, equals(sample.expectedSolutionInBase10), reason: "Expected Base10 solution to match");
      });
    }
  });

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
  group("Detecting invalid expression", () {
    void basicEvaluation(String expression) => evaluateExpression(
      expression: expression,
      expressionType: ExpressionType.base16,
      returnType: ExpressionType.base16,
    );

    test("Throws on invalid bracket order", () {
      expect(() => basicEvaluation("7+)A+8-)+(3-1)"), throwsA(isA<InvalidExpressionException>()));
    });

    test("Throws on missing closing bracket", () {
      expect(() => basicEvaluation("(A+B"), throwsA(isA<InvalidExpressionException>()));
    });

    test("Throws on missing opening bracket", () {
      expect(() => basicEvaluation("A+B)"), throwsA(isA<InvalidExpressionException>()));
    });

    test("Throws on empty brackets", () {
      expect(() => basicEvaluation("A+()"), throwsA(isA<EmptyBracketException>()));
    });

    test("Throws on missing number after operator", () {
      expect(() => basicEvaluation("A+"), throwsA(isA<PostOperatorNumberMissingException>()));
    });

    test("Throws on consecutive operators", () {
      expect(() => basicEvaluation("A++B"), throwsA(isA<PostOperatorNumberMissingException>()));
    });
  });
}
