import 'package:dotenv/dotenv.dart';
import 'package:image_converter/config.dart';
import 'package:image_converter/errors/exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

class MockConfig extends Mock implements Config {}

void main() {
  setUp(() {
    config = MockConfig();
  });

  test(
    'Should throws an NullOrEmptyException if IMAGES_PATH is null',
    () async {
      //arrange
      when(() => config.env).thenReturn(DotEnv());

      //act

      //assert
      expect(
        () => loadConfiguration(),
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
      when(() => config.env).thenReturn(dotEnv);

      //act

      //assert
      expect(
        () => loadConfiguration(),
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

      when(() => config.env).thenReturn(dotEnv);

      //act

      //assert
      expect(
        () => loadConfiguration(),
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

      when(() => config.env).thenReturn(dotEnv);
      //act
      final configuration = await loadConfiguration();

      //assert
      expect(configuration.imageDir.path, equals(validDirPath));
    },
  );
}
