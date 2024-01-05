import 'dart:async';
import 'package:ffi_helper/ffi_helper.dart';

import 'user_bindings.dart' as bindings;

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
int sum(int a, int b) => bindings.user.sum(a, b);

/// A longer lived native function, which occupies the thread calling it.
///
/// Do not call these kind of native functions in the main isolate. They will
/// block Dart execution. This will cause dropped frames in Flutter applications.
/// Instead, call these native functions on a separate isolate.
///
/// Modify this to suit your own use case. Example use cases:
///
/// 1. Reuse a single isolate for various different kinds of requests.
/// 2. Use multiple helper isolates for parallel execution.
Future<int> sumAsync(int a, int b) async {
  AsyncRunner asyncRunner = AsyncRunner();
  final Completer<int> completer = Completer<int>();

  asyncRunner
      .run<_SumAsyncRequest, _SumAsyncResponse>(_SumAsyncRequest(a, b))
      .then((response) {
    completer.complete(response.result);
    asyncRunner.dispose();
  });

  return completer.future;
}

class _SumAsyncRequest extends AsyncRequest {
  _SumAsyncRequest(this.a, this.b);

  final int a;
  final int b;

  @override
  AsyncResponse execute() {
    final int result = bindings.user.sum_long_running(a, b);
    return _SumAsyncResponse(this, result);
  }
}

class _SumAsyncResponse extends AsyncResponse {
  final int result;

  _SumAsyncResponse(AsyncRequest request, this.result) : super(request);
}
