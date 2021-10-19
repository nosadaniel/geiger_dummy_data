library geiger_dummy_data;

import 'dart:developer';

import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

import 'models/device.dart';
import 'models/threat_score.dart';

class InitialData {
  StorageController _storageController;
  InitialData(this._storageController);
  Node? _node;

  NodeValue? localNodeValue;

  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;

  /// set currentUser NodeValue in :Local
  void set setCurrentUser(String currentUser) {
    List<User> users = User.fromJSon(currentUser);

    try {
      _node = _storageController.get(":Local");
      localNodeValue = NodeValueImpl("currentUser", User.convertToJson(users));
      _node!.addOrUpdateValue(localNodeValue!);
      //_storageController.addOrUpdate(_node!);
      print(_node);
    } on StorageException {
      log(":Local not found");
    }
  }

  /// return list of single CurrentUser
  List<User> getCurrentUser(String jsonArray) {
    try {
      _node = _storageController.get(":Local");
      setCurrentUser = jsonArray;
      String currentUser =
          _node!.getValue("currentUser")!.getValue("en").toString();
      return User.fromJSon(currentUser);
    } on StorageController {
      setCurrentUser = jsonArray;
      String currentUser =
          _node!.getValue("currentUser")!.getValue("en").toString();
      return User.fromJSon(currentUser);
    }
  }

  /// set currentDevice NodeValue in :Local
  void set setCurrentDevice(String currentDevice) {
    List<Device> device = Device.fromJSon(currentDevice);

    try {
      _node = _storageController.get(":Local");
      localNodeValue =
          NodeValueImpl("currentDevice", Device.convertToJson(device));
      _node!.addOrUpdateValue(localNodeValue!);
      //_storageController.addOrUpdate(_node!);
      print(_node);
    } on StorageException {
      log(":Local not found");
    }
  }

  /// set all threat in Global:threats node
  void set setGlobalThreatsNode(String jsonArray) {
    List<Threat> threats = Threat.fromJSon(jsonArray);
    Node threatChildNode;

    try {
      _node = _storageController.get(':Global:threats');
      //create :Global:threats:$threatId
      for (Threat threat in threats) {
        threatChildNode = NodeImpl(":Global:threats:${threat.threatId}");
        //create :Global:threats:$threatId
        _node!.addChild(threatChildNode);
        //create a NodeValue
        NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
        // add NodeValue to threatChildNode
        threatChildNode.addValue(threatNodeValueName);
        //update threatNode
        log(threatChildNode.toString());
      }
    } on StorageException {
      log(":Global:threats not found");
      _node = NodeImpl("threats", ":Global");
      for (Threat threat in threats) {
        threatChildNode = NodeImpl("${threat.threatId}", ":Global:threats:");
        //create :Global:threats:$threatId
        _node!.addChild(threatChildNode);
        //create a NodeValue
        NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
        // add NodeValue to threatChildNode
        threatChildNode.addValue(threatNodeValueName);

        log(threatChildNode.toString());
      }
    }
  }

  List<Threat> getThreats(String jsonArray) {
    List<Threat> t = [];
    try {
      _node = _storageController.get(":Global:threats");
      setGlobalThreatsNode = jsonArray;
      _node!.getChildren().forEach((key, value) {
        return t.add(Threat(
            threatId: key,
            name: value.getValue("name")!.getValue("en").toString()));
      });
      return t;
    } on StorageException {
      setGlobalThreatsNode = jsonArray;
      _node!.getChildren().forEach((key, value) {
        return t.add(Threat(
            threatId: key,
            name: value.getValue("name")!.getValue("en").toString()));
      });
      return t;
    }
  }

  void setCurrentGeigerUserScoreNode(
      List<User> currentUser, List<ThreatScore> threatScores) {
    for (User user in currentUser) {
      try {
        _node = _storageController
            .get(":Users:${user.userId}:gi:data:GeigerScoreUser");
        NodeValue geigerScore = NodeValueImpl("GEIGER_score", "0");
        _node!.addOrUpdateValue(geigerScore);
        NodeValue geigerThreatScores = NodeValueImpl(
            "threats_score", ThreatScore.convertToJson(threatScores));
        _node!.addOrUpdateValue(geigerThreatScores);
        NodeValue geigerNumMetrics =
            NodeValueImpl("number_metrics", threatScores.length.toString());
        _node!.addOrUpdateValue(geigerNumMetrics);

        geigerScore.setDescription("GEIGER user score");
        geigerThreatScores.setDescription("GEIGER threat-specific user score");
        geigerNumMetrics.setDescription(
            "Number of metrics used in calculation of user score");
        _storageController.update(_node!);
        print(_node);
      } on StorageException {
        var numberMetrics = threatScores.length;
        Node userNode = NodeImpl("${user.userId}", ":Users");
        _storageController.add(userNode);
        Node giNode = NodeImpl("gi", ":Users:${user.userId}");
        _storageController.add(giNode);
        Node nodeData = NodeImpl("data", ":Users:${user.userId}:gi");
        _storageController.add(nodeData);
        Node userScoreNode =
            NodeImpl("GeigerScoreUser", ":Users:${user.userId}:gi:data");
        _storageController.add(userScoreNode);
        _geigerScore = NodeValueImpl("GEIGER_score", "0");
        userScoreNode.addOrUpdateValue(_geigerScore!);
        _geigerThreatScores = NodeValueImpl(
            "threats_score", ThreatScore.convertToJson(threatScores));
        userScoreNode.addOrUpdateValue(_geigerThreatScores!);
        _geigerNumMetrics =
            NodeValueImpl("number_metrics", numberMetrics.toString());
        userScoreNode.addOrUpdateValue(_geigerNumMetrics!);

        _geigerScore!.setDescription("GEIGER user score");
        _geigerThreatScores!
            .setDescription("GEIGER threat-specific user score");
        _geigerNumMetrics!.setDescription(
            "Number of metrics used in calculation of user score");
        _storageController.addOrUpdate(userScoreNode);
        print(userScoreNode);
      }
    }
    //print(_node!.getValue("threats_score")!.getValue("en"));
  }
  /* List<ThreatScore> getThreatScore(){

  }*/

  void setGeigerScoreAggregate(
      List<ThreatScore> threatScores, List<User> currentUsers) {
    for (User user in currentUsers) {
      try {
        _node = _storageController
            .get(":Users:${user.userId}:gi:data:GeigerScoreAggregate");
        print(_node);
      } on StorageException {
        Node aggScoreNode =
            NodeImpl("GeigerScoreAggregate", ":Users:${user.userId}:gi:data");
        _storageController.add(aggScoreNode);
        _geigerScore = NodeValueImpl("GEIGER_score", "0");
        aggScoreNode.addOrUpdateValue(_geigerScore!);
        _geigerThreatScores = NodeValueImpl(
            "threats_score", ThreatScore.convertToJson(threatScores));
        aggScoreNode.addOrUpdateValue(_geigerThreatScores!);
        _geigerNumMetrics =
            NodeValueImpl("number_metrics", threatScores.length.toString());
        aggScoreNode.addOrUpdateValue(_geigerNumMetrics!);
        _storageController.addOrUpdate(aggScoreNode);
        print(aggScoreNode);
      }
    }
  }

  //List<ThreatScore> get getGeigerScoreAggregate {}
}
