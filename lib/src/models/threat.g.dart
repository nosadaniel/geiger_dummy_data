// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Threat _$ThreatFromJson(Map<String, dynamic> json) => Threat(
      threatId: json['threatId'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ThreatToJson(Threat instance) => <String, dynamic>{
      'threatId': instance.threatId,
      'name': instance.name,
    };
