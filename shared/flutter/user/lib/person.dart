import 'package:ffi/ffi.dart';
import 'package:ffi_helper/ffi_helper.dart';
import 'package:user/error.dart';

import 'user_bindings.dart' as bindings;

import 'identity.dart';

// Person stub to call native code from Dart

Person newPerson(Identity identity, ErrorHandler errorHandler) {
  return Person(identity, errorHandler);
}

class Person extends ForeignInstanceStub {
  String fullName() {
    final res = bindings.user.PersonFullName(handle);
    final fullName = res.cast<Utf8>().toDartString();
    malloc.free(res);
    return fullName;
  }

  String address() {
    final res = bindings.user.PersonAddress(handle);
    final address = res.cast<Utf8>().toDartString();
    malloc.free(res);
    return address;
  }

  String dob() {
    final res = bindings.user.PersonDOB(handle);
    final dob = res.cast<Utf8>().toDartString();
    malloc.free(res);
    return dob;
  }

  String age() {
    final res = bindings.user.PersonAge(handle);
    final age = res.cast<Utf8>().toDartString();
    malloc.free(res);
    return age;
  }

  Person(Identity identity, ErrorHandler errorHandler)
      : super(
            bindings.user.PersonNewPerson(identity.handle, errorHandler.handle),
            bindings.user.PersonFreePerson);
}
