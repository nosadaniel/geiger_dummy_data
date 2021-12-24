library geiger_dummy_data;

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

import '../geiger_dummy_data.dart';

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

  ///get currentDeviceId
  Future<String> get _getCurrentDeviceId async {
    try {
      Node _node = await _storageController.get(":Local");
      String currentUser = await _node
          .getValue("currentDevice")
          .then((value) => value!.getValue("en")!);
      return currentUser;
    } on StorageException {
      throw ("Node :Local not found");
    }
  }

  /// <p>set deviceInfo in currentDeviceNew NodeValue in :Local</p>
  /// @param user object
  /// @throws :Local not found on StorageException

  Future<void> setCurrentDeviceInfo(Device currentDeviceInfo) async {
    try {
      _node = await _storageController.get(":Local");

      currentDeviceInfo.deviceId = await _getCurrentDeviceId;
      localNodeValue = NodeValueImpl(
          "deviceDetails", Device.convertDeviceToJson(currentDeviceInfo));
      await _node!.addOrUpdateValue(localNodeValue!);
      await _storageController.update(_node!);
    } on StorageException {
      throw Exception(":Local not found");
    }
  }

  ///<p> get current device info from :local value 'currentDeviceNew'
  /// @return device object
  /// @throws :Local not found on StorageException
  Future<Device> get getDeviceInfo async {
    try {
      _node = await _storageController.get(":Local");

      String currentDevice = await _node!
          .getValue("deviceDetails")
          .then((value) => value!.getValue("en")!);

      return Device.convertDeviceFromJson(currentDevice);
    } on StorageException {
      log("Node :Local not found");
      rethrow;
    }
  }

  /// <p>set GeigerDeviceScore. </p>
  /// @param option language as locale
  /// @param list of threatScore object
  /// @param optional geigerScore as string
  void setGeigerScoreDevice(
      {Locale? language,
      required GeigerScoreThreats geigerScoreThreats}) async {
    Device currentDevice = await getDeviceInfo;

    try {
      _node = await _storageController
          .get(":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
      _setDeviceNodeValues(language, geigerScoreThreats.threatScores,
          geigerScore: geigerScoreThreats.geigerScore);
      //print(_node);
    } on StorageException {
      Node deviceNode = NodeImpl(":Devices:${currentDevice.deviceId}", "owner");
      await _storageController.addOrUpdate(deviceNode);
      Node giNode = NodeImpl(":Devices:${currentDevice.deviceId}:gi", "owner");
      await _storageController.addOrUpdate(giNode);
      Node nodeData =
          NodeImpl(":Devices:${currentDevice.deviceId}:gi:data", "owner");
      await _storageController.addOrUpdate(nodeData);
      Node deviceScoreNode = NodeImpl(
          ":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice",
          "owner");
      await _storageController.addOrUpdate(deviceScoreNode);
      _setDeviceNodeValuesException(language, deviceScoreNode,
          geigerScoreThreats.threatScores, geigerScoreThreats.geigerScore);
    }
  }

  ///// @param optional language as string
  ///// @return GeigerScore as String  from GeigerScoreDevice Node
  ///// @throw Node not found on StorageException
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
  Future<GeigerScoreThreats> getGeigerScoreDeviceThreatScores(
      {String language: "en"}) async {
    Device currentDevice = await getDeviceInfo;

    try {
      _node = await _storageController
          .get(":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
      String geigerScore = await _node!
          .getValue("GEIGER_score")
          .then((value) => value!.getValue(language).toString());

      String threats_score = await _node!
          .getValue("threats_score")
          .then((value) => value!.getValue(language).toString());

      List<ThreatScore> _threatScores =
          ThreatScore.convertFromJson(threats_score);

      return GeigerScoreThreats(
          threatScores: _threatScores, geigerScore: geigerScore);
    } on StorageException {
      throw Exception("Node not found");
    }
  }

  // Future<List<Recommendations>> getDeviceThreatRecommendation(
  //     {String language: "en"}) async {
  //   Device currentDevice = await getDeviceInfo;
  //
  //   try {
  //     _node = await _storageController
  //         .get(":Devices:${currentDevice.deviceId}:gi:data:recommendations");
  //     String threatRecommendations = await _node!
  //         .getValue("deviceRecommendations")
  //         .then((value) => value!.getValue(language).toString());
  //
  //     return Recommendations.convertFromJSon(threatRecommendations);
  //   } on StorageException {
  //     throw Exception("NODE NOT FOUND");
  //   }
  // }

  ///<p> set device ImplementedRecommendation
  ///@param recommendationId as string
  ///@return bool
  Future<bool> setDeviceImplementedRecommendation(
      {required Recommendations recommendation}) async {
    Device currentDevice = await getDeviceInfo;

    List<Recommendations> implementedRecommendations = [];

    try {
      _node = await _storageController
          .get(":Devices:${currentDevice.deviceId}:gi:data:GeigerScoreDevice");
      implementedRecommendations.add(recommendation);

      NodeValue implementedRecom = NodeValueImpl("implementedRecommendations",
          Recommendations.convertToJson(implementedRecommendations));
      await _node!.addOrUpdateValue(implementedRecom);

      await _storageController.update(_node!);
      return true;
    } catch (e) {
      log("failed to addOrUpdate implementedRecommendations NodeValue");
      return false;
    }
  }

  void _setDeviceNodeValues(Locale? language, List<ThreatScore> threatScores,
      {String geigerScore: "0"}) async {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    await _node!.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));

    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    await _node!.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    await _node!.addOrUpdateValue(_geigerNumMetrics!);

    await _storageController.update(_node!);
  }

  void _setDeviceNodeValuesException(Locale? language, Node deviceScoreNode,
      List<ThreatScore> threatScores, String geigerScore) async {
    _geigerScore = NodeValueImpl("GEIGER_score", geigerScore);
    await deviceScoreNode.addOrUpdateValue(_geigerScore!);
    _geigerThreatScores =
        NodeValueImpl("threats_score", ThreatScore.convertToJson(threatScores));

    if (language != null) {
      //translations
      _geigerThreatScores!
          .setValue(ThreatScore.convertToJson(threatScores), language);
    }

    await deviceScoreNode.addOrUpdateValue(_geigerThreatScores!);
    _geigerNumMetrics =
        NodeValueImpl("number_metrics", threatScores.length.toString());
    await deviceScoreNode.addOrUpdateValue(_geigerNumMetrics!);
    await _storageController.update(deviceScoreNode);
  }
}
//Todo
//Ask martin to remove currentDevice Nodevalue
// I can't override it except I use another Nodevalue name

//Note: I can override when data is first populated but error pop up on refresh.
//Error message: can't retrive data from :device:path
