// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendations _$RecommendationsFromJson(Map<String, dynamic> json) =>
    Recommendations(
      recommendationId: json['recommendationId'] as String?,
      recommendationType: json['recommendationType'] as String?,
      description: DescriptionShortLong.fromJson(
          json['description'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecommendationsToJson(Recommendations instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'recommendationType': instance.recommendationType,
      'description': instance.description.toJson(),
    };
