library geiger_dummy_data;

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import '/src/models/threat.dart';

part 'threat_weight.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatWeight extends Equatable {
  final Threat threat;
  final String weight;

  ThreatWeight({required this.threat, required this.weight});

  factory ThreatWeight.fromJson(Map<String, dynamic> json) {
    return _$ThreatWeightFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatWeightToJson(this);
  }

  /// converts ThreatWeightList to String
  static String convertToJson(List<ThreatWeight> threatWeights) {
    List<Map<String, dynamic>> jsonData =
        threatWeights.map((threatWeight) => threatWeight.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// converts jsonThreatListString to List<ThreatWeight>
  static List<ThreatWeight> fromJSon(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData
        .map((threatWeight) => ThreatWeight.fromJson(threatWeight))
        .toList();
  }

  @override
  String toString() {
    super.toString();
    return '{"threat":$threat, "weight":$weight }';
  }

  @override
  List<Object?> get props => [threat, weight];
}
