import 'dart:convert';

import '/src/exceptions/custom_invalid_map_key_exception.dart';

import '/src/exceptions/custom_format_exception.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'implemented_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class ImplementedRecommendation extends Equatable {
  final String recommendationId;

  ImplementedRecommendation({required this.recommendationId});

  factory ImplementedRecommendation.fromJson(Map<String, dynamic> json) {
    try {
      return _$ImplementedRecommendationFromJson(json);
    } catch (e) {
      throw CustomInvalidMapKeyException(message: e);
    }
  }

  Map<String, dynamic> toJson() {
    return _$ImplementedRecommendationToJson(this);
  }

  /// convert from implementedRecommendationJson to ImplementedRecommendation List
  static List<ImplementedRecommendation> convertFromJson(
      String implementedRecommendationJson) {
    try {
      //decode json
      List<dynamic> jsonData = jsonDecode(implementedRecommendationJson);
      return jsonData
          .map((implRec) => ImplementedRecommendation.fromJson(implRec))
          .toList();
    } on FormatException {
      throw CustomFormatException(
          message:
              '\n that is the wrong format to List<ImplementedRecommendation>:\n $implementedRecommendationJson \n right String format:\n [{"recommendationId":"value"}] ');
    }
  }

  /// convert ImplementedRecommendation List to ImplementedRecommendationJson
  static String convertToJson(
      List<ImplementedRecommendation> implementedRecommendations) {
    try {
      List<Map<String, dynamic>> jsonData = implementedRecommendations
          .map((impRecom) => impRecom.toJson())
          .toList();
      return jsonEncode(jsonData);
    } on FormatException {
      throw CustomFormatException(
          message:
              "Fails to Convert List<ImplementedRecommendation> $implementedRecommendations to json");
    }
  }

  @override
  String toString() {
    super.toString();
    return '{"recommendationId":$recommendationId}';
  }

  @override
  List<Object?> get props => [recommendationId];
}
