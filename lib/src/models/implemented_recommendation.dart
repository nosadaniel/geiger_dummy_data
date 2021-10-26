import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'implemented_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class ImplementedRecommendation {
  final String recommendationId;

  ImplementedRecommendation({required this.recommendationId});

  factory ImplementedRecommendation.fromJson(Map<String, dynamic> json) {
    return _$ImplementedRecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ImplementedRecommendationToJson(this);
  }

  /// convert from implementedRecommendationString to ImplementedRecommendation List
  static List<ImplementedRecommendation> currentUserFromJSon(
      String implementedRecommendationList) {
    List<dynamic> jsonData = jsonDecode(implementedRecommendationList);
    return jsonData
        .map((implRec) => ImplementedRecommendation.fromJson(implRec))
        .toList();
  }

  /// convert from implementedRecommendationList to String
  static String convertToJsonCurrentUser(
      List<ImplementedRecommendation> implementedRecommendations) {
    List<Map<String, dynamic>> jsonData = implementedRecommendations
        .map((impRecom) => impRecom.toJson())
        .toList();
    return jsonEncode(jsonData);
  }
}
