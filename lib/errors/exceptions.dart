abstract class AppException implements Exception {
  final String _message;

  const AppException(this._message);

  @override
  String toString() => _message;
}

class NullException extends AppException {
  NullException() : super("The value can't be null");
}

class DirectoryInvalidException extends AppException {
  DirectoryInvalidException(String path) : super("The path ($path) is not a valid directory");
}

class UserCancelException extends AppException {
  UserCancelException() : super("The user cancel the action");
}