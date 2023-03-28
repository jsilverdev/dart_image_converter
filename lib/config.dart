import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'errors/exceptions.dart';
import 'models/configuration.dart';
import 'package:path/path.dart' as path;

Config config = Config();

class Config {

  DotEnv get env => _env;

  final DotEnv _env = DotEnv(includePlatformEnvironment: false)..load();
}

Future<Configuration> loadConfiguration() async {

  String? optionalImagePath = config.env["IMAGES_PATH"];
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
    width: int.tryParse(config.env["WIDTH"] ?? ''),
    height: int.tryParse(config.env["HEIGHT"] ?? ''),
    searchTerm: config.env["SEARCH_TERM"],
    prefixFile: config.env["PREFIX_FILE"],
    skipFiles: (config.env["SKIP_FILES"] ?? '').tryParseBool(),
    resultsFolder: config.env["RESULTS_FOLDER"],
  );
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
