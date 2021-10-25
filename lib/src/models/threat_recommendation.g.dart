// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreatRecommendation _$ThreatRecommendationFromJson(
        Map<String, dynamic> json) =>
    ThreatRecommendation(
      recommendationId: json['recommendationId'] as String,
      weight: ThreatWeight.fromJson(json['weight'] as Map<String, dynamic>),
      descriptionShortLong: DescriptionShortLong.fromJson(
          json['descriptionShortLong'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThreatRecommendationToJson(
        ThreatRecommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'weight': instance.weight.toJson(),
      'descriptionShortLong': instance.descriptionShortLong.toJson(),
    };
