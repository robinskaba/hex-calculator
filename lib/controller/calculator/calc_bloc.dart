import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hex_calculator/controller/calculator/calc_event.dart';
import 'package:hex_calculator/controller/calculator/calc_state.dart';
import 'package:hex_calculator/model/calculator/calculation_exceptions.dart';
import 'package:hex_calculator/model/calculator/evaluate_expression.dart';

class CalcBloc extends Bloc<CalcEvent, CalcState> {
  CalcBloc() : super(const CalcProcessingState()) {
    on<CalcExpressionChanged>((event, emit) {
      String expression = event.expression;
      log("Received expression changed event to $expression");

      try {
        String hexSolution = evaluateExpression(expression: expression, expressionType: ExpressionType.base16, returnType: ExpressionType.base16);
        log("Calculated solution to be: $hexSolution");
        emit(CalcProcessingState(solution: hexSolution));
      } on CalculationException catch (e) {
        log("Solution had problems.. ($e)");
        emit(const CalcProcessingState());
      }
    });
  }
}