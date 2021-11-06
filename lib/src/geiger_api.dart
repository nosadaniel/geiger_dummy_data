library geiger_dummy_data;

import 'dart:convert';

import 'package:geiger_localstorage/geiger_localstorage.dart';

import '/src/models/geiger_data.dart';
import '../geiger_dummy_data.dart';

class GeigerApi implements Geiger {
  StorageController _storageController;

  GeigerApi(this._storageController);

  @override
  Future<String> onBtnPressed() async {
    UserNode _userNode = UserNode(_storageController);
    DeviceNode _deviceNode = DeviceNode(_storageController);
    RecommendationNode _recommendationNode =
        RecommendationNode(_storageController);

    List<GeigerScoreThreats> geigerScoreThreats = [];

    try {
      //add aggregate,//userScore // deviceScore
      geigerScoreThreats.add(_userNode.getGeigerScoreAggregateThreatScore());
      geigerScoreThreats.add(_userNode.getGeigerScoreUserThreatScores());
      geigerScoreThreats.add(_deviceNode.getGeigerScoreDeviceThreatScores());
      return jsonEncode(GeigerData(
          geigerScoreThreats: geigerScoreThreats,
          recommendations: _recommendationNode.getRecommendations));
    } catch (e) {
      throw Exception(
          "Node aggregate, user, device and recommendation not created");
    }
  }

  @override
  Future<void> initialGeigerDummyData(
      TermsAndConditions termsAndConditions) async {
    UserNode _userNode = UserNode(_storageController);
    DeviceNode _deviceNode = DeviceNode(_storageController);
    ThreatNode _threatNode = ThreatNode(_storageController);

    if (_isTermAgreed(termsAndConditions: termsAndConditions)) {
      //device
      _deviceNode.setCurrentDeviceInfo = Device(owner: _userNode.getUserInfo!);
      //set threat
      _threatNode.setGlobalThreatsNode(
          threats: [Threat(name: "phishing"), Threat(name: "Malware")]);

      //set Agg
      List<String> AggScores = ["45", "65", "60"];
      List<Threat> AggThreats = _threatNode.getThreats();
      List<ThreatScore> aggThreatsScore = [];
      for (int i = 0; i < AggThreats.length; i++) {
        aggThreatsScore
            .add(ThreatScore(threat: AggThreats[i], score: AggScores[i]));
      }
      _userNode.setGeigerScoreAggregate(
          geigerScoreThreats: GeigerScoreThreats(
              threatScores: aggThreatsScore, geigerScore: "50"));

      // set userscore
      List<String> userScores = ["30", "70", "45"];
      List<Threat> userThreats = _threatNode.getThreats();
      List<ThreatScore> userThreatsScore = [];
      for (int i = 0; i < userThreats.length; i++) {
        userThreatsScore
            .add(ThreatScore(threat: userThreats[i], score: userScores[i]));
      }
      _userNode.setGeigerUserScore(
          geigerScoreThreats: GeigerScoreThreats(
              threatScores: aggThreatsScore, geigerScore: "45"));

      // set deviceScore
      List<String> deviceScores = ["40", "58", "47"];
      List<Threat> deviceThreats = _threatNode.getThreats();
      List<ThreatScore> deviceThreatsScore = [];
      for (int i = 0; i < deviceThreats.length; i++) {
        deviceThreatsScore
            .add(ThreatScore(threat: deviceThreats[i], score: deviceScores[i]));
      }
      _deviceNode.setGeigerScoreDevice(
          geigerScoreThreats: GeigerScoreThreats(
              threatScores: deviceThreatsScore, geigerScore: "35"));

      //set global recommendations
      List<Threat> threats = _threatNode.getThreats();
      List<ThreatWeight> threatWeight = [];
      List<String> weights = ["High", "Medium", "Low"];
      for (int i = 0; i < threats.length; i++) {
        threatWeight.add(ThreatWeight(threat: threats[i], weight: weights[i]));
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

      //set userRecommendation
      _userNode.setUserThreatRecommendation();
      //set deviceRecommendation
      _deviceNode.setDeviceRecommendation();
    } else {
      throw Exception("terms and conditions must be checked");
    }
  }

  bool _isTermAgreed({required TermsAndConditions termsAndConditions}) {
    if (termsAndConditions.agreedPrivacy == true &&
        termsAndConditions.signedConsent == true &&
        termsAndConditions.ageCompliant == true) {
      UserNode(_storageController).setUserInfo =
          User(termsAndConditions: termsAndConditions, consent: Consent());
      return true;
    }
    return false;
  }
}

//Todo
