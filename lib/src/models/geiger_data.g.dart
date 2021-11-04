// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerData _$GeigerDataFromJson(Map<String, dynamic> json) => GeigerData(
      geigerScoreThreats: (json['geigerScoreThreats'] as List<dynamic>)
          .map((e) => GeigerScoreThreats.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GeigerDataToJson(GeigerData instance) =>
    <String, dynamic>{
      'geigerScoreThreats': instance.geigerScoreThreats,
      'recommendations': instance.recommendations,
    };
