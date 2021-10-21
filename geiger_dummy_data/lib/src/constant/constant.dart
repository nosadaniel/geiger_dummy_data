import 'package:uuid/uuid.dart';

class GeigerConstant {
  static String GEIGER_INDICATOR_UUID = "fasfadsfasfadsfasfas";

  static String generateIds() {
    // Generate a v1 (time-based) id
    return Uuid().v1();
  }
}
