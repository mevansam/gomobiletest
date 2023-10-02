import 'dart:ffi' as ffi;

import 'async_runner.dart';

// ForeignInstanceStub is an abstract class that
// is implemented by stubs for foreign classes.
// It provides convenience methods for managing
// cross-references with instances created in the
// foreign language environment as well as boiler
// plate code for dart ffi bookeeping.
abstract class ForeignInstanceStub {
  // The handle to the foreign instance.
  ffi.Pointer<ffi.Void> get handle => _handle;

  // The async runner used to execute function
  // stups asynchronously in an isolate.
  final asyncRunner = AsyncRunner();

  // The handle to the foreign instance used
  // to associate the instance to execute
  // foreign functions  against.
  late final ffi.Pointer<ffi.Void> _handle;

  // Pointer to the foreign function that
  // frees the foreign instance.
  late final ForeignFinalizer _foreignFinalizer;

  ForeignInstanceStub(this._handle, this._foreignFinalizer) {
    _finalizer.attach(this, this, detach: this);
  }

  static final Finalizer<ForeignInstanceStub> _finalizer =
      Finalizer((fistub) => fistub.finalize());
  void finalize() {
    asyncRunner.finalize();
    _foreignFinalizer(_handle);
    _finalizer.detach(this);
  }
}

typedef ForeignFinalizer = void Function(ffi.Pointer<ffi.Void>);
