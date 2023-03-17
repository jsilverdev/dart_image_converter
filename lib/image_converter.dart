import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

import 'models/configuration.dart';
import 'models/process_image_result.dart';
import 'utils/file_utils.dart';
import 'utils/utils.dart';

LogoFilesResult findLogoFilesByConfig(Configuration config) {
  List<String> failedPaths = [];

  List<File> logoFiles = config.imageDir
      .listSync(recursive: false, followLinks: false)
      .whereType<Directory>()
      .map(
        (dir) => dir
            .listSync(followLinks: false, recursive: false)
            .whereType<File>()
            .cast<File?>()
            .firstWhere(
          (file) => file!.path.toLowerCase().contains(
                config.searchTerm.toLowerCase(),
              ),
          orElse: () {
            failedPaths.add(dir.path);
            return null;
          },
        ),
      )
      .whereType<File>()
      .toList();

  return LogoFilesResult(failedPaths, logoFiles);
}

Future<void> resizeImages(List<File> logoFiles, Configuration config) async {
  bool isSomePathSuccess = false;
  for (var logoImage in logoFiles) {
    String newImagePath = getCustomFilePath(
      parentPath: logoImage.parent.path,
      dirName: path.basename(logoImage.parent.path),
      extension: '.jpg',
    );

    if (config.skipFiles && File(newImagePath).existsSync()) continue;

    final cmd = img.Command()
      ..decodeImage(logoImage.readAsBytesSync())
      ..copyResize(
        width: config.width,
        height: config.height,
        interpolation: img.Interpolation.cubic,
      )
      ..filter((image) {
        if (image.numChannels == 4) {
          var imageDst = img.Image(
            width: image.width,
            height: image.height,
          ); // default format is uint8 and numChannels is 3 (no alpha)
          imageDst.clear(
            img.ColorRgb8(255, 255, 255),
          ); // clear the image with the color white.
          return img.compositeImage(
            imageDst,
            image,
          ); // alpha composite the image onto the white background
        }

        return image;
      })
      ..encodeJpg()
      ..writeToFile(newImagePath);

    await cmd.executeThread();

    simplePrint("Image saved in: $newImagePath");
    isSomePathSuccess = true;
  }
  if(isSomePathSuccess) simplePrint("No image saved");
}

void checkFailedPaths(List<String> failedPaths, String searchTerm) {

  if (failedPaths.isEmpty) return;

  printSeparator();
  simplePrint(
    'The following folders do not have any images with the word "$searchTerm":',
  );
  for (var failedPathText in failedPaths) {
    simplePrint(failedPathText);
  }
}
