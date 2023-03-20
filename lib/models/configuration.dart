import 'dart:io';

class Configuration {
  final Directory imageDir;
  final int width;
  final int height;
  final String searchTerm;
  final String prefixFile;
  final bool skipFiles;
  late String resultsPath;

  Configuration(
    this.imageDir, {
    required this.width,
    required this.height,
    required this.searchTerm,
    required this.prefixFile,
    required this.skipFiles,
    required String resultsFolder,
  }) {
    resultsPath = "${imageDir.path}/$resultsFolder";
  }

  factory Configuration.load(
    Directory imageDir, {
    int? width,
    int? height,
    String? searchTerm,
    String? prefixFile,
    bool? skipFiles,
    String? resultsFolder,
  }) {
    return Configuration(
      imageDir,
      width: width ?? 400,
      height: height ?? 400,
      searchTerm: searchTerm ?? 'logo',
      prefixFile: prefixFile ?? '',
      skipFiles: skipFiles ?? false,
      resultsFolder: resultsFolder ?? "results",
    );
  }

  @override
  String toString() =>
      "[imageDir Path]: ${imageDir.path}, [width]: $width, [height]: $height, [searchTerm]: $searchTerm, [prefixFile]: $prefixFile [skipFiles]: $skipFiles, [resultsPath]: $resultsPath";
}
