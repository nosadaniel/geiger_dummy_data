import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/geiger_aggregate_score.dart';
import 'package:geiger_dummy_data/src/geiger_user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:test/test.dart';

void main() {
  StorageController _storageController =
      GenericController("test", SqliteMapper("./test.db"));

  // geigerUserTest
  GeigerUserTest geigerUserTest = GeigerUserTest(_storageController);
  geigerUserTest.userGroupTest();

  //aggregateTest
  GeigerAggregateScoreTest geigerAggregateScoreTest =
      GeigerAggregateScoreTest(_storageController);
  geigerAggregateScoreTest.aggregateGroupTest();

  //geigerDeviceTest
  GeigerDeviceTest geigerDeviceTest = GeigerDeviceTest(_storageController);
  geigerDeviceTest.deviceGroupTest();
}

class GeigerUserTest {
  StorageController _storageController;
  GeigerUserTest(this._storageController);

  void userGroupTest() {
    GeigerUser geigerUser = GeigerUser(_storageController);
    group("currentUserGroupTest:", () {
      setUp(() {
        //setCurrentUser
        geigerUser.setCurrentUserInfo = User.currentUserFromJSon(
            '{"firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}');

        //setCurrentGeigerUserScore
        geigerUser.setCurrentGeigerUserScoreNodeAndNodeValue(
            currentUser: geigerUser.getCurrentUserInfo,
            threatScores: ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"}]'),
            geigerScore: "90");
      });

      test("getCurrentUser", () {
        expect(
            geigerUser.getCurrentUserInfo,
            equals(User.currentUserFromJSon(
                '{ "firstName":null, "lastName":null, "role":{"roleId":null, "name":null}}')));
      });

      test("getCurrentUserGeigerThreatScore", () {
        expect(
            geigerUser.getCurrentGeigerUserThreatScores,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"}]')));
      });

      test("getCurrentUserGeigerScore", () {
        expect(geigerUser.getCurrentGeigerUserScore, equals("90"));
      });
    });
  }
}

class GeigerAggregateScoreTest {
  StorageController _storageController;
  GeigerAggregateScoreTest(this._storageController);

  void aggregateGroupTest() {
    group("GeigerAggregateGroup", () {
      setUp(() {
        //set
        GeigerAggregateScore(_storageController).setGeigerScoreAggregate(
            ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"}]'),
            GeigerUser(_storageController).getCurrentUserInfo);
      });

      test("getGeigerAggregateThreatScore", () {
        expect(
            GeigerAggregateScore(_storageController).getGeigerScoreAggregate,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"}]')));
      });
    });
  }
}

class GeigerDeviceTest {
  StorageController _storageController;

  GeigerDeviceTest(this._storageController);

  void deviceGroupTest() {
    GeigerDevice geigerDevice = GeigerDevice(_storageController);
    group("GeigerDeviceGroupTest", () {
      setUp(() {
        // set currentDevice
        geigerDevice.setCurrentDeviceInfo = Device.currentDeviceFromJSon(
            '{"owner":{"firstName":null, "lastName":null, "role":{"roleId":null, "name":null}},"name":"Iphone","type":"mobile"}');

        // set list of threats for currentDevice
        geigerDevice.setCurrentGeigerScoreDeviceNodeAndNodeValue(
            geigerScore: "89",
            currentDevice: geigerDevice.getCurrentDeviceInfo,
            threatScores: ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"},{"threat":{"threatId":"c1","name":"cyber Attack"},"score":"50"}]'));
      });

      test("getGeigerCurrentDevice", () {
        expect(
            geigerDevice.getCurrentDeviceInfo,
            equals(Device.currentDeviceFromJSon(
                '{"owner":{"firstName":null, "lastName":null, "role":{"roleId":null, "name":null}},"name":"Iphone","type":"mobile"}')));
      });

      test("getGeigerCurrentDeviceThreatScore", () {
        expect(
            geigerDevice.getCurrentDeviceThreatScores,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"t1","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"},{"threat":{"threatId":"c1","name":"cyber Attack"},"score":"50"}]')));
      });

      test("getCurrentDeviceGeigerScore", () {
        expect(geigerDevice.getCurrentGeigerDeviceScore, equals("89"));
      });
    });
  }
}
