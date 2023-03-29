import 'dart:io';

import 'package:path/path.dart' as path;

import 'models/configuration.dart';
import 'models/process_image_result.dart';
import 'utils/common.dart';
import 'utils/file_utils.dart';
import 'utils/image_utils.dart';

FilesResult findFilesByConfig(Configuration config) {
  List<String> failedPaths = [];

  List<File> files = config.imageDir
      .listSync(recursive: false, followLinks: false)
      .whereType<Directory>()
      .where((dir) => !path.equals(dir.path, config.resultsPath))
      .map(
        (dir) => dir
            .listSync(followLinks: false, recursive: false)
            .whereType<File>()
            .cast<File?>()
            .firstWhere(
          (file) =>
              file!.path.toLowerCase().contains(
                    config.searchTerm.toLowerCase(),
                  ) &&
              isValidExtension(file.path),
          orElse: () {
            failedPaths.add(dir.path);
            return null;
          },
        ),
      )
      .whereType<File>()
      .toList();

  return FilesResult(failedPaths, files);
}

void processFiles(FilesResult result, Configuration configuration) {

  _createResultsFolder(configuration.resultsPath);

  bool isSomePathSuccess = false;
  for (var file in result.files) {
    String newImagePath = _getCustomFilePath(
      parentPath: configuration.resultsPath,
      name: path.basename(file.parent.path),
      extension: '.jpg',
    );

    if (configuration.skipFiles && File(newImagePath).existsSync()) continue;

    resizeAndSaveFileAsJpg(
      file,
      width: configuration.width,
      height: configuration.height,
      toSavePath: newImagePath,
    );
    isSomePathSuccess = true;
  }
  if (!isSomePathSuccess) simplePrint("No image saved");

  _checkFailedPaths(result.failedPaths, configuration.searchTerm);
}

String _getCustomFilePath({
  required String parentPath,
  required String name,
  required String extension,
  String prefixFile = '',
}) {
  String sanitizedFileName = sanitizeText(name) + extension;

  if (prefixFile.isNotEmpty) {
    sanitizedFileName = "${prefixFile.toUpperCase()}_$sanitizedFileName";
  }

  return path.join(parentPath, sanitizedFileName);
}

void _checkFailedPaths(List<String> failedPaths, String searchTerm) {
  if (failedPaths.isEmpty) return;

  printSeparator();
  simplePrint(
    'The following folders do not have any images with the word "$searchTerm" or with admitted extensions ${fileUtils.validFileExtensions}:',
  );
  for (var failedPathText in failedPaths) {
    simplePrint(failedPathText);
  }
}

void _createResultsFolder(String resultsPath) {
  final dir = Directory(resultsPath);

  if(dir.existsSync()) return;

  dir.createSync(recursive: true);
}