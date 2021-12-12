library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';

import '../src/models/terms_and_conditions.dart';

abstract class Geiger {
  /// @return Future<String>
  Future<String> onBtnPressed(StorageController storageController);

  ///Initial localstorage with data
  Future<void> initialGeigerDummyData(TermsAndConditions termsAndConditions,
      StorageController storageController);
}
