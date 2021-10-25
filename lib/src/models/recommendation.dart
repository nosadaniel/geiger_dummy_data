import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/src/models/threat_weight.dart';
import '../constant/constant.dart';

import 'package:json_annotation/json_annotation.dart';

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
    return _$RecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RecommendationToJson(this);
  }

  /// convert from recommendations List to String
  static String convertToJson(List<Recommendation> recommendations) {
    List<Map<String, dynamic>> jsonData = recommendations
        .map((recommendation) => recommendation.toJson())
        .toList();
    return jsonEncode(jsonData);
  }

  /// converts jsonRecommendationListString to List<Recommendation>
  static List<Recommendation> fromJSon(String recommendationJsonArray) {
    List<dynamic> jsonData = jsonDecode(recommendationJsonArray);
    return jsonData
        .map((recommendationMap) => Recommendation.fromJson(recommendationMap))
        .toList();
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
