import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

// ForeignInterfaceSkel is an abstract class that
// is implemented by dart abstract classes that
// will provide the skeleton for stups of foreign
// interfaces. It provides convenience methods for
// managing cross-references with the foreign
// interface stups as well as boiler plate code
// for dart ffi bookeeping.
abstract class ForeignInterfaceSkel<FOREIGN_T extends ffi.Struct> {
  // The handle to this skeleton passed to the
  // foreign code.
  ffi.Pointer<FOREIGN_T> get handle => _handle;

  // Looks up the skeleton instance when foreign code
  // calls dart code to invoke a function provide by
  // the skeleton implementation.
  static DART_T lookupInstance<DART_T>(int context) {
    return ForeignInterfaceSkel._handlers[context]! as DART_T;
  }

  // The implementing stub should implement this function.
  // It should create and initialize the ffi struct that
  // will be used as the handle for the foreign code to
  // invoke the dart code.
  ffi.Pointer<FOREIGN_T> create();

  late final ffi.Pointer<FOREIGN_T> _handle;
  static final Map<int, ForeignInterfaceSkel> _handlers =
      <int, ForeignInterfaceSkel>{};

  ForeignInterfaceSkel() {
    _handle = create();
    ForeignInterfaceSkel._handlers[_handle.address] = this;
  }

  static final Finalizer<ForeignInterfaceSkel> _finalizer =
      Finalizer((fiskel) => fiskel.finalize());
  void finalize() {
    ForeignInterfaceSkel._handlers.remove(_handle.address);
    calloc.free(_handle);
    _finalizer.detach(this);
  }
}
