import 'package:flutter/material.dart';

import 'package:user/user.dart' as user;

void showError(BuildContext context, String message) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red,
    content: Text(message),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class ErrorHandler extends user.ErrorHandler {
  int testErrorCode = 0;
  String testErrorMessage = '';

  final BuildContext _context;

  ErrorHandler(this._context);

  @override
  void handleError(int code, String message) {
    testErrorCode = code;
    testErrorMessage = message;
    showError(_context, "Error: $code, $message");
  }

  void reset() {
    testErrorCode = 0;
    testErrorMessage = '';
  }
}
