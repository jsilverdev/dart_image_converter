import 'dart:convert';
import 'dart:io';

import 'exceptions/app_exceptions.dart';
import 'models/configuration.dart';
import 'utils/common.dart';

class Setup {
  final Configuration configuration;

  Setup(this.configuration);

  void initialSetup() {
    simplePrint(
      configuration.skipFiles
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
}
