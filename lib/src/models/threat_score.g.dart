// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreatScore _$ThreatScoreFromJson(Map<String, dynamic> json) => ThreatScore(
      threat: Threat.fromJson(json['threat'] as Map<String, dynamic>),
      score: json['score'] as String,
    );

Map<String, dynamic> _$ThreatScoreToJson(ThreatScore instance) =>
    <String, dynamic>{
      'threat': instance.threat.toJson(),
      'score': instance.score,
    };
