import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'exceptions/app_exceptions.dart';
import 'models/configuration.dart';
import 'package:path/path.dart' as path;

class Config {

  late DotEnv _env;

  Config({DotEnv? env}) {
    _env = env ?? (DotEnv()..load());
  }

  Future<Configuration> loadConfiguration() async {

    String? optionalImagePath = _env["IMAGES_PATH"];
    if(optionalImagePath == null || optionalImagePath.isEmpty) {
      throw NullOrEmptyException();
    }

    String imagePath = path.absolute(optionalImagePath);

    bool isDir = await FileSystemEntity.isDirectory(imagePath);
    if (!isDir) {
      throw DirectoryInvalidException(imagePath);
    }

    return Configuration.load(
      Directory(imagePath),
      width: int.tryParse(_env["WIDTH"] ?? ''),
      height: int.tryParse(_env["HEIGHT"] ?? ''),
      searchTerm: _env["SEARCH_TERM"],
      prefixFile: _env["PREFIX_FILE"],
      skipFiles: (_env["SKIP_FILES"] ?? '').tryParseBool(),
      resultsFolder: _env["RESULTS_FOLDER"],
    );
  }
}

extension BoolParsing on String {
  bool? tryParseBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    }
    return null;
  }
}
