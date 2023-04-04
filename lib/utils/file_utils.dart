import 'package:diacritic/diacritic.dart';
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;

String sanitizeText(
  String text,
) {
  return removeDiacritics(text).replaceAll(" ", "_").toUpperCase();
}

bool isValidExtension(String filePath, {required List<String> extensions}) {
  return extensions.contains(
    path.extension(filePath).substring(1).toLowerCase(),
  );
}

bool isImageFileType(String filePath) {
  return mime.lookupMimeType(filePath)!.split("/").first == "image";
}