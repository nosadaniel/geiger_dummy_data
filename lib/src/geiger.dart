library geiger_dummy_data;

import 'dart:convert';
import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_dummy_data/src/geiger_listen.dart';
import 'package:geiger_dummy_data/src/models/geiger_score_threats.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import '/src/models/geiger_data.dart';

class Geiger implements GeigerListen {
  StorageController _storageController;

  Geiger(this._storageController);

  @override
  Future<String> onBtnPressed() async {
    UserNode _userNode = UserNode(_storageController);
    DeviceNode _deviceNode = DeviceNode(_storageController);
    RecommendationNode _recommendationNode =
        RecommendationNode(_storageController);

    List<GeigerScoreThreats> geigerScoreThreats = [];

    //add aggregate,//userScore // deviceScore
    geigerScoreThreats.add(_userNode.getGeigerScoreAggregateThreatScore());
    geigerScoreThreats.add(_userNode.getGeigerScoreUserThreatScores());
    geigerScoreThreats.add(_deviceNode.getGeigerScoreDeviceThreatScores());

    return jsonEncode(GeigerData(
        geigerScoreThreats: geigerScoreThreats,
        recommendations: _recommendationNode.getRecommendations));
  }
}

//Todo

// write test for onBtnPressed()
