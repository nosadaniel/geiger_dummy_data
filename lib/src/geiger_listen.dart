library geiger_dummy_data;

/// <p>Listener interface for Geiger.</p>
abstract class GeigerListen {
  /// @return Future<String>
  Future<String> onBtnPressed();

  ///Initial localstorage with data
  Future<void> initialLocalData();
}
