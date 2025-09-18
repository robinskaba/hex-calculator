import 'dart:developer';

import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final TextEditingController fractionalPlacesController;

  @override
  void initState() {
    fractionalPlacesController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fractionalPlacesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: Text("Fractional places", style: Theme.of(context).textTheme.labelLarge)),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: fractionalPlacesController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "0..20",
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondaryContainer,
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                    ),
                    onChanged: (value) {
                      log("Submitted: $value");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
