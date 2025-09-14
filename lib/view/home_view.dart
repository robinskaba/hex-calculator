import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hex_calculator/controller/calculator/calc_bloc.dart';
import 'package:hex_calculator/controller/calculator/calc_event.dart';
import 'package:hex_calculator/controller/calculator/calc_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

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
  Symbol("C", (_) => ""),
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

class _HomeViewState extends State<HomeView> {
  List<TextButton> buttons = [];

  String expression = "";

  @override
  void initState() {
    for (var symbol in keyboard) {
      buttons.add(
        TextButton(
          onPressed: () {
            setState(() {
              expression = symbol.updateExpression(expression);
              context.read<CalcBloc>().add(CalcExpressionChanged(expression: expression));
            });
          },
          child: Text(symbol.character),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalcBloc, CalcState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Hex Calculator")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            expression,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: 12),
                          Text(
                            state.solution?.base16 ?? "...",
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            state.solution?.base10 ?? "...",
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 8,
                  child: GridView.count(
                    crossAxisCount: 5,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: buttons,
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (state.solution != null) {
                          expression = state.solution!.base16;
                        }
                      });
                    },
                    child: Text("="),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
