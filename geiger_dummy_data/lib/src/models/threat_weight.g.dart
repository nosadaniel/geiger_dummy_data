// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat_weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreatWeight _$ThreatWeightFromJson(Map<String, dynamic> json) => ThreatWeight(
      threat: Threat.fromJson(json['threat'] as Map<String, dynamic>),
      weight: json['weight'] as String,
    );

Map<String, dynamic> _$ThreatWeightToJson(ThreatWeight instance) =>
    <String, dynamic>{
      'threat': instance.threat.toJson(),
      'weight': instance.weight,
    };
