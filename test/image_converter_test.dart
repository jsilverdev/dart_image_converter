import 'dart:io';

import 'package:image_converter/image_converter.dart';
import 'package:image_converter/models/configuration.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '_test_utils.dart';

void main() {
  setUp(() {
    printLog.clear();
  });

  test(
    'Should check for the valid files and the failed paths',
    () async {
      //arrange
      final dir = Directory(
        path.absolute("test/_data/valid_image_path"),
      );
      final configuration = Configuration.load(
        dir,
        searchTerm: "sample",
      );

      final imageConverter = ImageConverter(configuration);
      //act
      imageConverter.findValidFilesAndFailedPaths();

      //assert
      expect(imageConverter.files.length, equals(2));
      expect(imageConverter.failedPaths.length, equals(2));
    },
  );

  test(
    'Should convert and resize a list of files correctly',
    () async {
      //arrange
      final imagePath = path.absolute("test/_data/valid_image_path");
      final imageConverter = ImageConverter(
        Configuration.load(
          Directory(imagePath),
          searchTerm: "sample",
        ),
      );
      imageConverter.files = [
        File("$imagePath/valid_subfolder_1/sample.png"),
        File("$imagePath/valid_subfolder_2/sample.pdf")
      ];

      int imageSavedCounter = 0;

      //act
      IOOverrides.runZoned(
        () => imageConverter.resizeAndSaveValidFilesAsJpg(),
        stdout: () => FakeStdout(),
      );
      final dir = Directory("$imagePath/results");

      for (var log in printLog) {
        if (log is! String) continue;
        if (log.contains("Image saved in:")) {
          imageSavedCounter++;
        }
      }

      //assert
      expect(dir.existsSync(), equals(true));
      expect(imageSavedCounter, equals(2));
    },
  );

  test(
    'Should list the failed paths',
    () async {
      //arrange
      final imagePath = path.absolute("test/_data/valid_image_path");
      final imageConverter = ImageConverter(
        Configuration.load(
          Directory(imagePath),
          searchTerm: "sample",
        ),
      );
      imageConverter.failedPaths = [
        "$imagePath/invalid_subfolder_1",
        "$imagePath/invalid_subfolder_2",
      ];
      int imagesFailed = 0;

      //act
      IOOverrides.runZoned(
        () => imageConverter.checkFailedPaths(),
        stdout: () => FakeStdout(),
      );

      for (var log in printLog) {
        if (log is! String) continue;
        if (log.contains("invalid_subfolder")) {
          imagesFailed++;
        }
      }

      //assert
      expect(imagesFailed, equals(imageConverter.failedPaths.length));
    },
  );
}
