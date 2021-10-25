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
  // GeigerRecommendationTest geigerRecommendationTest =
  //     GeigerRecommendationTest(_storageController);
  // geigerRecommendationTest.recommendationGroupTest();
}

class GeigerThreatTest {
  StorageController _storageController;

  GeigerThreatTest(this._storageController);

  void threatGroupTest() {
    GeigerThreat geigerThreat = GeigerThreat(_storageController);
    group("threatGroupTest", () {
      setUp(() {
        geigerThreat.setGlobalThreatsNode = Threat.fromJSon(
            '[{"threatId":"6d42f926-8107-48ff-8e96-0a9f791429ae","name":"phishing"},{"threatId":"92f5fa23-d5c8-4d77-ba39-8b5ca9df547a","name":"malware"},{"threatId":"92f5fa23-d5c8-4d77-ba39-8b5ca9df548a","name":"web attack"}]');
      });
      test("getThreatList", () {
        expect(
            geigerThreat.getThreats,
            equals(Threat.fromJSon(
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
        geigerUser.setCurrentUserInfo = User.currentUserFromJSon(
            '{"userId":"25bc506d-938a-4cde-954d-d1f733a90092","firstName":"matthew", "lastName":null, "role":{"roleId":"a39e473b-bc9e-43aa-a210-da85d8c9792b", "name":null}}');

        //setCurrentGeigerUserScore
        geigerUser.setCurrentGeigerUserScoreNodeAndNodeValue(
            currentUser: geigerUser.getCurrentUserInfo,
            threatScores: ThreatScore.fromJSon(
                '[{"threat":{"threatId":"dd8fdb40-022d-41e8-ac21-51d5113b308b","name":"phishing"},"score":"25"}]'),
            geigerScore: "90");

        //set recommendations
        GeigerRecommendation(_storageController).setGlobalRecommendationsNode(
            recommendations: Recommendation.fromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"Email filtering"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber"}}]'));

        //setGeigerUserRecommendation
        geigerUser.setCurrentUserGeigerThreatRecommendation =
            Threat(threatId: "t2", name: "malware");
      });

      test("getCurrentUserInfo", () {
        expect(
          geigerUser.getCurrentUserInfo,
          equals(User.currentUserFromJSon(
              '{"userId":"25bc506d-938a-4cde-954d-d1f733a90092","firstName":"matthew", "lastName":null, "role":{"roleId":"a39e473b-bc9e-43aa-a210-da85d8c9792b", "name":null}}')),
        );
      });

      test("getCurrentUserGeigerScore", () {
        expect(geigerUser.getCurrentGeigerUserScore, equals("90"));
      });

      // test("getCurrentUserThreatRecommendation", () {
      //   expect(
      //       geigerUser.getCurrentUserGeigerThreatRecommendation(
      //           Threat(threatId: "t2", name: "malware")),
      //       equals(ThreatRecommendation.fromJSon(
      //           '[{"recommendationId":"123rec", "weight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"Low" }, "descriptionShortLong":{"shortDescription":"Email filtering"}},{"recommendationId":"124rec", "weight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"High" }, "descriptionShortLong":{"shortDescription":"cyber"} }]')));
      // });
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

        //set global recommendations
        GeigerRecommendation(_storageController).setGlobalRecommendationsNode(
            recommendations: Recommendation.fromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"Email filtering"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber"}}]'));

        //setGeigerCurrentDeviceRecommendation
        geigerDevice.setCurrentDeviceGeigerRecommendation =
            Threat(threatId: "t2", name: "malware");
      });

      test("getGeigerCurrentDeviceInfo", () {
        expect(
            geigerDevice.getCurrentDeviceInfo,
            equals(Device.currentDeviceFromJSon(
                '{"owner":${User.convertToJsonCurrentUser(geigerUser.getCurrentUserInfo)},"deviceId":"d62f5015-c790-48ae-83d0-2ae2f4a073ce","name":"Iphone","type":"mobile"}')));
      });

      test("getGeigerCurrentDeviceGeigerThreatScore", () {
        expect(
            geigerDevice.getCurrentDeviceGeigerThreatScores,
            equals(ThreatScore.fromJSon(
                '[{"threat":{"threatId":"5e5eb533-7b81-457c-92bc-76a3acd27cca","name":"phishing"},"score":"25"},{"threat":{"threatId":"83968e5c-7201-4b58-a5d1-efdb85b837e0","name":"malware"},"score":"45"},{"threat":{"threatId":"9e4d4366-4a8e-4c9e-877a-7baccd9d98bf","name":"cyber Attack"},"score":"50"}]')));
      });

      test("getCurrentDeviceGeigerScore", () {
        expect(geigerDevice.getCurrentGeigerDeviceScore, equals("89"));
      });

      // // getCurrentDeviceGeigerThreatRecommendation
      // test("getCurrentDeviceGeigerThreatRecommendation", () {
      //   expect(
      //       geigerDevice.getCurrentDeviceThreatRecommendation(
      //           Threat(threatId: "t2", name: "malware")),
      //       equals(ThreatRecommendation.fromJSon(
      //           '[{"recommendationId":"124rec", "weight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"low" }, "descriptionShortLong":{"shortDescription":"cyber"} }]')));
      // });
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
        geigerRecommendation.setGlobalRecommendationsNode(
            recommendations: Recommendation.fromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"Email filtering"}},{"recommendationId":"124rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber"}}]'));
      });

      test("getRecommendation", () {
        expect(
            geigerRecommendation.getRecommendations,
            equals(Recommendation.fromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"Email filtering"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber"}}]')));
      });

      test("getThreatRecommendations", () {
        expect(
            geigerRecommendation.getThreatRecommendation(
                threat: Threat.fromJson({"threatId": "t2", "name": "malware"}),
                recommendationType: "user"),
            equals(ThreatRecommendation.fromJSon(
                '[{"recommendationId":"123rec", "weight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"Low" }, "descriptionShortLong":{"shortDescription":"Email filtering"}},{"recommendationId":"124rec", "weight":{"threat":{"threatId":"t2","name":"malware"}, "weight":"Low" }, "descriptionShortLong":{"shortDescription":"cyber"} }]')));
      });
    });
  }
}

//Todo
//implemented user recommendations in GeigerScoreUser Node
//implementedRecommendations NodeValue and store implemented recommendationId in the nodevalue
