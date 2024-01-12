import 'package:flutter/material.dart';

import 'package:user/user.dart' as user;

class MessageDialog extends user.Printer {
  final String _title;

  final BuildContext _context;

  MessageDialog(this._title, this._context);

  @override
  void print(String s) {
    final AlertDialog dialog = AlertDialog(
      title: Text(_title),
      content: Text(s),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(_context, rootNavigator: true).pop(),
          child: const Text('DISMISS'),
        ),
      ],
    );

    showDialog<void>(context: _context, builder: (context) => dialog);
  }
}
