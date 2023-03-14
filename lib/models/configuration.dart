import 'dart:io';

class Configuration {
  final Directory imageDir;
  final int width;
  final int height;
  final String searchTerm;
  final String prefixFile;
  final bool skipFiles;

  const Configuration(
    this.imageDir,
    this.width,
    this.height,
    this.searchTerm,
    this.prefixFile,
    this.skipFiles,
  );

  factory Configuration.load(
    Directory imageDir, {
    int? width,
    int? height,
    String? searchTerm,
    String? prefixFile,
    bool? skipFiles
  }) {
    return Configuration(
      imageDir,
      width ?? 400,
      height ?? 400,
      searchTerm ?? 'logo',
      prefixFile ?? '',
      skipFiles ?? false
    );
  }

  @override
  String toString() =>
      "[imageDir Path]: ${imageDir.path}, [width]: $width, [height]: $height, [searchTerm]: $searchTerm, [prefixFile]: $prefixFile [skipFiles]: $skipFiles";
}
