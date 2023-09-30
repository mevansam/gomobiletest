import 'dart:io';

import 'package:test/test.dart';
import 'package:user/user.dart' as user;

void main() {
  test('Retrieves a person instances and sends a greeting', () async {
    stdout.writeln();
    TestPrinter printer = TestPrinter();

    user.Person person = user.Person(TestIdentity('anika'));
    user.Greeter greeter = user.Greeter(printer);
    greeter.greet(person);

    expect(printer.testResult, 'Hello Anika Luciana!');
  });

  test('adds input values via various ffi invocation mechanisms', () async {
    int sumResult = user.sum(1, 2);
    stdout.writeln("sumResult = $sumResult");
    expect(sumResult, 3);

    int sumAsyncResult = await user.sumAsync(3, 4);
    stdout.writeln("sumAsyncResult = $sumAsyncResult");
    expect(sumAsyncResult, 7);

    int sumCallbackResult = user.sumCallback(4, 6, sumCallback);
    stdout.writeln("callbackResult = $sumCallbackResult");
    expect(sumCallbackResult, 20);

    int sumAsyncCallbackResult = await user.sumAsyncCallback(4, 8, sumCallback);
    stdout.writeln("callbackResult = $sumAsyncCallbackResult");
    expect(sumAsyncCallbackResult, 24);
  });
}

int sumCallback(int val) {
  stdout.writeln("callback value to double = $val");
  return val * 2;
}

class TestIdentity extends user.Identity {
  @override
  String username() {
    return name;
  }

  final String name;

  TestIdentity(this.name) : super();
}

class TestPrinter extends user.Printer {
  String testResult = '';

  @override
  void print(String s) {
    stdout.writeln("This just in: $s");
    testResult = s;
  }
}
