library geiger_dummy_data;

import 'package:geiger_dummy_data/src/models/threat.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class GeigerThreat {
  StorageController _storageController;
  GeigerThreat(this._storageController);

  Node? _node;

  /// set all threat in Global:threats node
  void set setGlobalThreatsNode(List<Threat> threats) {
    try {
      for (Threat threat in threats) {
        _node = _storageController.get(':Global:threats:${threat.threatId}');
        //create a NodeValue
        _setThreatsNodeValue(threat);
      }
    } on StorageException {
      //log(":Global:threats not found");
      Node threatsNode = NodeImpl("threats", ":Global");
      _storageController.addOrUpdate(threatsNode);

      for (Threat threat in threats) {
        Node threatIdNode = NodeImpl("${threat.threatId}", ":Global:threats");
        //create :Global:threats:$threatId
        _storageController.add(threatIdNode);
        //create a NodeValue
        _setThreatsNodeValueException(threat, threatIdNode);
      }
    }
  }

  ///from return list of threats from localStorage
  List<Threat> getThreats() {
    List<Threat> t = [];
    _node = _storageController.get(":Global:threats");

    //return _node!.getChildNodesCsv();
    for (String threatId in _node!.getChildNodesCsv().split(",")) {
      Node threatNode = _storageController.get(":Global:threats:$threatId");
      t.add(Threat(
          threatId: threatId,
          name: threatNode.getValue("name")!.getValue("en").toString()));
    }
    return t;
  }

  void _setThreatsNodeValue(Threat threat) {
    //create a NodeValue
    NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
    // add NodeValue to threatChildNode
    _node!.addOrUpdateValue(threatNodeValueName);
    _storageController.update(_node!);
    print(_node);
  }

  void _setThreatsNodeValueException(Threat threat, Node threatIdNode) {
    //create a NodeValue
    NodeValue threatNodeValueName = NodeValueImpl("name", threat.name);
    // add NodeValue to threatChildNode
    threatIdNode.addOrUpdateValue(threatNodeValueName);
    _storageController.update(threatIdNode);
    print(threatIdNode);
  }
}
