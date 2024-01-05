import 'package:user/user.dart' as user;

import 'package:go_mobile_tester/utility/message.dart';

class GreeterService {
  final MessageDialog _printer;

  GreeterService(this._printer);

  Future<void> greet(user.Person? person) async {
    if (person == null) {
      throw Exception('No person to greet');
    }
    var greeter = user.Greeter(_printer);
    greeter.greet(person);
  }
}
