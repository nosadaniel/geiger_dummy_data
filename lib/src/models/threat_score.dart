library geiger_dummy_data;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import '/src/exceptions/custom_format_exception.dart';
import 'package:json_annotation/json_annotation.dart';

import '/src/models/threat.dart';

part 'threat_score.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatScore extends Equatable {
  final Threat threat;
  final String score;
  ThreatScore({required this.threat, required this.score});

  factory ThreatScore.fromJson(Map<String, dynamic> json) {
    return _$ThreatScoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatScoreToJson(this);
  }

  /// convert from ThreatScore List to threatScore json
  static String convertToJson(List<ThreatScore> threatScores) {
    try {
      List<Map<String, dynamic>> jsonData =
          threatScores.map((threatScore) => threatScore.toJson()).toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message: "Fails to Convert List<ThreatScore> $threatScores to json");
    }
  }

  /// converts json ThreatList to List<ThreatScore>
  static List<ThreatScore> convertFromJson(String threatScoreJson) {
    try {
      List<dynamic> jsonData = jsonDecode(threatScoreJson);
      return jsonData
          .map((threatMap) => ThreatScore.fromJson(threatMap))
          .toList();
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for ThreatScore:\n $threatScoreJson \n right String format:\n [{"threat":{"threatId":"value","name":"value"}, "score":"value"}] \n Note: threatId is optional');
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"threat": $threat, "score":$score}';
  }

  @override
  List<Object?> get props => [threat, score];
}
