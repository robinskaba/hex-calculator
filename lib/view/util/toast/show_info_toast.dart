import 'package:flutter/material.dart';
import "package:fluttertoast/fluttertoast.dart";

enum ToastPosition { top, bottom }

Future<void> showInfoToast({
  required BuildContext context,
  required String message,
  ToastPosition toastPosition = ToastPosition.bottom,
}) async {
  final gravity = toastPosition == ToastPosition.top ? ToastGravity.TOP : ToastGravity.BOTTOM;

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    textColor: Theme.of(context).colorScheme.primary,
    fontSize: 16.0,
  );
}
