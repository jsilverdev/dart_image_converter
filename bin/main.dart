import 'package:image_converter/config.dart';
import 'package:image_converter/image_converter.dart';
import 'package:image_converter/models/process_image_result.dart';
import 'package:image_converter/setup.dart';
import 'package:image_converter/utils/common.dart';

void main(List<String> arguments) async {
  try {
    final configuration = await loadConfiguration();
    initialSetup(configuration.skipFiles);

    FilesResult result = findFilesByConfig(configuration);
    processFiles(result.files, configuration);

    checkFailedPaths(result.failedPaths, configuration.searchTerm);
  } catch (e) {
    simpleErrorPrint(e);
  }
}
