library geiger_dummy_mapper;

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';

import 'models/threat_score.dart';
import 'models/user.dart';

class GeigerUser {
  StorageController _storageController;

  GeigerUser(this._storageController);
  Node? _node;
  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;

  /// set currentUserInfo NodeValue in :Local
  void set setCurrentUserInfo(User currentUserInfo) {
    try {
      _node = _storageController.get(":Local");
      NodeValue localNodeValue = NodeValueImpl(
          "currentUser", User.convertToJsonCurrentUser(currentUserInfo));
      _node!.addOrUpdateValue(localNodeValue);
      _storageController.update(_node!);
    } on StorageException {
      log(":Local not found");
    }
  }

  /// return User CurrentUserInfo
  User get getCurrentUserInfo {
    _node = _storageController.get(":Local");
    String currentUser =
        _node!.getValue("currentUser")!.getValue("en").toString();
    return User.currentUserFromJSon(currentUser);
  }

  /// set GeigerCurrentUserScoreNodeAndNodeValue
  void setCurrentGeigerUserScoreNodeAndNodeValue(
      {required User currentUser,
      required List<ThreatScore> threatScores,
      String geigerScore: "0"}) {
    User currentUser = getCurrentUserInfo;
    try {
      _node = _storageController
          .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");
      _setUserNodeValues(threatScores, geigerScore: geigerScore);
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
      _setUserNodeValuesException(userScoreNode, threatScores,
          geigerScore: geigerScore);
    }

    //print(_node!.getValue("threats_score")!.getValue("en"));
  }

  ///get list of currentUserThreatScores
  List<ThreatScore> get getCurrentGeigerUserThreatScores {
    User currentUser = getCurrentUserInfo;
    _node = _storageController
        .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");

    String threats_score =
        _node!.getValue("threats_score")!.getValue("en").toString();
    return ThreatScore.fromJSon(threats_score);
  }

  ///get CurrentGeigerUserScore
  String get getCurrentGeigerUserScore {
    User currentUser = getCurrentUserInfo;
    _node = _storageController
        .get(":Users:${currentUser.userId}:gi:data:GeigerScoreUser");

    String geigerScore =
        _node!.getValue("GEIGER_score")!.getValue("en").toString();
    return geigerScore;
  }

  void _setUserNodeValues(List<ThreatScore> threatScores,
      {String geigerScore: "0"}) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    _node!.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    _node!.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    _node!.addOrUpdateValue(_geigerNumMetrics!);

    _storageController.update(_node!);
  }

  void _setUserNodeValuesException(Node userScoreNode, threatScores,
      {String geigerScore: "0"}) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    userScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    userScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    userScoreNode.addOrUpdateValue(_geigerNumMetrics!);
  }
}

//Todo
//Can't be Done: let ids be autogenerated except being explicitly defined
//Note: can only be done during initialization
//add the following line of code below to geiger-toolbox ui

/*
SystemChrome.setPreferredOrientations(
[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/