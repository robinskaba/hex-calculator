import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CalcState {
  const CalcState();
}

class CalcProcessingState extends CalcState {
  final String? solution;
  const CalcProcessingState({this.solution});
}