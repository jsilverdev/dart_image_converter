import 'dart:convert';
import 'dart:io';

import 'package:image_converter/exceptions/app_exceptions.dart';
import 'package:image_converter/models/configuration.dart';
import 'package:image_converter/setup.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '_test_utils.dart';

void main() {
  late Stdin mockStdin;

  setUp(() {
    mockStdin = MockStdin();
  });

  test(
    "Should throws an UserCancelException if an user write 'n'",
    () async {
      _testUserCancel('n', mockStdin);
    },
  );

  test(
    "Should throws an UserCancelException if an user write 'no'",
    () async {
      _testUserCancel('no', mockStdin);
    },
  );
}

void _testUserCancel(String? readLine, Stdin stdin) {
  //arrange
  when(
    () => stdin.readLineSync(encoding: utf8),
  ).thenReturn(readLine);
  final configuration = Configuration.load(
    Directory.current,
  );

  //act
  //assert
  expect(
    () => IOOverrides.runZoned(
      () {
        Setup(configuration).initialSetup();
      },
      stdin: () => stdin,
    ),
    throwsA(isA<UserCancelException>()),
  );
}
