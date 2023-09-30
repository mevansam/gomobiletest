import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'user_bindings_generated.dart' as user;

abstract class Identity {
  String username();

  final ffi.Pointer<user.identity_t> handle = calloc<user.identity_t>();
  static final Map<int, Identity> _handlers = <int, Identity>{};

  Identity() {
    handle.ref.context = handle.address;
    handle.ref.username = ffi.Pointer.fromFunction(_username);
    Identity._handlers[handle.address] = this;
  }

  static final Finalizer<Identity> _finalizer =
      Finalizer((identity) => identity.finalize());
  void finalize() {
    Identity._handlers.remove(handle.address);
    calloc.free(handle);
    _finalizer.detach(this);
  }

  // Interface func skeletons from native code to Dart code

  static ffi.Pointer<ffi.Char> _username(int context) {
    final Identity identity = _handlers[context]!;
    final String username = identity.username();
    final ffi.Pointer<ffi.Char> usernamePtr =
        username.toNativeUtf8().cast<ffi.Char>();

    // caller must free the returned pointer
    return usernamePtr;
  }
}
