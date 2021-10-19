import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_dummy_data/src/geiger_device.dart';
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
      test("getCurrentUser", () {
        GeigerDevice initialData = GeigerDevice(storageController);
      });
    });
  }

  static void SetNodesValue(StorageController storageController) {
    group("set nodeValue", () {});
  }
}
