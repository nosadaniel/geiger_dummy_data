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

  /// set currentUser NodeValue in :Local
  void set setCurrentUser(String currentUserArray) {
    List<User> users = User.fromJSon(currentUserArray);

    try {
      _node = _storageController.get(":Local");
      NodeValue localNodeValue =
          NodeValueImpl("currentUser", User.convertToJson(users));
      _node!.addOrUpdateValue(localNodeValue);
      _storageController.update(_node!);
      print(_node);
    } on StorageException {
      log(":Local not found");
    }
  }

  /// return list of single CurrentUser
  List<User> getCurrentUser() {
    _node = _storageController.get(":Local");
    String currentUser =
        _node!.getValue("currentUser")!.getValue("en").toString();
    return User.fromJSon(currentUser);
  }

  void setCurrentGeigerUserScoreNodeAndNodeValue(
      List<User> currentUser, List<ThreatScore> threatScores) {
    for (User user in currentUser) {
      try {
        _node = _storageController
            .get(":Users:${user.userId}:gi:data:GeigerScoreUser");
        _setUserNodeValues(threatScores);
      } on StorageException {
        var numberMetrics = threatScores.length;
        Node userNode = NodeImpl("${user.userId}", ":Users");
        _storageController.addOrUpdate(userNode);
        Node giNode = NodeImpl("gi", ":Users:${user.userId}");
        _storageController.addOrUpdate(giNode);
        Node nodeData = NodeImpl("data", ":Users:${user.userId}:gi");
        _storageController.addOrUpdate(nodeData);
        Node userScoreNode =
            NodeImpl("GeigerScoreUser", ":Users:${user.userId}:gi:data");
        _storageController.add(userScoreNode);
        _setUserNodeValuesException(userScoreNode, threatScores);
      }
    }
    //print(_node!.getValue("threats_score")!.getValue("en"));
  }

  void setGeigerScoreAggregate(
      List<ThreatScore> threatScores, List<User> currentUsers) {
    for (User user in currentUsers) {
      try {
        _node = _storageController
            .get(":Users:${user.userId}:gi:data:GeigerScoreAggregate");
        _setUserNodeValues(threatScores);
      } on StorageException {
        Node aggScoreNode =
            NodeImpl("GeigerScoreAggregate", ":Users:${user.userId}:gi:data");
        _storageController.addOrUpdate(aggScoreNode);
        _geigerScore = NodeValueImpl("GEIGER_score", "0");
        _setUserNodeValuesException(aggScoreNode, threatScores);
      }
    }
  }

  void _setUserNodeValues(List<ThreatScore> threatScores) {
    _geigerScore = NodeValueImpl("GEIGER_score", "0");
    _node!.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    _node!.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    _node!.addOrUpdateValue(_geigerNumMetrics!);

    _storageController.update(_node!);
    print(_node);
  }

  void _setUserNodeValuesException(Node aggScoreNode, threatScores) {
    _geigerScore = NodeValueImpl("GEIGER_score", "0");
    aggScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    aggScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    aggScoreNode.addOrUpdateValue(_geigerNumMetrics!);

    print(aggScoreNode);
  }
}
