library geiger_dummy_data;

import 'dart:async';
import 'dart:convert';

import 'package:geiger_localstorage/geiger_localstorage.dart';

import '/src/models/geiger_data.dart';
import '../geiger_dummy_data.dart';

class GeigerApi implements Geiger {
  StorageController _storageController;

  GeigerApi(this._storageController);

  ///<p>implement onBtnPressed function from geiger abstract class</p>
  ///@return a Future of json string
  @override
  Future<String> onBtnPressed() async {
    UserNode _userNode = UserNode(_storageController);
    DeviceNode _deviceNode = DeviceNode(_storageController);
    RecommendationNode _recommendationNode =
        RecommendationNode(_storageController);

    List<GeigerScoreThreats> geigerScoreThreats = [];

    try {
      //add aggregate,//userScore // deviceScore
      geigerScoreThreats
          .add(await _userNode.getGeigerScoreAggregateThreatScore());
      geigerScoreThreats.add(await _userNode.getGeigerScoreUserThreatScores());
      geigerScoreThreats
          .add(await _deviceNode.getGeigerScoreDeviceThreatScores());
      return jsonEncode(GeigerData(
          geigerScoreThreats: geigerScoreThreats,
          recommendations: await _recommendationNode.getRecommendations));
    } catch (e) {
      throw Exception(
          "Node aggregate, user, device and recommendation not created");
    }
  }

  ///<p>implement initialGeigerDummyData function from geiger abstract class</p>
  ///@param TermsAndCondition object
  ///@return a Future void
  @override
  Future<bool> initialGeigerDummyData(
      TermsAndConditions termsAndConditions) async {
    //UserNode _userNode = UserNode(_storageController);
    DeviceNode _deviceNode = DeviceNode(_storageController);
    //ThreatNode _threatNode = ThreatNode(_storageController);
    //set device
    await _deviceNode.setCurrentDeviceInfo(Device());
    //get device
    Device device = await _deviceNode.getDeviceInfo;
    print("Device Details: $device");

    if (await _isTermAgreed(
        termsAndConditions: termsAndConditions, device: device)) {
      //device
      _deviceNode.setCurrentDeviceInfo(Device());
      /*//set threat
      _threatNode.setGlobalThreatsNode(
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
      _userNode.setGeigerScoreAggregate(
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
      _userNode.setGeigerUserScore(
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

      RecommendationNode(_storageController)
          .setGlobalRecommendationsNode(recommendations: [
        Recommendation(
            recommendationType: "user",
            relatedThreatsWeight: threatWeight,
            description: DescriptionShortLong(
                shortDescription: 'Recognize phishing mails',
                longDescription:
                    'Improve your ability to recognize phishing mails. Choose at least one email in the cyberrange app and judge wether it is a phishing mail or not.')),
        Recommendation(
            recommendationType: "device",
            relatedThreatsWeight: threatWeight,
            description: DescriptionShortLong(
                shortDescription: 'Password Manager',
                longDescription:
                    'Learn how to implement a password manager which offers a secure storage of passwords')),
        Recommendation(
            recommendationType: "device",
            relatedThreatsWeight: threatWeight,
            description: DescriptionShortLong(
                shortDescription: 'Activate Device Report',
                longDescription:
                    'The Kaspersky Mobile Security Device Report allows to assess the vulnerabilities and threats affecting the device and provides a report with information about:')),
        Recommendation(
            recommendationType: "user",
            relatedThreatsWeight: threatWeight,
            description: DescriptionShortLong(
                shortDescription: 'Strong passwords',
                longDescription:
                    'Complete the Password Safety lesson. Learn how to use strong and unique passwords.'))
      ]);

      //set userRecommendation
      _userNode.setUserThreatRecommendation();
      //set deviceRecommendation
      _deviceNode.setDeviceRecommendation();
*/
      return true;
    } else {
      throw Exception("terms and conditions must be checked");
    }
  }

  Future<bool> _isTermAgreed(
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

class Event {
  final EventType _event;
  final Node? _old;
  final Node? _new;

  Event(this._event, this._old, this._new);

  EventType get type => _event;

  Node? get oldNode => _old;

  Node? get newNode => _new;

  @override
  String toString() {
    return '${type.toString()} ${oldNode.toString()}=>${newNode.toString()}';
  }
}

class CustomStorageListener implements StorageListener {
  List<Event> events = <Event>[];
  @override
  void gotStorageChange(EventType event, Node? oldNode, Node? newNode) {
    Event e = Event(event, oldNode, newNode);
    events.add(e);
  }

  Future<List<Event>> getNumberEvents(int number,
      {int timeout = 1000000}) async {
    int start = DateTime.now().millisecondsSinceEpoch;
    List<Event> ret = await Future.doWhile(() =>
            events.length < number &&
            start + 1000 * timeout > DateTime.now().millisecondsSinceEpoch)
        .then((value) => events);
    if (events.length < number) {
      throw TimeoutException(
          'Timeout reached while waiting for $number events');
    }
    return ret;
  }
}

//Todo

// make score to be random
