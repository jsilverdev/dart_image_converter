import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:image_converter/config.dart';
import 'package:image_converter/setup.dart';
import 'package:image_converter/models/configuration.dart';
import 'package:image_converter/utils/file_utils.dart';
import 'package:image_converter/utils/utils.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) async {
  try {
    Configuration config = await loadConfig();

    initialSetup(config.skipFiles);

    List<String> failedPaths = [];
    int successPaths = 0;

    await for (var entity in config.imageDir.list(
      recursive: false,
      followLinks: false,
    )) {
      if (entity is! Directory) continue;
      Directory dir = entity;

      File? logo = dir
          .listSync(followLinks: false, recursive: false)
          .whereType<File>()
          .cast<File?>()
          .firstWhere(
            (file) => file!.path
                .toLowerCase()
                .contains(config.searchTerm.toLowerCase()),
            orElse: () => null,
          );

      if (logo == null) {
        failedPaths.add(dir.path);
        continue;
      }

      String newImagePath = path.join(
        dir.path,
        getCustomFileName(
            dirName: path.basename(dir.path),
            extension: '.jpg',
            prefixFile: config.prefixFile),
      );

      if(config.skipFiles && File(newImagePath).existsSync()) continue;

      final cmd = img.Command()
        ..decodeImage(logo.readAsBytesSync())
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

      await cmd.execute();

      simplePrint("Image saved in: $newImagePath");
      successPaths++;
    }

    if(successPaths == 0){
      simplePrint("No image saved");
    }

    if (failedPaths.isNotEmpty) {
      printSeparator();
      simplePrint(
        'The following folders do not have any images with the word "${config.searchTerm}":',
      );
      for (var failedPathText in failedPaths) {
        simplePrint(failedPathText);
      }
    }
  } catch (e) {
    simpleErrorPrint(e);
  }
}
