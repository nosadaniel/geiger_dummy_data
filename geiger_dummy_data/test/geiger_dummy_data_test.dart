import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_dummy_data/src/initial_data.dart';
import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  StorageController storageController =
      GenericController("test", SqliteMapper("./nosa.db"));
  // all test related to retrieving nodeValue
  NodeValueTest.getNodesValue(storageController);

  // all test related to setting nodevalue
  //NodeValueTest.SetNodesValue(storageController);
}

class NodeValueTest {
  static void getNodesValue(StorageController storageController) {
    group("get nodeValue", () {
      test('getThreats', () {
        InitialData initial = InitialData(storageController);
        expect(
            initial.getThreats(
                '[{"threatId":"1","name":"phishing"},{"threatId":"2","name":"malware"}]'),
            [
              Threat(threatId: "1", name: "phishing"),
              Threat(threatId: "2", name: "malware")
            ],
            reason: "Pass test");
      });
      test("getCurrentUser", () {
        InitialData initialData = InitialData(storageController);
        expect(
            initialData.getCurrentUser('[{"userId":"1"}]'), '[{"userId":"1"}]');
      });
    });
  }

  static void SetNodesValue(StorageController storageController) {
    group("set nodeValue", () {
      test("NodeValue in :Local", () {
        InitialData initial = InitialData(storageController);
        expect(initial.setCurrentUser = '[{"userId":"1"}]', User);
      });
    });
  }
}
