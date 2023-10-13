import 'package:flutter/material.dart';

import 'package:user/user.dart' as user;

class AppState extends ChangeNotifier {
  String _username = '';

  String get name => _username;

  bool isLoggedIn() {
    return _username.isNotEmpty;
  }

  void login(String name) {
    _username = name;
    notifyListeners();
  }

  void logout(String name) {
    _username = '';
    notifyListeners();
  }
}

class TestIdentity extends user.Identity {
  @override
  String username() {
    return name;
  }

  final String name;

  TestIdentity(this.name) : super();
}

class TestPrinter extends user.Printer {
  @override
  void print(String s) {
    debugPrint("This just in: $s");
  }
}
