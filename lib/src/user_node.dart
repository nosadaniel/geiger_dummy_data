library geiger_dummy_mapper;

import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

/// <p>Grant access to methods relating user.</p>
/// @param storageController
class UserNode extends RecommendationNode {
  StorageController _storageController;

  UserNode(this._storageController) : super(_storageController);
  Node? _node;
  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;

  ///get currentUserId
  Future<String> get _getCurrentUserId async {
    try {
      Node _node = await _storageController.get(":Local");
      String currentUser = await _node
          .getValue("currentUser")
          .then((value) => value!.getValue("en")!);
      return currentUser;
    } on StorageException {
      throw ("Node :Local not found");
    }
  }

  /// <p>set userInfo in currentUser NodeValue in :Local</p>
  /// @param user object
  /// @throws :Local not found on StorageException
  Future<void> setUserInfo(User currentUserInfo) async {
    try {
      _node = await _storageController.get(":Local");

      String currentUserId = await _getCurrentUserId;
      currentUserInfo.userId = currentUserId;
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
    String currentUser = await _getCurrentUserId;

    try {
      _node = await _storageController
          .get(":Users:${currentUser}:gi:data:GeigerScoreUser");
      _setUserNodeValues(language, geigerScoreThreats.threatScores,
          geigerScore: geigerScore);
    } on StorageException {
      Node userNode = NodeImpl(":Users:${currentUser}", " owner");
      await _storageController.addOrUpdate(userNode);

      Node giNode = NodeImpl(":Users:${currentUser}:gi", "owner");
      await _storageController.addOrUpdate(giNode);

      Node nodeData = NodeImpl(":Users:${currentUser}:gi:data", "owner");
      await _storageController.addOrUpdate(nodeData);

      Node userScoreNode =
          NodeImpl(":Users:${currentUser}:gi:data:GeigerScoreUser", "owner");

      await _storageController.add(userScoreNode);
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
    String currentUser = await _getCurrentUserId;

    try {
      _node = await _storageController
          .get(":Users:${currentUser}:gi:data:GeigerScoreAggregate");
      _setUserNodeValues(language, geigerScoreThreats.threatScores,
          geigerScore: geigerScoreThreats.geigerScore);
    } on StorageException {
      Node userNode = NodeImpl(":Users:${currentUser}", "owner");
      await _storageController.addOrUpdate(userNode);

      Node giNode = NodeImpl(":Users:${currentUser}:gi", "owner");
      await _storageController.addOrUpdate(giNode);

      Node nodeData = NodeImpl(":Users:${currentUser}:gi:data", "owner");
      await _storageController.addOrUpdate(nodeData);

      Node aggScoreNode = NodeImpl(
          ":Users:${currentUser}:gi:data:GeigerScoreAggregate", "owner");
      await _storageController.add(aggScoreNode);

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
    String currentUser = await _getCurrentUserId;

    try {
      _node = await _storageController
          .get(":Users:${currentUser}:gi:data:GeigerScoreUser");

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
    String currentUser = await _getCurrentUserId;

    _node = await _storageController
        .get(":Users:${currentUser}:gi:data:GeigerScoreAggregate");

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
  // Future<void> setUserThreatRecommendation({Locale? language}) async {
  //   User currentUser = await getUserInfo;
  //
  //   List<Recommendations> userRecommendations =
  //       await getThreatRecommendation(recommendationType: "user");
  //   try {
  //     _node = await _storageController
  //         .get(":Users:${currentUser.userId}:gi:data:recommendations");
  //
  //     NodeValue threatRecomValue = NodeValueImpl("userRecommendation",
  //         Recommendations.convertToJson(userRecommendations));
  //
  //     if (language != null) {
  //       //translations
  //       threatRecomValue.setValue(
  //           Recommendations.convertToJson(userRecommendations), language);
  //     }
  //
  //     await _node!.addOrUpdateValue(threatRecomValue);
  //     await _storageController.update(_node!);
  //   } on StorageException {
  //     Node userRecommendationNode = NodeImpl(
  //         ":Users:${currentUser.userId}:gi:data:recommendations", "owner");
  //     await _storageController.add(userRecommendationNode);
  //
  //     NodeValue threatRecomValue = NodeValueImpl("userRecommendation",
  //         Recommendations.convertToJson(userRecommendations));
  //
  //     if (language != null) {
  //       //translations
  //       threatRecomValue.setValue(
  //           Recommendations.convertToJson(userRecommendations), language);
  //     }
  //
  //     await userRecommendationNode.addOrUpdateValue(threatRecomValue);
  //
  //     _storageController.update(userRecommendationNode);
  //   }
  // }
  Future<bool> setUserImplementedRecommendation(
      {required Recommendations recommendation}) async {
    User currentUser = await getUserInfo;

    List<Recommendations> implementedRecommendations = [];
    try {
      _node = await _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");
      implementedRecommendations.add(recommendation);

      NodeValue implementedRecom = NodeValueImpl("implementedRecommendations",
          Recommendations.convertToJson(implementedRecommendations));
      await _node!.addOrUpdateValue(implementedRecom);

      await _storageController.update(_node!);
      return true;
    } catch (e) {
      log("failed to addOrUpdate implementedRecommendations NodeValue");
      return false;
    }
  }

  void _setUserNodeValues(Locale? language, List<ThreatScore> threatScores,
      {String geigerScore: "0"}) async {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    await _node!.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));

    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    await _node!.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    await _node!.addOrUpdateValue(_geigerNumMetrics!);

    await _storageController.update(_node!);
  }

  void _setUserNodeValuesException(Locale? language, Node userScoreNode,
      threatScores, String geigerScore) async {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    await userScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    await userScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    await userScoreNode.addOrUpdateValue(_geigerNumMetrics!);
    await _storageController.update(userScoreNode);
  }
}

//Todo

// write throw custom exception for all getters if object is not
// found

//add the following line of code below to geiger-toolbox ui

/*
SystemChrome.setPreferredOrientations(
[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/
