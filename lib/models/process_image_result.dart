import 'dart:io';

class FilesResult {
  final List<String> failedPaths;
  final List<File> files;

  FilesResult(this.failedPaths, this.files);
}
