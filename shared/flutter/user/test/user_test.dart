import 'dart:io';

import 'package:test/test.dart';
import 'package:user/user.dart' as user;

void main() {
  // Get the path to the Dart executable
  String dartExecutable = Platform.executable;
  print('Dart SDK path: $dartExecutable');

  test('adds one to input values', () async {
    int sumResult = user.sum(1, 2);
    print("sumResult = $sumResult");
    expect(sumResult, 3);

    int sumAsyncResult = await user.sumAsync(3, 4);
    print("sumAsyncResult = $sumAsyncResult");
    expect(sumAsyncResult, 7);
  });
}
