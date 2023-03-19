import 'package:image_converter/config.dart';
import 'package:image_converter/image_converter.dart';
import 'package:image_converter/models/configuration.dart';
import 'package:image_converter/models/process_image_result.dart';
import 'package:image_converter/setup.dart';
import 'package:image_converter/utils/common.dart';

void main(List<String> arguments) async {
  try {
    Configuration config = await loadConfig();
    initialSetup(config.skipFiles);

    LogoFilesResult result = findLogoFilesByConfig(config);
    await resizeImages(result.logoFiles, config);

    checkFailedPaths(result.failedPaths, config.searchTerm);
  } catch (e) {
    simpleErrorPrint(e);
  }
}
