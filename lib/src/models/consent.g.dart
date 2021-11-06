// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consent _$ConsentFromJson(Map<String, dynamic> json) => Consent(
      dataAccess: json['dataAccess'] as bool? ?? false,
      dataProcess: json['dataProcess'] as bool? ?? false,
      cloudProcess: json['cloudProcess'] as bool? ?? false,
      toolProcess: json['toolProcess'] as bool? ?? false,
    );

Map<String, dynamic> _$ConsentToJson(Consent instance) => <String, dynamic>{
      'dataAccess': instance.dataAccess,
      'dataProcess': instance.dataProcess,
      'cloudProcess': instance.cloudProcess,
      'toolProcess': instance.toolProcess,
    };
