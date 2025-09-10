import 'package:hex_calculator/model/calculator/evaluate_expression.dart';
import 'package:test/test.dart';

void main() {
  test("Convert expression", () {
    String expression = "A7D+AD";
    String base10 = "2685+173";

    String converted = convertToBase10Expression(expression);
    expect(converted, base10);
  });
}