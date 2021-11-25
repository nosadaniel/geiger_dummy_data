import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/recommendation_node.dart';
import 'package:geiger_dummy_data/src/user_node.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;
import 'package:test/test.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();

  await StorageMapper.initDatabaseExpander();
  final StorageController _masterController =
      GenericController("test", DummyMapper("test"));
  //SimpleEventListner masterListener;

  //GeigerOnBtnPressedTest
  //GeigerCheckTest().onBtnPressedTest();

  String nodeDataName = "MI";
  String geigerOwner = "loung";
  test("Mi test", () async {
    Future<Node?> writeToGeigerStorage(String data) async {
      log('Trying to get the data node');
      try {
        log('Found the data node - Going to write the data');
        Node node = await _masterController.get(':$nodeDataName');
        await node.addOrUpdateValue(NodeValueImpl('data', '$data'));
        await _masterController.update(node);
        return node;
      } catch (e) {
        log(e.toString());
        log('Cannot find the data node - Going to create a new one');
        try {
          Node node = NodeImpl(nodeDataName, geigerOwner);
          node.visibility = vis.Visibility.green;
          await _masterController.addOrUpdate(node);
          await node.addOrUpdateValue(NodeValueImpl('data', '$data'));
          await _masterController.update(node);
          print(node.parentPath);
          return node;
        } catch (e2) {
          print(e2.toString());
          log('---> Out of luck');
        }
      }
    }

    Future<String?> readDataFromGeigerStorage() async {
      log('Trying to get the data node');
      try {
        log('Found the data node - Going to get the data');
        Node node = await _masterController.get(':$nodeDataName');
        NodeValue? nValue = await node.getValue('data');
        if (nValue != null) {
          return nValue.value;
        } else {
          log('Failed to retrieve the node value');
        }
      } catch (e) {
        log('Failed to retrieve the data node');
        log(e.toString());
      }
      return null;
    }

    print("${await readDataFromGeigerStorage()}");
    print("${await writeToGeigerStorage("nosa")}");
  });
}

//geigerThreat
// GeigerThreatTest geigerThreatTest = GeigerThreatTest(_storageController);
// geigerThreatTest.threatGroupTest();
//
// //geigerRecommendation
// GeigerRecommendationTest geigerRecommendationTest =
//     GeigerRecommendationTest(_storageController);
// geigerRecommendationTest.recommendationGroupTest();
//

// //geigerDeviceTest
// GeigerDeviceTest geigerDeviceTest = GeigerDeviceTest(_storageController);
// geigerDeviceTest.deviceGroupTest();
//
// //geigerUserTest
// GeigerUserTest geigerUserTest = GeigerUserTest(_storageController);
// geigerUserTest.userGroupTest();
// //

class GeigerThreatTest {
  StorageController _storageController;

  GeigerThreatTest(this._storageController);

  void threatGroupTest() {
    ThreatNode geigerThreat = ThreatNode(_storageController);
    group("threatGroupTest", () {
      setUp(() async {
        await geigerThreat.setGlobalThreatsNode(
            threats: [Threat(name: "phishing"), Threat(name: "Malware")]);
      });
      test("getThreatList", () async {
        print(await geigerThreat.getThreats());
      });
    });
  }
}

class GeigerUserTest {
  StorageController _storageController;

  GeigerUserTest(this._storageController);

  void userGroupTest() {
    UserNode geigerUser = UserNode(_storageController);
    //DeviceNode _deviceNode = DeviceNode(_storageController);
    //ThreatNode _threatNode = ThreatNode(_storageController);
    group("currentUserGroupTest:", () {
      setUp(() {
        // //setCurrentUser
        // await geigerUser.setUserInfo(User(
        //   userName: "John Doe",
        //   termsAndConditions: TermsAndConditions(),
        //   consent: Consent(),
        //   deviceOwner: await _deviceNode.getDeviceInfo,
        //));
        // //
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
      });

      test("getCurrentUserInfo", () async {
        print(await geigerUser.getUserInfo);
      });

      // test("getCurrentUserThreat", () async {
      //   await geigerUser.getGeigerScoreUserThreatScores(language: "fr");
      // });
      //
      // test("getGeigerAggregateThreatScore", () async {
      //   await geigerUser.getGeigerScoreAggregateThreatScore(language: "de-ch");
      // });
      //
      // //check this
      // test("getCurrentUserRecommendation", () async {
      //   var r = await geigerUser.getUserRecommendation();
      //   print(r);
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

    // ThreatNode _threatNode = ThreatNode(_storageController);
    group("GeigerDeviceGroupTest", () {
      setUp(() {
        // //   // set currentDevice
        // CustomStorageListener listener = CustomStorageListener();
        // SearchCriteria criteria = SearchCriteria(":Users");
        // _storageController.registerChangeListener(listener, criteria);
        //
        // await geigerDevice.setCurrentDeviceInfo(Device(name: "Iphone"));

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
      });

      test("getGeigerCurrentDeviceInfo", () async {
        print("Device details: ${await geigerDevice.getDeviceInfo}");
      });

      // test("getGeigerScoreDeviceThreatScore", () async {
      //   await geigerDevice.getGeigerScoreDeviceThreatScores();
      // });
      //
      // // getCurrentDeviceGeigerThreatRecommendation
      // test("getCurrentDeviceGeigerThreatRecommendation", () async {
      //   var r = await geigerDevice.getDeviceThreatRecommendation();
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

      test("getRecommendation", () async {
        var r = await geigerRecommendation.getRecommendations;
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

class GeigerCheckTest {
  void onBtnPressedTest() {
    group("GeigerCheckGroupTest", () {
      setUp(() async {
        await GeigerDummy().initStorage();
      });
      test("testInitialGeigerDummyData", () async {
        bool value = await GeigerDummy().initialGeigerDummyData(
            TermsAndConditions(
                ageCompliant: true, agreedPrivacy: true, signedConsent: true));
        expect(await value, true);
      });

      test("getDataFrom OnBtnPressed", () async {
        String result = await GeigerDummy().onBtnPressed();
        print(result);
      });
    });
    test("MI", () {});
  }
}
