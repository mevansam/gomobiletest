import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:ffi_helper/ffi_helper.dart';

import 'user_bindings_generated.dart' as user;

// Printer skeleton to invoke Dart
// code when called from  native code

abstract class ErrorHandler extends ForeignInterfaceSkel<user.error_handler_t> {
  void handleError(int code, String message);

  ErrorHandler() : super();

  @override
  ffi.Pointer<user.error_handler_t> create() {
    ffi.Pointer<user.error_handler_t> handle = calloc<user.error_handler_t>();
    handle.ref.context = handle.address;
    handle.ref.handle_error = ffi.Pointer.fromFunction(_handleError);
    return handle;
  }

  // Interface func skeletons for calling
  // Dart code from foreign code

  static void _handleError(
      int context, int code, ffi.Pointer<ffi.Char> message) {
    final ErrorHandler errorHandler =
        ForeignInterfaceSkel.lookupInstance<ErrorHandler>(context);

    errorHandler.handleError(code, message.cast<Utf8>().toDartString());
  }
}
