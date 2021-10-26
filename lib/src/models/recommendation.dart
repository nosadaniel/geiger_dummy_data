library geiger_dummy_data;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import '/src/exceptions/custom_invalid_map_key_exception.dart';
import '/src/exceptions/custom_format_exception.dart';
import 'package:json_annotation/json_annotation.dart';
import '/src/models/threat_weight.dart';
import '/src/constant/constant.dart';

import 'describe_short_long.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendation extends Equatable {
  final String? recommendationId;
  final String recommendationType;
  final List<ThreatWeight> relatedThreatsWeight;
  final DescriptionShortLong description;

  Recommendation(
      {String? recommendationId,
      required this.recommendationType,
      required this.relatedThreatsWeight,
      required this.description})
      : recommendationId = recommendationId ?? GeigerConstant.uuid;

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    try {
      return _$RecommendationFromJson(json);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$RecommendationToJson(this);
  }

  /// convert from recommendations List to RecommendationJson
  static String convertToJson(List<Recommendation> recommendations) {
    try {
      List<Map<String, dynamic>> jsonData = recommendations
          .map((recommendation) => recommendation.toJson())
          .toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message:
              "Fails to Convert List<Recommendation>: \n $recommendations to json");
    }
  }

  /// converts RecommendationJson to List<Recommendation>
  static List<Recommendation> convertFromJSon(String recommendationJson) {
    try {
      List<dynamic> jsonData = jsonDecode(recommendationJson);
      return jsonData
          .map(
              (recommendationMap) => Recommendation.fromJson(recommendationMap))
          .toList();
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format to convert List<Recommendation>:\n $recommendationJson \n right String format: \n [{"recommendationId":"value","recommendationType":"value", "relatedThreatsWeight":[{"threat":{"threatId":"value","name":"value"},"weight":"value"},{"threat":{"threatId":"value","name":"value"},"weight":"value"}],"description":{"shortDescription":"value","longDescription":"value"}}] \n Note:all Ids are optional');
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"recommendationId":$recommendationId,"recommendationType":$recommendationType,"relatedThreatsWeight":$relatedThreatsWeight,"description":$description}';
  }

  @override
  List<Object?> get props =>
      [recommendationId, recommendationType, relatedThreatsWeight, description];
}
