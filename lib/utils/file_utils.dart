import 'package:diacritic/diacritic.dart';

String getCustomFileName({
  required String dirName,
  required String extension,
  String prefixFile = '',
}) {
  dirName = removeDiacritics(dirName).replaceAll(" ", "_").toUpperCase();

  String fileName = "$dirName$extension";
  if (prefixFile.isNotEmpty) fileName = "${prefixFile.toUpperCase()}_$fileName";

  return fileName;
}
