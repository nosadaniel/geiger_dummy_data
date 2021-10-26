// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreatRecommendation _$ThreatRecommendationFromJson(
        Map<String, dynamic> json) =>
    ThreatRecommendation(
      recommendationId: json['recommendationId'] as String,
      threatWeight:
          ThreatWeight.fromJson(json['threatWeight'] as Map<String, dynamic>),
      descriptionShortLong: DescriptionShortLong.fromJson(
          json['descriptionShortLong'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThreatRecommendationToJson(
        ThreatRecommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'threatWeight': instance.threatWeight.toJson(),
      'descriptionShortLong': instance.descriptionShortLong.toJson(),
    };
