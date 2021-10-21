library geiger_dummy_data;

import 'package:geiger_localstorage/geiger_localstorage.dart';

import 'models/device.dart';
import 'models/threat_score.dart';

class GeigerDevice {
  StorageController _storageController;
  GeigerDevice(this._storageController);
  Node? _node;

  NodeValue? localNodeValue;

  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;

  /// set currentDeviceInfo NodeValue in :Local
  void set setCurrentDeviceInfo(Device currentDeviceInfo) {
    try {
      _node = _storageController.get(":Local");

      //create new NodeValue key
      localNodeValue = NodeValueImpl("currentDeviceNew",
          Device.convertToJsonCurrentDevice(currentDeviceInfo));
      _node!.addOrUpdateValue(localNodeValue!);
      _storageController.update(_node!);
      print(_node);
    } catch (e) {
      print(":Local not found");
    }
  }

  /// return Device CurrentDevice
  Device get getCurrentDeviceInfo {
    _node = _storageController.get(":Local");

    String currentDevice =
        _node!.getValue("currentDeviceNew")!.getValue("en").toString();
    return Device.currentDeviceFromJSon(currentDevice);
  }

  /// set GeigerScoreCurrentDeviceNodeAndNodeValue
  void setCurrentGeigerScoreDeviceNodeAndNodeValue(
      {required Device currentDevice,
      required List<ThreatScore> threatScores,
      String geigerScore: "0"}) {
    try {
      _node = _storageController
          .get(":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
      _setDeviceNodeValues(threatScores, geigerScore: geigerScore);
      //print(_node);
    } on StorageException {
      Node deviceNode = NodeImpl("${currentDevice.deviceId}", ":Devices");
      _storageController.add(deviceNode);
      Node giNode = NodeImpl("gi", ":Devices:${currentDevice.deviceId}");
      _storageController.add(giNode);
      Node nodeData = NodeImpl("data", ":Devices:${currentDevice.deviceId}:gi");
      _storageController.add(nodeData);
      Node deviceScoreNode = NodeImpl(
          "GeigerScoreDevice", ":Devices:${currentDevice.deviceId}:gi:data");
      _storageController.add(deviceScoreNode);
      _setDeviceNodeValuesException(deviceScoreNode, threatScores, geigerScore);
    }
  }

  ///get list of currentDeviceThreatScores
  List<ThreatScore> get getCurrentDeviceThreatScores {
    Device currentDevice = getCurrentDeviceInfo;
    _node = _storageController
        .get(":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");

    String threats_score =
        _node!.getValue("threats_score")!.getValue("en").toString();
    return ThreatScore.fromJSon(threats_score);
  }

  ///get CurrentGeigerDeviceScore
  String get getCurrentGeigerDeviceScore {
    Device currentDevice = getCurrentDeviceInfo;
    _node = _storageController
        .get(":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");

    String geigerScore =
        _node!.getValue("GEIGER_score")!.getValue("en").toString();
    return geigerScore;
  }

  void _setDeviceNodeValues(List<ThreatScore> threatScores,
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

  void _setDeviceNodeValuesException(Node deviceScoreNode,
      List<ThreatScore> threatScores, String geigerScore) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    deviceScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));
    deviceScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    deviceScoreNode.addOrUpdateValue(_geigerNumMetrics!);
  }
}
