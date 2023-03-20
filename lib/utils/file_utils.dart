import 'package:diacritic/diacritic.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;

String getCustomFilePath({
  required String parentPath,
  required String dirName,
  required String extension,
  String prefixFile = '',
}) {
  dirName = removeDiacritics(dirName).replaceAll(" ", "_").toUpperCase();

  String fileName = "$dirName$extension";
  if (prefixFile.isNotEmpty) fileName = "${prefixFile.toUpperCase()}_$fileName";

  return path.join(parentPath, fileName);
}

bool isValidMimeType(String filePath) {
  return validMimeTypes.containsValue(mime.lookupMimeType(filePath));
}

Map<String, String> validMimeTypes = {
  "jpg" : "image/jpeg",
  "png" : "image/png",
  "gif" : "image/gif",
  "bmp" : "image/bmp",
  "ico" : "image/x-icon",
  "webp": "image/webp",
  "psd" : "image/vnd.adobe.photoshop",
  // "pdf" : "application/pdf",
};
