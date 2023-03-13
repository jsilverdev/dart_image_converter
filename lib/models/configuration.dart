import 'dart:io';

class Configuration {
  final Directory imageDir;
  final double width;
  final double height;

  const Configuration(
    this.imageDir,
    this.width,
    this.height,
  );

  factory Configuration.load(
    Directory imageDir, {
    double? width,
    double? height,
  }) {
    return Configuration(imageDir, width ?? 400, height ?? 400);
  }

  @override
  String toString() => "[imageDir Path]: ${imageDir.path}, [width]: $width, [height]: $height";
}
