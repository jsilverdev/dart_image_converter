import 'dart:io';

class LogoFilesResult {
  final List<String> failedPaths;
  final List<File> logoFiles;

  LogoFilesResult(this.failedPaths, this.logoFiles);
}
