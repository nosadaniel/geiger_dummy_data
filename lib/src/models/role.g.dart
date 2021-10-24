// GENERATED CODE - DO NOT MODIFY BY HAND

part of geiger_dummy_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      roleId: json['roleId'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'roleId': instance.roleId,
      'name': instance.name,
    };
