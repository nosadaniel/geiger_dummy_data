// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_score_threats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerScoreThreats _$GeigerScoreThreatsFromJson(Map<String, dynamic> json) =>
    GeigerScoreThreats(
      threatScores: (json['threatScores'] as List<dynamic>)
          .map((e) => ThreatScore.fromJson(e as Map<String, dynamic>))
          .toList(),
      geigerScore: json['geigerScore'] as String,
    );

Map<String, dynamic> _$GeigerScoreThreatsToJson(GeigerScoreThreats instance) =>
    <String, dynamic>{
      'threatScores': instance.threatScores.map((e) => e.toJson()).toList(),
      'geigerScore': instance.geigerScore,
    };
