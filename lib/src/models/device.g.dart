// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      deviceId: json['deviceId'] as String?,
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      name: json['name'] as String?,
      type: json['type'] as String?,
      tools: (json['tools'] as List<dynamic>?)
          ?.map((e) => Tool.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'deviceId': instance.deviceId,
      'owner': instance.owner.toJson(),
      'name': instance.name,
      'type': instance.type,
      'tools': instance.tools?.map((e) => e.toJson()).toList(),
    };
