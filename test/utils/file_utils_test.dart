import 'package:image_converter/utils/file_utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockFileUtils extends Mock implements FileUtils {}

void main() {

  setUp(() {
    fileUtils = MockFileUtils();
  });

  test(
    'Should get a text correctly sanitized',
    () async {
      //arrange
      String text1 = "Camilo Nuñez Ríos";
      String text2 = "José López-Agüero Pérez";

      //act
      String result1 = sanitizeText(text1);
      String result2 = sanitizeText(text2);

      //assert
      expect(result1, equals("CAMILO_NUNEZ_RIOS"));
      expect(result2, equals("JOSE_LOPEZ-AGUERO_PEREZ"));
    },
  );

  test(
    'Should check if a given filepath has a valid extension',
    () async {
      //arrange
      String validExtension = "valid";
      String invalidExtension = "invalid";
      when(() => fileUtils.validFileExtensions).thenReturn([
        validExtension
      ]);

      //act
      bool isValid1 = isValidExtension("file.$validExtension");
      bool isValid2 = isValidExtension("file.$invalidExtension");

      //assert
      expect(isValid1, equals(true));
      expect(isValid2, equals(false));
    },
  );

  test(
    'Should check if a given filepath is an image',
    () async {
      //arrange
      final imageExtension = "png";
      final notImageExtension = "pdf";

      //act
      final isImage1 = isImageFileType("file.$imageExtension");
      final isImage2 = isImageFileType("file.$notImageExtension");

      //assert
      expect(isImage1, equals(true));
      expect(isImage2, equals(false));
    },
  );
}
