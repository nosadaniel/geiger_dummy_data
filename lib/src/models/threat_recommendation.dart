library geiger_dummy_data;

import 'dart:convert';

import '/src/models/describe_short_long.dart';
import '/src/models/threat_weight.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'threat_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatRecommendation extends Equatable {
  final String recommendationId;
  final ThreatWeight weight;
  final DescriptionShortLong descriptionShortLong;

  ThreatRecommendation(
      {required this.recommendationId,
      required this.weight,
      required this.descriptionShortLong});

  factory ThreatRecommendation.fromJson(Map<String, dynamic> json) {
    return _$ThreatRecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatRecommendationToJson(this);
  }

  /// converts ThreatRecommendationList to String
  static String convertToJson(
      List<ThreatRecommendation> threatRecommendations) {
    List<Map<String, dynamic>> jsonData = threatRecommendations
        .map((threatRecommendation) => threatRecommendation.toJson())
        .toList();
    return jsonEncode(jsonData);
  }

  /// converts jsonThreatRecommendationListString to List<ThreatScore>
  static List<ThreatRecommendation> fromJSon(
      String threatRecommendationString) {
    List<dynamic> jsonData = jsonDecode(threatRecommendationString);
    return jsonData
        .map((threatMap) => ThreatRecommendation.fromJson(threatMap))
        .toList();
  }

  @override
  List<Object?> get props => [recommendationId, weight, descriptionShortLong];

  @override
  String toString() {
    super.toString();
    return '{"recommendationId":$recommendationId, "weight":$weight, "descriptionShortLong":$descriptionShortLong }';
  }
}
