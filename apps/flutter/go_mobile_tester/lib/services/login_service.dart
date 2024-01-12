import 'package:user/user.dart' as user;
import 'package:ffi_helper/ffi_helper.dart';

import 'package:go_mobile_tester/utility/error.dart';
import 'package:go_mobile_tester/state/app_state.dart';

class LoginService {
  final AppState _appState;
  final ErrorHandler _errorHandler;

  LoginService(this._appState, this._errorHandler);

  Future<void> login(String username) async {
    _appState.loggingInUser(username);
    await Future.delayed(const Duration(seconds: 2));

    try {
      var identity = users[username];
      if (identity == null) {
        throw Exception('Login failed');
      }
      try {
        var person = user.Person(identity, _errorHandler);
        _appState.userLoggedIn(person);
      } on InstanceCreateError {
        throw Exception('Login failed');
      } catch (e) {
        throw Exception(e.toString());
      }
    } catch (e) {
      _appState.userLoginFailed(e.toString());
      rethrow;
    }
  }
}

class LoggedInIdentity extends user.Identity {
  final String _userid;
  final String _username;
  final String _avatar;

  LoggedInIdentity(this._userid, this._username, this._avatar);

  @override
  String userid() {
    return _userid;
  }

  @override
  String username() {
    return _username;
  }

  @override
  String avatar() {
    return _avatar;
  }
}

Map<String, LoggedInIdentity> users = {
  'anika': LoggedInIdentity('001', 'anika', 'assets/images/avatar1.png'),
  'cece': LoggedInIdentity('002', 'cece', 'assets/images/avatar2.png'),
  'kazi': LoggedInIdentity('003', 'kazi', 'assets/images/avatar3.png'),
  'jdoe': LoggedInIdentity('999', 'jdoe', 'assets/images/avatar999.png'),
};
