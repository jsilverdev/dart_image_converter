import 'dart:io';

import 'package:image_converter/image_converter.dart';
import 'package:image_converter/models/configuration.dart';
import 'package:image_converter/models/process_image_result.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '_test_utils.dart';

void main() {
  setUp(() {
    printLog.clear();
  });

  test(
    'Should return the valid files and the invalid paths',
    () async {
      //arrange
      final dir = Directory(
        path.absolute("test/_data/valid_image_path"),
      );
      final configuration = Configuration.load(
        dir,
        searchTerm: "sample",
      );
      //act
      final filesResult = findFilesByConfig(configuration);

      //assert
      expect(filesResult.files.length, equals(2));
      expect(filesResult.failedPaths.length, equals(2));
    },
  );

  test(
    'Should convert and resize a list of files correctly',
    () async {
      //arrange
      String imagePath = path.absolute("test/_data/valid_image_path");
      final result = FilesResult(
        [
          "$imagePath/invalid_subfolder_1",
          "$imagePath/invalid_subfolder_2",
        ],
        [
          File("$imagePath/valid_subfolder_1/sample.png"),
          File("$imagePath/valid_subfolder_2/sample.pdf")
        ],
      );

      final configuration =
          Configuration.load(Directory(imagePath), searchTerm: "sample");
      int imageSavedCounter = 0;
      int invalidFolderCounter = 0;


      //act
      IOOverrides.runZoned(
        () => processFiles(result, configuration),
        stdout: () => FakeStdout(),
      );
      final dir = Directory("$imagePath/results");
      for (var log in printLog) {
        if(log is! String) continue;
        if(log.contains("Image saved in:")) {
          imageSavedCounter++;
        }
        if(log.contains("invalid")) {
          invalidFolderCounter++;
        }
      }

      //assert
      expect(dir.existsSync(), equals(true));
      expect(imageSavedCounter, equals(2));
      expect(invalidFolderCounter, equals(2));
    },
  );
}
