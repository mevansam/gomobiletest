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
  // stubs asynchronously in an isolate.
  final asyncRunner = AsyncRunner();

  // The handle to the foreign instance used
  // to associate the instance to execute
  // foreign functions  against.
  late final ffi.Pointer<ffi.Void> _handle;

  // Pointer to the foreign function that
  // frees the foreign instance.
  late final void Function(ffi.Pointer<ffi.Void>) _foreignFinalizer;

  static final Finalizer<_FinalizeWrapper> _finalizer =
      Finalizer((w) => w.finalize());

  ForeignInstanceStub(ffi.Pointer<ffi.Void> handle,
      void Function(ffi.Pointer<ffi.Void>) foreignFinalizer) {
    if (handle == ffi.nullptr) {
      throw InstanceCreateError('Foreign instance handle is null');
    }
    _handle = handle;
    _foreignFinalizer = foreignFinalizer;
    _finalizer.attach(this, _FinalizeWrapper(this), detach: this);
  }

  void dispose() {
    asyncRunner.dispose();
    _foreignFinalizer(_handle);
    _finalizer.detach(this);
  }
}

class _FinalizeWrapper {
  // Pointer to the foreign function that
  // frees the foreign instance.
  late final ForeignInstanceStub _stub;

  _FinalizeWrapper(this._stub);

  void finalize() {
    _stub.dispose();
  }
}

// InstanceCreateError is thrown if the foreign
// instance handle is null when the stub is
// instantiated.
class InstanceCreateError extends Error {
  InstanceCreateError(this.message);

  final String message;

  @override
  String toString() => message;
}
