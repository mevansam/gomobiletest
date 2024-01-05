import 'dart:async' as async;
import 'dart:ffi' as ffi;
import 'package:ffi_helper/ffi_helper.dart';

import 'user_bindings.dart' as bindings;

// A simple sum function with a callback with the result

Future<int> sumAsyncCallback(int a, int b, SumCallback callback) async {
  AsyncRunner asyncRunner = AsyncRunner();
  final async.Completer<int> completer = async.Completer<int>();

  asyncRunner
      .run<_SumAsyncRequest, _SumAsyncResponse>(
          _SumAsyncRequest(a, b, callback))
      .then((response) {
    completer.complete(response.result);
    asyncRunner.dispose();
  });

  return completer.future;
}

int sumCallback(int a, int b, SumCallback callback) {
  _handlers[callback.hashCode] = callback;

  int result;
  try {
    result = bindings.user.sum_with_callback(
      callback.hashCode,
      ffi.Pointer.fromFunction(_callback, 0),
      a,
      b,
    );
  } finally {
    _handlers.remove(callback.hashCode);
  }
  return result;
}

typedef SumCallback = int Function(int result);
Map<int, SumCallback> _handlers = <int, SumCallback>{};

// Callback from native code to Dart code
int _callback(int context, int result) {
  final SumCallback callback = _handlers[context]!;
  return callback(result);
}

class _SumAsyncRequest extends AsyncRequest {
  _SumAsyncRequest(this.a, this.b, this.callback);

  final int a;
  final int b;
  final SumCallback callback;

  @override
  AsyncResponse execute() {
    final int result = sumCallback(a, b, callback);
    return _SumAsyncResponse(this, result);
  }
}

class _SumAsyncResponse extends AsyncResponse {
  final int result;

  _SumAsyncResponse(AsyncRequest request, this.result) : super(request);
}
