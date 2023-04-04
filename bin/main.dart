import 'package:image_converter/config.dart';
import 'package:image_converter/image_converter.dart';
import 'package:image_converter/setup.dart';
import 'package:image_converter/utils/common.dart';

void main(List<String> arguments) async {
  try {
    final configuration = await Config().loadConfiguration();

    Setup(configuration).initialSetup();

    ImageConverter(configuration)
      ..findValidFilesAndFailedPaths()
      ..resizeAndSaveValidFilesAsJpg()
      ..checkFailedPaths();

  } catch (e) {
    simpleErrorPrint(e.toString());
  }
}
