import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart';

import 'package:json_annotation/json_annotation.dart';

part 'threat_weight.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatsWeight extends Equatable {
  final Threat threat;
  final String weight;

  ThreatsWeight({required this.threat, required this.weight});

  factory ThreatsWeight.fromJson(Map<String, dynamic> json) {
    return _$ThreatsWeightFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatsWeightToJson(this);
  }

  /// converts ThreatWeightList to String
  static String convertToJson(List<ThreatsWeight> threatWeights) {
    List<Map<String, dynamic>> jsonData =
        threatWeights.map((threatWeight) => threatWeight.toJson()).toList();
    return jsonEncode(jsonData);
  }

  /// converts jsonThreatWeightListString to List<ThreatWeight>
  static List<ThreatsWeight> fromJSon(String jsonArray) {
    List<dynamic> jsonData = jsonDecode(jsonArray);
    return jsonData
        .map((threatWeight) => ThreatsWeight.fromJson(threatWeight))
        .toList();
  }

  @override
  String toString() {
    return '{"threat":$threat, "weight":$weight}';
  }

  @override
  List<Object> get props => [threat, weight];
}
