import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' show restartable;
import 'package:hex_calculator/controller/calc_event.dart';
import 'package:hex_calculator/controller/calc_state.dart';
import 'package:hex_calculator/model/evaluate_expression.dart';
import 'package:hex_calculator/model/calculation_exceptions.dart';
import 'package:hex_calculator/model/hex_conversion.dart';

Future<Solution> _getSolution(String expression, int fractionalPlaces) {
  String decimalSolution = evaluateExpression(
    expression: expression,
    expressionType: ExpressionType.base16,
    returnType: ExpressionType.base10,
    fractionalPlaces: fractionalPlaces,
  );
  String hexSolution = getBase16FromBase10(num.parse(decimalSolution), fractionalPlaces);
  Solution solution = Solution(base16: hexSolution, base10: decimalSolution);

  return Future.value(solution);
}

class CalcBloc extends Bloc<CalcEvent, CalcState> {
  CalcBloc() : super(const CalcState()) {
    on<CalcExpressionChanged>((event, emit) async {
      String expression = event.expression;

      try {
        int fractionalPlaces = 5;
        Solution solution = await _getSolution(expression, fractionalPlaces);
        emit(CalcState(solution: solution));
      } catch (e) {
        String? reason;
        if (e is InvalidExpressionException) {
          reason = "Not a valid expression.";
        } else if (e is FractionalPlacesShouldNotBeOver20Exception) {
          reason = "Can not display more than 20 fractional places.";
        } else if (e is CalculationException) {
          reason = "A calculation problem occurred.";
        } else {
          reason = "An unknown exception occurred.";
        }
        emit(CalcState(solution: null, issue: reason));
      }
    }, transformer: restartable()
    );
  }
}
