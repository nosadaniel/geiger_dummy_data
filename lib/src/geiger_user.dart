library geiger_dummy_mapper;

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../src/geiger_recommendation.dart';
import '../src/models/threat.dart';
import '../src/models/threat_recommendation.dart';
import '../src/models/threat_score.dart';
import '../src/models/user.dart';
import 'models/implemented_recommendation.dart';

/// <p>Grant access to methods relating user.</p>
/// @param storageController
class GeigerUser {
  StorageController _storageController;

  GeigerUser(this._storageController);
  Node? _node;
  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;

  /// <p>set userInfo in currentUser NodeValue in :Local</p>
  /// @param user object
  /// @throws :Local not found on StorageException
  void set setUserInfo(User currentUserInfo) {
    try {
      _node = _storageController.get(":Local");
      NodeValue localNodeValue =
          NodeValueImpl("currentUser", User.convertUserToJson(currentUserInfo));
      _node!.addOrUpdateValue(localNodeValue);
      _storageController.update(_node!);
    } on StorageException {
      throw Exception(":Local not found");
    }
  }

  ///<p> get current user info from :local value 'currentUser'
  /// @return user object
  /// @throws :Local not found on StorageException
  User get getUserInfo {
    try {
      _node = _storageController.get(":Local");
      String currentUser =
          _node!.getValue("currentUser")!.getValue("en").toString();
      return User.convertUserFromJson(currentUser);
    } on StorageException {
      throw Exception("Node :Local not found");
    }
  }

  /// <p>set GeigerUserScore. </p>
  /// @param option language as locale
  /// @param list of threatScore object
  /// @param optional geigerScore as string
  void setGeigerUserScore(
      {Locale? language,
      required List<ThreatScore> threatScores,
      String geigerScore: "0"}) {
    User currentUser = getUserInfo;
    try {
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");
      _setUserNodeValues(language, threatScores, geigerScore: geigerScore);
    } on StorageException {
      Node userNode = NodeImpl("${currentUser.userId}", ":Users");
      _storageController.addOrUpdate(userNode);

      Node giNode = NodeImpl("gi", ":Users:${currentUser.userId}");
      _storageController.addOrUpdate(giNode);

      Node nodeData = NodeImpl("data", ":Users:${currentUser.userId}:gi");
      _storageController.addOrUpdate(nodeData);

      Node userScoreNode =
          NodeImpl("GeigerScoreUser", ":Users:${currentUser.userId}:gi:data");

      _storageController.add(userScoreNode);
      _setUserNodeValuesException(language, userScoreNode, threatScores,
          geigerScore: geigerScore);
    }
  }

  /// <p>set GeigerAggregateScore </p>
  /// @param option language as locale
  /// @param list of threatScore object
  /// @param optional geigerScore as string
  void setGeigerScoreAggregate(
      {Locale? language,
      required List<ThreatScore> threatScores,
      String geigerScore: "0"}) {
    User currentUser = getUserInfo;
    try {
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");
      _setUserNodeValues(language, threatScores, geigerScore: geigerScore);
    } on StorageException {
      Node userNode = NodeImpl("${currentUser.userId}", ":Users");
      _storageController.addOrUpdate(userNode);

      Node giNode = NodeImpl("gi", ":Users:${currentUser.userId}");
      _storageController.addOrUpdate(giNode);

      Node nodeData = NodeImpl("data", ":Users:${currentUser.userId}:gi");
      _storageController.addOrUpdate(nodeData);

      Node aggScoreNode = NodeImpl(
          "GeigerScoreAggregate", ":Users:${currentUser.userId}:gi:data");
      _storageController.add(aggScoreNode);

      _setUserNodeValuesException(language, aggScoreNode, threatScores);
    }
  }

  /// @param optional language as string
  /// @return GeigerScore as String  from GeigerScoreUser Node
  /// @throw Node not found on StorageException
  String getGeigerScoreUser({String language: "en"}) {
    try {
      User currentUser = getUserInfo;
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");

      String geigerScore =
          _node!.getValue("GEIGER_score")!.getValue(language).toString();
      return geigerScore;
    } on StorageException {
      throw Exception("Node not found");
    }
  }

  /// @param optional language as string
  /// @return list of threatScore object from GeigerScoreUser
  List<ThreatScore> getGeigerScoreUserThreatScores({String language: "en"}) {
    try {
      User currentUser = GeigerUser(_storageController).getUserInfo;
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");

      String threats_score =
          _node!.getValue("threats_score")!.getValue(language).toString();
      return ThreatScore.convertFromJson(threats_score);
    } on StorageException {
      throw Exception("NODE NOT FOUND");
    }
  }

  /// @return GeigerScoreAggregate as String  from GeigerScoreAggregate Node
  /// @throw Node not found on StorageException
  String getGeigerScoreAggregate({String language: "en"}) {
    try {
      User currentUser = getUserInfo;
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");

      String geigerScore =
          _node!.getValue("GEIGER_score")!.getValue(language).toString();
      return geigerScore;
    } on StorageException {
      throw Exception("Node not found");
    }
  }

  /// @param optional language as string
  /// @return list of threatScore object from GeigerScoreAggregate
  List<ThreatScore> getGeigerScoreAggregateThreatScore(
      {String language: "en"}) {
    User currentUser = GeigerUser(_storageController).getUserInfo;
    _node = _storageController
        .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");

    String threats_score =
        _node!.getValue("threats_score")!.getValue(language).toString();
    return ThreatScore.convertFromJson(threats_score);
  }

  /// <p>set UserRecommendation</p>
  /// @param optional language as locale
  /// @param threat object
  void setUserThreatRecommendation({Locale? language, required Threat threat}) {
    User currentUser = getUserInfo;
    List<ThreatRecommendation> threatRecommendations =
        GeigerRecommendation(_storageController).getThreatRecommendation(
            threat: threat, recommendationType: "user");
    try {
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:recommendations");

      NodeValue threatRecomValue = NodeValueImpl("${threat.threatId}",
          ThreatRecommendation.convertToJson(threatRecommendations));

      if (language != null) {
        //translations
        threatRecomValue.setValue(
            ThreatRecommendation.convertToJson(threatRecommendations),
            language);
      }

      _node!.addOrUpdateValue(threatRecomValue);
      _storageController.update(_node!);
    } on StorageException {
      Node userRecommendationNode =
          NodeImpl("recommendations", ":Users:${currentUser.userId}:gi:data");
      _storageController.add(userRecommendationNode);

      NodeValue threatRecomValue = NodeValueImpl("${threat.threatId}",
          ThreatRecommendation.convertToJson(threatRecommendations));

      if (language != null) {
        //translations
        threatRecomValue.setValue(
            ThreatRecommendation.convertToJson(threatRecommendations),
            language);
      }

      userRecommendationNode.addOrUpdateValue(threatRecomValue);

      _storageController.update(userRecommendationNode);
    }
  }

  ///<p>get UserRecommendation</p>
  ///@param option language as string
  ///@param threat object
  ///@return list of threatRecommendation object
  List<ThreatRecommendation> getUserThreatRecommendation({
    String language: "en",
    required Threat threat,
  }) {
    try {
      User currentUser = getUserInfo;
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:recommendations");
      String threatRecommendations =
          _node!.getValue("${threat.threatId}")!.getValue(language).toString();

      return ThreatRecommendation.convertFromJson(threatRecommendations);
    } on StorageException {
      throw Exception("NODE NOT FOUND");
    }
  }

  ///<p> set user ImplementedRecommendation
  ///@param recommendationId as string
  ///@return bool
  bool setUserImplementedRecommendation({required String recommendationId}) {
    List<ImplementedRecommendation> implementedRecommendations = [];
    //get currentDevice info
    User currentUser = getUserInfo;
    try {
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");
      implementedRecommendations
          .add(ImplementedRecommendation(recommendationId: recommendationId));

      NodeValue implementedRecom = NodeValueImpl("implementedRecommendations",
          ImplementedRecommendation.convertToJson(implementedRecommendations));
      _node!.addOrUpdateValue(implementedRecom);

      _storageController.update(_node!);
      return true;
    } catch (e) {
      log("failed to addOrUpdate implementedRecommendations NodeValue");
      return false;
    }
  }

  void _setUserNodeValues(Locale? language, List<ThreatScore> threatScores,
      {String geigerScore: "0"}) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    _node!.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));

    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    _node!.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    _node!.addOrUpdateValue(_geigerNumMetrics!);

    _storageController.update(_node!);
  }

  void _setUserNodeValuesException(
      Locale? language, Node userScoreNode, threatScores,
      {String geigerScore: "0"}) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    userScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    userScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    userScoreNode.addOrUpdateValue(_geigerNumMetrics!);
    _storageController.update(userScoreNode);
  }

// ///get list of currentUserThreatScores
// List<ThreatScore> get getCurrentGeigerUserThreatScores {
//   User currentUser = getCurrentUserInfo;
//   _node = _storageController
//       .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");
//
//   String threats_score =
//       _node!.getValue("threats_score")!.getValue("en").toString();
//   return ThreatScore.fromJSon(threats_score);
// }
}

//Todo

// write throw exception for all getters if object is not
// found

//add the following line of code below to geiger-toolbox ui

/*
SystemChrome.setPreferredOrientations(
[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/
