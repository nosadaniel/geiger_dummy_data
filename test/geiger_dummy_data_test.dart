import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/geiger.dart';
import 'package:geiger_dummy_data/src/models/geiger_score_threats.dart';
import 'package:geiger_dummy_data/src/recommendation_node.dart';
import 'package:geiger_dummy_data/src/user_node.dart';
import 'package:geiger_dummy_data/src/models/recommendation.dart';
import 'package:geiger_dummy_data/src/models/threat.dart';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';
import 'package:test/test.dart';

void main() {
  StorageController _storageController =
      GenericController("test", SqliteMapper("./test.sqlite"));

  //geigerThreat
  GeigerThreatTest geigerThreatTest = GeigerThreatTest(_storageController);
  geigerThreatTest.threatGroupTest();

  //geigerUserTest
  GeigerUserTest geigerUserTest = GeigerUserTest(_storageController);
  geigerUserTest.userGroupTest();

  //geigerDeviceTest
  GeigerDeviceTest geigerDeviceTest = GeigerDeviceTest(_storageController);
  geigerDeviceTest.deviceGroupTest();

  //geigerRecommendation
  //Test passed but failed to compare
  GeigerRecommendationTest geigerRecommendationTest =
      GeigerRecommendationTest(_storageController);
  geigerRecommendationTest.recommendationGroupTest();

  //GeigerOnBtnPressedTest
  GeigerOnBtnPressedTest(_storageController).onBtnPressedTest();
}

class GeigerThreatTest {
  StorageController _storageController;

  GeigerThreatTest(this._storageController);

  void threatGroupTest() {
    ThreatNode geigerThreat = ThreatNode(_storageController);
    group("threatGroupTest", () {
      setUp(() {
        geigerThreat.setGlobalThreatsNode(
            threats: Threat.convertFromJson(
                '[{"name":"phishing"},{"name":"malware"},{"name":"web attack"}]'));
      });
      test("getThreatList", () {
        geigerThreat.getThreats();
      });
    });
  }
}

class GeigerUserTest {
  StorageController _storageController;

  GeigerUserTest(this._storageController);

  void userGroupTest() {
    UserNode geigerUser = UserNode(_storageController);
    ThreatNode _threatNode = ThreatNode(_storageController);
    group("currentUserGroupTest:", () {
      setUp(() {
        //setCurrentUser
        geigerUser.setUserInfo = User.convertUserFromJson(
            '{"firstName":"matthew", "lastName":"doe", "role":{ "name":"CEO"}}');

        //setCurrentGeigerUserScore
        List<String> userScores = ["44", "50", "70"];
        List<Threat> userThreats = _threatNode.getThreats();
        List<ThreatScore> threatsScore = [];
        for (int i = 0; i < userThreats.length; i++) {
          threatsScore
              .add(ThreatScore(threat: userThreats[i], score: userScores[i]));
        }
        geigerUser.setGeigerUserScore(
            geigerScoreThreats: GeigerScoreThreats(
                threatScores: threatsScore, geigerScore: "45"));

        //setAggregate
        List<String> AggScores = ["20", "70", "90"];
        List<Threat> AggThreats = _threatNode.getThreats();
        List<ThreatScore> aggThreatsScore = [];
        for (int i = 0; i < AggThreats.length; i++) {
          aggThreatsScore
              .add(ThreatScore(threat: AggThreats[i], score: AggScores[i]));
        }
        geigerUser.setGeigerScoreAggregate(
            geigerScoreThreats: GeigerScoreThreats(
                threatScores: aggThreatsScore, geigerScore: "50"));

        //check this
        //set recommendations
        RecommendationNode(_storageController).setGlobalRecommendationsNode(
            recommendations: Recommendation.convertFromJSon(
                '[{"recommendationId":"123rec","recommendationType":"user", "relatedThreatsWeight":[{"threat":{"threatId":"t1","name":"phishing"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"medium"}],"description":{"shortDescription":"Email filtering","longDescription":"very long"}},{"recommendationId":"124rec","recommendationType":"device", "relatedThreatsWeight":[{"threat":{"threatId":"t3","name":"phishing web"},"weight":"High"},{"threat":{"threatId":"t2","name":"malware"},"weight":"Low"}],"description":{"shortDescription":"cyber"}}]'));

        //setGeigerUserRecommendation
        geigerUser.setUserThreatRecommendation(
            language: Locale.parse("de-ch"),
            threat: Threat(threatId: "t2", name: "malware"));
      });

      test("getCurrentUserInfo", () {
        geigerUser.getUserInfo;
      });

      test("getCurrentUserThreat", () {
        geigerUser.getGeigerScoreUserThreatScores(language: "fr");
      });

      test("getGeigerAggregateThreatScore", () {
        geigerUser.getGeigerScoreAggregateThreatScore(language: "de-ch");
      });

      //check this
      // test("getCurrentUserThreatRecommendation", () {
      //   geigerUser.getUserThreatRecommendation(
      //       threat: _threatNode.getThreats().last);
      // });

      // test("setUserImplementedRecommendation", () {
      //   String r = geigerUser
      //       .getUserThreatRecommendation(threat: _threatNode.getThreats().first)
      //       .first
      //       .recommendationId;
      //
      //   expect(geigerUser.setUserImplementedRecommendation(recommendationId: r),
      //       equals(true));
      // });
    });
  }
}

class GeigerDeviceTest {
  StorageController _storageController;

  GeigerDeviceTest(this._storageController);

  void deviceGroupTest() {
    DeviceNode geigerDevice = DeviceNode(_storageController);
    UserNode geigerUser = UserNode(_storageController);
    ThreatNode _threatNode = ThreatNode(_storageController);
    group("GeigerDeviceGroupTest", () {
      setUp(() {
        // set currentDevice
        geigerDevice.setCurrentDeviceInfo = Device.convertDeviceFromJson(
            '{"owner":${User.convertUserToJson(geigerUser.getUserInfo!)},"deviceId":"d62f5015-c790-48ae-83d0-2ae2f4a073ce","name":"Iphone","type":"mobile"}');

        // set list of threats for currentDevice
        List<String> deviceScores = ["24", "20", "80"];
        List<Threat> deviceThreats = _threatNode.getThreats();
        List<ThreatScore> threatsScore = [];
        for (int i = 0; i < deviceThreats.length; i++) {
          threatsScore.add(
              ThreatScore(threat: deviceThreats[i], score: deviceScores[i]));
        }
        geigerDevice.setGeigerScoreDevice(
            geigerScoreThreats: GeigerScoreThreats(
                threatScores: threatsScore, geigerScore: "23"));

        //set global recommendations
        List<ThreatWeight> threatWeight = [];
        List<String> weights = ["High", "Medium", "Low"];
        for (int i = 0; i < deviceThreats.length; i++) {
          threatWeight
              .add(ThreatWeight(threat: deviceThreats[i], weight: weights[i]));
        }
        RecommendationNode(_storageController)
            .setGlobalRecommendationsNode(recommendations: [
          Recommendation(
              recommendationType: "user",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Cyber attacks',
                  longDescription: 'they are real, Please be careful')),
          Recommendation(
              recommendationType: "device",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Device attacks',
                  longDescription: 'they are real, Please be really careful')),
          Recommendation(
              recommendationType: "device",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Internet attacks',
                  longDescription: 'they are real, Please be really careful')),
          Recommendation(
              recommendationType: "user",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Internet attacks',
                  longDescription: 'they are real, Please be really careful'))
        ]);

        //setGeigerCurrentDeviceRecommendation
        // geigerDevice.setDeviceRecommendation(
        //     threat: Threat(threatId: "t2", name: "malware"));
      });

      test("getGeigerCurrentDeviceInfo", () {
        expect(
            geigerDevice.getDeviceInfo,
            equals(Device.convertDeviceFromJson(
                '{"owner":${User.convertUserToJson(geigerUser.getUserInfo!)},"deviceId":"d62f5015-c790-48ae-83d0-2ae2f4a073ce","name":"Iphone","type":"mobile"}')));
      });

      test("getGeigerScoreDeviceThreatScore", () {
        geigerDevice.getGeigerScoreDeviceThreatScores();
      });

      // getCurrentDeviceGeigerThreatRecommendation
      // test("getCurrentDeviceGeigerThreatRecommendation", () {
      //   var r = geigerDevice.getDeviceThreatRecommendation(
      //       threat: _threatNode.getThreats().first);
      //   print(r);
      // });

      // test("setDeviceImplementedRecommendation", () {
      //   String r = geigerDevice.getDeviceThreatRecommendation(threat: Threat(threatId: "t2", name: "malware"))[0]
      //       .recommendationId;
      //
      //   expect(
      //       geigerDevice.setDeviceImplementedRecommendation(
      //           recommendationId: r),
      //       equals(true));
      // });
    });
  }
}

class GeigerRecommendationTest {
  StorageController _storageController;

  GeigerRecommendationTest(this._storageController);

  void recommendationGroupTest() {
    ThreatNode _threatNode = ThreatNode(_storageController);
    RecommendationNode geigerRecommendation =
        RecommendationNode(_storageController);

    group("RecommendationGroupTest", () {
      setUp(() {
        //set global recommendations
        List<Threat> threats = _threatNode.getThreats();
        List<ThreatWeight> threatWeight = [];
        List<String> weights = ["High", "Medium", "Low"];
        for (int i = 0; i < threats.length; i++) {
          threatWeight
              .add(ThreatWeight(threat: threats[i], weight: weights[i]));
        }
        RecommendationNode(_storageController)
            .setGlobalRecommendationsNode(recommendations: [
          Recommendation(
              recommendationType: "user",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Cyber attacks',
                  longDescription: 'they are real, Please be careful')),
          Recommendation(
              recommendationType: "device",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Device attacks',
                  longDescription: 'they are real, Please be really careful')),
          Recommendation(
              recommendationType: "device",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Internet attacks',
                  longDescription: 'they are real, Please be really careful')),
          Recommendation(
              recommendationType: "user",
              relatedThreatsWeight: threatWeight,
              description: DescriptionShortLong(
                  shortDescription: 'Internet attacks',
                  longDescription: 'they are real, Please be really careful'))
        ]);
      });

      test("getRecommendation", () {
        var r = geigerRecommendation.getRecommendations;
        print(r);
      });

      test("getUserThreatRecommendations", () {
        var r = geigerRecommendation.getThreatRecommendation(
            threat: _threatNode.getThreats().first, recommendationType: "user");
        print(r);
      });
    });
  }
}

class GeigerOnBtnPressedTest {
  StorageController _storageController;

  GeigerOnBtnPressedTest(this._storageController);

  void onBtnPressedTest() {
    test("getDataFrom OnBtnPressed", () async {
      String result = await Geiger(_storageController).onBtnPressed();
      print(result);
    });
  }
}
