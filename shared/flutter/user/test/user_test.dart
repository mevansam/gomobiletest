import 'dart:io';

import 'package:test/test.dart';

import 'package:ffi_helper/ffi_helper.dart';
import 'package:user/user.dart' as user;

void main() {
  test('Retrieves a person instances and sends a greeting', () async {
    ErrorHandler errorHandler = ErrorHandler();
    TestPrinter printer = TestPrinter();

    user.Person person;

    try {
      person = user.Person(
          TestIdentity('999', 'anika', '/test/anika.gif'), errorHandler);
    } on InstanceCreateError {
      expect(errorHandler.testErrorCode, 404);
      expect(errorHandler.testErrorMessage,
          'Person not found with userid "999" and username "anika".');
    }

    errorHandler.reset();
    person = user.Person(
        TestIdentity('001', 'anika', '/test/anika.gif'), errorHandler);

    expect(person.fullName(), 'Anika Luciana');
    expect(person.address(), '1186 Martha Street, Whipoorwill, AZ 86510');
    expect(person.dob(), '2004-04-21');

    stdout.writeln("Name = ${person.fullName()}");
    stdout.writeln("Address = ${person.address()}");
    stdout.writeln("DOB = ${person.dob()}");
    stdout.writeln("Age = ${person.age()}");

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

class ErrorHandler extends user.ErrorHandler {
  int testErrorCode = 0;
  String testErrorMessage = '';

  @override
  void handleError(int code, String message) {
    testErrorCode = code;
    testErrorMessage = message;
    stdout.writeln("Error: $code, $message");
  }

  void reset() {
    testErrorCode = 0;
    testErrorMessage = '';
  }
}

class TestIdentity extends user.Identity {
  @override
  String userid() {
    return id;
  }

  @override
  String username() {
    return name;
  }

  @override
  String avatar() {
    return avatarUri;
  }

  final String id;
  final String name;
  final String avatarUri;

  TestIdentity(this.id, this.name, this.avatarUri) : super();
}

class TestPrinter extends user.Printer {
  String testResult = '';

  @override
  void print(String s) {
    stdout.writeln("This just in: $s");
    testResult = s;
  }
}
