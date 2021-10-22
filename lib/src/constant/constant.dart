import 'package:uuid/uuid.dart';

class GeigerConstant {
  static String GEIGER_INDICATOR_UUID = "fasfadsfasfadsfasfas";

  static String get uuid {
    ///Generate a v4 (random) id
    return Uuid().v4();
  }
}

enum Type { device, user }
enum Weight { High, Medium, Low }
