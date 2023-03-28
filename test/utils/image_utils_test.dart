import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:image_converter/utils/image_utils.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  test(
    'Should capture a file and save as JPG',
    () async {
      //arrange
      final width = _randomInt(100, 999);
      final height = width;
      Map<String, File> mapInputFiles = {
        for (var file in Directory(path.absolute("test/_data/input"))
            .listSync()
            .whereType<File>()
            .toList())
          _newOutPath(file.path, "jpg"): file
      };

      //act
      List<img.Image?> outputImages = [];
      for (var entry in mapInputFiles.entries) {
        resizeAndSaveFileAsJpg(
          entry.value,
          width: width,
          height: height,
          toSavePath: entry.key,
        );
        outputImages.add(
          await img.decodeImageFile(entry.key),
        );
      }

      //assert
      for (var image in outputImages) {
        expect(image, isNotNull);
        expect(image?.isValid, equals(true));
        expect(image?.width, equals(width));
        expect(image?.height, equals(height));
        expect(image?.hasAlpha, equals(false));
      }
    },
  );
}

int _randomInt(int min, int max) {
  return min + Random().nextInt(max - min);
}

String _newOutPath(String filePath, String extension) {
  return "${path.absolute("test/_data/output/")}${path.extension(filePath).substring(1)}.$extension";
}
