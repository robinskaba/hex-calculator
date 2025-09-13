import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CalcEvent {
  const CalcEvent();
}

class CalcExpressionChanged extends CalcEvent {
  final String expression;
  const CalcExpressionChanged({required this.expression});
}

