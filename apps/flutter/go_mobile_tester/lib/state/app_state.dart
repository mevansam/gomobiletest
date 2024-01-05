import 'package:flutter/material.dart';

import 'package:user/user.dart' as user;

class AppState extends ChangeNotifier {
  bool _waiting = false;
  bool get isWaiting => _waiting;

  String _username = '';
  String get username => _username;

  user.Person? _person;
  bool get isLoggedIn => _person != null;
  user.Person? get loggedInPerson => _person;

  bool _greeted = false;
  bool get greeted => _greeted;

  bool _error = false;
  bool get isError => _error;
  String _errorMessage = '';

  void endWaiting() {
    _waiting = false;
    notifyListeners();
  }

  void loggingInUser(String username) {
    _waiting = true;
    _username = username;
    resetError();
    notifyListeners();
  }

  void userLoggedIn(user.Person person) {
    _waiting = false;
    _person = person;
    notifyListeners();
  }

  void userLoginFailed(String message) {
    _waiting = false;
    _username = '';
    setError(message);
    notifyListeners();
  }

  void logout() {
    _username = '';
    _person = null;
    _greeted = false;
    notifyListeners();
  }

  void greetingShown() {
    _greeted = true;
  }

  void setError(String message) {
    _error = true;
    _errorMessage = message;
  }

  void resetError() {
    _error = false;
    _errorMessage = '';
  }

  String getErrorMessage() {
    var msg = _errorMessage;
    _waiting = false;
    _error = false;
    _errorMessage = '';
    return msg;
  }
}

class TestPrinter extends user.Printer {
  @override
  void print(String s) {
    debugPrint("This just in: $s");
  }
}
