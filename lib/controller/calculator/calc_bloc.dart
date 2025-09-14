import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hex_calculator/controller/calculator/calc_event.dart';
import 'package:hex_calculator/controller/calculator/calc_state.dart';
import 'package:hex_calculator/model/calculator/evaluate_expression.dart';

class CalcBloc extends Bloc<CalcEvent, CalcState> {
  CalcBloc() : super(const CalcState()) {
    on<CalcExpressionChanged>((event, emit) {
      String expression = event.expression;
      log("Received expression changed event to $expression");

      try {
        int fractionPlaces = 5;

        String hexSolution = evaluateExpression(
          expression: expression,
          expressionType: ExpressionType.base16,
          returnType: ExpressionType.base16,
          fractionalPlaces: fractionPlaces,
        );
        String decimalSolution = evaluateExpression(
          expression: expression,
          expressionType: ExpressionType.base16,
          returnType: ExpressionType.base10,
          fractionalPlaces: fractionPlaces,
        );
        Solution solution = Solution(base16: hexSolution, base10: decimalSolution);
        emit(CalcState(solution: solution));
      } on Exception catch (_) { // TODO normal exception catching -> improve model detecting errors
        emit(const CalcState(solution: null));
      }
    });
  }
}
