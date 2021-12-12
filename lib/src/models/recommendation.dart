library geiger_dummy_data;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '/src/constant/constant.dart';
import '/src/exceptions/custom_format_exception.dart';
import '/src/exceptions/custom_invalid_map_key_exception.dart';
import 'describe_short_long.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendations extends Equatable {
  final String? recommendationId;
  final String? recommendationType;
  final DescriptionShortLong description;

  Recommendations(
      {String? recommendationId,
      this.recommendationType,
      required this.description})
      : recommendationId = recommendationId ?? GeigerConstant.uuid;

  factory Recommendations.fromJson(Map<String, dynamic> json) {
    try {
      return _$RecommendationsFromJson(json);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$RecommendationsToJson(this);
  }

  /// convert from recommendations List to RecommendationJson
  static String convertToJson(List<Recommendations> recommendations) {
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
  static List<Recommendations> convertFromJSon(String recommendationJson) {
    try {
      List<dynamic> jsonData = jsonDecode(recommendationJson);
      return jsonData
          .map((recommendationMap) =>
              Recommendations.fromJson(recommendationMap))
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
    return '{"recommendationId":$recommendationId,"recommendationType":$recommendationType,"description":$description}';
  }

  @override
  List<Object?> get props =>
      [recommendationId, recommendationType, description];
}
