// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      recommendationId: json['recommendationId'] as String?,
      recommendationType: json['recommendationType'] as String,
      relatedThreatsWeight: (json['relatedThreatsWeight'] as List<dynamic>)
          .map((e) => ThreatWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: DescriptionShortLong.fromJson(
          json['description'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'recommendationType': instance.recommendationType,
      'relatedThreatsWeight':
          instance.relatedThreatsWeight.map((e) => e.toJson()).toList(),
      'description': instance.description.toJson(),
    };
