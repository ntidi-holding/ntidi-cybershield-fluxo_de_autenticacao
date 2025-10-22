import 'package:flutter/material.dart';

showSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
      backgroundColor: Color(0xFF35a576),
    ),
  );
}

showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

showInfo(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("TODO: Not implemented yet!"),
      duration: Duration(milliseconds: 1000),
    ),
  );
}