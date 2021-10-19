// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      User.fromJson(json['owner'] as Map<String, dynamic>),
      json['deviceId'] as String,
      json['name'] as String?,
      json['type'] as String?,
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'owner': instance.owner.toJson(),
      'deviceId': instance.deviceId,
      'name': instance.name,
      'type': instance.type,
    };
