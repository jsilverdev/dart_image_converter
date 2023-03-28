import 'dart:io';

import 'package:image_converter/utils/common.dart';
import 'package:test/test.dart';

import '../_test_utils.dart';

void main() {
  setUp(() {
    printLog.clear();
  });

  test(
    'Should print with stdout',
    () async {
      //arrange
      final stdoutToPrint = "Stdout to Print";

      //act
      IOOverrides.runZoned(
        () => simplePrint(stdoutToPrint),
        stdout: () => FakeStdout(),
      );

      //assert
      expect(printLog.first, equals(stdoutToPrint));
    },
  );

  test(
    'Should print with stderr',
    () async {
      //arrange
      final stderrToPrint = "Stderr to Print";

      //act
      IOOverrides.runZoned(
        () => simpleErrorPrint(stderrToPrint),
        stderr: () => FakeStderr(),
      );

      //assert
      expect(printLog.first, equals(stderrToPrint));
    },
  );

  test(
    'Should print a separator with stdout',
    () async {
      //arrange
      final toPrint = "\n------------------";

      //act
      IOOverrides.runZoned(
        () => printSeparator(),
        stdout: () => FakeStdout(),
      );

      //assert
      expect(printLog.first, equals(toPrint));
    },
  );
}
