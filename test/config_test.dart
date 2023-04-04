import 'package:dotenv/dotenv.dart';
import 'package:image_converter/config.dart';
import 'package:image_converter/exceptions/app_exceptions.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';



void main() {

  test(
    'Should throws an NullOrEmptyException if IMAGES_PATH is null',
    () async {
      //arrange
      final config = Config(
        env: DotEnv()
      );
      //act

      //assert
      expect(
        () => config.loadConfiguration(),
        throwsA(isA<NullOrEmptyException>()),
      );
    },
  );

  test(
    'Should throws an NullOrEmptyException if IMAGES_PATH is empty',
    () async {
      //arrange
      final dotEnv = DotEnv();
      dotEnv.addAll({"IMAGES_PATH": ""});
      final config = Config(
        env: dotEnv
      );

      //act

      //assert
      expect(
        () => config.loadConfiguration(),
        throwsA(isA<NullOrEmptyException>()),
      );
    },
  );

  test(
    'Should throws an DirectoryInvalidException if IMAGES_PATH is invalid',
    () async {
      //arrange
      final dotEnv = DotEnv();
      dotEnv.addAll({"IMAGES_PATH": "test/_data/invalid_image_path"});
      final config = Config(
        env: dotEnv
      );

      //act
      //assert
      expect(
        () => config.loadConfiguration(),
        throwsA(isA<DirectoryInvalidException>()),
      );
    },
  );


  test(
    'Should load IMAGES_PATH correctly',
    () async {
      //arrange
      final String validDirPath = path.absolute("test/_data/valid_image_path");
      final dotEnv = DotEnv();
      dotEnv.addAll({"IMAGES_PATH": validDirPath});
      final config = Config(
        env: dotEnv
      );

      //act
      final configuration = await config.loadConfiguration();

      //assert
      expect(configuration.imageDir.path, equals(validDirPath));
    },
  );
}
