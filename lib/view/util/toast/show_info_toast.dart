import 'package:flutter/material.dart';
import "package:fluttertoast/fluttertoast.dart";

Future<void> showInfoToast({
  required BuildContext context,
  required String message,
}) async {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    textColor: Theme.of(context).colorScheme.onSecondaryContainer,
    fontSize: 16.0,
  );
}
