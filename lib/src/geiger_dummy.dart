library geiger_dummy_data;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../geiger_dummy_data.dart';

class GeigerDummy implements Geiger {
  // GeigerDummy(this.storageController);

  Future<GeigerApi> _initGeigerApi() async {
    //flushGeigerApiCache();
    //*****************************************master**********************
    GeigerApi localMaster =
        (await getGeigerApi("", GeigerApi.masterId, Declaration.doShareData))!;
    //clear existing state
    //await localMaster.zapState();
    return localMaster;
  }

  Future<StorageController> initDummyDataStorage() async {
    //for testing comment this
    GeigerApi _localGeigerApi = await _initGeigerApi();
    //for testing uncomment this
    //_storageController = GenericController("test", DummyMapper("testdb"));
    StorageController _storageController =
        (await _localGeigerApi.getStorage())!;
    return _storageController;
  }

  ///<p>implement onBtnPressed function from geiger abstract class</p>
  ///@return a Future of json string
  @override
  Future<String> onBtnPressed(StorageController _storageController) async {
    UserNode _userNode = UserNode(_storageController);
    DeviceNode _deviceNode = DeviceNode(_storageController);
    RecommendationNode _recommendationNode =
        RecommendationNode(_storageController);

    List<GeigerScoreThreats> geigerScoreThreats = [];
    List<GeigerRecommendation> gr =
        await _recommendationNode.getRecommendations;
    print(gr);
    try {
      List<GeigerRecommendation> gr =
          await RecommendationNode(_storageController).getRecommendations;
      //print(gr);
      //add aggregate,//userScore // deviceScore
      geigerScoreThreats
          .add(await _userNode.getGeigerScoreAggregateThreatScore());
      geigerScoreThreats.add(await _userNode.getGeigerScoreUserThreatScores());
      geigerScoreThreats
          .add(await _deviceNode.getGeigerScoreDeviceThreatScores());
      return jsonEncode(GeigerData(
          geigerScoreThreats: geigerScoreThreats, geigerRecommendations: gr));
    } catch (e) {
      throw Exception(
          "Node aggregate, user, device and recommendation not created");
    }
  }

  ///<p>implement initialGeigerDummyData function from geiger abstract class</p>
  ///@param TermsAndCondition object
  ///@return a Future void
  @override
  Future<bool> initialGeigerDummyData(TermsAndConditions termsAndConditions,
      StorageController _storageController) async {
    //clear database

    UserNode _userNode = await UserNode(_storageController);
    DeviceNode _deviceNode = await DeviceNode(_storageController);
    ThreatNode _threatNode = await ThreatNode(_storageController);
    //set device
    await _deviceNode.setCurrentDeviceInfo(Device());
    //get device
    Device device = await _deviceNode.getDeviceInfo;
    print("Device Details: $device");

    if (await _isTermAgreed(_storageController,
        termsAndConditions: termsAndConditions, device: device)) {
      //device
      await _deviceNode.setCurrentDeviceInfo(Device());
      //set threat
      await _threatNode.setGlobalThreatsNode(
          threats: [Threat(name: "phishing"), Threat(name: "Malware")]);

      // set random scores
      Random random = new Random();

      //set Agg
      List<int> AggScores = List.generate(
          3,
          (_) =>
              random.nextInt(100) +
              10); //This will generate a list of 3 integers from 10 to 99 (inclusive).

      List<Threat> AggThreats = await _threatNode.getThreats();
      List<ThreatScore> aggThreatsScore = [];
      for (int i = 0; i < AggThreats.length; i++) {
        aggThreatsScore.add(
            ThreatScore(threat: AggThreats[i], score: AggScores[i].toString()));
      }
      await _userNode.setGeigerScoreAggregate(
          geigerScoreThreats: GeigerScoreThreats(
              threatScores: aggThreatsScore,
              geigerScore: (random.nextInt(90) + 20).toString()));

      // set userscore
      List<int> userScores = List.generate(
          3,
          (_) =>
              random.nextInt(100) +
              10); //This will generate a list of 3 integers from 10 to 99 (inclusive).
      List<Threat> userThreats = await _threatNode.getThreats();
      List<ThreatScore> userThreatsScore = [];
      for (int i = 0; i < userThreats.length; i++) {
        userThreatsScore.add(ThreatScore(
            threat: userThreats[i], score: userScores[i].toString()));
      }
      await _userNode.setGeigerUserScore(
          geigerScoreThreats: GeigerScoreThreats(
              threatScores: aggThreatsScore,
              geigerScore: (random.nextInt(90) + 20).toString()));

      // set deviceScore
      List<int> deviceScores = List.generate(
          3,
          (_) =>
              random.nextInt(100) +
              10); //This will generate a list of 3 integers from 10 to 99 (inclusive).
      List<Threat> deviceThreats = await _threatNode.getThreats();
      List<ThreatScore> deviceThreatsScore = [];
      for (int i = 0; i < deviceThreats.length; i++) {
        deviceThreatsScore.add(ThreatScore(
            threat: deviceThreats[i], score: deviceScores[i].toString()));
      }
      _deviceNode.setGeigerScoreDevice(
          geigerScoreThreats: GeigerScoreThreats(
              threatScores: deviceThreatsScore,
              geigerScore: (random.nextInt(90) + 20).toString()));

      //set global recommendations
      List<Threat> threats = await _threatNode.getThreats();
      List<ThreatWeight> threatWeight = [];
      List<String> weights = ["High", "Medium", "Low"];
      for (int i = 0; i < threats.length; i++) {
        threatWeight.add(ThreatWeight(threat: threats[i], weight: weights[i]));
      }

      List<Threat> t = await _threatNode.getThreats();

      await RecommendationNode(_storageController)
          .setGlobalRecommendationsNode(relatedThreat: t, recommendations: [
        Recommendations(
            recommendationType: "user",
            description: DescriptionShortLong(
                shortDescription: 'Recognize phishing mails',
                longDescription:
                    'Improve your ability to recognize phishing mails. Choose at least one email in the cyberrange app and judge wether it is a phishing mail or not.')),
        Recommendations(
            recommendationType: "device",
            description: DescriptionShortLong(
                shortDescription: 'Password Manager',
                longDescription:
                    'Learn how to implement a password manager which offers a secure storage of passwords')),
        Recommendations(
            recommendationType: "device",
            description: DescriptionShortLong(
                shortDescription: 'Activate Device Report',
                longDescription:
                    'The Kaspersky Mobile Security Device Report allows to assess the vulnerabilities and threats affecting the device and provides a report with information about:')),
        Recommendations(
            recommendationType: "user",
            description: DescriptionShortLong(
                shortDescription: 'Strong passwords',
                longDescription:
                    'Complete the Password Safety lesson. Learn how to use strong and unique passwords.'))
      ]);
      await RecommendationNode(_storageController).setGlobalRecommendationsNode(
          language: Locale.parse("nl-nl"),
          relatedThreat: t,
          recommendations: [
            Recommendations(
                recommendationType: "user",
                description: DescriptionShortLong(
                    shortDescription: 'Recognize phishing mails',
                    longDescription:
                        'Improve your ability to recognize phishing mails. Choose at least one email in the cyberrange app and judge wether it is a phishing mail or not.')),
            Recommendations(
                recommendationType: "device",
                description: DescriptionShortLong(
                    shortDescription: 'Password Manager',
                    longDescription:
                        'Learn how to implement a password manager which offers a secure storage of passwords')),
            Recommendations(
                recommendationType: "device",
                description: DescriptionShortLong(
                    shortDescription: 'Activate Device Report',
                    longDescription:
                        'The Kaspersky Mobile Security Device Report allows to assess the vulnerabilities and threats affecting the device and provides a report with information about:')),
            Recommendations(
                recommendationType: "user",
                description: DescriptionShortLong(
                    shortDescription: 'Strong passwords',
                    longDescription:
                        'Complete the Password Safety lesson. Learn how to use strong and unique passwords.'))
          ]);
      //multiple language
      await RecommendationNode(_storageController).setGlobalRecommendationsNode(
          language: Locale.parse("de-ch"),
          relatedThreat: t,
          recommendations: [
            Recommendations(
                recommendationType: "user",
                description: DescriptionShortLong(
                    shortDescription: 'Recognize phishing mails',
                    longDescription:
                        'Improve your ability to recognize phishing mails. Choose at least one email in the cyberrange app and judge wether it is a phishing mail or not.')),
            Recommendations(
                recommendationType: "device",
                description: DescriptionShortLong(
                    shortDescription: 'Password Manager',
                    longDescription:
                        'Learn how to implement a password manager which offers a secure storage of passwords')),
            Recommendations(
                recommendationType: "device",
                description: DescriptionShortLong(
                    shortDescription: 'Activate Device Report',
                    longDescription:
                        'The Kaspersky Mobile Security Device Report allows to assess the vulnerabilities and threats affecting the device and provides a report with information about:')),
            Recommendations(
                recommendationType: "user",
                description: DescriptionShortLong(
                    shortDescription: 'Strong passwords',
                    longDescription:
                        'Complete the Password Safety lesson. Learn how to use strong and unique passwords.'))
          ]);

      return true;
    } else {
      throw Exception("terms and conditions must be checked");
    }
  }

  Future<bool> _isTermAgreed(StorageController _storageController,
      {required TermsAndConditions termsAndConditions,
      required Device device}) async {
    if (termsAndConditions.agreedPrivacy == true &&
        termsAndConditions.signedConsent == true &&
        termsAndConditions.ageCompliant == true) {
      await UserNode(_storageController).setUserInfo(User(
          termsAndConditions: termsAndConditions,
          consent: Consent(),
          deviceOwner: device));
      print("UserDetails : ${await UserNode(_storageController).getUserInfo}");
      return true;
    }
    return false;
  }
}

//Todo
