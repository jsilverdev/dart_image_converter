import 'dart:io';

import 'package:image_converter/services/impl/gcp_storage_service.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  test('gcp storage service ...', () async {
    final storageService = GcpStorageService(
      keyFilePath: path.absolute("keys/gcp_key.json")
    );

    final file = File(
      path.absolute("test/_data/input/sample.webp"),
    );

    await storageService.uploadFile(
      file,
      "dart-image-converter-bucket",
      "sample.webp",
    );
  });
}
