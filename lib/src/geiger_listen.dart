library geiger_dummy_data;

import '/src/models/geiger_data.dart';

/// <p>Listener interface for Geiger.</p>
abstract class GeigerListen {
  /// @return geigerData as a Future
  Future<GeigerData> onBtnPress();
}
