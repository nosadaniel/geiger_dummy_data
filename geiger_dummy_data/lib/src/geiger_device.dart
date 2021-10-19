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

  /// set currentDevice NodeValue in :Local
  void set setCurrentDevice(String currentDevice) {
    List<Device> device = Device.fromJSon(currentDevice);

    try {
      _node = _storageController.get(":Local");

      //create new NodeValue key
      localNodeValue =
          NodeValueImpl("currentDeviceNew", Device.convertToJson(device));
      _node!.addOrUpdateValue(localNodeValue!);
      _storageController.update(_node!);
      print(_node);
    } catch (e) {
      print(":Local not found");
    }
  }

  /// return list of single CurrentDevice
  List<Device> getCurrentDevice() {
    _node = _storageController.get(":Local");

    String currentDevice =
        _node!.getValue("currentDeviceNew")!.getValue("en").toString();
    return Device.fromJSon(currentDevice);
  }

  /* List<ThreatScore> getThreatScore(){

  }*/

  void setCurrentGeigerDeviceNodeAndNodeValue(
      List<Device> currentDevice, List<ThreatScore> threatScores) {
    for (Device device in currentDevice) {
      try {
        _node = _storageController
            .get(":Devices:${device.deviceId}:gi:data:GeigerScoreDevice");
        _geigerScore = NodeValueImpl("GEIGER_score", "0");
        _node!.addOrUpdateValue(_geigerScore!);
        _geigerThreatScores = NodeValueImpl(
            "threats_score", ThreatScore.convertToJson(threatScores));
        _node!.addOrUpdateValue(_geigerThreatScores!);
        _geigerNumMetrics =
            NodeValueImpl("number_metrics", threatScores.length.toString());
        _node!.addOrUpdateValue(_geigerNumMetrics!);

        _geigerScore!.setDescription("GEIGER user score");
        _geigerThreatScores!
            .setDescription("GEIGER threat-specific user score");
        _geigerNumMetrics!.setDescription(
            "Number of metrics used in calculation of user score");
        _storageController.update(_node!);
        //print(_node);
      } on StorageException {
        var numberMetrics = threatScores.length;
        Node deviceNode = NodeImpl("${device.deviceId}", ":Devices");
        _storageController.add(deviceNode);
        Node giNode = NodeImpl("gi", ":Devices:${device.deviceId}");
        _storageController.add(giNode);
        Node nodeData = NodeImpl("data", ":Devices:${device.deviceId}:gi");
        _storageController.add(nodeData);
        Node deviceScoreNode = NodeImpl(
            "GeigerScoreDevice", ":Devices:${device.deviceId}:gi:data");
        _storageController.add(deviceScoreNode);
        _geigerScore = NodeValueImpl("GEIGER_score", "0");
        deviceScoreNode.addOrUpdateValue(_geigerScore!);
        _geigerThreatScores = NodeValueImpl(
            "threats_score", ThreatScore.convertToJson(threatScores));
        deviceScoreNode.addOrUpdateValue(_geigerThreatScores!);
        _geigerNumMetrics =
            NodeValueImpl("number_metrics", numberMetrics.toString());
        deviceScoreNode.addOrUpdateValue(_geigerNumMetrics!);

        _storageController.addOrUpdate(deviceScoreNode);
        print(deviceScoreNode);
      }
    }
    //print(_node!.getValue("threats_score")!.getValue("en"));
  }

  //List<ThreatScore> get getGeigerScoreAggregate {}
}
