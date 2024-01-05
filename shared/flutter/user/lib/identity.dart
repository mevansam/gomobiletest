import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:ffi_helper/ffi_helper.dart';

import 'user_bindings_generated.dart' as user;

// Identity skeleton to invoke Dart
// code when called from  native code

abstract class Identity extends ForeignInterfaceSkel<user.identity_t> {
  String userid();
  String username();
  String avatar();

  Identity() : super();

  @override
  ffi.Pointer<user.identity_t> create() {
    ffi.Pointer<user.identity_t> handle = calloc<user.identity_t>();
    handle.ref.context = handle.address;
    handle.ref.userid = ffi.Pointer.fromFunction(_userid);
    handle.ref.username = ffi.Pointer.fromFunction(_username);
    handle.ref.avatar = ffi.Pointer.fromFunction(_avatar);
    return handle;
  }

  // Interface func skeletons for calling
  // Dart code from foreign code

  static ffi.Pointer<ffi.Char> _userid(int context) {
    final Identity identity =
        ForeignInterfaceSkel.lookupInstance<Identity>(context);

    final String username = identity.userid();
    final ffi.Pointer<ffi.Char> useridPtr =
        username.toNativeUtf8().cast<ffi.Char>();

    return useridPtr;
  }

  static ffi.Pointer<ffi.Char> _username(int context) {
    final Identity identity =
        ForeignInterfaceSkel.lookupInstance<Identity>(context);

    final String username = identity.username();
    final ffi.Pointer<ffi.Char> usernamePtr =
        username.toNativeUtf8().cast<ffi.Char>();

    return usernamePtr;
  }

  static ffi.Pointer<ffi.Char> _avatar(int context) {
    final Identity identity =
        ForeignInterfaceSkel.lookupInstance<Identity>(context);

    final String avatar = identity.avatar();
    final ffi.Pointer<ffi.Char> avatarPtr =
        avatar.toNativeUtf8().cast<ffi.Char>();

    return avatarPtr;
  }
}
