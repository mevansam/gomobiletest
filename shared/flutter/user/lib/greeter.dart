import 'foreign_instance_stub.dart';
import 'user_bindings.dart' as bindings;

import 'printer.dart';
import 'person.dart';

// Greeter stub to call native code from Dart

Greeter newGreeter(Printer printer) {
  return Greeter(printer);
}

class Greeter extends ForeignInstanceStub {
  void greet(Person person) {
    bindings.user.GreeterGreet(handle, person.handle);
  }

  Greeter(Printer printer)
      : super(bindings.user.GreeterNewGreeter(printer.handle),
            bindings.user.GreeterFreeGreeter);
}
