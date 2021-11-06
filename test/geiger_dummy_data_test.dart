import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/geiger_api.dart';
import 'package:geiger_dummy_data/src/models/terms_and_conditions.dart';
import 'package:geiger_dummy_data/src/recommendation_node.dart';
import 'package:geiger_dummy_data/src/user_node.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:test/test.dart';

void main() {
  StorageController _storageController =
      GenericController("test", SqliteMapper("./test.sqlite"));

  //GeigerOnBtnPressedTest
  GeigerApiTest(_storageController).onBtnPressedTest();

  //geigerThreat
  GeigerThreatTest geigerThreatTest = GeigerThreatTest(_storageController);
  geigerThreatTest.threatGroupTest();

  //geigerRecommendation
  GeigerRecommendationTest geigerRecommendationTest =
      GeigerRecommendationTest(_storageController);
  geigerRecommendationTest.recommendationGroupTest();

  //geigerUserTest
  GeigerUserTest geigerUserTest = GeigerUserTest(_storageController);
  geigerUserTest.userGroupTest();

  //geigerDeviceTest
  GeigerDeviceTest geigerDeviceTest = GeigerDeviceTest(_storageController);
  geigerDeviceTest.deviceGroupTest();
}

class GeigerThreatTest {
  StorageController _storageController;

  GeigerThreatTest(this._storageController);

  void threatGroupTest() {
    ThreatNode geigerThreat = ThreatNode(_storageController);
    group("threatGroupTest", () {
      // setUp(() {
      //   geigerThreat.setGlobalThreatsNode(
      //       threats: [Threat(name: "phishing"), Threat(name: "Malware")]);
      // });
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
    //ThreatNode _threatNode = ThreatNode(_storageController);
    group("currentUserGroupTest:", () {
      // setUp(() {
      //   //setCurrentUser
      //   geigerUser.setUserInfo = User(
      //       userName: "John Doe",
      //       termsAndConditions: TermsAndConditions(),
      //       consent: Consent());
      //
      //   //setCurrentGeigerUserScore
      //   List<String> userScores = ["44", "50", "70"];
      //   List<Threat> userThreats = _threatNode.getThreats();
      //   List<ThreatScore> threatsScore = [];
      //   for (int i = 0; i < userThreats.length; i++) {
      //     threatsScore
      //         .add(ThreatScore(threat: userThreats[i], score: userScores[i]));
      //   }
      //   geigerUser.setGeigerUserScore(
      //       geigerScoreThreats: GeigerScoreThreats(
      //           threatScores: threatsScore, geigerScore: "45"));
      //
      //   //setAggregate
      //   List<String> AggScores = ["20", "70", "90"];
      //   List<Threat> AggThreats = _threatNode.getThreats();
      //   List<ThreatScore> aggThreatsScore = [];
      //   for (int i = 0; i < AggThreats.length; i++) {
      //     aggThreatsScore
      //         .add(ThreatScore(threat: AggThreats[i], score: AggScores[i]));
      //   }
      //   geigerUser.setGeigerScoreAggregate(
      //       geigerScoreThreats: GeigerScoreThreats(
      //           threatScores: aggThreatsScore, geigerScore: "50"));
      //
      //   //set user recommendation in userNode
      //   geigerUser.setUserThreatRecommendation();
      //   //
      //   // List<Recommendation> recommendations = RecommendationNode(_storageController).getRecommendations;
      //   //
      //   // List<String> userWeight = ["high", "low", "medium"];
      //   // List<Threat> threats = _threatNode.getThreats();
      //   // List<ThreatWeight> threatWeight = [];
      //   // for(int i =0; i<recommendations.length; i++){
      //   //   threatWeight.add(ThreatWeight(threat: threats[i], weight: userWeight[i]));
      //   // }
      //   // geigerUser.setRelatedThreatsWeightInRecommendation(recommendationId: recommendationId, threatsWeight: threatsWeight, recommendationType: "user")s
      // });

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
      test("getCurrentUserRecommendation", () {
        var r = geigerUser.getUserRecommendation();
        print(r);
      });

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
    // UserNode geigerUser = UserNode(_storageController);
    // ThreatNode _threatNode = ThreatNode(_storageController);
    group("GeigerDeviceGroupTest", () {
      // setUp(() {
      //   // set currentDevice
      //   geigerDevice.setCurrentDeviceInfo =
      //       Device(owner: geigerUser.getUserInfo!);
      //   // set list of threats for currentDevice
      //   List<String> deviceScores = ["24", "20", "80"];
      //   List<Threat> deviceThreats = _threatNode.getThreats();
      //   List<ThreatScore> threatsScore = [];
      //   for (int i = 0; i < deviceThreats.length; i++) {
      //     threatsScore.add(
      //         ThreatScore(threat: deviceThreats[i], score: deviceScores[i]));
      //   }
      //   geigerDevice.setGeigerScoreDevice(
      //       geigerScoreThreats: GeigerScoreThreats(
      //           threatScores: threatsScore, geigerScore: "23"));
      //
      //   //set deviceRecommendation in device node
      //   geigerDevice.setDeviceRecommendation();
      // });

      test("getGeigerCurrentDeviceInfo", () {
        print("Device details: ${geigerDevice.getDeviceInfo}");
      });

      test("getGeigerScoreDeviceThreatScore", () {
        geigerDevice.getGeigerScoreDeviceThreatScores();
      });

      // getCurrentDeviceGeigerThreatRecommendation
      test("getCurrentDeviceGeigerThreatRecommendation", () {
        var r = geigerDevice.getDeviceThreatRecommendation();
        print(r);
      });

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
    //ThreatNode _threatNode = ThreatNode(_storageController);
    RecommendationNode geigerRecommendation =
        RecommendationNode(_storageController);

    group("RecommendationGroupTest", () {
      // setUp(() {
      //   // //set global recommendations
      //   List<Threat> threats = _threatNode.getThreats();
      //   List<ThreatWeight> threatWeight = [];
      //   List<String> weights = ["High", "Medium", "Low"];
      //   for (int i = 0; i < threats.length; i++) {
      //     threatWeight
      //         .add(ThreatWeight(threat: threats[i], weight: weights[i]));
      //   }
      //   RecommendationNode(_storageController)
      //       .setGlobalRecommendationsNode(recommendations: [
      //     Recommendation(
      //         recommendationType: "user",
      //         relatedThreatsWeight: threatWeight,
      //         description: DescriptionShortLong(
      //             shortDescription: 'Cyber attacks',
      //             longDescription: 'they are real, Please be careful')),
      //     Recommendation(
      //         description: DescriptionShortLong(
      //             shortDescription: 'Device attacks',
      //             longDescription: 'they are real, Please be really careful')),
      //     Recommendation(
      //         description: DescriptionShortLong(
      //             shortDescription: 'Internet attacks',
      //             longDescription: 'they are real, Please be really careful')),
      //     Recommendation(
      //         description: DescriptionShortLong(
      //             shortDescription: 'Internet attacks',
      //             longDescription: 'they are real, Please be really careful'))
      //   ]);
      // });

      test("getRecommendation", () {
        var r = geigerRecommendation.getRecommendations;
        print(r);
      });

      // test("getUserThreatRecommendations", () {
      //   var r = geigerRecommendation.getThreatRecommendation(
      //       threat: _threatNode.getThreats().first, recommendationType: "user");
      //   print(r);
      // });
    });
  }
}

class GeigerApiTest {
  StorageController _storageController;

  GeigerApiTest(this._storageController);

  void onBtnPressedTest() {
    group("RecommendationGroupTest", () {
      setUp(() async {
        await GeigerApi(_storageController).initialGeigerDummyData(
            TermsAndConditions(
                ageCompliant: true, agreedPrivacy: true, signedConsent: true));
      });
      test("getDataFrom OnBtnPressed", () async {
        String result = await GeigerApi(_storageController).onBtnPressed();
        print(result);
      });
    });
    tearDown(() {
      _storageController.flush();
    });
  }
}
