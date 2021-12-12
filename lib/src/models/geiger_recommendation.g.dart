// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerRecommendation _$GeigerRecommendationFromJson(
        Map<String, dynamic> json) =>
    GeigerRecommendation(
      threat: Threat.fromJson(json['threat'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => Recommendations.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GeigerRecommendationToJson(
        GeigerRecommendation instance) =>
    <String, dynamic>{
      'threat': instance.threat.toJson(),
      'recommendations':
          instance.recommendations.map((e) => e.toJson()).toList(),
    };
