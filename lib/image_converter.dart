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

void processFiles(List<File> files, Configuration config) {
  bool isSomePathSuccess = false;
  for (var file in files) {
    String newImagePath = _getCustomFilePath(
      parentPath: config.resultsPath,
      name: path.basename(file.parent.path),
      extension: '.jpg',
    );

    if (config.skipFiles && File(newImagePath).existsSync()) continue;

    resizeAndSaveFileAsJpg(
      file,
      width: config.width,
      height: config.height,
      toSavePath: newImagePath,
    );
    isSomePathSuccess = true;
  }
  if (!isSomePathSuccess) simplePrint("No image saved");
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

void checkFailedPaths(List<String> failedPaths, String searchTerm) {
  if (failedPaths.isEmpty) return;

  printSeparator();
  simplePrint(
    'The following folders do not have any images with the word "$searchTerm" or with admitted extensions ${fileUtils.validFileExtensions}:',
  );
  for (var failedPathText in failedPaths) {
    simplePrint(failedPathText);
  }
}
