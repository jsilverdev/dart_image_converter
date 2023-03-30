import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:image_converter/errors/exceptions.dart';
import 'package:image_converter/utils/image_utils.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../_test_utils.dart';

void main() {
  setUp(() {
    printLog.clear();
  });

  test(
    "Should print the ImageDecodingException message if the file can't be decoded",
    () async {
      //arrange
      final extension = "png";
      final file = File(
        path.absolute("test/_data/invalid_file.$extension"),
      );

      //act
      IOOverrides.runZoned(
        () {
          resizeAndSaveFileAsJpg(
            file,
            width: 400,
            height: 400,
            toSavePath: _newOutJpgPath(extension),
          );
        },
        stdout: () => FakeStdout(),
      );

      //assert
      expect(
        printLog.first.toString(),
        equals(ImageDecodingException(file.path).toString()),
      );
    },
  );

  test(
    'Should print the FileNotValidException message if the file is not a valid file',
    () async {
      //arrange
      final extension = "txt";
      final file = File(
        path.absolute("test/_data/file_not_valid.$extension"),
      );

      //act
      IOOverrides.runZoned(
        () {
          resizeAndSaveFileAsJpg(
            file,
            width: 400,
            height: 400,
            toSavePath: _newOutJpgPath(extension),
          );
        },
        stdout: () => FakeStdout(),
      );

      //assert
      expect(
        printLog.first.toString(),
        equals(FileNotValidException(file.path).toString()),
      );
    },
  );

  test(
    'Should convert a jpeg file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("jpeg");
    },
  );

  test(
    'Should convert a jpg file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("jpg");
    },
  );

  test(
    'Should convert a png file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("png");
    },
  );

  test(
    'Should convert a gif file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("gif");
    },
  );

  test(
    'Should convert a bmp file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("bmp");
    },
  );

  test(
    'Should convert a ico file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("ico");
    },
  );

  test(
    'Should convert a tiff file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("tiff");
    },
  );

  test(
    'Should convert a webp file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("webp");
    },
  );

  test(
    'Should convert a psd file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("psd");
    },
  );

  test(
    'Should convert a pdf file then resize and save as jpg',
    () async {
      _testResizeAndSaveFileAsJpg("pdf");
    },
  );
}

Future<void> _testResizeAndSaveFileAsJpg(String extension) async {
  //arrange
  final width = _randomInt(100, 999);
  final height = width;

  final file = File(path.absolute("test/_data/input/sample.$extension"));
  final toSavePath = _newOutJpgPath(extension);

  //act
  resizeAndSaveFileAsJpg(
    file,
    width: width,
    height: height,
    toSavePath: toSavePath,
  );
  img.Image? image = await img.decodeImageFile(toSavePath);

  //assert
  expect(image, isNotNull);
  expect(image?.isValid, equals(true));
  expect(image?.width, equals(width));
  expect(image?.height, equals(height));
  expect(image?.hasAlpha, equals(false));
}

int _randomInt(int min, int max) {
  return min + Random().nextInt(max - min);
}

String _newOutJpgPath(String originExtension) {
  return "${path.absolute("test/_data/output/")}$originExtension.jpg";
}
