import 'package:flutter/material.dart';

mixin ErrorDialog {
  void showErrorDialog(BuildContext context, {String message}) {
    showDialog<Null>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("An error ocurred"),
              content: message == null
                  ? const Text("Something went wrong")
                  : Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Okay"))
              ],
            ));
  }
}
