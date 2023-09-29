import 'dart:io';

import 'package:test/test.dart';
import 'package:user/user.dart' as user;

void main() {
  // Get the path to the Dart executable
  String dartExecutable = Platform.executable;
  print('Dart CLI path: $dartExecutable');

  test('adds one to input values', () async {
    int sumResult = user.sum(1, 2);
    print("sumResult = $sumResult");
    expect(sumResult, 3);

    int sumAsyncResult = await user.sumAsync(3, 4);
    print("sumAsyncResult = $sumAsyncResult");
    expect(sumAsyncResult, 7);

    int sumCallbackResult = user.sumCallback(4, 6, callback);
    print("callbackResult = $sumCallbackResult");
    expect(sumCallbackResult, 20);

    int sumAsyncCallbackResult = await user.sumAsyncCallback(4, 8, callback);
    print("callbackResult = $sumAsyncCallbackResult");
    expect(sumAsyncCallbackResult, 24);
  });
}

int callback(int val) {
  print("callback value to double = $val");
  return val * 2;
}
