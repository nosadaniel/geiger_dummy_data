library geiger_dummy_data;

abstract class Geiger {
  /// @return Future<String>
  Future<String> storeData();

  ///Initial localstorage with data
  Future<void> initialGeigerDummyData();
}
