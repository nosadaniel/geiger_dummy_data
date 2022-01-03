library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';

abstract class Geiger {
  /// @return Future<String>
  Future<String> _storeData(StorageController storageController);

  ///Initial localstorage with data
  Future<void> initialGeigerDummyData(StorageController storageController);
}
