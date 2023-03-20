import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'errors/exceptions.dart';
import 'models/configuration.dart';

Future<Configuration> loadConfig() async {
  final DotEnv env = DotEnv(includePlatformEnvironment: false)..load();

  String imagePath = env["IMAGES_PATH"] ?? (throw NullException());

  bool isDir = await FileSystemEntity.isDirectory(imagePath);
  if (!isDir) {
    throw DirectoryInvalidException(imagePath);
  }

  return Configuration.load(
    Directory(imagePath),
    width: int.tryParse(env["WIDTH"] ?? ''),
    height: int.tryParse(env["HEIGHT"] ?? ''),
    searchTerm: env["SEARCH_TERM"],
    prefixFile: env["PREFIX_FILE"],
    skipFiles: (env["SKIP_FILES"] ?? '').tryParseBool(),
    resultsFolder: env["RESULTS_FOLDER"],
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
