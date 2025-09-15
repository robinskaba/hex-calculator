class Symbol {
  final String character;
  final String Function(String) updateExpression;
  const Symbol(this.character, this.updateExpression);
}

class WritingSymbol extends Symbol {
  WritingSymbol(String character)
    : super(character, (String expression) => expression + character);
}

final List<Symbol> keyboard = [
  WritingSymbol("("),
  WritingSymbol(")"),
  WritingSymbol("."),
  Symbol("AC", (_) => ""),
  Symbol("⌫", (String e) => e.length > 1 ? e.substring(0, e.length - 1) : ""),

  WritingSymbol("C"),
  WritingSymbol("D"),
  WritingSymbol("E"),
  WritingSymbol("F"),
  WritingSymbol("+"),

  WritingSymbol("8"),
  WritingSymbol("9"),
  WritingSymbol("A"),
  WritingSymbol("B"),
  WritingSymbol("-"),

  WritingSymbol("4"),
  WritingSymbol("5"),
  WritingSymbol("6"),
  WritingSymbol("7"),
  WritingSymbol("*"),

  WritingSymbol("0"),
  WritingSymbol("1"),
  WritingSymbol("2"),
  WritingSymbol("3"),
  WritingSymbol("/"),
];
