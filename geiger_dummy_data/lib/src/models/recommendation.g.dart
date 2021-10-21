// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      json['recommendationId'] as String,
      json['recommendationType'] as String,
      (json['threatWeight'] as List<dynamic>)
          .map((e) => ThreatWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['shortDescription'] as String,
      json['longDescription'] as String?,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'recommendationType': instance.recommendationType,
      'threatWeight': instance.threatWeight.map((e) => e.toJson()).toList(),
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
    };
