import 'dart:io';

import 'package:image_converter/image_converter.dart';
import 'package:image_converter/models/configuration.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
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
}
