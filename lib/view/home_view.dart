import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> symbols = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    '+',
    '-',
    '*',
    '/',
    '.',
    '(',
    ')',
    'C',
    '<',
  ];

  List<TextButton> buttons = [];

  @override
  void initState() {
    for (var symbol in symbols) {
      buttons.add(TextButton(onPressed: () {}, child: Text(symbol)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        "AB5D+85CCC-45.223*2",
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "=ABCD",
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child: GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: buttons,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
