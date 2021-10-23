// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      recommendationId: json['recommendationId'] as String?,
      recommendationType: json['recommendationType'] as String,
      threatsWeight: (json['threatsWeight'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : ThreatsWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String?,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'recommendationType': instance.recommendationType,
      'threatsWeight': instance.threatsWeight.map((e) => e?.toJson()).toList(),
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
    };
