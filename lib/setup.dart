import 'dart:convert';
import 'dart:io';

import 'errors/exceptions.dart';
import 'utils/utils.dart';

void initialSetup(bool skipFiles) {

  simplePrint(
    skipFiles
        ? "If a file exists with the same, it will be skipped"
        : "If a file with the same name exists, it will be overwritten",
  );
  simplePrint("Continue ? y/n (default yes)");

  var line = stdin.readLineSync(encoding: utf8);

  if (line?.toLowerCase() == 'n' || line?.toLowerCase() == 'no') {
    throw UserCancelException();
  }

  printSeparator();
}
