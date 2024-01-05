import 'dart:async';
import 'dart:isolate';

// The AsyncRunner is a helper class that can be
// used to run code in an isolate and return the
// result to the caller. This can be used to create
// asynchronous bindings to foreign code. In such
// use cases you must be careful not to call foreign
// code from the isolate that will call back into
// Dart code via an interface skeleton that was
// created on the main isolate. This class is not
// limited to such use cases though.
class AsyncRunner {
  // Executes the given request in an isolate
  // and returns a future with the response.
  Future<Response_T>
      run<Request_T extends AsyncRequest, Response_T extends AsyncResponse>(
          Request_T request) async {
    // Port to the isolate that executes the request.
    final asyncIsolatePort = await _asyncIsolatePort();
    // Completer used to return the future response.
    final completer = Completer<Response_T>();
    _asyncCalls[request.id] = completer;
    asyncIsolatePort.send(request);
    return completer.future;
  }

  // Shuts down the isolate.
  dispose() {
    _isolate?.kill();
  }

  _asyncIsolatePort() async {
    // The SendPort to the helper isolate which is
    // spawned only at the first invocation of the
    // runner's run function.
    _sendPort ??= await _getAsycHelperIsolatePort();
    return _sendPort;
  }

  SendPort? _sendPort;
  Isolate? _isolate;

  // Spawns the helper isolate for this async
  // instance and sets up the communication port.
  Future<SendPort> _getAsycHelperIsolatePort() async {
    // The helper isolate is going to send us back a
    // SendPort, which we want to wait for.
    final Completer<SendPort> completer = Completer<SendPort>();

    // Receive port on the main isolate to receive
    // messages from the helper.
    //
    // We receive two types of messages:
    // 1. A port to send messages on.
    // 2. Responses to requests we sent.
    final ReceivePort receivePort = ReceivePort()
      ..listen((dynamic data) {
        if (data is SendPort) {
          // The helper isolate sent us the port on
          // which we can send it requests.
          completer.complete(data);
          return;
        }
        if (data is AsyncResponse) {
          // The helper isolate sent us a response to
          // a request we sent.
          final Completer completer = _asyncCalls[data.id]!;
          _asyncCalls.remove(data.id);
          completer.complete(data);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Start the helper isolate.
    _isolate = await Isolate.spawn((SendPort sendPort) async {
      final ReceivePort helperReceivePort = ReceivePort()
        ..listen((dynamic data) {
          // On the helper isolate listen to requests and respond to them.
          if (data is AsyncRequest) {
            sendPort.send(data.execute());
            return;
          }
          throw UnsupportedError(
              'Unsupported message type: ${data.runtimeType}');
        });

      // Send the port to the main isolate on which we can receive requests.
      sendPort.send(helperReceivePort.sendPort);
    }, receivePort.sendPort);

    // Wait until the helper isolate has sent us back the SendPort on which we
    // can start sending requests.
    return completer.future;
  }

  final Map<int, Completer> _asyncCalls = <int, Completer>{};
}

abstract class AsyncRequest {
  AsyncResponse execute();

  late final int id;
  static int _nextId = 0;
  AsyncRequest() {
    id = _nextId++;
  }
}

class AsyncResponse {
  final int id;
  AsyncResponse(AsyncRequest request) : id = request.id;
}
