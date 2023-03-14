import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:image_converter/errors/exceptions.dart';
import 'package:image_converter/models/configuration.dart';

Future<Configuration> loadConfig() async {
  final DotEnv env = DotEnv(includePlatformEnvironment: false)..load();

  String imagePath = env["IMAGES_PATH"] ?? (throw NullException());
  int? width = int.tryParse(env["WIDTH"] ?? '');
  int? height = int.tryParse(env["HEIGHT"] ?? '');
  String? searchTerm = env["SEARCH_TERM"];
  String? prefix = env["PREFIX_FILE"];

  bool isDir = await FileSystemEntity.isDirectory(imagePath);
  if(!isDir) {
    throw DirectoryInvalidException(imagePath);
  }

  return Configuration.load(
    Directory(imagePath),
    width: width,
    height: height,
    searchTerm: searchTerm,
    prefixFile: prefix
  );

}