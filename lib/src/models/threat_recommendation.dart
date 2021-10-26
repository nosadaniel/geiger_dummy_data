library geiger_dummy_data;

import 'dart:convert';

import '/src/exceptions/custom_invalid_map_key_exception.dart';

import '/src/exceptions/custom_format_exception.dart';

import '/src/models/describe_short_long.dart';
import '/src/models/threat_weight.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'threat_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatRecommendation extends Equatable {
  final String recommendationId;
  final ThreatWeight threatWeight;
  final DescriptionShortLong descriptionShortLong;

  ThreatRecommendation(
      {required this.recommendationId,
      required this.threatWeight,
      required this.descriptionShortLong});

  factory ThreatRecommendation.fromJson(Map<String, dynamic> json) {
    try {
      return _$ThreatRecommendationFromJson(json);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$ThreatRecommendationToJson(this);
  }

  /// converts ThreatRecommendation List to ThreatRecommendation json
  static String convertToJson(
      List<ThreatRecommendation> threatRecommendations) {
    try {
      List<Map<String, dynamic>> jsonData = threatRecommendations
          .map((threatRecommendation) => threatRecommendation.toJson())
          .toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message:
              "Fails to Convert List<ThreatRecommendation> $threatRecommendations to json");
    }
  }

  /// converts jsonThreatRecommendationListString to List<ThreatRecommendation>
  static List<ThreatRecommendation> convertFromJson(
      String threatRecommendationJson) {
    try {
      List<dynamic> jsonData = jsonDecode(threatRecommendationJson);
      return jsonData
          .map((threatMap) => ThreatRecommendation.fromJson(threatMap))
          .toList();
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format for ThreatRecommendation: \n $threatRecommendationJson \n right String format: \n [{"recommendationId":"value", "threatWeight":{"threat":{"threatId":"value","name":"value"},"weight":"value"}, "descriptionShortLong":{"shortDescription":"value", "longDescription":"value"} }]\n Note:all Ids are optional');
    }
  }

  @override
  List<Object?> get props =>
      [recommendationId, threatWeight, descriptionShortLong];

  @override
  String toString() {
    super.toString();
    return '{"recommendationId":$recommendationId, "weight":$threatWeight, "descriptionShortLong":$descriptionShortLong }';
  }
}

//Todo
// write exception when on key in map is used == this throws null safety error
