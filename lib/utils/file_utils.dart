import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;

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

bool isValidMimeType(File file) {
  return validMimeTypes.containsValue(mime.lookupMimeType(file.path));
}

Map<String, String> validMimeTypes = {
  "jpg" : "image/jpeg",
  "png" : "image/png",
  "gif" : "image/gif",
  "bmp" : "image/bmp",
  "tiff": "image/tiff",
  "ico" : "image/x-icon",
  "webp": "image/webp",
  "psd" : "image/vnd.adobe.photoshop",
  "pdf" : "application/pdf",
};

String getFileType(File file) {
  return mime.lookupMimeType(file.path)!.split("/").first;
}
