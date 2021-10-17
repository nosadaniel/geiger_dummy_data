import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_dummy_data/src/initial_data.dart';
import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  test('getThreats', () {
    StorageController _storageController =
        GenericController("test", DummyMapper());
    InitialData calculator = InitialData(_storageController);
    expect(
        calculator.getThreats(
            '[{"threatId":"1","name":"phishing"},{"threatId":"2","name":"malware"}]'),
        [
          Threat(threatId: "1", name: "phishing"),
          Threat(threatId: "2", name: "malware")
        ],
        reason: "Pass test");
  });
}
