import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hex_calculator/bloc/calc/calc_bloc.dart';
import 'package:hex_calculator/bloc/calc/calc_event.dart';
import 'package:hex_calculator/bloc/calc/calc_state.dart';
import 'package:hex_calculator/view/config/keyboard.dart';
import 'package:hex_calculator/view/config/routes.dart';
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
    const double keyboardButtonSpacing = 5;

    return BlocBuilder<CalcBloc, CalcState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(settingsRoute).then((_) {
                    // recalculate solution on settings updated
                    if (!context.mounted) return;
                    context.read<CalcBloc>().add(CalcExpressionChanged(expression: expression));
                  });
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 12,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              expression,
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "0x${state.solution?.base16 ?? '...'}",
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "0b${state.solution?.base10 ?? '...'}",
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: keyboardButtonSpacing,
                    children: [
                      GridView.count(
                        crossAxisCount: 5,
                        mainAxisSpacing: keyboardButtonSpacing,
                        crossAxisSpacing: keyboardButtonSpacing,
                        padding: EdgeInsets.all(0), // grid view has default padding
                        childAspectRatio: 1,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: buttons,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (state.solution != null) {
                              expression = state.solution!.base16;
                            } else {
                              showInfoToast(context: context, message: state.issue!);
                            }
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
