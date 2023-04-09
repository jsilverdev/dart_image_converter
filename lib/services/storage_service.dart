import 'dart:io';

abstract class StorageService {
  Future<void> uploadFile(
    File file,
    String bucket,
    String remotePath,
  );
}
