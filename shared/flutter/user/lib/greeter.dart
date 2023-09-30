import 'dart:ffi' as ffi;

import 'user_bindings.dart' as bindings;

import 'printer.dart';
import 'person.dart';

// Greeter stub to call native code from Dart

Greeter newGreeter(Printer printer) {
  return Greeter(printer);
}

class Greeter {
  void greet(Person person) {
    bindings.user.GreeterGreet(handle, person.handle);
  }

  late final ffi.Pointer<ffi.Void> handle;
  final Printer _printer;

  static final Finalizer<Greeter> _finalizer =
      Finalizer((greeter) => greeter.finalize());

  Greeter(this._printer) {
    _finalizer.attach(this, this, detach: this);
    handle = bindings.user.GreeterNewGreeter(_printer.handle);
  }

  void finalize() {
    bindings.user.GreeterFreeGreeter(handle);
    _finalizer.detach(this);
  }
}
