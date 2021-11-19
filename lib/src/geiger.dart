library geiger_dummy_data;

import '../src/models/terms_and_conditions.dart';

abstract class Geiger {
  /// @return Future<String>
  Future<String> onBtnPressed();

  ///Initial localstorage with data
  Future<void> initialGeigerDummyData(TermsAndConditions termsAndConditions);
}
