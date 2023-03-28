import 'dart:io';

import 'package:mocktail/mocktail.dart';

class FakeStdout extends Fake implements Stdout {
  @override
  void writeln([Object? object = ""]) {
    printLog.add(object);
  }
}

class FakeStderr extends Fake implements Stdout {
  @override
  void writeln([Object? object = ""]) {
    printLog.add(object);
  }
}

class MockStdin extends Mock implements Stdin {}

final List<Object?> printLog = [];