import 'package:image_converter/config.dart';
import 'package:image_converter/models/configuration.dart';
import 'package:image_converter/utils/utils.dart';

void main(List<String> arguments) async {
  try {
    Configuration config = await loadConfig();
    simplePrint(config);

    await for (var entity in config.imageDir.list(
      recursive: false,
      followLinks: false,
    )) {
      simplePrint(entity.path);
    }

  } catch (e) {
    simplePrint(e);
  }
}
