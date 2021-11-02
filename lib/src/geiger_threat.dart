library geiger_dummy_data;

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../src/models/threat.dart';

/// <p>Grant access to methods relating threat.</p>
/// @param storageController
class GeigerThreat {
  StorageController _storageController;
  GeigerThreat(this._storageController);

  Node? _node;

  /// <p> set all threat in Global:threats node</p>
  /// @param optional language as locale
  /// @param list of threat object
  void setGlobalThreatsNode({Locale? language, required List<Threat> threats}) {
    try {
      for (Threat threat in threats) {
        _node = _storageController.get(':Global:threats:${threat.threatId}');
        //create a NodeValue
        _setThreatsNodeValue(language, threat);
      }
    } on StorageException {
      //log(":Global:threats not found");
      Node threatsNode = NodeImpl("threats", ":Global");
      _storageController.addOrUpdate(threatsNode);

      for (Threat threat in threats) {
        Node threatIdNode = NodeImpl("${threat.threatId}", ":Global:threats");
        //create :Global:threats:$threatId
        _storageController.addOrUpdate(threatIdNode);
        //create a NodeValue
        _setThreatsNodeValueException(language, threat, threatIdNode);
      }
    }
  }

  ///@param optional language as string
  ///@return  list of threats from localStorage
  List<Threat> getThreats({String language: "en"}) {
    List<Threat> t = [];
    _node = _storageController.get(":Global:threats");

    //return _node!.getChildNodesCsv();
    for (String threatId in _node!.getChildNodesCsv().split(",")) {
      Node threatNode = _storageController.get(":Global:threats:$threatId");
      t.add(Threat(
          threatId: threatId,
          name: threatNode.getValue("name")!.getValue(language).toString()));
    }
    return t;
  }

  void _setThreatsNodeValue(Locale? language, Threat threat) {
    //create a NodeValue
    NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
    //translations
    if (language != null) {
      threatNodeValueName.setValue(threat.name, language);
    }
    // add NodeValue to threatChildNode
    _node!.addOrUpdateValue(threatNodeValueName);
    _storageController.update(_node!);
  }

  void _setThreatsNodeValueException(
      Locale? language, Threat threat, Node threatIdNode) {
    //create a NodeValue
    NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
    //translations
    if (language != null) {
      threatNodeValueName.setValue(threat.name, language);
    }

    // add NodeValue to threatChildNode
    threatIdNode.addOrUpdateValue(threatNodeValueName);
    _storageController.update(threatIdNode);
    log(threatIdNode.toString());
  }
}
