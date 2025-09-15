import 'package:flutter/foundation.dart' show immutable;

@immutable
class Solution {
  final String base16;
  final String base10;

  const Solution({
    required this.base16,
    required this.base10
  });
}

class CalcState {
  final Solution? solution;

  const CalcState({this.solution});

  @override
  operator ==(covariant CalcState other) => solution == other.solution;
  @override
  int get hashCode => solution.hashCode;
}
