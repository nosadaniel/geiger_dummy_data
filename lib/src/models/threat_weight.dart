library geiger_dummy_data;

import 'dart:convert';

import '/src/exceptions/custom_format_exception.dart';
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

  /// convert from ThreatWeight List to threatWeight json
  static String convertToJson(List<ThreatWeight> threatWeights) {
    try {
      List<Map<String, dynamic>> jsonData =
          threatWeights.map((threatWeight) => threatWeight.toJson()).toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message:
              "Fails to Convert List<ThreatWeight> $threatWeights to json");
    }
  }

  /// converts json ThreatListString to List<ThreatWeight>
  static List<ThreatWeight> convertFromJson(String threatWeightJson) {
    try {
      List<dynamic> jsonData = jsonDecode(threatWeightJson);
      return jsonData
          .map((threatWeight) => ThreatWeight.fromJson(threatWeight))
          .toList();
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for ThreatWeight: \n $threatWeightJson \n right String format: [{"threat":{"threatId":"value","name":"value"},"weight":"value"}] \n Note: threatId is optional');
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"threat":$threat, "weight":$weight }';
  }

  @override
  List<Object?> get props => [threat, weight];
}
