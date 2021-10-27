import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/geiger_aggregate_score.dart';
import 'package:geiger_dummy_data/src/geiger_recommendation.dart';
import 'package:geiger_dummy_data/src/geiger_user.dart';

import 'package:geiger_dummy_data/src/models/recommendation.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_dummy_data/src/models/threat_recommendation.dart';
import 'package:test/test.dart';

void main() {
  StorageController _storageController =
      GenericController("test", SqliteMapper("./test.db"));

  //geigerThreat
  GeigerThreatTest geigerThreatTest = GeigerThreatTest(_storageController);
  geigerThreatTest.threatGroupTest();

  //geigerUserTest
  GeigerUserTest geigerUserTest = GeigerUserTest(_storageController);
  geigerUserTest.userGroupTest();

  //aggregateTest
  GeigerAggregateScoreTest geigerAggregateScoreTest =
      GeigerAggregateScoreTest(_storageController);
  geigerAggregateScoreTest.aggregateGroupTest();

  //geigerDeviceTest
  GeigerDeviceTest geigerDeviceTest = GeigerDeviceTest(_storageController);
  geigerDeviceTest.deviceGroupTest();

  //geigerRecommendation
  //Test passed but failed to compare
  GeigerRecommendationTest geigerRecommendationTest =
      GeigerRecommendationTest(_storageController);
  geigerRecommendationTest.recommendationGroupTest();
}

class GeigerThreatTest {
  StorageController _storageController;

  GeigerThreatTest(this._storageController);

  void threatGroupTest() {
    GeigerThreat geigerThreat = GeigerThreat(_storageController);
    group("threatGroupTest", () {
      setUp(() {
        geigerThreat.setGlobalThreatsNode = Threat.convertFromJson(
            '[{"threatId":"6d42f926-8107-48ff-8e96-0a9f791429ae","name":"phishing"},{"threatId":"92f5fa23-d5c8-4d77-ba39-8b5ca9df547a","name":"malware"},{"threatId":"92f5fa23-d5c8-4d77-ba39-8b5ca9df548a","name":"web attack"}]');
      });
      test("getThreatList", () {
        expect(
            geigerThreat.getThreats,
            equals(Threat.convertFromJson(
                '[{"threatId":"6d42f926-8107-48ff-8e96-0a9f791429ae","name":"phishing"},{"threatId":"92f5fa23-d5c8-4d77-ba39-8b5ca9df547a","name":"malware"},{"threatId":"92f5fa23-d5c8-4d77-ba39-8b5ca9df548a","name":"web attack"}]')));
      });
    });
  }
}

class GeigerUserTest {
  StorageController _storageController;

  GeigerUserTest(this._storageController);

  void userGroupTest() {
    GeigerUser geigerUser = GeigerUser(_storageController);
    group("currentUserGroupTest:", () {
      setUp(() {
        //setCurrentUser
        geigerUser.setCurrentUserInfo = User.convertUserFromJson(
            '{"userId":"25bc506d-938a-4cde-954d-d1f733a90092","firstName":"matthew", "lastName":null, "role":{"roleId":"a39e473b-bc9e-43aa-a210-da85d8c9792b", "name":null}}');

        //setCurrentGeigerUserScore
        geigerUser.setCurrentGeigerUserScoreNodeAndNodeValue(
            currentUser: geigerUser.getCurrentUserInfo,
            threatScores: ThreatScore.convertFromJson(
                '[{"threat":{"threatId":"dd8fdb40-022d-41e8-ac21-51d5113b308b","name":"phishing"},"score":"25"}]'),
            geigerScore: "90");

        //set recommendations
        GeigerRecommendation(_storageController).setGlobalRecommendationsNode =
            Recommendation.convertFromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"medium"}],"description":{"shortDescription":"Email filtering","longDescription":"very long"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber"}}]');

        //setGeigerUserRecommendation
        geigerUser.setCurrentUserGeigerThreatRecommendation =
            Threat(threatId: "t2", name: "malware");
      });

      test("getCurrentUserInfo", () {
        expect(
          geigerUser.getCurrentUserInfo,
          equals(User.convertUserFromJson(
              '{"userId":"25bc506d-938a-4cde-954d-d1f733a90092","firstName":"matthew", "lastName":null, "role":{"roleId":"a39e473b-bc9e-43aa-a210-da85d8c9792b", "name":null}}')),
        );
      });

      test("getCurrentUserGeigerScore", () {
        expect(geigerUser.getCurrentGeigerUserScore, equals("90"));
      });

      test("getCurrentUserThreatRecommendation", () {
        expect(
            geigerUser.getCurrentUserGeigerThreatRecommendation(
                threat: Threat(threatId: "t2", name: "malware")),
            equals(ThreatRecommendation.convertFromJson(
                '[{"recommendationId":"123rec", "threatWeight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"medium" }, "descriptionShortLong":{"shortDescription":"Email filtering", "longDescription":"very long"}}]')));
      });

      test("setUserImplementedRecommendation", () {
        String r = geigerUser
            .getCurrentUserGeigerThreatRecommendation(
                threat: Threat(threatId: "t2", name: "malware"))[0]
            .recommendationId;
        expect(geigerUser.setUserImplementedRecommendation(recommendationId: r),
            equals(true));
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
            threatScores: ThreatScore.convertFromJson(
                '[{"threat":{"threatId":"dd8fdb40-022d-41e8-ac21-51d5113b308b","name":"phishing"},"score":"25"},{"threat":{"threatId":"w1","name":"malware"},"score":"45"}]'),
            currentUser: GeigerUser(_storageController).getCurrentUserInfo);
      });

      test("getGeigerAggregateThreatScore", () {
        expect(
            GeigerAggregateScore(_storageController).getGeigerScoreAggregate,
            equals(ThreatScore.convertFromJson(
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
        geigerDevice.setCurrentDeviceInfo = Device.convertDeviceFromJson(
            '{"owner":${User.convertUserToJson(geigerUser.getCurrentUserInfo)},"deviceId":"d62f5015-c790-48ae-83d0-2ae2f4a073ce","name":"Iphone","type":"mobile"}');

        // set list of threats for currentDevice
        geigerDevice.setCurrentGeigerScoreDeviceNodeAndNodeValue(
            geigerScore: "89",
            currentDevice: geigerDevice.getCurrentDeviceInfo,
            threatScores: ThreatScore.convertFromJson(
                '[{"threat":{"threatId":"5e5eb533-7b81-457c-92bc-76a3acd27cca","name":"phishing"},"score":"25"},{"threat":{"threatId":"83968e5c-7201-4b58-a5d1-efdb85b837e0","name":"malware"},"score":"45"},{"threat":{"threatId":"9e4d4366-4a8e-4c9e-877a-7baccd9d98bf","name":"cyber Attack"},"score":"50"}]'));

        //set global recommendations
        GeigerRecommendation(_storageController).setGlobalRecommendationsNode =
            Recommendation.convertFromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"Email filtering","longDescription":"very long"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber","longDescription":"very long2"}}]');

        //setGeigerCurrentDeviceRecommendation
        geigerDevice.setCurrentDeviceGeigerRecommendation =
            Threat(threatId: "t2", name: "malware");
      });

      test("getGeigerCurrentDeviceInfo", () {
        expect(
            geigerDevice.getCurrentDeviceInfo,
            equals(Device.convertDeviceFromJson(
                '{"owner":${User.convertUserToJson(geigerUser.getCurrentUserInfo)},"deviceId":"d62f5015-c790-48ae-83d0-2ae2f4a073ce","name":"Iphone","type":"mobile"}')));
      });

      test("getGeigerCurrentDeviceGeigerThreatScore", () {
        expect(
            geigerDevice.getCurrentDeviceGeigerThreatScores,
            equals(ThreatScore.convertFromJson(
                '[{"threat":{"threatId":"5e5eb533-7b81-457c-92bc-76a3acd27cca","name":"phishing"},"score":"25"},{"threat":{"threatId":"83968e5c-7201-4b58-a5d1-efdb85b837e0","name":"malware"},"score":"45"},{"threat":{"threatId":"9e4d4366-4a8e-4c9e-877a-7baccd9d98bf","name":"cyber Attack"},"score":"50"}]')));
      });

      test("getCurrentDeviceGeigerScore", () {
        expect(geigerDevice.getCurrentGeigerDeviceScore, equals("89"));
      });

      // getCurrentDeviceGeigerThreatRecommendation
      test("getCurrentDeviceGeigerThreatRecommendation", () {
        expect(
            geigerDevice.getCurrentDeviceThreatRecommendation(
                threat: Threat(threatId: "t2", name: "malware")),
            equals(ThreatRecommendation.convertFromJson(
                '[{"recommendationId":"124rec", "threatWeight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"Low" }, "descriptionShortLong":{"shortDescription":"cyber","longDescription":"very long2"} }]')));
      });

      test("setDeviceImplementedRecommendation", () {
        String r = geigerDevice
            .getCurrentDeviceThreatRecommendation(
                threat: Threat(threatId: "t2", name: "malware"))[0]
            .recommendationId;
        expect(
            geigerDevice.setDeviceImplementedRecommendation(
                recommendationId: r),
            equals(true));
      });
    });
  }
}

class GeigerRecommendationTest {
  StorageController _storageController;

  GeigerRecommendationTest(this._storageController);

  void recommendationGroupTest() {
    GeigerRecommendation geigerRecommendation =
        GeigerRecommendation(_storageController);

    group("RecommendationGroupTest", () {
      setUp(() {
        //set recommendations
        geigerRecommendation.setGlobalRecommendationsNode =
            Recommendation.convertFromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"Email filtering","longDescription":"very long1"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber","longDescription":"very long2"}}]');
      });

      test("getRecommendation", () {
        expect(
            geigerRecommendation.getRecommendations,
            equals(Recommendation.convertFromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"Email filtering","longDescription":"very long1"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber", "longDescription":"very long2"}}]')));
      });

      test("getThreatRecommendations", () {
        expect(
            geigerRecommendation.getThreatRecommendation(
                threat: Threat.fromJson({"threatId": "t2", "name": "malware"}),
                recommendationType: "user"),
            equals(ThreatRecommendation.convertFromJson(
                '[{"recommendationId":"123rec", "threatWeight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"Low" }, "descriptionShortLong":{"shortDescription":"Email filtering","longDescription":"very long1"} }]')));
      });
    });
  }
}

//Todo
//implemented user recommendations in GeigerScoreUser Node
//implementedRecommendations NodeValue and store implemented recommendationId in the nodevalue
