import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'user_bindings.dart' as bindings;

import 'identity.dart';

// Person stub to call native code from Dart

Person newPerson(Identity identity) {
  return Person(identity);
}

class Person {
  void age() {
    bindings.user.PersonAge(handle);
  }

  late final ffi.Pointer<ffi.Void> handle;

  static final Finalizer<Person> _finalizer =
      Finalizer((person) => person.finalize());

  Person(Identity identity) {
    _finalizer.attach(this, this, detach: this);
    handle = bindings.user.PersonNewPerson(identity.handle);
  }

  void finalize() {
    bindings.user.PersonFreePerson(handle);
    _finalizer.detach(this);
  }
}
