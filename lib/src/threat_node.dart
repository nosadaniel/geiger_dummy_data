library geiger_dummy_data;

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../src/models/threat.dart';

/// <p>Grant access to methods relating threat.</p>
/// @param storageController
class ThreatNode {
  StorageController _storageController;
  ThreatNode(this._storageController);

  Node? _node;

  /// <p> set all threat in Global:threats node</p>
  /// @param optional language as locale
  /// @param list of threat object
  Future<void> setGlobalThreatsNode(
      {Locale? language, required List<Threat> threats}) async {
    try {
      for (Threat threat in threats) {
        _node =
            await _storageController.get(':Global:threats:${threat.threatId}');
        //create a NodeValue
        _setThreatsNodeValue(language, threat);
      }
    } on StorageException {
      //log(":Global:threats not found");
      Node threatsNode = NodeImpl("threats", ":Global");
      await _storageController.addOrUpdate(threatsNode);

      for (Threat threat in threats) {
        Node threatIdNode = NodeImpl("${threat.threatId}", ":Global:threats");
        //create :Global:threats:$threatId
        await _storageController.addOrUpdate(threatIdNode);
        //create a NodeValue
        _setThreatsNodeValueException(language, threat, threatIdNode);
      }
    }
  }

  ///@param optional language as string
  ///@return  list of threats from localStorage
  Future<List<Threat>> getThreats({String language: "en"}) async {
    List<Threat> t = [];
    try {
      _node = await _storageController.get(":Global:threats");

      //return _node!.getChildNodesCsv();
      for (String threatId in await _node!
          .getChildNodesCsv()
          .then((value) => value.split(','))) {
        Node threatNode =
            await _storageController.get(":Global:threats:$threatId");

        t.add(Threat(
            threatId: threatId,
            name: await threatNode
                .getValue("name")
                .then((value) => value!.getValue(language)!)));
      }
    } on StorageException {
      rethrow;
    }
    return t;
  }

  void _setThreatsNodeValue(Locale? language, Threat threat) async {
    //create a NodeValue
    NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
    //translations
    if (language != null) {
      threatNodeValueName.setValue(threat.name, language);
    }
    // add NodeValue to threatChildNode
    await _node!.addOrUpdateValue(threatNodeValueName);
    await _storageController.update(_node!);
  }

  void _setThreatsNodeValueException(
      Locale? language, Threat threat, Node threatIdNode) async {
    //create a NodeValue
    NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
    //translations
    if (language != null) {
      threatNodeValueName.setValue(threat.name, language);
    }

    // add NodeValue to threatChildNode
    await threatIdNode.addOrUpdateValue(threatNodeValueName);
    await _storageController.update(threatIdNode);
    log(threatIdNode.toString());
  }
}
