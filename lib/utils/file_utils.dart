import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;
import 'package:pdfium_bindings/pdfium_bindings.dart';

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
  "pdf" : "application/pdf",
};

bool checkFileType(File file, String fileType) {
  return mime.lookupMimeType(file.path) == validMimeTypes[fileType];
}

void imageFromPdfFile(File pdfFile, int width, int height, String outPath) {
  PdfiumWrap()
      .loadDocumentFromBytes(pdfFile.readAsBytesSync())
      .loadPage(0)
      .savePageAsJpg(outPath, width: width, height: height)
      .closePage()
      .closeDocument()
      .dispose();
}
