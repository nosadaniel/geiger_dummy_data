// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String? ?? "123user",
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      knowledgeLevel: json['knowledgeLevel'] as String?,
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'knowledgeLevel': instance.knowledgeLevel,
      'role': instance.role?.toJson(),
    };
