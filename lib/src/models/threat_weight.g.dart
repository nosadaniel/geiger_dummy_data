// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat_weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreatsWeight _$ThreatsWeightFromJson(Map<String, dynamic> json) =>
    ThreatsWeight(
      threat: Threat.fromJson(json['threat'] as Map<String, dynamic>),
      weight: json['weight'] as String,
    );

Map<String, dynamic> _$ThreatsWeightToJson(ThreatsWeight instance) =>
    <String, dynamic>{
      'threat': instance.threat.toJson(),
      'weight': instance.weight,
    };
