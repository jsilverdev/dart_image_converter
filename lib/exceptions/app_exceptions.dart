abstract class AppException implements Exception {
  final String _message;

  const AppException(this._message);

  @override
  String toString() => _message;
}

class NullOrEmptyException extends AppException {
  NullOrEmptyException() : super("The value can't be null or empty");
}

class DirectoryInvalidException extends AppException {
  DirectoryInvalidException(
    String path,
  ) : super("The path ($path) is not a valid directory");
}

class UserCancelException extends AppException {
  UserCancelException() : super("The user cancel the action");
}

class ImageDecodingException extends AppException {
  ImageDecodingException(
    String path,
  ) : super("The image in $path failed to decode");
}

class FileNotValidException extends AppException {
  FileNotValidException(
    String path,
  ) : super("The file in $path is not valid");
}

class ArchNotSupportedException extends AppException {
  ArchNotSupportedException({
    required String path,
    required String arch,
  }) : super("The file in $path can't be converted because $arch is not currently supported");
}
