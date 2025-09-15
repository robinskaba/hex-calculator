import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hex_calculator/controller/calc_bloc.dart';
import 'package:hex_calculator/controller/calc_event.dart';
import 'package:hex_calculator/controller/calc_state.dart';
import 'package:hex_calculator/view/config/keyboard.dart';
import 'package:hex_calculator/view/util/toast/show_info_toast.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(child: Spacer()),
                Expanded(
                  flex: 1,
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
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GridView.count(
                        crossAxisCount: 5,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: buttons,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (state.solution != null) {
                              expression = state.solution!.base16;
                            }

                            // demo
                            showInfoToast(context: context, message: "Testing a message");
                          });
                        },
                        child: Text("="),
                      ),
                    ],
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
