library geiger_dummy_data;

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../geiger_dummy_data.dart';
import '../src/models/device.dart';
import '../src/models/threat_score.dart';
import '../src/recommendation_node.dart';
import 'models/geiger_score_threats.dart';

/// <p>Grant access to methods relating device.</p>
/// @param storageController
class DeviceNode extends RecommendationNode {
  StorageController _storageController;
  DeviceNode(this._storageController) : super(_storageController);
  Node? _node;

  NodeValue? localNodeValue;

  NodeValue? _geigerScore;
  NodeValue? _geigerThreatScores;
  NodeValue? _geigerNumMetrics;

  /// <p>set deviceInfo in currentDeviceNew NodeValue in :Local</p>
  /// @param user object
  /// @throws :Local not found on StorageException

  void set setCurrentDeviceInfo(Device currentDeviceInfo) {
    try {
      _node = _storageController.get(":Local");

      NodeValue currentDeviceId =
          NodeValueImpl("currentDevice", currentDeviceInfo.deviceId);
      _node!.addOrUpdateValue(currentDeviceId);
      //store deviceInfo in deviceDetails Nodevalue

      localNodeValue = NodeValueImpl(
          "deviceDetails", Device.convertDeviceToJson(currentDeviceInfo));
      _node!.addOrUpdateValue(localNodeValue!);
      _storageController.update(_node!);
    } on StorageException {
      throw Exception(":Local not found");
    }
  }

  ///<p> get current device info from :local value 'currentDeviceNew'
  /// @return device object
  /// @throws :Local not found on StorageException
  Device? get getDeviceInfo {
    try {
      _node = _storageController.get(":Local");

      String currentDevice =
          _node!.getValue("deviceDetails")!.getValue("en").toString();
      return Device.convertDeviceFromJson(currentDevice);
    } on StorageException {
      log("Node :Local not found");
      return null;
    }
  }

  /// <p>set GeigerDeviceScore. </p>
  /// @param option language as locale
  /// @param list of threatScore object
  /// @param optional geigerScore as string
  void setGeigerScoreDevice(
      {Locale? language, required GeigerScoreThreats geigerScoreThreats}) {
    if (getDeviceInfo != null) {
      Device currentDevice = getDeviceInfo!;
      try {
        _node = _storageController.get(
            ":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
        _setDeviceNodeValues(language, geigerScoreThreats.threatScores,
            geigerScore: geigerScoreThreats.geigerScore);
        //print(_node);
      } on StorageException {
        Node deviceNode = NodeImpl("${currentDevice.deviceId}", ":Devices");
        _storageController.add(deviceNode);
        Node giNode = NodeImpl("gi", ":Devices:${currentDevice.deviceId}");
        _storageController.add(giNode);
        Node nodeData =
            NodeImpl("data", ":Devices:${currentDevice.deviceId}:gi");
        _storageController.add(nodeData);
        Node deviceScoreNode = NodeImpl(
            "GeigerScoreDevice", ":Devices:${currentDevice.deviceId}:gi:data");
        _storageController.add(deviceScoreNode);
        _setDeviceNodeValuesException(language, deviceScoreNode,
            geigerScoreThreats.threatScores, geigerScoreThreats.geigerScore);
      }
    } else {
      log("currentDevice is null ");
    }
  }

  /// @param optional language as string
  /// @return GeigerScore as String  from GeigerScoreDevice Node
  /// @throw Node not found on StorageException
  // String getGeigerScoreDevice({String language: "en"}) {
  //   if (getDeviceInfo != null) {
  //     Device currentDevice = getDeviceInfo!;
  //     try {
  //       _node = _storageController.get(
  //           ":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
  //
  //       String geigerScore =
  //           _node!.getValue("GEIGER_score")!.getValue(language).toString();
  //       return geigerScore;
  //     } on StorageException {
  //       throw Exception("Node not found");
  //     }
  //   } else {
  //     throw Exception("currentDevice is null ");
  //   }
  // }

  /// @param optional language as string
  /// @return list of threatScore object from GeigerScoreDevice
  /// @throw node not found on StorageException
  GeigerScoreThreats getGeigerScoreDeviceThreatScores({String language: "en"}) {
    if (getDeviceInfo != null) {
      Device currentDevice = getDeviceInfo!;
      try {
        _node = _storageController.get(
            ":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
        String geigerScore =
            _node!.getValue("GEIGER_score")!.getValue(language).toString();

        String threats_score =
            _node!.getValue("threats_score")!.getValue(language).toString();
        List<ThreatScore> _threatScores =
            ThreatScore.convertFromJson(threats_score);

        return GeigerScoreThreats(
            threatScores: _threatScores, geigerScore: geigerScore);
      } on StorageException {
        throw Exception("Node not found");
      }
    } else {
      throw Exception("currentDevice is null ");
    }
  }

  /// <p>get DeviceRecommendation from recommendation node and set in :device node</p>
  /// @param optional language as locale
  /// @param threat object
  void setDeviceRecommendation({Locale? language}) {
    if (getDeviceInfo != null) {
      Device currentDevice = getDeviceInfo!;
      List<Recommendation> threatRecommendations =
          getThreatRecommendation(recommendationType: "device");
      try {
        _node = _storageController
            .get(":Devices:${currentDevice.deviceId}:gi:data:recommendations");

        NodeValue threatRecomValue = NodeValueImpl("deviceRecommendation",
            Recommendation.convertToJson(threatRecommendations));

        if (language != null) {
          //translations
          threatRecomValue.setValue(
              Recommendation.convertToJson(threatRecommendations), language);
        }

        _node!.addOrUpdateValue(threatRecomValue);
        _storageController.update(_node!);
      } on StorageException {
        Node deviceRecommendationNode = NodeImpl(
            "recommendations", ":Devices:${currentDevice.deviceId}:gi:data");
        _storageController.add(deviceRecommendationNode);

        NodeValue threatRecomValue = NodeValueImpl("deviceRecommendations",
            Recommendation.convertToJson(threatRecommendations));

        if (language != null) {
          //translations
          threatRecomValue.setValue(
              Recommendation.convertToJson(threatRecommendations), language);
        }

        deviceRecommendationNode.addOrUpdateValue(threatRecomValue);
        _storageController.update(deviceRecommendationNode);
      }
    } else {
      log("currentDevice is null ");
    }
  }

  ///<p>get deviceRecommendation from :device node</p>
  ///@param option language as string
  ///@param threat object
  ///@return list of threatRecommendation object
  List<Recommendation> getDeviceThreatRecommendation({String language: "en"}) {
    if (getDeviceInfo != null) {
      Device currentDevice = getDeviceInfo!;
      try {
        _node = _storageController
            .get(":Devices:${currentDevice.deviceId}:gi:data:recommendations");
        String threatRecommendations = _node!
            .getValue("deviceRecommendations")!
            .getValue(language)
            .toString();

        return Recommendation.convertFromJSon(threatRecommendations);
      } on StorageException {
        throw Exception("NODE NOT FOUND");
      }
    } else {
      throw Exception("currentDevice is null");
    }
  }

  ///<p> set device ImplementedRecommendation
  ///@param recommendationId as string
  ///@return bool
  bool setDeviceImplementedRecommendation(
      {required Recommendation recommendation}) {
    if (getDeviceInfo != null) {
      Device currentDevice = getDeviceInfo!;
      List<Recommendation> implementedRecommendations = [];

      try {
        _node = _storageController.get(
            ":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
        implementedRecommendations.add(recommendation);

        NodeValue implementedRecom = NodeValueImpl("implementedRecommendations",
            Recommendation.convertToJson(implementedRecommendations));
        _node!.addOrUpdateValue(implementedRecom);

        _storageController.update(_node!);
        return true;
      } catch (e) {
        log("failed to addOrUpdate implementedRecommendations NodeValue");
        return false;
      }
    } else {
      throw Exception("currentDevice is null");
    }
  }

  void _setDeviceNodeValues(Locale? language, List<ThreatScore> threatScores,
      {String geigerScore: "0"}) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    _node!.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));

    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    _node!.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    _node!.addOrUpdateValue(_geigerNumMetrics!);

    _storageController.update(_node!);
  }

  void _setDeviceNodeValuesException(Locale? language, Node deviceScoreNode,
      List<ThreatScore> threatScores, String geigerScore) {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    deviceScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));

    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    deviceScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    deviceScoreNode.addOrUpdateValue(_geigerNumMetrics!);
    _storageController.update(deviceScoreNode);
  }
}
//Todo
//Ask martin to remove currentDevice Nodevalue
// I can't override it except I use another Nodevalue name

//Note: I can override when data is first populated but error pop up on refresh.
//Error message: can't retrive data from :device:path
