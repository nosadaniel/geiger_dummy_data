library geiger_dummy_data;

import 'package:geiger_dummy_data/src/geiger_listen.dart';
import '/src/models/geiger_data.dart';

class Geiger implements GeigerListen {
  @override
  Future<GeigerData> onBtnPress() {
    throw UnimplementedError();
  }
}
