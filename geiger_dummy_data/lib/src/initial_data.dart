library geiger_dummy_data;

import 'dart:developer';

import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_dummy_data/src/models/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class InitialData {
  StorageController _storageController;
  InitialData(this._storageController);
  Node? _node;

  /// set currentUser NodeValue in :Local
  void set setCurrentUser(String jsonArray) {
    List<User> users = User.fromJSon(jsonArray);
    try {
      _node = _storageController.get(":Local");
      NodeValue localNodeValue =
          NodeValueImpl("currentUser", User.convertToJson(users));
      _node!.addOrUpdateValue(localNodeValue);
      //_storageController.addOrUpdate(_node!);
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

  /*void set setGeigerScoreAggregate(String jsonArray) {
    List<Threat> threatScores = ThreatScore.fromJSon(jsonArray);
    try{
      _threatNode = _storageController.get(":")
    }
  }

  List<ThreatScore> get getGeigerScoreAggregate {}*/
}
