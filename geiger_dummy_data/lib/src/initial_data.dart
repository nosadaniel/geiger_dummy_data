library geiger_dummy_data;

import 'dart:developer';

import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class InitialData {
  StorageController _storageController;
  InitialData(this._storageController);
  Node? _threatNode;
  void populateGlobalThreatsNode({required String json}) {
    List<Threat> threats = Threat.fromJSon(json);

    try {
      _threatNode = _storageController.get(':Global:threats');
    } on StorageException {
      _threatNode = NodeImpl("threats", ":Global");
      //create :Global:threats
      _storageController.add(_threatNode!);
      for (Threat threat in threats) {
        Node threatChildNode = NodeImpl(":Global:threats:${threat.threatId}");
        //create :Global:threats:$threatId
        _threatNode!.addChild(threatChildNode);
        //create a NodeValue
        NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
        // add NodeValue to threatChildNode
        threatChildNode.addValue(threatNodeValueName);
        //update threatNode
        _storageController.update(_threatNode!);
        log(threatChildNode.toString());
      }
    }
  }

  List<Threat> getThreats(String json) {
    List<Threat> t = [];
    try {
      _threatNode = _storageController.get(":Global:threats");
      //log(threatNode!.getChildren().toString());
      _threatNode!.getChildren().forEach((key, value) {
        return t.add(Threat(
            threatId: key,
            name: value.getValue("name")!.getValue("en").toString()));
      });
      return t;
    } on StorageException {
      populateGlobalThreatsNode(json: json);
      log(":Global:threats can not be find in the database");
      _threatNode = _storageController.get(":Global:threats");
      //log(threatNode!.getChildren().toString());
      log(_threatNode!.getChildNodesCsv());
      _threatNode!.getChildren().forEach((key, value) {
        return t.add(Threat(
            threatId: key,
            name: value.getValue("name")!.getValue("en").toString()));
      });
      return t;
    }
  }
}
