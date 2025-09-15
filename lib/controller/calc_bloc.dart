import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hex_calculator/controller/calc_event.dart';
import 'package:hex_calculator/controller/calc_state.dart';
import 'package:hex_calculator/model/evaluate_expression.dart';
import 'package:hex_calculator/model/calculation_exceptions.dart';
import 'package:hex_calculator/model/hex_conversion.dart';

class CalcBloc extends Bloc<CalcEvent, CalcState> {
  CalcBloc() : super(const CalcState()) {
    on<CalcExpressionChanged>((event, emit) {
      String expression = event.expression;
      log("Received expression changed event to $expression");

      try {
        int fractionPlaces = 5;

        String decimalSolution = evaluateExpression(
          expression: expression,
          expressionType: ExpressionType.base16,
          returnType: ExpressionType.base10,
          fractionalPlaces: fractionPlaces,
        );
        String hexSolution = getBase16FromBase10(num.parse(decimalSolution), fractionPlaces);
        Solution solution = Solution(base16: hexSolution, base10: decimalSolution);
        emit(CalcState(solution: solution));
      } on CalculationException catch (_) {
        emit(const CalcState(solution: null));
      }
    });
  }
}
