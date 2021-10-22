import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geiger_dummy_data/src/constant/constant.dart';
import 'package:geiger_dummy_data/src/models/threat_weight.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendation extends Equatable {
  final String? recommendationId;
  final String recommendationType;
  final List<ThreatWeight> threatWeight;
  final String shortDescription;
  final String? longDescription;

  Recommendation(
      {String? recommendationId,
      required this.recommendationType,
      required this.threatWeight,
      required this.shortDescription,
      this.longDescription})
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
  // TODO: implement props
  List<Object?> get props => [
        recommendationId,
        recommendationType,
        threatWeight,
        shortDescription,
        longDescription
      ];
}
