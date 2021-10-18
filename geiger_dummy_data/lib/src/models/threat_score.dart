import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '/src/models/threat.dart';

part 'threat_score.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatScore {
  Threat threat;
  String score;
  ThreatScore({required this.threat, required this.score});

  factory ThreatScore.fromJson(Map<String, dynamic> json) {
    return _$ThreatScoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatScoreToJson(this);
  }

  /// convert to json string
  static String convertToJson(List<ThreatScore> threatScores) {
    List<Map<String, dynamic>> jsonData =
        threatScores.map((threatScore) => threatScore.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// pass [ThreatScore] as a string
  static List<ThreatScore> fromJSon(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData
        .map((threatMap) => ThreatScore.fromJson(threatMap))
        .toList();
  }
}
