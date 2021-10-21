// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      json['recommendationId'] as String,
      json['recommendationType'] as String,
      ThreatWeight.fromJson(json['threatWeight'] as Map<String, dynamic>),
      json['short_description'] as String,
      json['long_description'] as String?,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'recommendationType': instance.recommendationType,
      'threatWeight': instance.threatWeight.toJson(),
      'short_description': instance.short_description,
      'long_description': instance.long_description,
    };
