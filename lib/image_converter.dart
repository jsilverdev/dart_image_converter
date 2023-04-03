import 'dart:io';

import 'package:path/path.dart' as path;

import 'models/configuration.dart';
import 'utils/common.dart';
import 'utils/file_utils.dart';
import 'utils/image_utils.dart';

class ImageConverter {
  final Configuration configuration;
  List<String> failedPaths = [];
  List<File> files = [];

  ImageConverter(this.configuration);

  void findValidFilesAndFailedPaths() {
    files = configuration.imageDir
        .listSync(recursive: false, followLinks: false)
        .whereType<Directory>()
        .where((dir) => !path.equals(dir.path, configuration.resultsPath))
        .map(
          (dir) => dir
              .listSync(followLinks: false, recursive: false)
              .whereType<File>()
              .cast<File?>()
              .firstWhere(
            (file) =>
                file!.path.toLowerCase().contains(
                      configuration.searchTerm.toLowerCase(),
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
  }

  void resizeAndSaveValidFilesAsJpg() {
    _createResultsFolder();

    bool isSomePathSuccess = false;
    for (var file in files) {
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

  void checkFailedPaths() {
    if (failedPaths.isEmpty) return;

    printSeparator();
    simplePrint(
      'The following folders do not have any images with the word "${configuration.searchTerm}" or with admitted extensions ${fileUtils.validFileExtensions}:',
    );
    for (var failedPathText in failedPaths) {
      simplePrint(failedPathText);
    }
  }

  void _createResultsFolder() {
    final dir = Directory(configuration.resultsPath);

    if (dir.existsSync()) return;

    dir.createSync(recursive: true);
  }
}
