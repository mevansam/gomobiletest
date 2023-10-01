import 'dart:ffi' as ffi;

import 'foreign_interface_skel.dart';
import 'package:ffi/ffi.dart';

import 'user_bindings_generated.dart' as user;

// Identity skeleton to invoke Dart
// code when called from  native code

abstract class Identity extends ForeignInterfaceSkel<user.identity_t> {
  String username();

  Identity() : super();

  @override
  ffi.Pointer<user.identity_t> create() {
    ffi.Pointer<user.identity_t> handle = calloc<user.identity_t>();
    handle.ref.context = handle.address;
    handle.ref.username = ffi.Pointer.fromFunction(_username);
    return handle;
  }

  // Interface func skeletons from foreign code to Dart code

  static ffi.Pointer<ffi.Char> _username(int context) {
    final Identity identity =
        ForeignInterfaceSkel.lookupInstance<Identity>(context);

    final String username = identity.username();
    final ffi.Pointer<ffi.Char> usernamePtr =
        username.toNativeUtf8().cast<ffi.Char>();

    return usernamePtr;
  }
}
