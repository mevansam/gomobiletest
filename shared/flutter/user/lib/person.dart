import 'foreign_instance_stub.dart';
import 'user_bindings.dart' as bindings;

import 'identity.dart';

// Person stub to call native code from Dart

Person newPerson(Identity identity) {
  return Person(identity);
}

class Person extends ForeignInstanceStub {
  void age() {
    bindings.user.PersonAge(handle);
  }

  Person(Identity identity)
      : super(bindings.user.PersonNewPerson(identity.handle),
            bindings.user.PersonFreePerson);
}
