import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:ffi_helper/ffi_helper.dart';

import 'user_bindings_generated.dart' as user;

// Printer skeleton to invoke Dart
// code when called from  native code

abstract class Printer extends ForeignInterfaceSkel<user.printer_t> {
  void print(String s);

  Printer() : super();

  @override
  ffi.Pointer<user.printer_t> create() {
    ffi.Pointer<user.printer_t> handle = calloc<user.printer_t>();
    handle.ref.context = handle.address;
    handle.ref.print = ffi.Pointer.fromFunction(_print);
    return handle;
  }

  // Interface func skeletons for calling
  // Dart code from foreign code

  static void _print(int context, ffi.Pointer<ffi.Char> s) {
    final Printer printer =
        ForeignInterfaceSkel.lookupInstance<Printer>(context);

    printer.print(s.cast<Utf8>().toDartString());
  }
}
