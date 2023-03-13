import 'package:dotenv/dotenv.dart';
import 'package:image_converter/utils/utils.dart';

void main(List<String> arguments) {
  final DotEnv env = DotEnv(includePlatformEnvironment: false)..load();

  simplePrint(env["IMAGES_PATH"]);
}
