import 'dart:async';
import 'dart:isolate';
import 'dart:ffi' as ffi;

import 'user_bindings.dart' as bindings;

// A simple sum function with a callback with the result

Future<int> sumAsyncCallback(int a, int b, SumCallback callback) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextSumCallbackRequestId++;
  final _SumCallbackRequest request =
      _SumCallbackRequest(requestId, a, b, callback);
  final Completer<int> completer = Completer<int>();
  _sumCallbackRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
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

/// A request to compute `sum`.
///
/// Typically sent from one isolate to another.
class _SumCallbackRequest {
  final int id;
  final int a;
  final int b;
  final SumCallback callback;

  const _SumCallbackRequest(this.id, this.a, this.b, this.callback);
}

/// A response with the result of `sum`.
///
/// Typically sent from one isolate to another.
class _SumCallbackResponse {
  final int id;
  final int result;

  const _SumCallbackResponse(this.id, this.result);
}

/// Counter to identify [_SumCallbackRequest]s and [_SumCallbackResponse]s.
int _nextSumCallbackRequestId = 0;

/// Mapping from [_SumCallbackRequest] `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<int>> _sumCallbackRequests = <int, Completer<int>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        // The helper isolate sent us the port on which we can sent it requests.
        completer.complete(data);
        return;
      }
      if (data is _SumCallbackResponse) {
        // The helper isolate sent us a response to a request we sent.
        final Completer<int> completer = _sumCallbackRequests[data.id]!;
        _sumCallbackRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _SumCallbackRequest) {
          final int result = sumCallback(data.a, data.b, data.callback);
          final _SumCallbackResponse response =
              _SumCallbackResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
