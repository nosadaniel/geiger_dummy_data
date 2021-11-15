library geiger_dummy_mapper;

import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/models/geiger_score_threats.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../src/models/threat_score.dart';
import '../src/models/user.dart';
import '../src/recommendation_node.dart';

/// <p>Grant access to methods relating user.</p>
/// @param storageController
class UserNode extends RecommendationNode {
  StorageController _storageController;

  UserNode(this._storageController) : super(_storageController);
  Node? _node;
  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;

  /// <p>set userInfo in currentUser NodeValue in :Local</p>
  /// @param user object
  /// @throws :Local not found on StorageException
  Future<void> setUserInfo(User currentUserInfo) async {
    try {
      _node = await _storageController.get(":Local");

      NodeValue currentUserId =
          NodeValueImpl("currentUser", currentUserInfo.userId);
      await _node!.updateValue(currentUserId);
      //store userInfo in userDetails Nodevalue
      NodeValue localNodeValue =
          NodeValueImpl("userDetails", User.convertUserToJson(currentUserInfo));
      await _node!.addOrUpdateValue(localNodeValue);
      await _storageController.update(_node!);
    } on StorageException {
      throw Exception(":Local not found");
    }
  }

  ///<p> get current user info from :local value 'currentUser'
  /// @return user object
  /// @throws :Local not found on StorageException
  Future<User> get getUserInfo async {
    try {
      _node = await _storageController.get(":Local");
      String userDetails = await _node!
          .getValue("userDetails")
          .then((value) => value!.getValue("en")!);
      return User.convertUserFromJson(userDetails);
    } on StorageException {
      throw ("Node :Local not found");
    }
  }

  /// <p>set GeigerUserScore. </p>
  /// @param option language as locale
  /// @param list of threatScore object
  /// @param optional geigerScore as string
  Future<void> setGeigerUserScore(
      {Locale? language,
      required GeigerScoreThreats geigerScoreThreats,
      String geigerScore: "0"}) async {
    User currentUser = await getUserInfo;

    try {
      _node = await _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");
      _setUserNodeValues(language, geigerScoreThreats.threatScores,
          geigerScore: geigerScore);
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
      _setUserNodeValuesException(language, userScoreNode,
          geigerScoreThreats.threatScores, geigerScoreThreats.geigerScore);
    }
  }

  /// <p>set GeigerAggregateScore </p>
  /// @param option language as locale
  /// @param list of threatScore object
  /// @param optional geigerScore as string
  Future<void> setGeigerScoreAggregate(
      {Locale? language,
      required GeigerScoreThreats geigerScoreThreats}) async {
    User currentUser = await getUserInfo;

    try {
      _node = await _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");
      _setUserNodeValues(language, geigerScoreThreats.threatScores,
          geigerScore: geigerScoreThreats.geigerScore);
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

      _setUserNodeValuesException(language, aggScoreNode,
          geigerScoreThreats.threatScores, geigerScoreThreats.geigerScore);
    }
  }

  ///// @param optional language as string
  ///// @return GeigerScore as String  from GeigerScoreUser Node
  ///// @throw Node not found on StorageException
  /*String getGeigerScoreUser({String language: "en"}) {
    if (getUserInfo != null) {
      User currentUser = getUserInfo!;
      try {
        _node = _storageController
            .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");

        String geigerScore =
            _node!.getValue("GEIGER_score")!.getValue(language).toString();
        return geigerScore;
      } on StorageException {
        throw Exception("Node not found");
      }
    } else {
      throw Exception("currentUser is null ");
    }
  }*/

  /// @param optional language as string
  /// @return list of threatScore object from GeigerScoreUser
  Future<GeigerScoreThreats> getGeigerScoreUserThreatScores(
      {String language: "en"}) async {
    User currentUser = await getUserInfo;

    try {
      _node = await _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");

      String geigerScore = await _node!
          .getValue("GEIGER_score")
          .then((value) => value!.getValue(language).toString());

      String threats_score = await _node!
          .getValue("threats_score")
          .then((value) => value!.getValue(language).toString());

      List<ThreatScore> _threatScores =
          ThreatScore.convertFromJson(threats_score);

      return GeigerScoreThreats(
          threatScores: _threatScores, geigerScore: geigerScore);
    } on StorageException {
      throw Exception("NODE NOT FOUND");
    }
  }

  /// @param optional language as string
  /// @return list of threatScore object from GeigerScoreAggregate
  Future<GeigerScoreThreats> getGeigerScoreAggregateThreatScore(
      {String language: "en"}) async {
    User currentUser = await getUserInfo;

    _node = await _storageController
        .get(":Users:${currentUser.userId}:gi:data:GeigerScoreAggregate");

    String geigerScore = await _node!
        .getValue("GEIGER_score")
        .then((value) => value!.getValue(language).toString());

    String threatsScore = await _node!
        .getValue("threats_score")
        .then((value) => value!.getValue(language)!);

    List<ThreatScore> _threatScores = ThreatScore.convertFromJson(threatsScore);

    return GeigerScoreThreats(
        threatScores: _threatScores, geigerScore: geigerScore);
  }

  //a problem: please don't use
  // I need to understand it
  //I wanted to stored user recommendation into recommendation in
  // without using Recommendation.
  // set user relatedThreatsWeight in :recommendation node
  // void setUserRelatedThreatsWeightInRecommendation(
  //     {required Recommendation recommendationId,
  //     required List<ThreatWeight> threatWeight}) {
  //   setRelatedThreatsWeightInRecommendation(
  //       recommendationId: recommendationId.recommendationId!,
  //       threatsWeight: threatWeight,
  //       recommendationType: "user");
  // }

  /// <p>get UserRecommendation from recommendation node and set in :users node</p>
  /// @param optional language as locale
  /// @param threat object
  ///
  ///
  Future<void> setUserThreatRecommendation({Locale? language}) async {
    User currentUser = await getUserInfo;

    List<Recommendation> userRecommendations =
        await getThreatRecommendation(recommendationType: "user");
    try {
      _node = await _storageController
          .get(":Users:${currentUser.userId}:gi:data:recommendations");

      NodeValue threatRecomValue = NodeValueImpl("userRecommendation",
          Recommendation.convertToJson(userRecommendations));

      if (language != null) {
        //translations
        threatRecomValue.setValue(
            Recommendation.convertToJson(userRecommendations), language);
      }

      _node!.addOrUpdateValue(threatRecomValue);
      _storageController.update(_node!);
    } on StorageException {
      Node userRecommendationNode =
          NodeImpl("recommendations", ":Users:${currentUser.userId}:gi:data");
      _storageController.add(userRecommendationNode);

      NodeValue threatRecomValue = NodeValueImpl("userRecommendation",
          Recommendation.convertToJson(userRecommendations));

      if (language != null) {
        //translations
        threatRecomValue.setValue(
            Recommendation.convertToJson(userRecommendations), language);
      }

      userRecommendationNode.addOrUpdateValue(threatRecomValue);

      _storageController.update(userRecommendationNode);
    }
  }

  ///<p>get UserRecommendation from :user path</p>
  ///@param option language as string
  ///@param threat object
  ///@return list of threatRecommendation object
  Future<List<Recommendation>> getUserRecommendation({
    String language: "en",
  }) async {
    User currentUser = await getUserInfo;

    try {
      _node = await _storageController
          .get(":Users:${currentUser.userId}:gi:data:recommendations");
      String userRecommendations = await _node!
          .getValue("userRecommendation")
          .then((value) => value!.getValue(language)!);

      return Recommendation.convertFromJSon(userRecommendations);
    } on StorageException {
      throw Exception("NODE NOT FOUND");
    }
  }

  ///<p> set user ImplementedRecommendation
  ///@param recommendation as Recommendation
  ///@return bool
  Future<bool> setUserImplementedRecommendation(
      {required Recommendation recommendation}) async {
    User currentUser = await getUserInfo;

    List<Recommendation> implementedRecommendations = [];
    try {
      _node = await _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");
      implementedRecommendations.add(recommendation);

      NodeValue implementedRecom = NodeValueImpl("implementedRecommendations",
          Recommendation.convertToJson(implementedRecommendations));
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
      Locale? language, Node userScoreNode, threatScores, String geigerScore) {
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
}

//Todo

// write throw custom exception for all getters if object is not
// found

//add the following line of code below to geiger-toolbox ui

/*
SystemChrome.setPreferredOrientations(
[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/
