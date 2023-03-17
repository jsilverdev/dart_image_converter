import 'package:diacritic/diacritic.dart';
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
