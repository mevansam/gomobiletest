import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'user_bindings_generated.dart' as user;

// Printer skeleton to invoke Dart
// code when called from  native code

abstract class Printer {
  void print(String s);

  final ffi.Pointer<user.printer_t> handle = calloc<user.printer_t>();
  static final Map<int, Printer> _handlers = <int, Printer>{};

  Printer() {
    handle.ref.context = handle.address;
    handle.ref.printSomething = ffi.Pointer.fromFunction(_print);
    Printer._handlers[handle.address] = this;
  }

  static final Finalizer<Printer> _finalizer =
      Finalizer((printer) => printer.finalize());
  void finalize() {
    Printer._handlers.remove(handle.address);
    calloc.free(handle);
    _finalizer.detach(this);
  }

  // Interface func skeletons from foreign code to Dart code

  static void _print(int context, ffi.Pointer<ffi.Char> s) {
    String str = s.cast<Utf8>().toDartString();

    final Printer printer = _handlers[context]!;
    printer.print(str);
  }
}
