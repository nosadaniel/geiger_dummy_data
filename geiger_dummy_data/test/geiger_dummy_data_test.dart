import 'package:geiger_dummy_data/src/geiger_user.dart';
import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:test/test.dart';

void main() {
  StorageController storageController =
      GenericController("test", SqliteMapper("./test.db"));
  GeigerUserTest.setCurrentUser(storageController);

  // all test related to setting nodevalue
  //NodeValueTest.SetNodesValue(storageController);
}

class GeigerUserTest {
  static void setCurrentUser(StorageController storageController) {
    GeigerUser geigerUser = GeigerUser(storageController);
    group("Users", () {
      test("set CurrentUser in :Local NodeValue", () {
        expect(
            geigerUser.setCurrentUser =
                '[{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}]',
            '[{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}]');
      });
      test("getCurrentUser", () {
        expect(
            geigerUser.getCurrentUser(),
            User.fromJSon(
                '[{"userId":"1", "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}]'));
      });
    });
  }
}
