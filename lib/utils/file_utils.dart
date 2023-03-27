import 'package:diacritic/diacritic.dart';
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;


FileUtils fileUtils = FileUtils();

String sanitizeText(
  String text,
) {
  return removeDiacritics(text).replaceAll(" ", "_").toUpperCase();
}

bool isValidExtension(String filePath) {
  return fileUtils.validFileExtensions.contains(
    path.extension(filePath).substring(1),
  );
}

bool isImageFileType(String filePath) {
  return mime.lookupMimeType(filePath)!.split("/").first == "image";
}

class FileUtils {

  List<String> get validFileExtensions => fileUtils._validFileExtensions;

  final List<String> _validFileExtensions = [
    "jpg",
    "png",
    "gif",
    "bmp",
    "tiff",
    "ico",
    "webp",
    "psd",
    "pdf",
  ];
}
