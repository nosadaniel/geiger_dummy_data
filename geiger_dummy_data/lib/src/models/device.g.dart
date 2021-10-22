// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      deviceId: json['deviceId'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'deviceId': instance.deviceId,
      'owner': instance.owner.toJson(),
      'name': instance.name,
      'type': instance.type,
    };
