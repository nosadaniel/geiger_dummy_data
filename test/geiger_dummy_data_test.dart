import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/geiger_aggregate_score.dart';
import 'package:geiger_dummy_data/src/geiger_user.dart';
import 'package:geiger_dummy_data/src/models/ids.dart';
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
            '{"userId":"00455d61-7f93-45e2-b9df-f03de641853e","firstName":"matthew", "lastName":null, "role":{"roleId":"a39e473b-bc9e-43aa-a210-da85d8c9792b", "name":null}}');

        //setCurrentGeigerUserScore
        geigerUser.setCurrentGeigerUserScoreNodeAndNodeValue(
            currentUser: geigerUser.getCurrentUserInfo,
            threatScores: ThreatScore.fromJSon(
                '[{"threat":{"threatId":"dd8fdb40-022d-41e8-ac21-51d5113b308b","name":"phishing"},"score":"25"}]'),
            geigerScore: "90");
      });

      test("getCurrentUserInfo", () {
        expect(
            geigerUser.getCurrentUserInfo,
            equals(User.currentUserFromJSon(
                '{"userId":"00455d61-7f93-45e2-b9df-f03de641853e","firstName":"matthew", "lastName":null, "role":{"roleId":"a39e473b-bc9e-43aa-a210-da85d8c9792b", "name":null}}')));
      });

      test("getCurrentUserGeigerThreatScore", () {
        expect(
            geigerUser.getCurrentGeigerUserThreatScores,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"dd8fdb40-022d-41e8-ac21-51d5113b308b","name":"phishing"},"score":"25"}]')));
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
                '[{"threat":{"threatId":"dd8fdb40-022d-41e8-ac21-51d5113b308b","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"}]'),
            GeigerUser(_storageController).getCurrentUserInfo);
      });

      test("getGeigerAggregateThreatScore", () {
        expect(
            GeigerAggregateScore(_storageController).getGeigerScoreAggregate,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"dd8fdb40-022d-41e8-ac21-51d5113b308b","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"}]')));
      });
    });
  }
}

class GeigerDeviceTest {
  StorageController _storageController;

  GeigerDeviceTest(this._storageController);

  void deviceGroupTest() {
    GeigerDevice geigerDevice = GeigerDevice(_storageController);
    GeigerUser geigerUser = GeigerUser(_storageController);
    group("GeigerDeviceGroupTest", () {
      setUp(() {
        // set currentDevice
        geigerDevice.setCurrentDeviceInfo = Device.currentDeviceFromJSon(
            '{"owner":${User.convertToJsonCurrentUser(geigerUser.getCurrentUserInfo)},"deviceId":"d62f5015-c790-48ae-83d0-2ae2f4a073ce","name":"Iphone","type":"mobile"}');

        // set list of threats for currentDevice
        geigerDevice.setCurrentGeigerScoreDeviceNodeAndNodeValue(
            geigerScore: "89",
            currentDevice: geigerDevice.getCurrentDeviceInfo,
            threatScores: ThreatScore.fromJSon(
                '[{"threat":{"threatId":"5e5eb533-7b81-457c-92bc-76a3acd27cca","name":"phishing"},"score":"25"},{"threat":{"threatId":"83968e5c-7201-4b58-a5d1-efdb85b837e0","name":"malware"},"score":"45"},{"threat":{"threatId":"9e4d4366-4a8e-4c9e-877a-7baccd9d98bf","name":"cyber Attack"},"score":"50"}]'));
      });

      test("getGeigerCurrentDeviceInfo", () {
        expect(
            geigerDevice.getCurrentDeviceInfo,
            equals(Device.currentDeviceFromJSon(
                '{"owner":${User.convertToJsonCurrentUser(geigerUser.getCurrentUserInfo)},"deviceId":"d62f5015-c790-48ae-83d0-2ae2f4a073ce","name":"Iphone","type":"mobile"}')));
      });

      test("getGeigerCurrentDeviceThreatScore", () {
        expect(
            geigerDevice.getCurrentDeviceThreatScores,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"5e5eb533-7b81-457c-92bc-76a3acd27cca","name":"phishing"},"score":"25"},{"threat":{"threatId":"83968e5c-7201-4b58-a5d1-efdb85b837e0","name":"malware"},"score":"45"},{"threat":{"threatId":"9e4d4366-4a8e-4c9e-877a-7baccd9d98bf","name":"cyber Attack"},"score":"50"}]')));
      });

      test("getCurrentDeviceGeigerScore", () {
        expect(geigerDevice.getCurrentGeigerDeviceScore, equals("89"));
      });

      test("test UUids", () {
        expect(Id(uuid: "95b41e00-3312-11ec-a9f3-fd9a28936c03"),
            Id(uuid: "95b41e00-3312-11ec-a9f3-fd9a28936c03"));
      });
    });
  }
}
