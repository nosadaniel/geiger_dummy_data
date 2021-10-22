import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:json_annotation/json_annotation.dart';

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

  /// converts jsonThreatWeightListString to List<ThreatWeight>
  static List<ThreatWeight> fromJSon(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData
        .map((threatWeight) => ThreatWeight.fromJson(threatWeight))
        .toList();
  }

  @override
  List<Object> get props => [threat, weight];
}
